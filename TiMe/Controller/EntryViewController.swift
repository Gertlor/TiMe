//
//  EntryViewController.swift
//  TiMe
//
//  Created by Gerrit Louis on 08/01/2020.
//  Copyright © 2020 Gerrit Louis de Beuze. All rights reserved.
//

import UIKit
import CoreData

class EntryViewController: UITableViewController {
	
	var entries = [Entry]()
	var selectedProject : Project? {
		didSet{
			loadEntries()
		}
	}
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	//MARK: - TableView Datasource Methods
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return entries.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! ProjectEntryTableViewCell
		
		cell.entryTitleLabel?.text = entries[indexPath.row].timeDescription
		cell.entryTimeLabel?.text = entries[indexPath.row].timeStamp
		
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "nl_NL")
		dateFormatter.dateFormat = "EEE, d MMM yyyy - HH:mm:ss"
		
		cell.entryStartDateLabel?.text = dateFormatter.string(from: entries[indexPath.row].startTime ?? Date())
		cell.entryEndDateLabel?.text = dateFormatter.string(from: entries[indexPath.row].endTime ?? Date())
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			context.delete(entries[indexPath.row])
			entries.remove(at: indexPath.row)
			saveContext()
		}
	}
	
	//MARK: - TableView Delegate Methods
	
	
	func loadEntries(request: NSFetchRequest<Entry> = Entry.fetchRequest(), predicate: NSPredicate? = nil) {
		let projectPredicate = NSPredicate(format: "parentProject.name MATCHES %@", selectedProject!.name!)
		
		if let additionalPredicate = predicate {
			request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [projectPredicate, additionalPredicate])
			
		} else {
			request.predicate = projectPredicate
		}
		
		do {
			entries = try context.fetch(request)
		} catch {
			print("Error fetching data from context \(error)")
		}
		
		tableView.reloadData()
	}
	
	func saveContext() {
		do {
			try context.save()
		} catch {
			print("Error saving context \(error)")
		}
		
		loadEntries()
	}
}

class ProjectEntryTableViewCell: UITableViewCell {
	
	@IBOutlet weak var entryTitleLabel: UILabel!
	@IBOutlet weak var entryStartDateLabel: UILabel!
	@IBOutlet weak var entryEndDateLabel: UILabel!
	@IBOutlet weak var entryTimeLabel: UILabel!
	
}
