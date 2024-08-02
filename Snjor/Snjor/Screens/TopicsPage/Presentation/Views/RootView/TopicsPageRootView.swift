//
//  TopicsPageRootView.swift
//  Snjor
//
//  Created by Adam on 26.07.2024.
//

import UIKit

final class TopicPageRootView: UIView {
  
  // MARK: - Internal Views
  let pageViewController: UIPageViewController = {
    $0.view.backgroundColor = .clear
    return $0
  }(UIPageViewController(
    transitionStyle: .scroll,
    navigationOrientation: .horizontal,
    options: nil
  ))
  
  let categoryCollectionView: TopicsPageCategoryCollectionView = {
    $0.heightAnchor.constraint(equalToConstant: 40).isActive = true
    return $0
  }(TopicsPageCategoryCollectionView())
  
  // MARK: - Private Views
  private let appNameLabel: UILabel = {
    let text = "Snjør"
    let fontSize = UIFont.systemFont(ofSize: 20, weight: .bold)
    let attributes: [NSAttributedString.Key: Any] = [
      .kern: 0.5,
      .font: fontSize
    ]
    $0.attributedText = NSAttributedString(string: text, attributes: attributes)
    $0.textColor = .white
    return $0
  }(UILabel())
  
  private let gradientView: GradientView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setColors([
      GradientView.Color(
        color: UIColor(white: 0, alpha: 1.0),
        location: 0.1
      ),
      GradientView.Color(
        color: .clear,
        location: 0.25
      ),
    ])
    $0.isUserInteractionEnabled = false
    return $0
  }(GradientView())
  
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
    addSubview(pageViewController.view)
    addSubview(gradientView)
    addSubview(categoryCollectionView)
    addSubview(appNameLabel)
  }
  
  private func setupConstraints() {
    setupCategoryCollectionViewConstraints()
    setupPageViewControllerViewConstraints()
    setupGradientViewConstraints()
    setupAppNameLabelConstraints()
  }
  
  private func setupCategoryCollectionViewConstraints() {
    categoryCollectionView.setConstraints(
      top: safeAreaLayoutGuide.topAnchor,
      right: rightAnchor,
      left: leftAnchor,
      pTop: 45
    )
  }
  
  private func setupPageViewControllerViewConstraints() {
    pageViewController.view.fillSuperView()
  }
  
  private func setupGradientViewConstraints() {
    gradientView.setConstraints(
      top: topAnchor,
      right: rightAnchor,
      bottom: bottomAnchor,
      left: leftAnchor,
      pTop: -40
    )
  }
  
  private func setupAppNameLabelConstraints() {
    appNameLabel.centerX()
    appNameLabel.setConstraints(
      top: safeAreaLayoutGuide.topAnchor,
      pTop: 15
    )
  }
}