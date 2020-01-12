//
//  InsightsViewController.swift
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
		loadEntries()
    }
	
	func loadEntries(request: NSFetchRequest<Entry> = Entry.fetchRequest(), predicate: NSPredicate? = nil) {
		
		let dateFromSevenDaysAgo = Date().addingTimeInterval(-604800) //-604800
		
		let predicate = NSPredicate(format: "startTime >= %@", argumentArray: [dateFromSevenDaysAgo])
		
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
	}

}

class CustomDateEntryTableViewCell: UITableViewCell {
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var entryNameLabel: UILabel!
	@IBOutlet weak var durationLabel: UILabel!
	
}
