//
//  TimerViewController.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/25/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

public class TimerViewController : NotepadViewController {
    @IBOutlet var lblTimer : UILabel?
    @IBOutlet var containerView : UIView?
    
    @IBAction func completed(sender : UIButton) {
        timer?.invalidate()
        dismissViewControllerAnimated(true, completion: payload?.completionCallback)
    }
    
    private var timer : NSTimer?
    private var payload : ShowTimerPayload?
    private var duration : Float = 0
    
    private var startTime : NSDate?
    
    public func setPayload(payload : ShowTimerPayload) {
        self.payload = payload
        self.duration = Float(payload.duration!)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        startTime = NSDate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        timer?.fire()
    }

    private var animating = false;
    private var toRed = false;
    
    func animateToRed() {
        
    }
    
    func updateTimer() {
        let now = NSDate()

        let interval = now.timeIntervalSinceDate(startTime!)

        let elapsed = self.duration - Float(interval)

        if(elapsed <= 0) {

            if(!self.animating) {

                self.animating = true

                UIView.animateWithDuration(NSTimeInterval(0.25), delay: NSTimeInterval(0.0), options: [UIViewAnimationOptions.AllowUserInteraction, UIViewAnimationOptions.CurveEaseInOut], animations: { () -> Void in
                    if(self.toRed){
                        self.containerView!.backgroundColor = UIColor.redColor();
                    }else{
                        self.containerView!.backgroundColor = UIColor.clearColor()
                    }
                }, completion:{(b)->Void in
                        self.toRed = !self.toRed
                        self.animating = false;
                });
            }
        }
        lblTimer?.text = String(format: "%02.4f", elapsed)
    }
}
