//
//  TimerViewController.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/25/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

open class TimerViewController : NotepadViewController {
    @IBOutlet var lblTimer : UILabel?
    @IBOutlet var containerView : UIView?
    
    @IBAction func completed(_ sender : UIButton) {
        timer?.invalidate()
        dismiss(animated: true, completion: payload?.completionCallback)
    }
    
    fileprivate var timer : Timer?
    fileprivate var payload : ShowTimerPayload?
    fileprivate var duration : Float = 0
    
    fileprivate var startTime : Date?
    
    open func setPayload(_ payload : ShowTimerPayload) {
        self.payload = payload
        self.duration = Float(payload.duration!)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        startTime = Date()
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(TimerViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer?.fire()
    }

    fileprivate var animating = false;
    fileprivate var toRed = false;
    
    func animateToRed() {
        
    }
    
    func updateTimer() {
        let now = Date()

        let interval = now.timeIntervalSince(startTime!)

        let elapsed = self.duration - Float(interval)

        if(elapsed <= 0) {

            if(!self.animating) {

                self.animating = true

                UIView.animate(withDuration: TimeInterval(0.25), delay: TimeInterval(0.0), options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                    if(self.toRed){
                        self.containerView!.backgroundColor = UIColor.red;
                    }else{
                        self.containerView!.backgroundColor = UIColor.clear
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
