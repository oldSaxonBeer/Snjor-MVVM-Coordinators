//
//  UserProfileViewControllerRootView.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 10.09.2024.
//

import UIKit

fileprivate typealias Const = UserProfileViewControllerRootViewConst

final class UserProfileViewControllerRootView: UIView {
  // MARK: Private Properties
  
  
  // MARK: UserProfilePhoto
  let profilePhotoView: UserProfilePhotoView = {
    $0.contentMode = .scaleAspectFill
    $0.layer.cornerRadius = Const.profilePhotoCircle
    $0.clipsToBounds = true
    $0.widthAnchor.constraint(
      equalToConstant: Const.profilePhotoSize
    ).isActive = true
    $0.heightAnchor.constraint(
      equalToConstant: Const.profilePhotoSize
    ).isActive = true
    return $0
  }(UserProfilePhotoView())
  
  // MARK: Gradient
  private let gradientView: MainGradientView = {
    $0.isUserInteractionEnabled = false
    let color = UIColor(
      white: .zero,
      alpha: Const.gradientOpacity
    )
    $0.setColors([
      MainGradientView.Color(
        color: .clear,
        location: Const.gradientEndLocation
      ),
      MainGradientView.Color(
        color: color,
        location: Const.gradientStartLocation
      )
    ])
    return $0
  }(MainGradientView())
  
  // MARK: ImageViews
  private let totalLikesImageView: UIImageView = {
    $0.contentMode = .scaleAspectFill
    $0.image = UIImage(systemName: .heartImage)
    $0.tintColor = .systemPink
    return $0
  }(UIImageView())
  
  private let totalPhotosImageView: UIImageView = {
    $0.contentMode = .scaleAspectFill
    $0.image = UIImage(systemName: .photosImage)
    $0.tintColor = .white
    return $0
  }(UIImageView())
  
  private let totalAlbumsImageView: UIImageView = {
    $0.contentMode = .scaleAspectFill
    $0.image = UIImage(systemName: .albumsImage)
    $0.tintColor = .white
    return $0
  }(UIImageView())
  
  private let locationImageView: UIImageView = {
    $0.contentMode = .scaleAspectFill
    $0.image = UIImage(systemName: .locationImage)
    $0.tintColor = .white
    return $0
  }(UIImageView())
  
  // MARK: Labels
  let nameLabel: UILabel = {
    $0.textColor = .white
    $0.numberOfLines = .zero
    $0.font = UIFont(
      name: .timesNewRomanBold,
      size: Const.userNameFontSize
    )
    return $0
  }(UILabel())
  
  let bioLabel: UILabel = {
    $0.textColor = .white
    $0.textAlignment = .center
    $0.numberOfLines = .zero
    $0.font = .systemFont(
      ofSize: Const.defaultFontSize,
      weight: .medium
    )
    return $0
  }(UILabel())
  
  let totalLikesLabel: UILabel = {
    $0.textColor = .white
    $0.font = .systemFont(
      ofSize: Const.defaultFontSize,
      weight: .medium
    )
    return $0
  }(UILabel())
  
  let totalPhotosLabel: UILabel = {
    $0.textColor = .white
    $0.font = .systemFont(
      ofSize: Const.defaultFontSize,
      weight: .medium
    )
    return $0
  }(UILabel())
  
  let totalAlbumsLabel: UILabel = {
    $0.textColor = .white
    $0.font = .systemFont(
      ofSize: Const.defaultFontSize,
      weight: .medium
    )
    return $0
  }(UILabel())
  
  let locationLabel: UILabel = {
    $0.textColor = .white
    $0.font = .systemFont(
      ofSize: Const.defaultFontSize,
      weight: .medium
    )
    return $0
  }(UILabel())
  
  // MARK: Lines
  private let firstLine: UIView = {
    $0.backgroundColor = .white
    $0.alpha = Const.defaultOpacity
    $0.heightAnchor.constraint(
      equalToConstant: Const.lineWidth
    ).isActive = true
    return $0
  }(UIView())
  
  private let secondLine: UIView = {
    $0.backgroundColor = .white
    $0.alpha = Const.defaultOpacity
    $0.heightAnchor.constraint(
      equalToConstant: Const.lineWidth
    ).isActive = true
    return $0
  }(UIView())
  
  // MARK: StackViews
  private lazy var profilePhotoAndNameLabelStackView: UIStackView = {
    $0.axis = .vertical
    $0.distribution = .fill
    $0.alignment = .center
    $0.spacing = Const.stackViewSpacing
    $0.addArrangedSubview(profilePhotoView)
    $0.addArrangedSubview(nameLabel)
    $0.addArrangedSubview(locationStackView)
    $0.addArrangedSubview(bioLabel)
    return $0
  }(UIStackView())
  
  private lazy var locationStackView: UIStackView = {
    $0.axis = .horizontal
    $0.distribution = .fill
    $0.alignment = .center
    $0.spacing = Const.smallStackViewSpacing
    $0.addArrangedSubview(locationImageView)
    $0.addArrangedSubview(locationLabel)
    return $0
  }(UIStackView())
  
  private lazy var totalLikesStackView: UIStackView = {
    $0.axis = .horizontal
    $0.distribution = .fill
    $0.alignment = .center
    $0.spacing = Const.smallStackViewSpacing
    $0.addArrangedSubview(totalLikesImageView)
    $0.addArrangedSubview(totalLikesLabel)
    return $0
  }(UIStackView())
  
  private lazy var totalPhotosStackView: UIStackView = {
    $0.axis = .horizontal
    $0.distribution = .fill
    $0.alignment = .center
    $0.spacing = Const.smallStackViewSpacing
    $0.addArrangedSubview(totalPhotosImageView)
    $0.addArrangedSubview(totalPhotosLabel)
    return $0
  }(UIStackView())
  
  private lazy var totalAlbumsStackView: UIStackView = {
    $0.axis = .horizontal
    $0.distribution = .fill
    $0.alignment = .center
    $0.spacing = Const.smallStackViewSpacing
    $0.addArrangedSubview(totalAlbumsImageView)
    $0.addArrangedSubview(totalAlbumsLabel)
    return $0
  }(UIStackView())
  
  private lazy var profitStackView: UIStackView = {
    $0.axis = .horizontal
    $0.distribution = .equalSpacing
    $0.spacing = Const.stackViewSpacing
    $0.addArrangedSubview(UIView())
    $0.addArrangedSubview(totalLikesStackView)
    $0.addArrangedSubview(totalPhotosStackView)
    $0.addArrangedSubview(totalAlbumsStackView)
    $0.addArrangedSubview(UIView())
    return $0
  }(UIStackView())
  
  private lazy var infoStackView: UIStackView = {
    $0.axis = .vertical
    $0.distribution = .equalSpacing
    $0.spacing = Const.smallStackViewSpacing
    $0.addArrangedSubview(profilePhotoAndNameLabelStackView)
    $0.addArrangedSubview(firstLine)
    $0.addArrangedSubview(profitStackView)
    $0.addArrangedSubview(secondLine)
    return $0
  }(UIStackView())
  
  // MARK: - Initializers
  init() {
    super.init(frame: .zero)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError(.requiredInitFatalErrorText)
  }
  
  // MARK: Setup Data
  func setupData(viewModel: any UserProfileViewModelProtocol) {
    let viewModelItem = viewModel.getUserProfileViewModelItem()
    guard let viewModelItem = viewModelItem else { return }
    let user = viewModelItem.user
    let profilePhotoURL = user.regularURL
    profilePhotoView.configure(with: user, url: profilePhotoURL)
    nameLabel.text = viewModelItem.displayName
    bioLabel.text = viewModelItem.userBio
    totalLikesLabel.text = viewModelItem.totalLikes
    totalPhotosLabel.text = viewModelItem.totalPhotos
    totalAlbumsLabel.text = viewModelItem.totalCollections
    locationLabel.text = viewModelItem.location
  }
  
  // MARK: Setup Views
  private func setupViews() {
    addSubviews()
    setupConstraints()
  }
  
  private func addSubviews() {
    addSubview(gradientView)
    addSubview(infoStackView)
  }
  
  private func setupConstraints() {
    gradientView.fillSuperView()
    infoStackView.setConstraints(
      right: rightAnchor,
      bottom: bottomAnchor,
      left: leftAnchor,
      pRight: Const.rightPadding,
      pBottom: Const.bottomPadding,
      pLeft: Const.leftPadding
    )
  }
  
}

enum UserProfileViewControllerRootViewConst {
  static let gradientOpacity: CGFloat = 0.8
  static let gradientStartLocation: CGFloat = 0.9
  static let gradientEndLocation: CGFloat = 0.1
  static let defaultFontSize: CGFloat = 14.0
  static let userNameFontSize: CGFloat = 35.0
  static let profilePhotoSize: CGFloat = 100.0
  static let profilePhotoCircle: CGFloat = profilePhotoSize / 2
  static let smallStackViewSpacing: CGFloat = 16.0
  static let stackViewSpacing: CGFloat = 32.0
  static let defaultOpacity: CGFloat = 0.4
  static let lineWidth: CGFloat = 1.0
  static let rightPadding: CGFloat = 20.0
  static let bottomPadding: CGFloat = 300.0
  static let leftPadding: CGFloat = 20.0
}
