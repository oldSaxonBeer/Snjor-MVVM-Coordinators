//
//  PhotosCollectionView.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 08.08.2024.
//

final class PhotosCollectionView: MainCollectionView {
  override func cellRegister() {
    register(
      SearchScreenPhotoCell.self,
      forCellWithReuseIdentifier: SearchScreenPhotoCell.reuseID
    )
  }
}
