//
//  TableViewController.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import UIKit

class MemoListViewController: UITableViewController {
  private let reuseIdentifier = "memoReuseCell"
  private let titleString = "메모"
  private let tableViewModel: MemoListViewModel = MemoListViewModel()
  
  lazy var addButton: UIBarButtonItem = {
    let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMemo))
    return button
  }()
  
  @objc func addMemo() {
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.rightBarButtonItem = addButton
    self.navigationItem.title = titleString
    configureTableView()
  }
  
  private func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(MemoListCell.self, forCellReuseIdentifier: reuseIdentifier)
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewModel.getNumberOfMemo()
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
            as? MemoListCell else {
      return UITableViewCell()
    }
    
    guard let viewModel = tableViewModel.getMemoViewModel(for: indexPath) else {
      return UITableViewCell()
    }
    
    cell.configure(with: viewModel)
    return cell
  }
  
  // MARK: - Table view Delegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let navigationController = UINavigationController(rootViewController: MemoDetailViewController())
    guard let memoDetailVC = navigationController.viewControllers.first as? MemoDetailViewController else {
      return
    }
    
    guard let memo = tableViewModel.getMemo(for: indexPath) else { return }
    memoDetailVC.configure(with: memo)
    showDetailViewController(navigationController, sender: self)
  }
}