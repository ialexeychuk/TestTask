//
//  TableViewCell.swift
//  TestTaskOMG
//
//  Created by Илья Алексейчук on 19.03.2024.
//

import UIKit
import SnapKit

// MARK: - TableViewCell
final class TableViewCell: UITableViewCell {
    
    // MARK: Properties
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(
            width: Consts.itemSideSize,
            height: Consts.itemSideSize)
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            CollectionViewCell.self,
            forCellWithReuseIdentifier: Consts.collectionViewIdentifier)
        return collectionView
    }()
    
    private var items: [Int] = []
    
    // MARK: Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:  Methods
    func configure(with rows: [Int]) {
        items = rows
    }
    
    func updateRandomNumber(inRange range: ClosedRange<Int>) {
        let number = collectionView.visibleCells.randomElement() as? CollectionViewCell
        number?.updateNumber(inRange: range)
    }
}

// MARK: - Private methods
private extension TableViewCell {
    func setupCollectionView() {
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource
extension TableViewCell: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return items.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Consts.collectionViewIdentifier,
            for: indexPath) as? CollectionViewCell,
              items.indices ~= indexPath.row
        else { return UICollectionViewCell() }
        cell.configure(with: items[indexPath.item])
        return cell
    }
}

// MARK: - Consts
private extension TableViewCell {
    enum Consts {
        static let collectionViewIdentifier = "CollectionViewCell"
        static let itemSideSize = 60
    }
}
