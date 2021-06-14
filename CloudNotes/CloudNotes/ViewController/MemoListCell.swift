//
//  TableViewCell.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import UIKit

final class MemoListCell: UITableViewCell {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    self.accessoryType = .disclosureIndicator
    setView()
    setAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func prepareForReuse() {
    titleLabel.text = nil
    dateLabel.text = nil
    contentLabel.text = nil
  }
  
  lazy var titleLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .title1)
    return label
  }()
  
  lazy var dateLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .body)
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    return label
  }()
  
  lazy var contentLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .body)
    label.textColor = .systemGray
    return label
  }()
  
  lazy var stackView: UIStackView = {
    var stackView = UIStackView(arrangedSubviews: [dateLabel, contentLabel])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.spacing = 20
    return stackView
  }()
  
  private func setView() {
    self.contentView.addSubview(titleLabel)
    self.contentView.addSubview(stackView)
  }
  
  private func setAutoLayout() {
    let margins = contentView.layoutMarginsGuide
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: margins.topAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
      stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
    ])
  }
  
  func configure(with viewModel: MemoViewModel) {
    if viewModel.title.isEmpty == true {
      titleLabel.text = "새로운 메세지"
    } else {
      titleLabel.text = viewModel.title
    }
    if viewModel.content.isEmpty == true {
      contentLabel.text = "추가 텍스트 없음"
    } else {
      let splitString = viewModel.content.split(separator: "\n").map{ String($0) }.first
      contentLabel.text = splitString
    }
    dateLabel.text = viewModel.date
  }
}

struct MemoViewModel {
  let title: String
  let date: String
  let content: String
}
