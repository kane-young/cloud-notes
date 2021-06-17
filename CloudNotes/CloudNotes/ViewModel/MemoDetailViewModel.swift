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
    static let doubleNewLine = "\n"
  }
  
  private let context = MemoProvider.shared.context
  private lazy var memo: Memo = Memo(context: context)
  var delegate: MemoDetailViewModelDelegate?
  
  var date: Date { return memo?.lastModified }
  var content: String {
    let title = memo?.title ?? ""
    let body = memo?.body ?? ""
    if title.isEmpty == true && body.isEmpty == true {
      return ContentConstant.emptyString
    }
    return title + ContentConstant.doubleNewLine + body
  }
  
  func configure(with memo: Memo) {
    self.memo = memo
    delegate?.changeMemo(content: content)
  }
  
  func saveData(_ text: String) {
    let seperatedText = seperateMemo(text)
    guard let title = seperatedText?.title else { return }
    guard let body = seperatedText?.body else { return }
    memo.setValue(title, forKey: "title")
    memo.setValue(body, forKey: "body")
    memo.setValue(Int32(Date().timeIntervalSince1970), forKey: "lastModified")
    do {
      try self.context.save()
    } catch {
      fatalError(error.localizedDescription)
    }
  }
  
  private func seperateMemo(_ text: String) -> (title: String, body: String)? {
    let seperatedText = text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
    var title = ""
    var body = ""
    switch seperatedText.count {
    case 0:
      break
    case 1:
      title = String(seperatedText[0])
    case 2:
      title = String(seperatedText[0])
      body = String(seperatedText[1])
    default:
      return nil
    }
    return (title, body)
  }
}

protocol MemoDetailViewModelDelegate: NSObject {
  func changeMemo(content: String)
}
