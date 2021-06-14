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
  
  var isExistedEmptyMemo: Bool {
    guard let firstMemo = memos.first else { return false }
    if firstMemo.title?.isEmpty == true {
      return true
    }
    return false
  }
  
  //만든 memoViewModels배열에서 필요한 index의 MemoViewModel만 가지고 오자!!
  func getMemoViewModel(for indexPath: IndexPath) -> MemoViewModel {
    let memoViewModel = memoViewModels[indexPath.row]
    return memoViewModel
  }
  
  //getMemo 메서드는 이제 DetailViewController로 넘어갈때 필요한 Memo가 어떤 것인지 알고 가져가기 위해서 정의해준 것이다
  func getMemo(for indexPath: IndexPath) -> Memo? {
    return memos[indexPath.row]
  }
  
  // BarButton에 있는 + 버튼으로 Memo를 추가해주기 위해서!!! CoreData 내에 저장해주는 로직!!
  func addMemo() {
    let memo = Memo(context: memoServiceAdapter.context)
    memo.title = ""
    memo.body = ""
    memo.lastModified = Int32(Date().timeIntervalSince1970)
    memoServiceAdapter.saveContext()
  }
  
  // Swipe 했을 경우 Memo가 삭제되는 것을 구현하기 위한 로직
  func deleteMemo(_ indexPath: IndexPath) {
    let memo = self.memos[indexPath.row]
    memoServiceAdapter.context.delete(memo)
    memoServiceAdapter.saveContext()
  }
}
