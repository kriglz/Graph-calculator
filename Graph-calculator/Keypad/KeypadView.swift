//
//  KeypadCollectionView.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/9/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

protocol KeypadViewDelegate: class {
    func keypadView(_ view: KeypadView, didSelectPresent popoverViewController: UIViewController)
    func keypadView(_ view: KeypadView, didDeselect popoverViewController: UIViewController)
    func keypadView(_ view: KeypadView, didSelect keyOperation: KeyType)
}

class KeypadView: UIView, KeypadCellDelegate {
    
    weak var delegate: KeypadViewDelegate?
    
    private lazy var gridCollectionView: UICollectionView = {
        let layout = FixedSpacingCollectionViewFlowLayout()
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        
        let collectionView = IntrinsicContentSizeCollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.register(KeypadCell.self, forCellWithReuseIdentifier: KeypadCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.delaysContentTouches = false

        collectionView.backgroundColor = .clear
        
        return collectionView
    }()

    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(self.gridCollectionView)
        self.gridCollectionView.constraint(edgesTo: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension KeypadView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegate implementation
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Keypad.dataSource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK: - UICollectionViewDataSource implementation
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeypadCell.identifier, for: indexPath) as! KeypadCell
        
        cell.delegate = self
        cell.operation = Keypad.dataSource[indexPath.item]
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout implementation
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.frame.size.width * 0.1796
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let constant = self.frame.size.width * 0.035
        return UIEdgeInsets(top: 0, left: constant, bottom: constant, right: constant)
    }
    
    // MARK: - KeypadCellDelegate
    
    func keypadCell(_ cell: KeypadCell, didSelectPresent popoverViewController: UIViewController) {
        self.delegate?.keypadView(self, didSelectPresent: popoverViewController)
    }

    func keypadCell(_ cell: KeypadCell, didDeselect popoverViewController: UIViewController) {
        self.delegate?.keypadView(self, didDeselect: popoverViewController)
    }
    
    func keypadCell(_ cell: KeypadCell, didSelect keyOperation: KeyType) {
        self.delegate?.keypadView(self, didSelect: keyOperation)
    }
}
