//
//  TransitionLayout.swift
//  Swift-Paper
//
//  Created by Shaf on 8/5/15.
//  Copyright (c) 2015 Shaffiulla. All rights reserved.
//

import UIKit

class TransitionLayout: UICollectionViewTransitionLayout {
    var itemSize: CGSize
    
    override init() {
        itemSize = CGSizeZero
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        itemSize = CGSizeZero
        super.init(coder: aDecoder)
    }
    
    init(currentLayout: UICollectionViewLayout, nextLayout newLayout: UICollectionViewLayout, itemSize newSize: CGSize){
        itemSize = newSize
        super.init(currentLayout: currentLayout, nextLayout: newLayout);
    }

    override var transitionProgress:CGFloat {
        didSet {
            super.transitionProgress = transitionProgress;
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        let attributes = super.layoutAttributesForElementsInRect(rect);
        
        for currentAttribute in (attributes! as NSArray) {
            let currentCenter = currentAttribute.center;
            let updatedCenter = CGPointMake(currentCenter.x, currentCenter.y);
            
            var layoutArr = currentAttribute as! UICollectionViewLayoutAttributes;

            layoutArr.center = updatedCenter;
        }

        return attributes;
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        // returns the layout attributes for the item at the specified index path
        let attributes = super.layoutAttributesForItemAtIndexPath(indexPath) as UICollectionViewLayoutAttributes;
        let currentCenter = attributes.center;
        let updatedCenter = CGPointMake(currentCenter.x , currentCenter.y);
        attributes.center = updatedCenter;
        return attributes;
    }
}
