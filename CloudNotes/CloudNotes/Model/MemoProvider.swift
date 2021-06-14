//
//  MemoItemProvider.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import UIKit
import CoreData

final class MemoProvider {
  static var shared: MemoProvider = MemoProvider()
  
  private init() { }
  
  // MARK: - Core Data stack
  private let persistentContainer: NSPersistentCloudKitContainer = {
    let container = NSPersistentCloudKitContainer(name: "CloudNotes")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  var context: NSManagedObjectContext {
    return self.persistentContainer.viewContext
  }
  
  // MARK: - Core Data Saving support
  func saveContext () {
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  func fetchMemos() -> [Memo] {
    do {
      guard let fetchResult = try context.fetch(Memo.fetchRequest()) as? [Memo] else {
        return []
      }
      return fetchResult
    } catch {
      fatalError(error.localizedDescription)
    }
  }
}
