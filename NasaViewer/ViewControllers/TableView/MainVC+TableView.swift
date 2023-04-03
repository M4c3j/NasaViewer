//
//  MainVC+TableView.swift
//  NasaViewer
//
//  Created by Maciej Lipiec on 2023-03-22.
//

import UIKit

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func createTableView() {
        registerCells()
        configureTableView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO: Make Switch with possible cells and create new cell for big picture, when user taps on picture show bigger inside, when he taps on rest show nav link to full side.
        let dataIndex = indexPath.row
        if selectedRow == indexPath {
            return createBigCell(forIndex: dataIndex)
        }
        else if dataIndex % 2 == 0 {
            return createRightCell(forIndex: dataIndex)
        } else {
            return createLeftCell(forIndex: dataIndex)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == selectedRow {
            // Deselect the row and reset selectedRow to an empty IndexPath
            selectedRow = nil
            UIView.animate(withDuration: 0.3) {
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            UIView.animate(withDuration: 0.3, delay: 0.3) {
                tableView.scrollToRow(at: self.rowsPosition?.first ?? indexPath, at: .top, animated: false)
            }
        } else {
            // Deselect the currently selected row, select the new row and update selectedRow
            var indexPathsToReload = [IndexPath]()
            if let previousSelectedRow = selectedRow {
                indexPathsToReload.append(previousSelectedRow)
            }
            selectedRow = indexPath
            indexPathsToReload.append(indexPath)
            tableView.reloadRows(at: indexPathsToReload, with: .automatic)
            rowsPosition = tableView.indexPathsForVisibleRows
            tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedRow == indexPath {
            return tableView.frame.height
        } else {
            return 120
        }
    }

}

extension MainViewController {
    
    private func registerCells() {
        tableView.register(ImageOnRightCell.self, forCellReuseIdentifier: ImageOnRightCell.identifier)
        tableView.register(ImageOnLeftCell.self, forCellReuseIdentifier: ImageOnLeftCell.identifier)
        tableView.register(BigImageCell.self, forCellReuseIdentifier: BigImageCell.identifier)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 4, bottom: 10, right: 4)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func createRightCell(forIndex dataIndex: Int) -> UITableViewCell {
        let rightImageCell = tableView.dequeueReusableCell(withIdentifier: ImageOnRightCell.identifier) as! ImageOnRightCell
        rightImageCell.configureCell(data: self.data[dataIndex])
        return rightImageCell
    }
    
    private func createLeftCell(forIndex dataIndex: Int) -> UITableViewCell {
        let leftImageCell = tableView.dequeueReusableCell(withIdentifier: ImageOnLeftCell.identifier) as! ImageOnLeftCell
        leftImageCell.configureCell(data: self.data[dataIndex])
        return leftImageCell
    }
    
    private func createBigCell(forIndex dataIndex: Int) -> UITableViewCell {
        let bigImageCell = tableView.dequeueReusableCell(withIdentifier: BigImageCell.identifier) as! BigImageCell
        bigImageCell.configureCell(data: self.data[dataIndex])
        return bigImageCell
    }
    
}
