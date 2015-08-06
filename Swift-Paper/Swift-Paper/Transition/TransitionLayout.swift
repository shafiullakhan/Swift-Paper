//
//  TransitionLayout.swift
//  Swift-Paper
//
//  Created by Shaf on 8/5/15.
//  Copyright (c) 2015 Shaffiulla. All rights reserved.
//

import UIKit

class TransitionLayout: UICollectionViewTransitionLayout {
    var offset: UIOffset{
        didSet {
            self.updateValue(offset.horizontal, forAnimatedKey: kOffsetH)
            self.updateValue(offset.vertical, forAnimatedKey: kOffsetV)
        }
    }
    var progress: CGFloat
    var itemSize: CGSize

    
    let kOffsetH = "offsetH";
    let kOffsetV = "offsetV";
    
    
    override init() {
        offset = UIOffsetZero
        progress = 0.0
        itemSize = CGSizeZero
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        offset = UIOffsetZero
        progress = 0.0
        itemSize = CGSizeZero
        super.init(coder: aDecoder)
    }
    
    override var transitionProgress:CGFloat {
        didSet {
            super.transitionProgress = transitionProgress;
        
            // return the most recently set values for each key
            let offsetH = self.valueForAnimatedKey(kOffsetH);
            let offsetV = self.valueForAnimatedKey(kOffsetV);
            self.offset = UIOffsetMake(offsetH, offsetV);
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        let attributes = super.layoutAttributesForElementsInRect(rect);
        
        for currentAttribute in (attributes! as NSArray) {
            let currentCenter = currentAttribute.center;
            let updatedCenter = CGPointMake(currentCenter.x, currentCenter.y + self.offset.vertical);
            
            var layoutArr = currentAttribute as! UICollectionViewLayoutAttributes;

            layoutArr.center = updatedCenter;
        }

        return attributes;
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        // returns the layout attributes for the item at the specified index path
        let attributes = super.layoutAttributesForItemAtIndexPath(indexPath) as UICollectionViewLayoutAttributes;
        let currentCenter = attributes.center;
        let updatedCenter = CGPointMake(currentCenter.x + self.offset.horizontal, currentCenter.y + self.offset.vertical);
        attributes.center = updatedCenter;
        return attributes;
    }
}
