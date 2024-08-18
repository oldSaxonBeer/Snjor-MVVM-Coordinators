//
//  TopicPhotoCellMainView.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 17.08.2024.
//

import UIKit

protocol TopicPhotoCellMainViewDelegate: AnyObject {
  func downloadTapped()
}

final class TopicPhotoCellMainView: BaseImageContainerView {
  
  // MARK: - Delegate
  weak var delegate: (any TopicPhotoCellMainViewDelegate)?
  
  // MARK: - Private Properties
  private var screenScale: CGFloat {
    UIScreen.main.scale
  }
  
  private var showsUsername = true {
    didSet {
      userNameLabel.alpha = showsUsername ? GlobalConst.maxAlpha : .zero
      gradientView.alpha = showsUsername ? GlobalConst.maxAlpha : .zero
    }
  }
  
  // MARK: - Gradient
  let gradientView: GradientView = {
    let color = UIColor(
      white: .zero,
      alpha: BasePhotoViewConst.gradientAlpha
    )
    $0.setColors([
      GradientView.Color(
        color: .clear,
        location: BasePhotoViewConst.downLocation
      ),
      GradientView.Color(
        color: color,
        location: BasePhotoViewConst.upLocation
      )
    ])
    return $0
  }(GradientView())
  
  // MARK: - Spinner
  lazy var spinner: UIActivityIndicatorView = {
    let xCenter = self.downloadButtonBlurEffect.contentView.bounds.midX
    let yCenter = self.downloadButtonBlurEffect.contentView.bounds.midY
    $0.center = CGPoint(x: xCenter, y: yCenter)
    $0.stopAnimating()
    $0.color = .label
    $0.transform = CGAffineTransform(
      scaleX: PhotoDetailRootViewConst.spinnerScale, 
      y: PhotoDetailRootViewConst.spinnerScale
    )
    $0.alpha = GlobalConst.defaultAlpha
    $0.isHidden = true
    return $0
  }(UIActivityIndicatorView(style: .medium))
  
  // MARK: - Blur Effects
  let downloadButtonBlurEffect: UIVisualEffectView = {
    $0.frame.size.width = GlobalConst.fullValue
    $0.frame.size.height = GlobalConst.fullValue
    $0.layer.cornerRadius = GlobalConst.defaultValue
    $0.clipsToBounds = true
    $0.widthAnchor.constraint(
      equalToConstant: GlobalConst.fullValue
    ).isActive = true
    $0.heightAnchor.constraint(
      equalToConstant: GlobalConst.fullValue
    ).isActive = true
    return $0
  }(UIVisualEffectView(effect: UIBlurEffect(style: .regular)))
  
  // MARK: - Buttons
  lazy var downloadButton: UIButton = {
    let icon = UIImage(systemName: .downloadCellButtonImage)
    $0.setImage(icon, for: .normal)
    $0.tintColor = .label
    $0.setTitleColor(.label, for: .normal)
    $0.alpha = GlobalConst.defaultAlpha
    $0.frame = downloadButtonBlurEffect.bounds
    return $0
  }(UIButton(type: .custom))
  
  // MARK: - Labels
  let userNameLabel: UILabel = {
    $0.textColor = .white
    $0.font = .systemFont(
      ofSize: GlobalConst.defaultFontSize,
      weight: .medium
    )
    $0.numberOfLines = 0
    return $0
  }(UILabel())

  // MARK: - Initializers
  override init() {
    super.init()
    configDownloadButtonAction()
    setupPhotoCellViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Sized Image
  override func sizedImageURL(from url: URL) -> URL {
    layoutIfNeeded()
    let widthValue = String(describing: frame.width)
    let screenScaleValue = String(describing: Int(screenScale))
    let widthQueryItem = URLQueryItem(
      name: .width,
      value: widthValue
    )
    let screenScaleQueryItem = URLQueryItem(
      name: .devicePixelRatio,
      value: screenScaleValue
    )
    return url.appending(
      queryItems: [widthQueryItem, screenScaleQueryItem]
    )
  }

  // MARK: - Setup Data
  func configure(
    with photo: Photo,
    showsUsername: Bool = true,
    url: URL?
  ) {
    super.configure(
      url: url,
      blurHash: photo.blurHash,
      photoID: photo.id
    )
    self.showsUsername = showsUsername
    userNameLabel.text = photo.user.displayName
  }
  
  func prepareForReuse() {
    reset()
  }
  
  private func reset() {
    currentPhotoID = nil
    mainImageView.image = nil
    userNameLabel.text = nil
    imageDownloader.cancel()
    downloadButton.isHidden = false
    spinner.isHidden = true
    spinner.stopAnimating()
  }
  
  // MARK: - Setup Views
  private func setupPhotoCellViews() {
    addSubviews()
    setupConstraints()
  }
  
  private func addSubviews() {
    addSubview(gradientView)
    addSubview(downloadButtonBlurEffect)
    addSubview(userNameLabel)
    downloadButtonBlurEffect.contentView.addSubview(downloadButton)
    downloadButtonBlurEffect.contentView.addSubview(spinner)
  }

  private func setupConstraints() {
    setupGradientConstraints()
    setupBlurEffectConstraints()
    setupUserNameLabelConstraints()
  }

  private func setupGradientConstraints() {
    gradientView.fillSuperView()
  }

  private func setupBlurEffectConstraints() {
    downloadButtonBlurEffect.setConstraints(
      top: topAnchor,
      right: rightAnchor,
      pTop: GlobalConst.defaultValue,
      pRight: GlobalConst.defaultValue
    )
  }

  private func setupUserNameLabelConstraints() {
    userNameLabel.setConstraints(
      right:  mainImageView.rightAnchor,
      bottom: mainImageView.bottomAnchor,
      left: mainImageView.leftAnchor,
      pRight: GlobalConst.defaultValue,
      pBottom: GlobalConst.defaultValue,
      pLeft: GlobalConst.defaultValue
    )
  }

  // MARK: - Config Actions
  private func configDownloadButtonAction() {
    let downloadButtonAction = downloadAction()
    addAction(downloadButtonAction)
  }

  private func downloadAction() -> UIAction {
    return UIAction { [weak self] _ in
      guard
        let self = self,
        let delegate = delegate
      else {
        return
      }
      animateButton()
      delegate.downloadTapped()
    }
  }

  private func addAction(_ action: UIAction) {
    downloadButton.addAction(
      action,
      for: .touchUpInside
    )
  }

  // MARK: - Animate Buttons
  private func animateButton() {
    UIView.animate(withDuration: PhotoCellMainViewConst.duration) {
      let scaleTransform = CGAffineTransform(
        scaleX: PhotoCellMainViewConst.scale,
        y: PhotoCellMainViewConst.scale
      )
      self.downloadButtonBlurEffect.transform = scaleTransform
    } completion: { _ in
      UIView.animate(withDuration: PhotoCellMainViewConst.duration) {
        self.downloadButton.isHidden = true
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        self.downloadButtonBlurEffect.transform = .identity
      }
    }
  }
}