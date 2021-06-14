//
//  MemoDetailViewModel.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import Foundation

final class MemoDetailViewModel {
  private enum ContentConstant {
    static let emptyString = ""
    static let doubleNewLine = "\n\n"
  }
  
  private let context = MemoProvider.shared.context
  private lazy var memo: Memo = Memo(context: context)
  var delegate: MemoDetailViewModelDelegate?
  var date: Int32 {
    return memo.lastModified
  }
  var content: String {
    guard let title = memo.title else { return ContentConstant.emptyString }
    guard let body = memo.body else { return ContentConstant.emptyString }
    return title + ContentConstant.doubleNewLine + body
  }
  
  func configure(with memo: Memo) {
    self.memo = memo
    delegate?.changeMemo(content: content)
  }
}

protocol MemoDetailViewModelDelegate: NSObject {
  func changeMemo(content: String)
}
