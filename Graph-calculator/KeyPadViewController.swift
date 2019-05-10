//
//  KeyPadCollectionView.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/9/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class KeyPadViewController: UIViewController, KeyPadCellDelegate {
    
    private var gridCollectionView: UICollectionView {
        let layout = FixedSpacingCollectionViewFlowLayout()
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        
        let collectionView = IntrinsicContentSizeCollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.register(KeyPadCell.self, forCellWithReuseIdentifier: KeyPadCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.delaysContentTouches = false

        collectionView.backgroundColor = .clear
        
        return collectionView
    }
    
//    fileprivate let maskView = UIImageView(image: UIImage(named: "KeyPadMask"))
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        
        let collectionView = self.gridCollectionView
        self.view.addSubview(collectionView)
        collectionView.constraint(edgesTo: self.view)
    }
}

extension KeyPadViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegate implementation
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK: - UICollectionViewDataSource implementation
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyPadCell.identifier, for: indexPath) as! KeyPadCell
        
        cell.delegate = self
        
        let maskView = UIImageView(image: UIImage(named: "KeyPadMask"))
        let origin = CGPoint(x: -cell.frame.origin.x, y: -cell.frame.origin.y)
        let size = self.view.bounds.size
        maskView.frame = CGRect(origin: origin, size: size)
        cell.backgroundMaskedView = maskView
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout implementation
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.size.width * 0.1796
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let constant = view.frame.size.width * 0.035
        return UIEdgeInsets(top: 0, left: constant, bottom: constant, right: constant)
    }
    
    // MARK: - KeyPadCellDelegate
    
    func keyPadCell(_ cell: KeyPadCell, didSelectPresentPopover popoverViewController: UIViewController) {
        self.present(popoverViewController, animated: false)
    }

    func keyPadCell(_ cell: KeyPadCell, didDeselect popoverViewController: UIViewController) {
        popoverViewController.dismiss(animated: false, completion: nil)
    }
}
