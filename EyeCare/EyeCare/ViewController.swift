//
//  ViewController.swift
//  EyeCare
//
//  Created by Max Kuznetsov on 13.07.2022.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var startButton: NSButton!
    @IBOutlet var stopButton: NSButton!
    @IBOutlet var timerLabel: NSTextField!
    
    var timer: Timer? = nil
    var startTime: Date?
    var duration: TimeInterval = 5      // default = 6 minutes
    var elapsedTime: TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    @IBAction func buttonTapped(_ sender: NSButton) {
        if sender == startButton {
            startTimer()
        } else if sender == stopButton {
            stopTimer()
        }
    }
    
    func timerAction() {
        // 1
        guard let startTime = startTime else {
            return
        }
        
        // 2
        elapsedTime = -startTime.timeIntervalSinceNow
        
        // 3
        let secondsRemaining = (duration - elapsedTime).rounded()
        
        if secondsRemaining >= 60 {
            let leftSide = Int(secondsRemaining/60)
            let rightSide = Int(secondsRemaining.truncatingRemainder(dividingBy: 60))
            if leftSide < 10 {
                if rightSide < 10 {
                    timerLabel.stringValue = "0\(leftSide):0\(rightSide)"
                } else {
                    timerLabel.stringValue = "0\(leftSide):\(rightSide)"
                }
            } else {
                if rightSide < 10 {
                    timerLabel.stringValue = "\(leftSide):0\(rightSide)"
                } else {
                    timerLabel.stringValue = "\(leftSide):\(rightSide)"
                }
            }
        } else {
            if secondsRemaining < 10 {
                timerLabel.stringValue = "00:0\(Int(secondsRemaining))"
            } else {
                timerLabel.stringValue = "00:\(Int(secondsRemaining))"
            }
        }
        
        // 4
        if secondsRemaining <= 0 {
            timerLabel.stringValue = "00:00"
            stopTimer()
        }
    }
    
    func startTimer() {
        startTime = Date()
        elapsedTime = 0
        
        showNotification()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timerAction()
        }
        timerAction()
    }
    
    // 2
    func resumeTimer() {
        startTime = Date(timeIntervalSinceNow: -elapsedTime)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timerAction()
        }
        timerAction()
    }
    
    // 3
    func stopTimer() {
        // really just pauses the timer
        timer?.invalidate()
        timer = nil
        
    }
    
    func showNotification() -> Void {
        let notification = NSUserNotification()
        notification.title = "Make some break!"
        notification.subtitle = "It's great opportunity to make some rest for your eyes!"
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.deliveryDate = Date(timeIntervalSinceNow: duration)
        NSUserNotificationCenter.default.scheduleNotification(notification)
        
    }
    
    
}

