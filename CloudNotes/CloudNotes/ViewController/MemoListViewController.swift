//
//  TableViewController.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import UIKit

final class MemoListViewController: UITableViewController {
  // MARK: - Constant and Variable
  
  private let tableViewModel: MemoListViewModel = MemoListViewModel()
  
  enum Style {
    static let firstRow: Int = 0
    static let swipeButtonTitle: String = "Delete"
    static let titleString = "메모"
    static let reuseIdentifier = "memoReuseCell"
  }
  
  // MARK: - UI Component & action function
  
  lazy var addButton: UIBarButtonItem = {
    let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMemo))
    return button
  }()
  
  @objc func addMemo() {
    let indexPath = IndexPath(row: Style.firstRow, section: .zero)
    tableViewModel.addMemo()
    tableView.insertRows(at: [indexPath], with: .automatic)
    showMemo(indexPath: indexPath)
  }
  
  //MARK: - Life Cycle function
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.rightBarButtonItem = addButton
    self.navigationItem.title = Style.titleString
    configureTableView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    deleteEmptyMemo()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  //MARK: - tableView configure
  
  private func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(MemoListCell.self, forCellReuseIdentifier: Style.reuseIdentifier)
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewModel.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
  -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Style.reuseIdentifier)
            as? MemoListCell else {
      return UITableViewCell()
    }
    let viewModel = tableViewModel.getMemoViewModel(for: indexPath)
    cell.configure(with: viewModel)
    return cell
  }
  
  // MARK: - Table view Delegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    showMemo(indexPath: indexPath)
  }
  
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .destructive, title: Style.swipeButtonTitle, handler: { (action, view, completionHandler) in
      self.tableViewModel.deleteMemo(indexPath)
      tableView.reloadData()
    })
    return UISwipeActionsConfiguration(actions: [action])
  }
  
  private func showMemo(indexPath: IndexPath) {
    guard let splitViewController = splitViewController as? SplitViewController else { return }
    guard let detailViewController = splitViewController.viewController(for: .secondary)
            as? MemoDetailViewController else {
      return
    }
    guard let memo = tableViewModel.getMemo(for: indexPath) else { return }
    detailViewController.configure(with: memo)
    showDetailViewController(detailViewController, sender: self)
  }
  
  private func deleteEmptyMemo() {
    if tableViewModel.isExistedEmptyMemo == true {
      let indexPath = IndexPath(row: Style.firstRow, section: 0)
      tableViewModel.deleteMemo(indexPath)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
}
