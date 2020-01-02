//
//  Project.swift
//  TiMe
//
//  Created by Gerrit Louis on 02/01/2020.
//  Copyright © 2020 Gerrit Louis de Beuze. All rights reserved.
//

import Foundation

class Project {
	
	let timeEntries: [Entry]
	let category: String
	
	
	init(timeEntries: [Entry], category: String) {
		self.timeEntries = timeEntries
		self.category = category
	}
	
}
