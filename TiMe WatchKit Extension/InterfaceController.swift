//
//  InterfaceController.swift
//  TiMe WatchKit Extension
//
//  Created by Gerrit Louis on 12/12/2019.
//  Copyright © 2019 Gerrit Louis de Beuze. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

	@IBOutlet weak var timerLabel: WKInterfaceLabel!
	@IBOutlet weak var entryName: WKInterfaceTextField!
	@IBOutlet weak var selectProjectButton: WKInterfaceButton!
	@IBOutlet weak var startStopButton: WKInterfaceButton!
	
	let context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
	
	var timer = Timer()
	var hours: Int = 0
	var minutes: Int = 0
	var seconds: Int = 0
	var timerString: String = ""
	var startDate: Date = Date()
	var endDate: Date = Date()
	
	var startTimer: Bool = true
	var entryNameString = ""
	
	override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
		timerLabel.setText("00:00:00")
		
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
	
	@IBAction func startStopTimer() {
		print("clicked")
		
		if startTimer == true {
			timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
			startTimer = false
			startStopButton.setTitle("Stop")
			startDate = Date()
		} else {
			timer.invalidate()
			startTimer = true
			startStopButton.setTitle("Start")
			endDate = Date()
			saveTimeEntry()
		}
		
	}
	
	@IBAction func receiveEntryName(_ value: NSString?) {
		entryNameString = value! as String
	}
	
	@objc func updateTimer() {
		seconds += 1
		if seconds == 60 {
			minutes += 1
			seconds = 0
		}
		
		if minutes == 60 {
			hours += 1
			minutes = 0
		}
		
		let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
		let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
		let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
		
		timerString = "\(hoursString):\(minutesString):\(secondsString)"
		timerLabel.setText(timerString)
	}
	
	func saveTimeEntry() {
		
		let newEntry = Entry(context: context)
		newEntry.timeDescription = entryNameString
		newEntry.timeStamp = timerString
//		newEntry.parentProject = selectedProject
		newEntry.startTime = startDate
		newEntry.endTime = endDate
		
		saveContext()
		
		hours = 0
		minutes = 0
		seconds = 0
		timerString = "00:00:00"
		timerLabel.setText(timerString)
		entryName.setText("Entry Name")
		selectProjectButton.setTitle("Select a project")
	}
	
	func saveContext() {
		do {
			try context.save()
		} catch {
			print("Error saving context \(error)")
		}
		
	}
	

}
