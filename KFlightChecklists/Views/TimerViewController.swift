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
    
    @IBAction func completed(sender : UIButton) {
        timer?.invalidate()
        dismissViewControllerAnimated(true, completion: payload?.completionCallback)
    }
    
    private var timer : NSTimer?
    private var payload : ShowTimerPayload?
    private var duration : Int = 0
    
    public func setPayload(payload : ShowTimerPayload) {
        self.payload = payload
        self.duration = payload.duration!
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        timer?.fire()
    }
    
    func updateTimer() {
        duration--
        if(duration <= 0) {
            lblTimer?.text = "Timer Done"
            timer?.invalidate()
        } else {
            lblTimer?.text = String(format: "%d", duration)
        }
    }
}
