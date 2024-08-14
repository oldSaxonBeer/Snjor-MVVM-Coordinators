//
//  TagCell.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 12.08.2024.
//

import UIKit

final class TagCell: UICollectionViewCell, Reusable {
  
  private let tagLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 11, weight: .medium)
    label.textColor = .systemBackground
    label.textAlignment = .center
    label.backgroundColor = .systemOrange
    label.layer.cornerRadius = 11
    label.layer.masksToBounds = true
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(tagLabel)
    tagLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tagLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      tagLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      tagLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      tagLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with tag: Tag) {
    tagLabel.text = "# " + tag.title
  }
}