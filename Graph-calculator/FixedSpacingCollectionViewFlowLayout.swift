//
//  FixedSpacingCollectionViewFlowLayout.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/9/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class FixedSpacingCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let currentItemAttributes = super.layoutAttributesForItem(at: indexPath)
        let numberOfItemsPerLine = Int(floor(self.collectionViewContentSize.width / self.itemSize.width))
        
        if currentItemAttributes != nil, indexPath.item % numberOfItemsPerLine != 0 {
            let cellIndexInLine = CGFloat(indexPath.item % numberOfItemsPerLine)
            
            var itemFrame = currentItemAttributes!.frame
            itemFrame.origin.x = self.itemSize.width * cellIndexInLine + self.minimumInteritemSpacing * cellIndexInLine
            currentItemAttributes?.frame = itemFrame
        }
        
        return currentItemAttributes
    }
}
