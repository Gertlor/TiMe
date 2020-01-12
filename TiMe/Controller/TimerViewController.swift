//
//  ViewController.swift
//  TiMe
//
//  Created by Gerrit Louis on 12/12/2019.
//  Copyright © 2019 Gerrit Louis de Beuze. All rights reserved.
//

import UIKit
import CoreData

class TimerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	var timer = Timer()
	var hours: Int = 0
	var minutes: Int = 0
	var seconds: Int = 0
	var timerString: String = ""
	var startDate: Date = Date()
	var endDate: Date = Date()
	
	var startTimer: Bool = true
	
	var projectArray: [Project] = []
	var selectedProject: Project?
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	@IBOutlet weak var projectsTableView: UITableView!
	@IBOutlet weak var showHideProjectTVButton: UIButton!
	@IBOutlet weak var timeEntryDescriptionLabel: UITextField!
	@IBOutlet weak var timerLabel: UILabel!
	@IBOutlet weak var startStopButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupToHideKeyboardOnTapOnView()
		
		timerLabel.text = "00:00:00"
		projectsTableView.isHidden = true
		loadProjects()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return projectArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
		cell.backgroundColor = self.view.backgroundColor
		let project = projectArray[indexPath.row]
		
		cell.textLabel?.text = project.name
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedProject = projectArray[indexPath.row]
		
		showHideProjectTVButton.setTitle(selectedProject!.name, for: .normal)
		hideTableView(hide: true)
		
	}

	
	@IBAction func startStop(_ sender: UIButton) {
		if startTimer == true {
			timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
			startTimer = false
			startStopButton.setImage(UIImage(named: "stop.png"), for: UIControl.State.normal)
			startDate = Date()
			self.view.endEditing(true)
		} else {
			timer.invalidate()
			startTimer = true
			startStopButton.setImage(UIImage(named:"start.png"), for: UIControl.State.normal)
			endDate = Date()
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
		newEntry.parentProject = selectedProject
		newEntry.startTime = startDate
		newEntry.endTime = endDate
		
		saveContext()
		
		hours = 0
		minutes = 0
		seconds = 0
		timerString = "00:00:00"
		timerLabel.text = timerString
		timeEntryDescriptionLabel.text = ""
		showHideProjectTVButton.setTitle("Select a project", for: .normal)
		
	}
	
	func saveContext() {
		do {
			try context.save()
		} catch {
			print("Error saving context \(error)")
		}
		
		loadProjects()
	}
	
	//MARK: - Project methods
	
	func loadProjects(request: NSFetchRequest<Project> = Project.fetchRequest()) {
		do {
			projectArray = try context.fetch(request)
		} catch {
			print("Error fetching data from context \(error)")
		}
		projectsTableView.reloadData()
	}
	
	@IBAction func showHideProjectTableView(_ sender: UIButton) {
		self.projectsTableView.isHidden == true ? hideTableView(hide: false) : hideTableView(hide: true)
		loadProjects()
	}
	
	func hideTableView(hide: Bool) {
		UIView.animate(withDuration: 0.3) {
			hide ? (self.projectsTableView.isHidden = true) : (self.projectsTableView.isHidden = false)
		}
	}
	
}

extension UIViewController {
	func setupToHideKeyboardOnTapOnView() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
}
