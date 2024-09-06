//
//  SearchScreenViewController + AlbumCellDelegate.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 07.09.2024.
//

extension SearchScreenViewController: AlbumCellDelegate {
  func tagCellDidSelect(_ tag: Tag, _ cell: AlbumCell) {
    if let indexPath = rootView.albumsCollectionView.indexPath(for: cell) {
      let album = albumsViewModel.getItem(at: indexPath.item)
      let searchTerm = tag.title
      delegate?.searchButtonClicked(
        with: searchTerm,
        currentScopeIndex: currentScopeIndex
      )
      print(#function, Self.self, tag.title)
    }
  }
}
