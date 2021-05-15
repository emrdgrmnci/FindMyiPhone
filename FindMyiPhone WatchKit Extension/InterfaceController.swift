//
//  InterfaceController.swift
//  FindMyiPhone WatchKit Extension
//
//  Created by Emre Değirmenci on 14.05.2021.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var watchLabel: WKInterfaceLabel!
    
    let session = WCSession.default
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        super.awake(withContext: context)
        
        session.delegate = self
        session.activate()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated && session.isReachable { // Check if the iPhone is paired with the Apple Watch
            // Do stuff
            watchLabel.setText("")
            let validSession = self.session
            if validSession.isReachable {
                validSession.sendMessage(["iPhone": watchLabel.setText("")], replyHandler: nil, errorHandler: nil)
            }
        } else {
            watchLabel.setText("Telefonunu almayı unutma!")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let value = message["iPhone"] as? String {
            self.watchLabel.setText(value)
        }
    }
    
}
