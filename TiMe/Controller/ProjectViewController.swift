//
//  ProjectViewController.swift
//  TiMe
//
//  Created by Gerrit Louis on 02/01/2020.
//  Copyright © 2020 Gerrit Louis de Beuze. All rights reserved.
//

import UIKit
import CoreData

class ProjectViewController: UITableViewController {
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	var projectArray: [Project] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		loadEntries()
		return projectArray.count
	}
	
	//MARK - Tableview Datasource Methods
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
		cell.backgroundColor = self.view.backgroundColor
		let project = projectArray[indexPath.row]
		
		cell.textLabel?.text = project.category
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			context.delete(projectArray[indexPath.row])
			projectArray.remove(at: indexPath.row)
			saveContext()
		}
	}
	
	//MARK = Tableview Delegate Methods
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func saveContext() {
		do {
			try context.save()
		} catch {
			print("Error saving context \(error)")
		}
		
//		projectsTableView.reloadData()
	}
	
	func loadEntries() {
		let request: NSFetchRequest<Project> = Project.fetchRequest()
		do {
			projectArray = try context.fetch(request)
		} catch {
			print("Error fetching data from context \(error)")
		}
	}
    
}
