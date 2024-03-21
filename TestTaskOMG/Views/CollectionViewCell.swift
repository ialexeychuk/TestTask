//
//  CollectionViewCell.swift
//  TestTaskOMG
//
//  Created by Илья Алексейчук on 19.03.2024.
//

import UIKit
import SnapKit

// MARK: - CollectionViewCell
final class CollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    private let numberButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = Consts.numberButtonBorderColor
        button.layer.borderWidth = Consts.numberButtonBorderWidth
        button.layer.cornerRadius = Consts.numberButtonCornerRadius
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func configure(with number: Int) {
        numberButton.setTitle(String(number), for: .normal)
    }
    
    func updateNumber(inRange range: ClosedRange<Int>) {
        highlightChangedItem()
        let newNumber = Int.random(in: range)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.numberButton.setTitle(String(newNumber), for: .normal)
        }
    }
}

// MARK: - Private methods
private extension CollectionViewCell {
    func setupSubviews() {
        contentView.addSubview(numberButton)
        numberButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        numberButton.addTarget(
            self,
            action: #selector(handleTapDown),
            for: .touchDown)
        numberButton.addTarget(
            self,
            action: #selector(handleTapUp),
            for: [.touchUpInside, .touchUpOutside])
    }
    
    func highlightChangedItem() {
        numberButton.backgroundColor = .red
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.numberButton.backgroundColor = .white
        }
    }
    
    @objc func handleTapDown() {
        UIView.animate(withDuration: Consts.animationDuration) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: Consts.scaleFactor, y: Consts.scaleFactor)
        }
    }
    
    @objc func handleTapUp() {
        UIView.animate(withDuration: Consts.animationDuration) { [weak self] in
            self?.transform = CGAffineTransform.identity
        }
    }
}

// MARK: - Consts
private extension CollectionViewCell {
    enum Consts {
        static let numberButtonBorderColor = UIColor.systemYellow.cgColor
        static let numberButtonBorderWidth: CGFloat = 2
        static let numberButtonCornerRadius: CGFloat = 6
        static let animationDuration = 0.2
        static let scaleFactor = 0.8
    }
}
