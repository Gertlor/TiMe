//
//  CustomDateViewController.swift
//  TiMe
//
//  Created by Gerrit Louis on 02/01/2020.
//  Copyright © 2020 Gerrit Louis de Beuze. All rights reserved.
//

import UIKit
import CoreData

class CustomDateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var entries = [Entry]()
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	@IBOutlet weak var selectDateButton: UIButton!
	@IBOutlet weak var selectDatePicker: UIDatePicker!
	@IBOutlet weak var entriesTableView: UITableView!
	@IBOutlet weak var entriesTitleLabel: UILabel!
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return entries.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "DateEntryCell", for: indexPath) as! CustomDateEntryTableViewCell
		
		let project = entries[indexPath.row].parentProject?.name
		let entryName = entries[indexPath.row].timeDescription
		
		cell.entryNameLabel?.text = "\(entryName ?? "No Name") - \(project ?? "No Project")"
		cell.durationLabel?.text = entries[indexPath.row].timeStamp
		
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "nl_NL")
		dateFormatter.dateFormat = "EEE, d MMM yyyy - HH:mm"
		
		cell.dateLabel?.text = dateFormatter.string(from: entries[indexPath.row].startTime ?? Date())
		
		cell.selectionStyle = .none
		
		return cell
		
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			context.delete(entries[indexPath.row])
			entries.remove(at: indexPath.row)
			saveContext()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
		loadEntries()
		selectDatePicker.isHidden = true
    }
	
	@IBAction func filterDate(_ sender: UIDatePicker) {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_GB")
		dateFormatter.dateFormat = "yyyy-MM-dd"
		
		let dateFormatterWithTime = DateFormatter()
		dateFormatterWithTime.locale = Locale(identifier: "en_GB")
		dateFormatterWithTime.dateFormat = "yyyy-MM-dd HH:mm:ss"
		
		let dateForButtonFormatter = DateFormatter()
		dateForButtonFormatter.dateFormat = "d MMMM yyyy"
		
		let filterDate = selectDatePicker.date
		
		let datestring = dateFormatter.string(from: filterDate)
		
		let filterStartDate = dateFormatterWithTime.date(from: "\(datestring) 00:00:00")!
		let filterEndDate = dateFormatterWithTime.date(from: "\(datestring) 23:59:59")!
		
		let predicate = NSPredicate(format: "startTime > %@ AND startTime < %@", argumentArray: [filterStartDate, filterEndDate])
		
		selectDateButton.setTitle(dateForButtonFormatter.string(from: filterDate), for: .normal)
		
		loadEntries(predicate: predicate)
	}
	
	func loadEntries(request: NSFetchRequest<Entry> = Entry.fetchRequest(), predicate: NSPredicate? = nil) {
		
		if predicate == nil {
			let dateFromSevenDaysAgo = Date().addingTimeInterval(-604800)
			_ = NSPredicate(format: "startTime >= %@", argumentArray: [dateFromSevenDaysAgo])
		}
		
		request.predicate = predicate
		
		do {
			entries = try context.fetch(request)
			entries.reverse()
		} catch {
			print("Error fetching data from context \(error)")
		}
		
		entriesTableView.reloadData()
	}
	
	func saveContext() {
		do {
			try context.save()
		} catch {
			print("Error saving context \(error)")
		}
		
		loadEntries()
	}
	
	
	@IBAction func showHideDatePicker(_ sender: UIButton) {
		self.selectDatePicker.isHidden == true ? hidePicker(hide: false) : hidePicker(hide: true)
		
	}
	@IBAction func clearFilter(_ sender: UIButton) {
		loadEntries()
		hidePicker(hide: true)
		selectDateButton.setTitle("Select a date", for: .normal)
	}
	
	func hidePicker(hide: Bool) {
		UIView.animate(withDuration: 0.3) {
			hide ? (self.selectDatePicker.isHidden = true) : (self.selectDatePicker.isHidden = false)
		}
	}

}

class CustomDateEntryTableViewCell: UITableViewCell {
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var entryNameLabel: UILabel!
	@IBOutlet weak var durationLabel: UILabel!
	
}
