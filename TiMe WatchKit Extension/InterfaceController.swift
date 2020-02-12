//
//  InterfaceController.swift
//  TiMe WatchKit Extension
//
//  Created by Gerrit Louis on 12/12/2019.
//  Copyright © 2019 Gerrit Louis de Beuze. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

	//MARK: - Outlets
	@IBOutlet weak var timerLabel: WKInterfaceLabel!
	@IBOutlet weak var entryName: WKInterfaceTextField!
	@IBOutlet weak var selectProjectButton: WKInterfaceButton!
	@IBOutlet weak var startStopButton: WKInterfaceButton!
	
	//MARK: - Variables
	 var wcSession : WCSession!
	
	//MARK: - Overrides
	
	override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
		
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
		
		wcSession = WCSession.default
		wcSession.delegate = self
		wcSession.activate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
	
	//MARK: - WatchConnectivity
	func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
		if let entryNameObject = message["entryNameFromiPhone"] {
			entryName.setText(entryNameObject as? String)
		}
		
		if let timerLabelObject = message["timerFromiPhone"]  {
			timerLabel.setText(timerLabelObject as? String)
		}
		
		if let selectedProjectNameObject = message["selectedProjectFromiPhone"]  {
			selectProjectButton.setTitle(selectedProjectNameObject as? String)
		}
		
		if let timerActiveObject = message["isTimerActiveFromiPhone"]  {
			let timerActive = timerActiveObject as! Bool
			
			if timerActive {
				startStopButton.setTitle("Stop")
			} else {
				startStopButton.setTitle("Start")
			}
		
		}
    }
	
	func sendMessageToiPhone(key: String, object: Any) {
        let message = [key:object]
		wcSession.sendMessage(message as [String : Any], replyHandler: nil) { (error) in
            print("Error: \(error.localizedDescription)")
        }
	}
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
	
	}
	
	//MARK: - Actions
	
	@IBAction func startStopTimer() {
		
		
	}
	
	@IBAction func receiveEntryName(_ value: NSString?) {
//		sendMessageToiPhone(key: "entryNameFromAW", object: value!)
		
	}
	
}
