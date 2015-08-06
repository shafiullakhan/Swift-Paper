//
//  ViewController.swift
//  Swift-Paper
//
//  Created by Shaf on 8/5/15.
//  Copyright (c) 2015 Shaffiulla. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,PaperBubleDelegate {
    
    private var toogle = true;
    private var bubble:PaperBuble?;
    private var addfrd,noti,msg: UIImageView?;

    var baseController =  BaseCollection(collectionViewLayout: SmallLayout())
    var slide: Int = 0
    var mainView:UIView?
    var topImage,reflected: UIImageView?
    var galleryImages = ["one.jpg", "two.jpg", "three.png", "five.jpg", "one.jpg"]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        //
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.baseController.collectionView?.frame = UIScreen.mainScreen().bounds;
        self.view.addSubview(self.baseController.collectionView!)
        
        // Init mainView
        addMainView();
        
        // ImageView on top
        addTopImage();
        // Reflect imageView
        addReflectImage();
        
        // Add Card Details
        addCardDetails();
        
        // First Load
        changeSlide();
        
        let timer = NSTimer(timeInterval: 5.0, target: self, selector: "changeSlide", userInfo: nil, repeats: true)
        
        // notificaiton friedns and messsage
        addNotificationTabs();
    }

    func addMainView(){
        self.mainView = UIView(frame: self.view.bounds)
        self.mainView?.clipsToBounds = true
        self.mainView?.layer.cornerRadius = 4
        self.view.insertSubview(self.mainView!, belowSubview: self.baseController.collectionView!)
    }
    
    func addTopImage(){
        self.topImage = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, AppDelegate.sharedDelegate().itemHeight-256))
        self.topImage?.contentMode = UIViewContentMode.ScaleAspectFill;
        self.mainView?.addSubview(self.topImage!)
        
        // Gradient to top image
        var gradient = CAGradientLayer();
        gradient.frame = self.topImage!.bounds;
        gradient.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).CGColor,UIColor(white: 0, alpha: 0).CGColor];
        self.topImage!.layer.insertSublayer(gradient, atIndex: 0);
        
        
        // Content perfect pixel
        var perfectPixelContent = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.topImage!.bounds), 1));
        perfectPixelContent.backgroundColor = UIColor(white: 1, alpha: 0.2);
        self.topImage!.addSubview(perfectPixelContent);
    }
    
    func addReflectImage(){
        self.reflected = UIImageView(frame: CGRectMake(0, CGRectGetHeight(self.topImage!.bounds), self.view.frame.size.width, self.view.frame.size.height/2))
        self.mainView?.addSubview(self.reflected!)
        self.reflected!.transform = CGAffineTransformMakeScale(1.0, -1.0);
        
        
        // Gradient to reflected image
        var gradientReflected = CAGradientLayer();
        gradientReflected.frame = self.reflected!.bounds;
        gradientReflected.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 1).CGColor,UIColor(white: 0, alpha: 0).CGColor];
        self.reflected!.layer.insertSublayer(gradientReflected, atIndex: 0);
    }
    
    func addCardDetails(){
        
        // Label logo
        var logo = UILabel(frame: CGRectMake(15, 12, 100, 0))
        logo.backgroundColor = UIColor.clearColor();
        logo.textColor = UIColor.whiteColor();
        logo.font = UIFont(name: "Helvetica-Bold", size: 22);
        logo.text = "MMPaper";
        logo.sizeToFit();
        
        // Label Shadow
        logo.clipsToBounds = false;
        logo.layer.shadowOffset = CGSizeMake(0, 0);
        logo.layer.shadowColor = UIColor.blackColor().CGColor;
        logo.layer.shadowRadius = 1.0;
        logo.layer.shadowOpacity = 0.6;
        self.mainView?.addSubview(logo);
        
        // Label Title
        var title = UILabel(frame: CGRectMake(15, logo.frame.origin.y + CGRectGetHeight(logo.frame) + 8, 290, 0))
        title.backgroundColor = UIColor.clearColor();
        title.textColor = UIColor.whiteColor();
        title.font = UIFont(name: "Helvetica-Bold", size: 13);
        title.text = "Mukesh Mandora";
        title.sizeToFit();
        
        // Label Shadow
        title.clipsToBounds = false;
        title.layer.shadowOffset = CGSizeMake(0, 0);
        title.layer.shadowColor = UIColor.blackColor().CGColor;
        title.layer.shadowRadius = 1.0;
        title.layer.shadowOpacity = 0.6;
        self.mainView?.addSubview(title);
        
        // Label SubTitle
        var subTitle = UILabel(frame: CGRectMake(15, title.frame.origin.y + CGRectGetHeight(title.frame), 290, 0))
        subTitle.backgroundColor = UIColor.clearColor();
        subTitle.textColor = UIColor.whiteColor();
        subTitle.font = UIFont(name: "Helvetica", size: 13);
        subTitle.text = "Inspired from Paper by Facebook";
        subTitle.lineBreakMode = .ByWordWrapping;
        subTitle.numberOfLines = 0;
        subTitle.sizeToFit();
        
        // Label Shadow
        subTitle.clipsToBounds = false;
        subTitle.layer.shadowOffset = CGSizeMake(0, 0);
        subTitle.layer.shadowColor = UIColor.blackColor().CGColor;
        subTitle.layer.shadowRadius = 1.0;
        subTitle.layer.shadowOpacity = 0.6;
        self.mainView?.addSubview(subTitle);
    }
    
    func addNotificationTabs(){
        
        noti=UIImageView(frame: CGRectMake(self.view.frame.size.width-50, 20, 25, 25));
        noti!.image = UIImage(named: "Tones-50")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        noti!.tintColor=UIColor.whiteColor();
        noti?.userInteractionEnabled = true;
        self.view.addSubview(noti!)
        
        addfrd=UIImageView(frame: CGRectMake(noti!.frame.origin.x-50, 20, 25, 25));
        addfrd!.image=UIImage(named: "Group-50")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate);
        addfrd!.tintColor=UIColor.whiteColor();
        addfrd?.userInteractionEnabled = true;
        self.view.addSubview(addfrd!)
        
        msg=UIImageView(frame: CGRectMake(addfrd!.frame.origin.x-50, 20, 25, 25));
        msg!.image=UIImage(named: "Talk-50")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate);
        msg!.tintColor=UIColor.whiteColor();
        msg?.userInteractionEnabled = true;
        self.view.addSubview(msg!)
        
        var tapNoti=UITapGestureRecognizer(target: self, action: "tapBubble:");
        tapNoti.delegate=self;
        noti?.addGestureRecognizer(tapNoti);
        noti!.tag = 1;
        
        var tapFrd=UITapGestureRecognizer(target: self, action: "tapBubble:");
        tapFrd.delegate=self;
        addfrd?.addGestureRecognizer(tapFrd);
        addfrd!.tag = 2;
        
        var tapChat=UITapGestureRecognizer(target: self, action: "tapBubble:");
        tapChat.delegate=self;
        msg?.addGestureRecognizer(tapChat);
        msg!.tag = 3;
    }
    
    //MARK: Gesture Action
    func tapBubble(sender: UIGestureRecognizer){
        let tag = sender.view?.tag;
        
        if tag == 1{
            self.toogleHelpAction(self)
        }
        else if tag == 2{
            actionBut2(self)
        }
        else{
            actionbut3(self)
        }
    }
    
    func toogleHelpAction(sender: AnyObject){
        if(bubble==nil && toogle==true){
            toogle=false;
            bubble=PaperBuble(frame: CGRectMake(8, noti!.center.y+20, self.view.frame.size.width-16, self.view.frame.size.height), attachedView: noti!);
            bubble!.delegate = self
            bubble!.button1=noti;
            bubble!.tableView!.delegate=self;
            bubble!.tableView!.dataSource=self;
            self.view.addSubview(bubble!)
            bubble?.popBubble()
        }
        else{
            if(bubble!.button1==noti){
                toogle=true;
                bubble?.pushBubble()
                bubble=nil;
            }
            else{
                bubble!.button1=noti;
                bubble?.updateArrow()
                bubble?.shapeLayer?.removeFromSuperlayer()
            }
        }
        if bubble != nil{
            bubble!.tableView!.reloadData()
        }
    }
    
    func actionBut2(sender: AnyObject){
        if(bubble==nil && toogle==true){
            toogle=false;
            bubble=PaperBuble(frame: CGRectMake(8, addfrd!.center.y+20, self.view.frame.size.width-16, self.view.frame.size.height), attachedView: addfrd!);
            bubble!.delegate = self
            bubble!.button1=addfrd;
            bubble!.tableView!.delegate=self;
            bubble!.tableView!.dataSource=self;
            self.view.addSubview(bubble!)
            bubble?.popBubble()
        }
        else{
            if(bubble!.button1==addfrd){
                toogle=true;
                bubble?.pushBubble()
                bubble=nil;
            }
            else{
                bubble!.button1=addfrd;
                bubble?.updateArrow()
                bubble?.shapeLayer?.removeFromSuperlayer()
            }
        }
        if bubble != nil{
            bubble!.tableView!.reloadData()
        }
    }
    
    func actionbut3(sender: AnyObject){
        if(bubble==nil && toogle==true){
            toogle=false;
            bubble=PaperBuble(frame: CGRectMake(8, msg!.center.y+20, self.view.frame.size.width-16, self.view.frame.size.height), attachedView: msg!);
            bubble!.delegate = self
            bubble!.button1=msg;
            bubble!.tableView!.delegate=self;
            bubble!.tableView!.dataSource=self;
            self.view.addSubview(bubble!)
            bubble?.popBubble()
        }
        else{
            if(bubble!.button1==msg){
                toogle=true;
                bubble?.pushBubble()
                bubble=nil;
            }
            else{
                bubble!.button1=msg;
                bubble?.updateArrow()
                bubble?.shapeLayer?.removeFromSuperlayer()
            }
        }
        if bubble != nil{
            bubble!.tableView!.reloadData()
        }
    }
    
    func dismissBubble(){
        toogle=true;
        bubble=nil;
    }
    
    //MARK: Timer Action
    func changeSlide(){
        if slide > (galleryImages.count - 1){
            slide = 0
        }
        
        let toImage = UIImage(named: galleryImages[slide])
        UIView.transitionWithView(self.mainView!,
            duration: 0.6,
            options: UIViewAnimationOptions.TransitionCrossDissolve | UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.topImage?.image = toImage;
                self.reflected?.image = toImage;
        }, completion: nil)
        
        slide++
    }
    
    //MARK: TableViewData Source
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //
        var view = UIView(frame: CGRectMake(0, 10, tableView.frame.size.width, 30))
        view.backgroundColor = UIColor.whiteColor()
        /* Create custom view to display section header... */

        var result : UInt32 = 0
        NSScanner(string: "0xe94c5e").scanHexInt(&result);
        
        var label = UILabel(frame: CGRectMake(18, 10, 300, 20))
        label.textAlignment = .Left
        label.textColor = UIColor.blackColor();
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        
        if(bubble!.button1==noti!){
            label.text="Notification";
        }
        else if (bubble!.button1==addfrd!){
            label.text="Friend Request";
        }
        else{
            label.text="Chats";
        }
        
        label.textColor = UIColor.lightGrayColor();
        view.addSubview(label)
        
        view.backgroundColor = UIColor.whiteColor()
        view.layer.cornerRadius = 5.0
        view.clipsToBounds = false;
        view.layer.masksToBounds = false
        
        return view
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let simpleTableIdentifier = "SimpleTableCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(simpleTableIdentifier) as? UITableViewCell
        
        if cell == nil{
            cell = UITableViewCell(style: .Default, reuseIdentifier: simpleTableIdentifier)
        }
        
        cell?.backgroundColor = UIColor.clearColor()
        
        return cell!;
    }
}



