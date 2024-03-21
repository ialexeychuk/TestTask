//
//  ViewController.swift
//  TestTaskOMG
//
//  Created by Илья Алексейчук on 19.03.2024.
//

import UIKit
import SnapKit

// MARK: - ViewController
final class ViewController: UIViewController {
    
    // MARK: Properties
    let initialData: [[Int]] = {
        var array = [[Int]]()
        let rowsCount = Int.random(in: Consts.rowsRange)
        let itemsCount = Int.random(in: Consts.itemsRange)
        (.zero..<rowsCount).forEach { _ in
            var subArray = Array<Int>()
            (.zero..<itemsCount).forEach { _ in
                let number = Int.random(in: Consts.numbersRange)
                subArray.append(number)
            }
            array.append(subArray)
        }
        return array
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            TableViewCell.self,
            forCellReuseIdentifier: Consts.tableViewIdentifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = Consts.rowHeight
        return tableView
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        scheduleTimer()
    }
}

// MARK: - Private methods
private extension ViewController {
    func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        tableView.dataSource = self
    }
    
    func scheduleTimer() {
        let timer = Timer.scheduledTimer(
            timeInterval: Consts.timerInterval,
            target: self,
            selector: #selector(updateRandomNumber),
            userInfo: nil,
            repeats: true)
        RunLoop.current.add(timer, forMode: .common)
    }
    
    @objc func updateRandomNumber() {
        let row = tableView.visibleCells.randomElement() as? TableViewCell
        row?.updateRandomNumber(inRange: Consts.numbersRange)
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return initialData.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Consts.tableViewIdentifier,
            for: indexPath) as? TableViewCell,
              initialData.indices ~= indexPath.row
        else { return UITableViewCell() }
        cell.configure(with: initialData[indexPath.row])
        return cell
    }
}

// MARK: - Consts
private extension ViewController {
    enum Consts {
        static let tableViewIdentifier = "TableViewCell"
        static let rowHeight: CGFloat = 70
        static let rowsRange = 100...10_000
        static let itemsRange = 10...1000
        static let numbersRange = 0...10_000
        static let timerInterval: TimeInterval = 1
    }
}
