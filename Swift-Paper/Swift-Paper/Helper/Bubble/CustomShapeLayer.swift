//
//  CustomShapeLayer.swift
//  Swift-Paper
//
//  Created by Shaf on 8/5/15.
//  Copyright (c) 2015 Shaffiulla. All rights reserved.
//

import UIKit

class CustomShapeLayer: CAShapeLayer {
    
    override var bounds: CGRect {
        didSet {
            // Do stuff here
            super.bounds = bounds;
            self.path = self.shapeForBounds(bounds).CGPath;
        }
    }
    
    func shapeForBounds(bounds: CGRect) -> UIBezierPath{
        let point1 = CGPointMake(CGRectGetMidX(bounds), CGRectGetMinY(bounds));
        let point2 = CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        let point3 = CGPointMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        
        var path = UIBezierPath();
        path.moveToPoint(point1);
        path.addLineToPoint(point2);
        path.addLineToPoint(point3);
        path.closePath();
        
        return path;
    }
    
    override func addAnimation(anim: CAAnimation!, forKey key: String!) {
        super.addAnimation(anim, forKey: key);
        
        if anim.isKindOfClass(CABasicAnimation){
            var basicAnimation = anim as! CABasicAnimation;
            
            if basicAnimation.keyPath == "bounds.size"{
                var pathAnimation = basicAnimation.copy() as! CABasicAnimation;
                pathAnimation.keyPath = "path";
                
                // The path property has not been updated to the new value yet
                pathAnimation.fromValue = self.path;
                // Compute the new value for path
                pathAnimation.toValue = self.shapeForBounds(bounds).CGPath;
                
                addAnimation(pathAnimation, forKey: "path");
            }
        }
    }
}
