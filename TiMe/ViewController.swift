//
//  ViewController.swift
//  TiMe
//
//  Created by Gerrit Louis on 12/12/2019.
//  Copyright © 2019 Gerrit Louis de Beuze. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	var timer = Timer()
	var hours: Int = 0
	var minutes: Int = 0
	var seconds: Int = 0
	var timerString: String = ""
	var projectTimes: [String] = []
	var projectNames: [String] = []
	
	var startTimer: Bool = true
	
	@IBOutlet weak var projectLabel: UITextField!
	@IBOutlet weak var timerLabel: UILabel!
	@IBOutlet weak var projectTableView: UITableView!
	@IBOutlet weak var startStopButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		timerLabel.text = "00:00:00"
		let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return projectNames.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
		cell.backgroundColor = self.view.backgroundColor
		cell.textLabel?.text = projectNames[indexPath.row]
		cell.detailTextLabel?.text = projectTimes[indexPath.row]
		
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
			addProjectToTableView()
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
	
	func addProjectToTableView() {
		projectTimes.insert(timerString, at: 0)
		projectNames.insert(projectLabel.text ?? "Empty Project", at: 0)
		projectTableView.reloadData()
		
		hours = 0
		minutes = 0
		seconds = 0
		timerString = "00:00:00"
		timerLabel.text = timerString
		projectLabel.text = ""
		
	}
}

