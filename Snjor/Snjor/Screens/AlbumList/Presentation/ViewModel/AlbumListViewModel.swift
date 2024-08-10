//
//  AlbumListViewModel.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 08.08.2024.
//

import UIKit
import Combine

final class AlbumListViewModel: AlbumListViewModelProtocol {
  
  // MARK: - Internal Properties
  var albumsCount: Int { albums.count }
  
  // MARK: - Private Properties
  private(set) var state: PassthroughSubject<StateController, Never>
  private let loadUseCase: any LoadAlbumListUseCaseProtocol
  private var lastPageValidationUseCase: any lastPageValidationUseCaseProtocol
  private var dataSource: UICollectionViewDiffableDataSource<Section, Album>?
  private var albums: [Album] = []
  private var sections: [Section] = []
  
  private var snapshot: NSDiffableDataSourceSnapshot<Section, Album> {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Album>()
    snapshot.appendSections([.main])
    snapshot.appendItems(albums, toSection: .main)
    sections = snapshot.sectionIdentifiers
    return snapshot
  }
  
  // MARK: - Initializers
  init(
    state: PassthroughSubject<StateController, Never>,
    loadUseCase: any LoadAlbumListUseCaseProtocol,
    lastPageValidationUseCase: any lastPageValidationUseCaseProtocol
  ) {
    self.state = state
    self.loadUseCase = loadUseCase
    self.lastPageValidationUseCase = lastPageValidationUseCase
  }
  
  // MARK: - Internal Methods
  func viewDidLoad() {
    state.send(.loading)
    Task {
      await loadAlbumsUseCase()
    }
  }
  
  func createDataSource(for collectionView: UICollectionView) {
    dataSource = UICollectionViewDiffableDataSource<Section, Album>(
      collectionView: collectionView
    ) { [weak self] collectionView, indexPath, album in
      
      let defaultCell = UICollectionViewCell()
      
      guard let strongSelf = self else { return defaultCell }
      
      let section = strongSelf.sections[indexPath.section]
      switch section {
      case .main:
        return strongSelf.configureCell(
          collectionView: collectionView,
          indexPath: indexPath,
          album: album
        )
      }
    }
  }
  
  func applySnapshot() {
    guard let dataSource = dataSource else { return }
    dataSource.apply(
      snapshot,
      animatingDifferences: true
    )
  }
  
  func getAlbumListViewModelItem(
    at index: Int
  ) -> AlbumListViewModelItem {
    checkAndLoadMoreAlbums(at: index)
    return makeAlbumListViewModelItem(at: index)
  }
  
  // MARK: - Private Methods
  private func makeAlbumListViewModelItem(at index: Int) -> AlbumListViewModelItem {
    let album = albums[index]
    return AlbumListViewModelItem(album: album)
  }
  
  private func loadAlbumsUseCase() async {
    let result = await loadUseCase.execute()
    updateStateUI(with: result)
  }
  
  private func updateStateUI(with result: Result<[Album], Error>) {
    switch result {
    case .success(let albums):
      let existingAlbumIDs = self.albums.map { $0.id }
      let newAlbums = albums.filter { !existingAlbumIDs.contains($0.id) }
      lastPageValidationUseCase.updateLastPage(itemsCount: albums.count)
      self.albums.append(contentsOf: newAlbums)
      state.send(.success)
    case .failure(let error):
      state.send(.fail(error: error.localizedDescription))
    }
  }
  
  private func checkAndLoadMoreAlbums(at index: Int) {
    lastPageValidationUseCase.checkAndLoadMoreItems(
      at: index,
      actualItems: albums.count,
      action: viewDidLoad
    )
  }
  
  
  private func configureCell(
    collectionView: UICollectionView,
    indexPath: IndexPath,
    album: Album
  ) -> UICollectionViewCell {
    guard
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: AlbumListCell.reuseID,
        for: indexPath
      ) as? AlbumListCell
    else {
      return UICollectionViewCell()
    }
    
    checkAndLoadMoreAlbums(at: indexPath.item)
    let viewModelItem = getAlbumListViewModelItem(at: indexPath.item)
    cell.configure(viewModelItem: viewModelItem)
    return cell
  }
}

private enum Section: Hashable {
  case main
}