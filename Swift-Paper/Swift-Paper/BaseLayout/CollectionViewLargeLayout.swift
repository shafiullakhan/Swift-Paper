//
//  CollectionViewLargeLayout.swift
//  Swift-Paper
//
//  Created by Shaf on 8/5/15.
//  Copyright (c) 2015 Shaffiulla. All rights reserved.
//

import UIKit

class CollectionViewLargeLayout: UICollectionViewFlowLayout {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        //
        super.init();
        
        self.itemSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(UIScreen.mainScreen().bounds));
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.minimumInteritemSpacing = 10.0;
        self.minimumLineSpacing = 4.0;
        self.scrollDirection = .Horizontal;
    }
    
    override func shouldInvalidateLayoutForBoundsChange(oldBounds : CGRect) -> Bool{
        return true;
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment:CGFloat = CGFloat(MAXFLOAT);
        let horizontalCenter:CGFloat = proposedContentOffset.x + (CGRectGetWidth(self.collectionView!.bounds) / 2.0);
        
        let targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView!.bounds.size.width, self.collectionView!.bounds.size.height);
        let array = self.layoutAttributesForElementsInRect(targetRect);
        for layoutAttributes in (array! as NSArray) {
            if (layoutAttributes.representedElementCategory != .Cell){
                continue; // skip headers
            }
            
            let itemHorizontalCenter:CGFloat = layoutAttributes.center.x;
            if (abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment)) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter;
                
                var layoutArr = layoutAttributes as! UICollectionViewLayoutAttributes;
                layoutArr.alpha = 0.0;
            }
        }
        return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
    }
}
