//
//  ViewController.swift
//  TiMe
//
//  Created by Gerrit Louis on 12/12/2019.
//  Copyright © 2019 Gerrit Louis de Beuze. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	var timer = Timer()
	var hours: Int = 0
	var minutes: Int = 0
	var seconds: Int = 0
	var timerString: String = ""
	
	var startTimer: Bool = true
	
	var entryArray: [Entry] = []
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	@IBOutlet weak var timeEntryDescriptionLabel: UITextField!
	@IBOutlet weak var timerLabel: UILabel!
	@IBOutlet weak var timeEntriesTableView: UITableView!
	@IBOutlet weak var startStopButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		timerLabel.text = "00:00:00"
		let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
		loadEntries()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		loadEntries()
		return entryArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
		cell.backgroundColor = self.view.backgroundColor
		let entry = entryArray[indexPath.row]
		
		cell.textLabel?.text = entry.timeDescription
		cell.detailTextLabel?.text = entry.timeStamp
		
		return cell
	}

	
	@IBAction func startStop(_ sender: UIButton) {
		if startTimer == true {
			timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
			startTimer = false
			startStopButton.setImage(UIImage(named: "stop.png"), for: UIControl.State.normal)
			self.view.endEditing(true)
		} else {
			timer.invalidate()
			startTimer = true
			startStopButton.setImage(UIImage(named:"start.png"), for: UIControl.State.normal)
//			addProjectToTableView()
			saveTimeEntry()
		}
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
		timerLabel.text = timerString
	}
	
	func saveTimeEntry() {
		
		let newEntry = Entry(context: context)
		newEntry.timeDescription = timeEntryDescriptionLabel.text
		newEntry.timeStamp = timerString
		
		do {
			try context.save()
		} catch {
			print("Error saving context \(error)")
		}
		
		print("Saved succesfull")
		
		timeEntriesTableView.reloadData()
		
		hours = 0
		minutes = 0
		seconds = 0
		timerString = "00:00:00"
		timerLabel.text = timerString
		timeEntryDescriptionLabel.text = ""
		
	}
	
	func loadEntries() {
		let request: NSFetchRequest<Entry> = Entry.fetchRequest()
		do {
			entryArray = try context.fetch(request)
		} catch {
			print("Error fetching data from context \(error)")
		}
		
	}
}

