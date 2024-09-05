//
//  AlbumCell.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 08.08.2024.
//

import UIKit

final class AlbumCell: UICollectionViewCell {
  
  // MARK: Views
  let mainView: AlbumCellMainView = {
    return $0
  }(AlbumCellMainView())
  
  let tagsCollectionView: AlbumTagsCollectionView = {
    $0.heightAnchor.constraint(
      equalToConstant: AlbumCellConst.gradientWidthSize
    ).isActive = true
    return $0
  }(AlbumTagsCollectionView())

  private let rightGradientView: MainGradientView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.isUserInteractionEnabled = false
    $0.widthAnchor.constraint(
      equalToConstant: AlbumCellConst.gradientWidthSize
    ).isActive = true
    $0.transform = CGAffineTransform(
      rotationAngle: .pi / AlbumCellConst.rightGradientViewRotationAngle
    )
    return $0
  }(MainGradientView())
  
  private let leftGradientView: MainGradientView = {
    $0.isUserInteractionEnabled = false
    $0.widthAnchor.constraint(
      equalToConstant: AlbumCellConst.gradientWidthSize
    ).isActive = true
    $0.transform = CGAffineTransform(
      rotationAngle: .pi * AlbumCellConst.leftGradientViewRotationAngle
    )
    return $0
  }(MainGradientView())
  
  lazy var mainViewAndTagsCollectionStackView: UIStackView = {
    $0.axis = .vertical
    $0.addArrangedSubview(mainView)
    $0.addArrangedSubview(tagsCollectionView)
    $0.spacing = AlbumCellConst.stackViewSpacing
    return $0
  }(UIStackView())
  
  // MARK: Initializers
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupConstraints()
    updateGradientColors()
  }
  
  required init?(coder: NSCoder) {
    fatalError(.requiredInitFatalErrorText)
  }
  
  // MARK: Override Methods
  override func prepareForReuse() {
    super.prepareForReuse()
    mainView.prepareForReuse()
    tagsCollectionView.tags = []
    tagsCollectionView.reloadData()
  }
  
  // MARK: Setup Data
  func configure(viewModelItem: BaseViewModelItem <Album> ) {
    let album = viewModelItem.item
    let coverPhotoURL = viewModelItem.photoURL
    mainView.configure(with: album, url: coverPhotoURL)
    tagsCollectionView.tags = album.tags ?? []
  }
  
  // MARK: Setup Views
  private func setupViews() {
    addSubviews()
    setupConstraints()
  }
  
  private func addSubviews() {
    contentView.addSubview(mainViewAndTagsCollectionStackView)
    addSubview(rightGradientView)
    addSubview(leftGradientView)
  }
  
  private func setupConstraints() {
    mainViewAndTagsCollectionStackView.fillSuperView()
    setupLeftGradientViewConstraints()
    setupRightGradientViewConstraints()
  }
  
  private func setupLeftGradientViewConstraints() {
    leftGradientView.setConstraints(
      top: tagsCollectionView.topAnchor,
      bottom: tagsCollectionView.bottomAnchor,
      left: tagsCollectionView.leftAnchor
    )
  }
  
  private func setupRightGradientViewConstraints() {
    rightGradientView.setConstraints(
      top: tagsCollectionView.topAnchor,
      right: tagsCollectionView.rightAnchor,
      bottom: tagsCollectionView.bottomAnchor
    )
  }
  
  // MARK: Update Gradient Colors
  private func updateGradientColors() {
    rightGradientView.setColors([
      MainGradientView.Color(
        color: UIColor.systemBackground.withAlphaComponent(AlbumCellConst.maxOpacity),
        location: AlbumCellConst.gradientStartLocation
      ),
      MainGradientView.Color(
        color: UIColor.systemBackground.withAlphaComponent(.zero),
        location: AlbumCellConst.gradientEndLocation
      ),
    ])
    
    leftGradientView.setColors([
      MainGradientView.Color(
        color: UIColor.systemBackground.withAlphaComponent(AlbumCellConst.maxOpacity),
        location: AlbumCellConst.gradientStartLocation
      ),
      MainGradientView.Color(
        color: UIColor.systemBackground.withAlphaComponent(.zero),
        location: AlbumCellConst.gradientEndLocation
      ),
    ])
  }
  
  override func traitCollectionDidChange(
    _ previousTraitCollection: UITraitCollection?
  ) {
    super.traitCollectionDidChange(previousTraitCollection)
    if traitCollection.hasDifferentColorAppearance(
      comparedTo: previousTraitCollection
    ) {
      updateGradientColors()
    }
  }
}
