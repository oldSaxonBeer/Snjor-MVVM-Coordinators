//
//  SearchScreenViewController + AlbumsDataSource.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 13.08.2024.
//

import UIKit

// Extension для SearchScreenViewController
extension SearchScreenViewController {
  
  // Создание snapshot для коллекции
  var collectionsSnapshot: NSDiffableDataSourceSnapshot<CollectionsSection, Item> {
    var snapshot = NSDiffableDataSourceSnapshot<CollectionsSection, Item>()
    let topicSection = CollectionsSection.topics
    let albumSection = CollectionsSection.albums
    snapshot.appendSections([topicSection, albumSection])
    snapshot.appendItems(Item.topics, toSection: topicSection)
    snapshot.appendItems(Item.albums, toSection: albumSection)
    albumsSections = snapshot.sectionIdentifiers
    return snapshot
  }
  
  // Создание DataSource для коллекции
  func createAlbumsDataSource(for collectionView: UICollectionView) {
    collectionsDataSource = UICollectionViewDiffableDataSource<CollectionsSection, Item>(
      collectionView: collectionView
    ) { [weak self] collectionView, indexPath, item in
      let defaultCell = UICollectionViewCell()
      guard let strongSelf = self else { return defaultCell }
      let section = strongSelf.albumsSections[indexPath.section]
      switch section {
      case .topics:
        if let topic = item.topic {
          return strongSelf.configureTopicCell(
            collectionView: collectionView,
            indexPath: indexPath,
            topic: topic
          )
        } else {
          return defaultCell
        }
      case .albums:
        if let album = item.album {
          return strongSelf.configureAlbumCell(
            collectionView: collectionView,
            indexPath: indexPath,
            album: album
          )
        } else {
          return defaultCell
        }
      }
    }
  }
  
  func applyAlbumsSnapshot() {
    guard let dataSource = collectionsDataSource else { return }
    dataSource.apply(
      collectionsSnapshot,
      animatingDifferences: true
    )
  }
  
  private func configureAlbumCell(
    collectionView: UICollectionView,
    indexPath: IndexPath,
    album: Album
  ) -> UICollectionViewCell {
    guard
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: AlbumCell.reuseID,
        for: indexPath
      ) as? AlbumCell
    else {
      return UICollectionViewCell()
    }
    albumsViewModel.checkAndLoadMoreAlbums(at: indexPath.item)
    let viewModelItem = albumsViewModel.getAlbumsViewModelItem(at: indexPath.item)
    cell.configure(viewModelItem: viewModelItem)
    return cell
  }
  
  private func configureTopicCell(
    collectionView: UICollectionView,
    indexPath: IndexPath,
    topic: Topic
  ) -> UICollectionViewCell {
    guard
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: TopicCell.reuseID,
        for: indexPath
      ) as? TopicCell
    else {
      return UICollectionViewCell()
    }
    let viewModelItem = topicsViewModel.getTopicsPageViewModelItem(at: indexPath.item)
    cell.configure(viewModelItem: viewModelItem)
    return cell
  }
  
}

// Определение секций для коллекции
enum CollectionsSection: Hashable {
  case topics
  case albums
}
