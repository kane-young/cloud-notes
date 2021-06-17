//
//  MemoProviderDelegate.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/16.
//

import UIKit

protocol MemoProviderDelegate: AnyObject {
  func memoDidCreate()
  func memoDidUpdate(indexPath: IndexPath)
  func memoDidDelete(indexPath: IndexPath)
}
