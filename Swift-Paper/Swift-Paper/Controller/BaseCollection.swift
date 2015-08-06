//
//  BaseCollection.swift
//  Swift-Paper
//
//  Created by Shaf on 8/5/15.
//  Copyright (c) 2015 Shaffiulla. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class BaseCollection: UICollectionViewController, UIGestureRecognizerDelegate {
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var pichGestureRecogonizer: UIPinchGestureRecognizer?
    private var toBeExpandedFlag = true,transitioningFlag = false,changedFlag = false
    private var initialPanPoint: CGPoint = CGPointZero
    private var targetY: CGFloat = 0.0
    private var initialPinchDistance: CGFloat = 0.0
    var initialPinchPoint: CGPoint = CGPointZero
    
    var smallLayout = SmallLayout()
    var largeLayout = LargeLayout()
    
    
    let MAX_COUNT   = 20
    let CELL_ID     = "CELL_ID"
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        
        self.collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: CELL_ID);
        self.collectionView!.backgroundColor = UIColor.clearColor();
        
        gestureInit();
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func gestureInit(){
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panGestureRecognizer?.delegate = self;
        panGestureRecognizer?.minimumNumberOfTouches = 1
        panGestureRecognizer?.maximumNumberOfTouches = 1
        
        self.collectionView?.addGestureRecognizer(panGestureRecognizer!);
        
        pichGestureRecogonizer = UIPinchGestureRecognizer(target: self, action: "handlePinch:")
        self.collectionView?.addGestureRecognizer(pichGestureRecogonizer!)
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "changeLayout:")
        tapGesture.delegate = self;
        self.collectionView?.addGestureRecognizer(tapGesture);

    
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView!.decelerationRate = (self.isKindOfClass(BaseCollection.self)) ? UIScrollViewDecelerationRateFast : UIScrollViewDecelerationRateNormal;
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MAX_COUNT
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_ID, forIndexPath: indexPath) as! CollectionViewCell
    
        cell.setIndex(indexPath.row, withSize:(toBeExpandedFlag ? smallLayout.itemSize : largeLayout.itemSize))
        return cell
    }

    override func collectionView(collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout! {
        let transitionLayout = TransitionLayout(currentLayout: fromLayout, nextLayout: toLayout, itemSize :(toBeExpandedFlag ? smallLayout.itemSize : largeLayout.itemSize))
        
        return transitionLayout;
    }

    // MARK: Gesture Delegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false;
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(gestureRecognizer == panGestureRecognizer) {
            
            
            var pan = UIPanGestureRecognizer(target: self, action: "handlePan:");
            pan = gestureRecognizer as! UIPanGestureRecognizer;
            let direction = pan.velocityInView(pan.view);
            let pos = pan.locationInView(pan.view);
            
            //if touch point of out of range of cell, return false
            if (toBeExpandedFlag) {
                if(CGRectGetHeight(self.collectionView!.frame) - smallLayout.itemSize.height > pos.y) {
                    return false;
                }
            }
            
            // if swipe for vertical direction, returns true
            
            if(abs(direction.y) >  abs(direction.x)) {
                return true;
            }
            else{
                return false;
            }
        }
        else{
            return true;
        }

    }
    
    
    //MARK: Gesture Action
    func changeLayout(sender: UITapGestureRecognizer){
        if toBeExpandedFlag{
            self.collectionView?.setCollectionViewLayout(largeLayout, animated: true, completion: nil)
            toBeExpandedFlag = false;
        }
    }
    
    func handlePan(sender: UIPanGestureRecognizer){
        let point  = sender.locationInView(sender.view)
        let velocity = sender.velocityInView(sender.view)
        
        //limit the range of velocity so that animation will not stop when verlocity is 0

        let progress = abs(point.y - initialPanPoint.y) / abs(targetY - initialPanPoint.y)
        
        switch sender.state{
        case .Began:
            changedFlag = false;//clear flag here

            if getTransitionLayout() != nil {
                //animation is interrupted by user action
                //initialPoint.y and targetY has to be updated according to progress
                //and touched position

                updatePositionData(point, progress: getTransitionLayout()!.transitionProgress)
                return;
            }
            
            if (velocity.y > 0 && toBeExpandedFlag) || (velocity.y < 0 && !toBeExpandedFlag){
                //only respond to one direction of swipe
                return;
            }
            
            initialPanPoint = point;    // record the point where gesture began
            
            let tallHeight = largeLayout.itemSize.height;
            let shortHeight = smallLayout.itemSize.height;
            
            let hRatio = (tallHeight - initialPanPoint.y) / (toBeExpandedFlag ? shortHeight : tallHeight);
            
            // when the touch point.y reached targetY, that meanas progress = 1.0
            // update targetY value
            
            targetY = tallHeight - hRatio * (toBeExpandedFlag ? tallHeight : shortHeight);
            
            
            self.collectionView?.startInteractiveTransitionToCollectionViewLayout((toBeExpandedFlag ? largeLayout:smallLayout), completion: { (completed, finished) -> Void in
                self.panGestureRecognizer!.enabled=true;
            })
            transitioningFlag = true;
            break;
        case .Cancelled, .Ended:
            if (!changedFlag) {//without this guard, collectionview behaves strangely
                return;
            }
            
            if getTransitionLayout() != nil{
                let success = getTransitionLayout()!.transitionProgress > 0.5;
                var yToReach:CGFloat;
                if (success) {
                    self.collectionView!.finishInteractiveTransition();
                    toBeExpandedFlag = !toBeExpandedFlag;
                    
                    yToReach = targetY;
                }
                else{
                    self.collectionView!.cancelInteractiveTransition();
                    yToReach = initialPanPoint.y;
                }
            }
            break
        case .Changed:
            if (!transitioningFlag) {//if not transitoning, return
                return;
            }
            changedFlag = true ; // set flag here
            
            
            //update position only when point.y is between initialPoint.y and targety
            if ((point.y - initialPanPoint.y) * (point.y - targetY) <= 0) {
                
            }
            if(progress<=1.1){
                updateWithProgress(progress)
            }
            break;
        default:
            break;
        }
    }
    
    
    func handlePinch(sender: UIPinchGestureRecognizer){
        if sender.state == .Cancelled || sender.state == .Ended{
            if getTransitionLayout() != nil{
                let success = getTransitionLayout()!.transitionProgress > 0.5;
                
                if (success) {
                    self.collectionView!.finishInteractiveTransition();
                    toBeExpandedFlag = !toBeExpandedFlag;
                    
                }
                else{
                    self.collectionView!.cancelInteractiveTransition();
                }
            }
        }
        else if sender.numberOfTouches() == 2{
            
            // here we expect two finger touch
            var point: CGPoint;      // the main touch point
            var point1: CGPoint;     // location of touch #1
            var point2: CGPoint;     // location of touch #2
            var distance: CGFloat;   // computed distance between both touches
            
            point1 = sender.locationOfTouch(0, inView: sender.view);
            point2 = sender.locationOfTouch(1, inView: sender.view);
            
            distance = sqrt(point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y);
            
            point = sender.locationInView(sender.view);
            
            if sender.state == .Began{
                changedFlag = false;
                // start the pinch in our out
                if (transitioningFlag)
                {
                    self.initialPinchDistance = distance;
                    self.initialPinchPoint = point;
                    transitioningFlag = true;
                    self.collectionView?.startInteractiveTransitionToCollectionViewLayout((toBeExpandedFlag ? largeLayout:smallLayout), completion: { (completed, finished) -> Void in
                        self.panGestureRecognizer!.enabled=true;
                    })
                }
            }
            if (transitioningFlag)
            {
                if (sender.state == .Changed)
                {
                    
                    changedFlag = true;
                    // update the progress of the transtition as the user continues to pinch
                    let delta = distance - self.initialPinchDistance;
                    let offsetX = point.x - self.initialPinchPoint.x;
                    //                CGFloat offsetY = point.y - self.initialPinchPoint.y;
                    let offsetY = (point.y - self.initialPinchPoint.y) + delta/CGFloat(M_PI);
                    let offsetToUse = UIOffsetMake(offsetX, offsetY);
                    
                    var distanceDelta = distance - self.initialPinchDistance;
                    if (!toBeExpandedFlag)
                    {
                        distanceDelta = -distanceDelta;
                    }
                    //                CGFloat dimension = sqrt(self.collectionView.bounds.size.width * self.collectionView.bounds.size.width + self.collectionView.bounds.size.height * self.collectionView.bounds.size.height);
                    //                CGFloat progress = MAX(MIN((distanceDelta / dimension), 1.0), 0.0);
                    let progress =  CGFloat(max(CGFloat(min(((distanceDelta + sender.velocity * CGFloat(M_PI)) / 250.0), 1.0)), 0.0));
                    
                    // tell our UICollectionViewTransitionLayout subclass (transitionLayout)
                    // the progress state of the pinch gesture
                    //
                    updateWithProgress(progress);

                }
            }
        }
    }

    //MARK: helper methods
    
    func updatePositionData(point : CGPoint, progress: CGFloat){
        let tallHeight = largeLayout.itemSize.height;
        let shortHeight = smallLayout.itemSize.height;
        
        let itemHeight  = ((1.0 - progress) * (toBeExpandedFlag ? shortHeight : tallHeight)) + (progress * (toBeExpandedFlag ? tallHeight : shortHeight));
        
        let hRatio = (largeLayout.itemSize.height - point.y) / itemHeight;
        
        initialPanPoint.y = tallHeight - hRatio * (toBeExpandedFlag ? smallLayout.itemSize.height:largeLayout.itemSize.height);
        targetY = tallHeight - hRatio * (toBeExpandedFlag ? largeLayout.itemSize.height:smallLayout.itemSize.height);
    }
    
    func getTransitionLayout() -> UICollectionViewTransitionLayout?{
        if (self.collectionView?.collectionViewLayout.isKindOfClass(UICollectionViewTransitionLayout.self) != nil){
            return self.collectionView?.collectionViewLayout as? UICollectionViewTransitionLayout;
        }
        else
        {
            return nil;
        }
    }
    
    
    func updateWithProgress(progress: CGFloat){
        if getTransitionLayout() != nil{
            getTransitionLayout()!.transitionProgress = progress;
        }
    }
    
    func startGesture(){
        self.panGestureRecognizer!.enabled=true;
    }
    
    func stopGesture(){
        self.panGestureRecognizer!.enabled=false;
    }
    
    func finishUpInteraction(success: Bool){
        if (!transitioningFlag) {
            return;
        }
        
        if (success) {
            updateWithProgress(1.0);
            self.collectionView!.finishInteractiveTransition();
            transitioningFlag = false;
            toBeExpandedFlag = !toBeExpandedFlag;
        }
        else{
            updateWithProgress(0.0);
            
            self.collectionView!.cancelInteractiveTransition();
            transitioningFlag = false;
        }
    }
    
    func finishInteractiveTransition(progress: CGFloat, inDuration duration:CGFloat,withSucess success:Bool){
        if ((success && (progress >= 1.0)) || (!success && (progress <= 0.0))) {
            // no need to animate
            finishUpInteraction(success);
        }
    }
}
