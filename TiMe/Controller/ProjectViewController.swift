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
	
	
	@IBOutlet var projectsTableView: UITableView!
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	var projectArray: [Project] = []

    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupToHideKeyboardOnTapOnView()
		loadProjects()
    }
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return projectArray.count
	}
	
	//MARK: - Tableview Datasource Methods
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
		cell.backgroundColor = self.view.backgroundColor
		let project = projectArray[indexPath.row]
		
		cell.textLabel?.text = project.name ?? "No projects added yet"
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			context.delete(projectArray[indexPath.row])
			projectArray.remove(at: indexPath.row)
			saveContext()
		}
	}
	
	//MARK: - Tableview Delegate Methods
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "goToEntries", sender: self)
//		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! EntryViewController
		
		if let indexPath = tableView.indexPathForSelectedRow {
			destinationVC.selectedProject = projectArray[indexPath.row]
		}
	}
	
	//MARK: - Add new projects
	@IBAction func addProject(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add New Project", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Project", style: .default, handler: { (action) in
			self.saveProject(projectName: textField.text ?? "No Name Project")
		})
		
		alert.addTextField { (projectNameTextField) in
			projectNameTextField.placeholder = "Create new project"
			textField = projectNameTextField
		}
		
		alert.addAction(action)
		
		present(alert, animated:true, completion: nil)
		
	}
	
	func saveProject(projectName: String) {
		let newProject = Project(context: context)
		newProject.name = projectName
		
		saveContext()
	}
	
	
	//MARK: - CoreData Methods
	func saveContext() {
		do {
			try context.save()
		} catch {
			print("Error saving context \(error)")
		}
		
		loadProjects()
	}
	
	func loadProjects(request: NSFetchRequest<Project> = Project.fetchRequest()) {
		do {
			projectArray = try context.fetch(request)
		} catch {
			print("Error fetching data from context \(error)")
		}
		projectsTableView.reloadData()
	}
}


//MARK: - Searchbar methods
extension ProjectViewController: UISearchBarDelegate {
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text?.count == 0 {
			loadProjects()
		} else {
			let request: NSFetchRequest<Project> = Project.fetchRequest()
			
			request.predicate = NSPredicate(format: "name CONTAINS %@", searchBar.text!)
			
			request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

			loadProjects(request: request)
		}
		
	}
}

