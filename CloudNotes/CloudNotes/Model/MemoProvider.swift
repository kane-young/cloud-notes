//
//  MemoItemProvider.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import UIKit
import CoreData

final class MemoProvider {
  private let currentViewController = UIApplication.shared.connectedScenes
    .filter({$0.activationState == .foregroundActive})
    .map({$0 as? UIWindowScene})
    .compactMap({$0})
    .first?.windows
    .filter({$0.isKeyWindow}).first?.rootViewController
  
  // MARK: - For Single Tone
  static let shared: MemoProvider = MemoProvider()
  private init() { }
    
  // MARK: - Core Data stack
  lazy var persistentContainer: NSPersistentCloudKitContainer = {
    let container = NSPersistentCloudKitContainer(name: "CloudNotes")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        self.presentAlert("Core Data Store Container Error", error: error)
      }
    })
    return container
  }()
  
  private lazy var context = persistentContainer.viewContext
  
  // MARK: - Core Data Saving support
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        presentAlert("Core Data Save Error", error: error)
      }
    }
  }
  
  // MARK: - Manage Memo Data
  private var memos: [Memo]?
  var delegate: MemoProviderDelegate?

  func createMemoData() {
    let newMemo = Memo(context: context)
    newMemo.lastModified = Date()
    self.memos?.insert(newMemo, at: 0)
    let newIndexPath = IndexPath(row: .zero, section: .zero)
    self.delegate?.memoDidCreate(newMemo, indexPath: newIndexPath)
  }
  
  func fetchMemoData() {
    let request: NSFetchRequest<Memo> = Memo.fetchRequest()
    let sort = NSSortDescriptor(key: "lastModified", ascending: false)
    request.sortDescriptors = [sort]
    do {
      self.memos = try context.fetch(request)
    } catch {
      presentAlert("Memo Data Fetch Error", error: error)
    }
  }
  
  func updateMemoData(indexPath: IndexPath, title: String, body: String) {
    let memo = memos?[indexPath.row]
    memo?.lastModified = Date()
    memo?.title = title
    memo?.body = body
    delegate?.memoDidUpdate(indexPath: indexPath, title: title, body: body)
  }
  
  func deleteMemoData(indexPath: IndexPath) {
    guard let memoToDelete = memos?[indexPath.row] else { return }
    context.delete(memoToDelete)
    self.memos?.remove(at: indexPath.row)
    self.delegate?.memoDidDelete(indexPath: indexPath)
  }
}

extension MemoProvider {
  func presentAlert(_ title: String, error: Error) {
    let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(cancel)
    currentViewController?.present(alert, animated: true, completion: nil)
  }
}
