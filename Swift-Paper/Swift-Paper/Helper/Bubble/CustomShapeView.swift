//
//  CustomShapeView.swift
//  Swift-Paper
//
//  Created by Shaf on 8/5/15.
//  Copyright (c) 2015 Shaffiulla. All rights reserved.
//

import UIKit

class CustomShapeView: UIView {
    var shapeLayer:CAShapeLayer {
        get {
            return self.layer as! CAShapeLayer;
        }
    }
    override var backgroundColor: UIColor?{
        get {
            return UIColor(CGColor: self.shapeLayer.fillColor);
        }
        set{
            self.shapeLayer.fillColor = UIColor.whiteColor().CGColor;//self.backgroundColor!.CGColor;
        }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override class func layerClass() -> AnyClass {
        return CustomShapeLayer.self
    }
    
}
