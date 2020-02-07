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
import WatchConnectivity

class ProjectInterfaceController: WKInterfaceController, WCSessionDelegate {
	
	//MARK: - Outlets
	@IBOutlet weak var projectTable: WKInterfaceTable!
	
	//MARK: - Variables
	
	var projectArray: [Project] = []
	var selectedProject: Project?
	
	//MARK: - Constants
	
	let context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
	
	//MARK: - Overrides
	
	override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
		
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
	}
	
	//MARK: - WatchConnectivity
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		
	}
}

//MARK: - CustomTableRow - ProjectRowController

class ProjectRowController: NSObject {
	
	@IBOutlet weak var projectNameLabel: WKInterfaceLabel!
}
