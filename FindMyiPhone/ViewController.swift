//
//  ViewController.swift
//  FindMyiPhone
//
//  Created by Emre Değirmenci on 14.05.2021.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!

    var session: WCSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createWCSession()

        welcomeLabel.text = "Hoşgeldiniz"

        //        let myArray = ["One", "Two", "Three", "Four"]
        //        welcomeLabel.text = myArray.randomElement()
    }

    func createWCSession() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()

            if ((session?.isPaired) != nil) { // Check if the iPhone is paired with the Apple Watch
                welcomeLabel.text = "Telefonun yanında"
            } else {
                welcomeLabel.text = "Telefonunu almayı unutma!"
            }
        }
    }


}

extension ViewController: WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated && session.isReachable { // Check if the iPhone is paired with the Apple Watch
            // Do stuff
            DispatchQueue.main.async {
                self.welcomeLabel.textColor = .black
                self.welcomeLabel.text = "Telefonun yanında"
                if let validSession = self.session, validSession.isReachable {
                    validSession.sendMessage(["iPhone": self.welcomeLabel.text ?? ""], replyHandler: nil, errorHandler: nil)
                }
            }
        } else {
            DispatchQueue.main.async {
                self.welcomeLabel.textColor = .systemRed
                self.welcomeLabel.text = "Telefonunu almayı unutma!"
                if let validSession = self.session, validSession.isReachable {
                    validSession.sendMessage(["iPhone": self.welcomeLabel.text ?? ""], replyHandler: nil, errorHandler: nil)
                }
            }
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {

    }

    func sessionDidDeactivate(_ session: WCSession) {

    }


}
