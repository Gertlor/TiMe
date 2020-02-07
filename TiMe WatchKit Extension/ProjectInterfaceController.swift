//
//  ProjectInterfaceController.swift
//  TiMe WatchKit Extension
//
//  Created by Gerrit Louis on 06/02/2020.
//  Copyright © 2020 Gerrit Louis de Beuze. All rights reserved.
//

import Foundation
import WatchKit
import CoreData

class ProjectInterfaceController: WKInterfaceController {
	
	@IBOutlet weak var projectTable: WKInterfaceTable!
	
	var projectArray: [Project] = []
	var selectedProject: Project?
	
	let context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
	
	override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
		loadProjects()
		
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
	
	
	func loadProjects(request: NSFetchRequest<Project> = Project.fetchRequest()) {
		do {
			projectArray = try context.fetch(request)
		} catch {
			print("Error fetching data from context \(error)")
		}
		
		loadTableRows()
	}
	
	func loadTableRows() {
		self.projectTable.setNumberOfRows(projectArray.count, withRowType: "MainRowType")
		let rowCount = self.projectTable.numberOfRows
		
		for i in 0..<rowCount {
			// Set the values for the row controller
			let row = self.projectTable.rowController(at: i) as! ProjectRowController
			
			let project = projectArray[i]
			
			row.projectNameLabel.setText(project.name)
		}
	}
	
}

class ProjectRowController: NSObject {
	
	@IBOutlet weak var projectNameLabel: WKInterfaceLabel!
}
