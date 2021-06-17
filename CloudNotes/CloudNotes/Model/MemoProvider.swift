//
//  MemoItemProvider.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import UIKit
import CoreData

final class MemoProvider {
<<<<<<< Updated upstream
  static var shared: MemoProvider = MemoProvider()
  
  private init() { }
  
  // MARK: - Core Data stack
  private let persistentContainer: NSPersistentCloudKitContainer = {
    let container = NSPersistentCloudKitContainer(name: "CloudNotes")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
=======
  static let shared: MemoProvider = MemoProvider()
  private init() { }
  var memos: [Memo]?
  var delegate: MemoProviderDelegate?
  private let currentViewController = UIApplication.shared.connectedScenes
    .filter({$0.activationState == .foregroundActive})
    .map({$0 as? UIWindowScene})
    .compactMap({$0})
    .first?.windows
    .filter({$0.isKeyWindow}).first?.rootViewController
  
  // MARK: - Core Data stack
  
  lazy var persistentContainer: NSPersistentCloudKitContainer = {
    let container = NSPersistentCloudKitContainer(name: "CloudNotes")
    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        let alert = UIAlertController(title: "CoreData Store Container Error",
                                      message: error.description,
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.currentViewController?.present(alert, animated: true, completion: nil)
>>>>>>> Stashed changes
      }
    })
    return container
  }()
  
  var context: NSManagedObjectContext {
<<<<<<< Updated upstream
    return self.persistentContainer.viewContext
  }
  
  // MARK: - Core Data Saving support
=======
    return persistentContainer.viewContext
  }
  
  // MARK: - Core Data Saving support
  
>>>>>>> Stashed changes
  func saveContext () {
    if context.hasChanges {
      do {
        try context.save()
      } catch {
<<<<<<< Updated upstream
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
=======
        let alert = UIAlertController(title: "Don't save Core Data",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        currentViewController?.present(alert, animated: true, completion: nil)
>>>>>>> Stashed changes
      }
    }
  }
  
<<<<<<< Updated upstream
  func fetchMemos() -> [Memo] {
    do {
      guard let fetchResult = try context.fetch(Memo.fetchRequest()) as? [Memo] else {
        return []
      }
      return fetchResult
    } catch {
      fatalError(error.localizedDescription)
    }
=======
  //MARK: - Memo CRUD Method
  
  func createMemo() {
    context.perform {
      self.delegate?.memoDidCreate()
      self.fetchMemo()
    }
  }
  
  func fetchMemo() {
    do {
      let request: NSFetchRequest<Memo> = Memo.fetchRequest()
      let sort: NSSortDescriptor = NSSortDescriptor(key: "lastModified", ascending: false)
      request.sortDescriptors = [sort]
      self.memos = try context.fetch(request)
    } catch {
      let alert = UIAlertController(title: "Fetch Memo Data Error",
                                    message: error.localizedDescription,
                                    preferredStyle: .alert)
      let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      alert.addAction(cancel)
      currentViewController?.present(alert, animated: true, completion: nil)
    }
  }
  
  func updateMemo(indexPath: IndexPath, title: String, body: String) {
    guard let memos = memos else { return }
    let memo = memos[indexPath.row]
    memo.title = title
    memo.body = body
    memo.lastModified = Date()
    saveContext()
    delegate?.memoDidUpdate(indexPath: indexPath)
  }
  
  func deleteMemo(indexPath: IndexPath) {
    guard let memos = memos else { return }
    let memo = memos[indexPath.row]
    context.delete(memo)
>>>>>>> Stashed changes
  }
}
