//
//  CollectionViewSmallLayout.swift
//  Swift-Paper
//
//  Created by Shaf on 8/5/15.
//  Copyright (c) 2015 Shaffiulla. All rights reserved.
//

import UIKit

class CollectionViewSmallLayout: UICollectionViewFlowLayout {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        //
        super.init();
        
        self.itemSize = CGSizeMake(142, 254)//CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds) - 30.0, CGRectGetHeight(UIScreen.mainScreen().bounds) - 100);
        self.sectionInset = UIEdgeInsetsMake(((UIScreen.mainScreen().bounds.size.height == 568) ? 314 : 224), 2, 0, 2)//UIEdgeInsetsMake(224, 2, 0, 2);
        self.minimumInteritemSpacing = 10.0;
        self.minimumLineSpacing = 10.0;
        self.scrollDirection = .Horizontal;
    }
    
    override func shouldInvalidateLayoutForBoundsChange(oldBounds : CGRect) -> Bool{
        return false;
    }
    
}
