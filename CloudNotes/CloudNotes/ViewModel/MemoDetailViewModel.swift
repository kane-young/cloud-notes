//
//  MemoDetailViewModel.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import Foundation
import CoreData

final class MemoDetailViewModel {
  private enum ContentConstant {
    static let emptyString = ""
    static let doubleNewLine = "\n\n"
  }
  
  var delegate: MemoDetailViewModelDelegate?
  private var memo: Memo?
  var indexPath: IndexPath?

  var date: Date {
    guard let memo = memo else { return Date() }
    guard let date = memo.lastModified else { return Date() }
    return date
  }
  
  var content: String {
    guard let memo = memo else { return ContentConstant.emptyString }
    let title = memo.title ?? ContentConstant.emptyString
    let body = memo.body ?? ContentConstant.emptyString
    if title.isEmpty == true && body.isEmpty == true { return ContentConstant.emptyString }
    return title + ContentConstant.doubleNewLine + body
  }
  
  func configure(with memo: Memo, indexPath: IndexPath) {
    self.memo = memo
    self.indexPath = indexPath
    delegate?.changeMemo(content: content)
  }
  
  func changeIndex(_ indexPath: IndexPath) {
    self.indexPath = indexPath
  }
}

protocol MemoDetailViewModelDelegate: NSObject {
  func changeMemo(content: String)
}
