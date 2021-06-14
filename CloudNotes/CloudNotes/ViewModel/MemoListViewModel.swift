//
//  TableViewModel.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import Foundation

final class MemoListViewModel {
  private var memoServiceAdapter = MemoProvider.shared
  
  enum Style {
    static let dateFormTemplate = "yyyy. MM. d"
  }
  
  //Core Data에서 가지고 온 Memo 배열을 날짜 순서대로 정렬해보자!!!
  private var memos: [Memo] {
    var memos = memoServiceAdapter.fetchMemos()
    memos = memos.sorted(by: {
      return $0.lastModified > $1.lastModified
    })
    return memos
  }
  
  //Memo 배열을 가지고 List의 Cell에 들어갈 MemoViewModel을 정의해서 연산프로퍼티로 정의해보자!!
  private var memoViewModels: [MemoViewModel] {
    var memoViewModels: [MemoViewModel] = [MemoViewModel]()
    let dateFormatter: DateFormatter = DateFormatter()
    for memo in memos {
      let date = Date(timeIntervalSince1970: TimeInterval(memo.lastModified))
      dateFormatter.locale = Locale(identifier: Locale.current.identifier)
      dateFormatter.setLocalizedDateFormatFromTemplate(Style.dateFormTemplate)
      guard let title = memo.title else { return [] }
      guard let body = memo.body else { return [] }
      let dateString = dateFormatter.string(from: date)
      memoViewModels.append(MemoViewModel(title: title, date: dateString, content: body))
    }
    return memoViewModels
  }
  
  var count: Int {
    return memos.count
  }
  
  func addMemo(_ memo: Memo) {
    memos?.append(memo)
  }
  
  func getMemoViewModel(for indexPath: IndexPath) -> MemoViewModel? {
    guard let memoViewModels = memoViewModels else { return nil }
    let memoViewModel = memoViewModels[indexPath.row]
    return memoViewModel
  }
  
  func getMemo(for indexPath: IndexPath) -> Memo? {
    guard let memos = memos else { return nil }
    return memos[indexPath.row]
  }
}
