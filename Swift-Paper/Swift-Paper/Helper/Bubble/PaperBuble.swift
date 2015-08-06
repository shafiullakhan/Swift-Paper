//
//  PaperBuble.swift
//  Swift-Paper
//
//  Created by Shaf on 8/5/15.
//  Copyright (c) 2015 Shaffiulla. All rights reserved.
//

import UIKit

@objc
protocol PaperBubleDelegate{
    optional
    func dismissBubble();
}

class PaperBuble: UIView,UIGestureRecognizerDelegate {
    var savedTrans: CGFloat?
    
    var button1: UIView?
    var tableView: UITableView?
    var snap: UIView?
    var startShapeLayer,shapeLayer: CAShapeLayer?
    var customShapeView: CustomShapeView?
    
    var delegate: PaperBubleDelegate?
    // Constant
    let CR_ARROW_SIZE:CGFloat = 20
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, attachedView: UIView) {
        super.init(frame : frame);
        self.button1 = attachedView;
        
        addTableView();
        self.backgroundColor = UIColor.clearColor();
        
        // Drawing code
        addCustomShapeView();
        
        addGesture();
        addSnap();
        
        self.tableView!.alpha=0;
        self.customShapeView!.alpha=0;
    }
    
    func addTableView(){
        self.tableView = UITableView(frame: CGRectMake(0, 18, self.frame.size.width, self.frame.size.height-20), style: .Plain);
        self.tableView!.backgroundColor = UIColor.whiteColor();
        self.tableView!.layer.cornerRadius = 5.0;
        self.tableView!.layer.shadowRadius = 10;
        self.tableView!.layer.shadowOpacity = 1.0;
        self.tableView!.clipsToBounds = false;
        self.tableView!.layer.masksToBounds = false;
        self.tableView!.layer.shadowColor = UIColor.blackColor().CGColor;
        self.tableView!.separatorStyle = .SingleLineEtched;
        self.tableView!.separatorColor = UIColor.lightGrayColor();
        
        self.addSubview(self.tableView!);
        
    }
    
    func addCustomShapeView(){
        self.customShapeView = CustomShapeView(frame: CGRectMake(self.button1!.center.x-20, 0, 20, 20))
        self.customShapeView!.layer.borderWidth = 1.0;
        self.customShapeView!.backgroundColor=UIColor.whiteColor();
        self.customShapeView!.layer.borderColor = UIColor.clearColor().CGColor;
        self.addSubview(self.customShapeView!);
    }
    
    func addGesture(){
        var stretch = UIPanGestureRecognizer(target: self, action: "strectBezierPath:");
        stretch.delegate=self;
        self.tableView!.addGestureRecognizer(stretch);
    }
    
    func addSnap(){
        snap = UIView();
        snap = self.snapshotViewAfterScreenUpdates(true);
        NSLog("Snap Shot\(snap)");
    }
    
    func strectBezierPath(recognizer : UIPanGestureRecognizer){
        let translation = recognizer.translationInView(recognizer.view!);
        let vel = recognizer.velocityInView(recognizer.view!);
        var diff:CGFloat = CR_ARROW_SIZE;
        
        recognizer.view!.center = CGPointMake(recognizer.view!.center.x, recognizer.view!.center.y+translation.y);
        
        recognizer.setTranslation(CGPointZero, inView: recognizer.view!)
        
        diff = self.tableView!.frame.origin.y-diff;
        
        var fraction : Float = (Float(Float(translation.y) * Float(M_PI_2)) / Float(recognizer.view!.frame.size.height));
        
        NSLog("\(fraction), \(diff)");
        
        if(diff>=0 && diff < 30){
            
            if(vel.y>0){
                self.superview!.center = CGPointMake(self.superview!.center.x, CGFloat(self.superview!.center.y)+CGFloat(translation.y));
                recognizer.setTranslation(CGPointZero, inView: self.superview)
            }
            
            self.customShapeView!.alpha = 1.0;
            self.customShapeView!.frame=CGRectMake(self.button1!.center.x-20, 0, CR_ARROW_SIZE, CR_ARROW_SIZE+diff);
            NSLog("Custom bounds \(self.customShapeView!)");
        }
            
        else{
            UIView.animateWithDuration(0.1,
                animations: { () -> Void in
                    //
                    self.customShapeView!.frame = CGRectMake(self.button1!.center.x-20, self.CR_ARROW_SIZE+diff, self.CR_ARROW_SIZE, 0);
                    
                    self.superview!.frame=CGRectMake(0, 0, self.superview!.frame.size.width, self.superview!.frame.size.height);
                }, completion: nil);
            
            self.customShapeView!.alpha=0.0;
            if(recognizer.state == .Ended){
                pushBubble();
                delegate!.dismissBubble!()
            }
        }
    }
    
    func pushBubble() {
        snap = self.snapshotViewAfterScreenUpdates(true);
        self.addSubview(self.snap!);
        
        let shrunk = CGRectMake(self.button1!.center.x, 0, 0, 0);
        
        self.snap!.alpha=1;
        self.tableView!.alpha=0;
        self.customShapeView!.alpha=0;
        
        // animate with keyframes
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 1.0,
            options: .CurveEaseInOut,
            animations: {
                self.snap!.frame = shrunk;
            },
            completion: {success in
        
            var scaleDown2 = CABasicAnimation(keyPath: "transform")
                scaleDown2.duration = 0.2;
                scaleDown2.fromValue = NSValue(CATransform3D: CATransform3DMakeScale(1.15, 1.15, 1.15))
                scaleDown2.toValue = NSValue(CATransform3D: CATransform3DMakeScale(1, 1, 1))
                self.button1!.layer.addAnimation(scaleDown2, forKey: nil)
                self.removeFromSuperview();
        });
    }
    
    func popBubble() {
        self.addSubview(self.snap!);
        let shrunk = CGRectMake(self.button1!.center.x, 0, 0, 0);
        var final = self.snap!.frame;
        self.snap!.frame = shrunk;
        // animate with keyframes
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 1.0,
            options: .CurveEaseInOut,
            animations: {
                self.snap!.frame = final;
            },
            completion: {success in
                self.snap?.alpha = 0.0;
                self.tableView!.alpha=1;
                self.customShapeView!.alpha=1;
        });

    }
    
    func updateArrow() {
        UIView.animateWithDuration(0.5,
            animations: { () -> Void in
                self.customShapeView!.frame=CGRectMake(self.button1!.center.x-20, 0, 20, 20);
            }, completion: nil);
    }
}
