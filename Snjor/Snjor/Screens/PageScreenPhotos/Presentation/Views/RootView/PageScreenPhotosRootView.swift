//
//  PageScreenPhotosRootView.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 01.08.2024.
//

import UIKit

final class PageScreenPhotosRootView: UIView {
  
  // MARK: - Views
  let pageScreenPhotosCollectionView: PageScreenPhotosCollectionView = {
    return $0
  }(PageScreenPhotosCollectionView())
  
  // MARK: - Initializers
  init() {
    super.init(frame: .zero)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup Views
  private func setupViews() {
    addSubviews()
    setupConstraints()
  }
  
  private func addSubviews() {
    addSubview(pageScreenPhotosCollectionView)
  }
  
  private func setupConstraints() {
    pageScreenPhotosCollectionView.setConstraints(
      top: topAnchor,
      right: rightAnchor,
      bottom: bottomAnchor,
      left: leftAnchor
    )
  }
}