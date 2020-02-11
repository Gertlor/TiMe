//
//  EditEntryViewController.swift
//  TiMe
//
//  Created by Gerrit Louis on 11/02/2020.
//  Copyright © 2020 Gerrit Louis de Beuze. All rights reserved.
//

import UIKit
import CoreData

class EditEntryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var projectsTableView: UITableView!
	@IBOutlet weak var selectProjectButton: UIButton!
	@IBOutlet weak var entryNameField: UITextField!
	@IBOutlet weak var fromDatePicker: UIDatePicker!
	@IBOutlet weak var untilDatePicker: UIDatePicker!
	@IBOutlet weak var durationLabel: UILabel!
	
	var selectedEntry : Entry?
	var selectedProject: Project?
	
	var timerString: String = "00:00:00"
	var projectArray: [Project] = []
	var entries = [Entry]()
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
		self.setupToHideKeyboardOnTapOnView()
		projectsTableView.isHidden = true
		selectedProject = selectedEntry?.parentProject
		loadProjects()
		loadEntryInfo()
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return projectArray.count
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
		cell.backgroundColor = self.view.backgroundColor
		let project = projectArray[indexPath.row]
		
		cell.textLabel?.text = project.name ?? "No projects added yet"
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedProject = projectArray[indexPath.row]
		
		selectProjectButton.setTitle(selectedProject!.name, for: .normal)
		hideTableView(hide: true)
		
	}
	
	func loadProjects(request: NSFetchRequest<Project> = Project.fetchRequest()) {
		do {
			projectArray = try context.fetch(request)
		} catch {
			print("Error fetching data from context \(error)")
		}
		projectsTableView.reloadData()
	}
	
	func loadEntryInfo() {
		
		entryNameField.text = selectedEntry?.timeDescription!
		fromDatePicker.setDate(selectedEntry!.startTime!, animated: false)
		untilDatePicker.setDate(selectedEntry!.endTime!, animated: false)
		durationLabel.text = selectedEntry?.timeStamp
		selectProjectButton.setTitle(selectedEntry?.parentProject?.name, for: .normal)
	}
	
	@IBAction func showHideProjects(_ sender: Any) {
	self.projectsTableView.isHidden == true ? hideTableView(hide: false) : hideTableView(hide: true)
			loadProjects()
	}
		
	func hideTableView(hide: Bool) {
		UIView.animate(withDuration: 0.3) {
			hide ? (self.projectsTableView.isHidden = true) : (self.projectsTableView.isHidden = false)
		}
	}
	
	@IBAction func saveEntry(_ sender: UIBarButtonItem) {
		let updateEntry = selectedEntry!
		updateEntry.setValue(entryNameField.text, forKey: "timeDescription")
		updateEntry.setValue(fromDatePicker.date, forKey: "startTime")
		updateEntry.setValue(untilDatePicker.date, forKey: "endTime")
		updateEntry.setValue(durationLabel.text, forKey: "timeStamp")
		updateEntry.setValue(selectedProject, forKey: "parentProject")
		
		saveContext()
	}
	
	func saveContext() {
		do {
			try context.save()
		} catch {
			print("Error saving context \(error)")
		}
		_ = navigationController?.popToRootViewController(animated: true)
	}
	
	@IBAction func fromDatePickerChanged(_ sender: Any) {
		calculateDuration()
	}
	@IBAction func untilDatePickerChanged(_ sender: Any) {
		calculateDuration()
	}
	
	func calculateDuration() {
		let calendar = Calendar.current

		let components = calendar.dateComponents([.hour, .minute, .second], from: fromDatePicker.date, to: untilDatePicker.date)
		let date = calendar.date(from: components)!
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm:ss"
		let dateString = formatter.string(from: date)
		timerString = dateString
		durationLabel.text = timerString
	}
}
