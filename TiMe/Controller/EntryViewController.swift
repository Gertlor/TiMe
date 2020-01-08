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
		let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "EntryCell")
		
		cell.textLabel?.text = entries[indexPath.row].timeDescription
		cell.detailTextLabel?.text = entries[indexPath.row].timeStamp
		
		return cell
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

}
