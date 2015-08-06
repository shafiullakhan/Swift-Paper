//
//  CollectionViewCell.swift
//  Swift-Paper
//
//  Created by Shaf on 8/5/15.
//  Copyright (c) 2015 Shaffiulla. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    var indexData: Int
    var cellSize: CGSize
    
    required init(coder aDecoder: NSCoder) {
        indexData = -1;
        cellSize = CGSizeZero
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        indexData = -1;
        cellSize = CGSizeZero
        super.init(frame: frame);
        
        self.backgroundColor = UIColor.whiteColor();
        self.layer.cornerRadius = 4;
        self.clipsToBounds = true;
        
        var backgroundView = UIImageView(image: UIImage(named: "2"))
        self.backgroundView = backgroundView;
    }
    
    func setIndex(index :Int, withSize size:CGSize){
        self.indexData=index;
        self.cellSize=size;
    }
    
    func layout(){
    
    }
    
}
