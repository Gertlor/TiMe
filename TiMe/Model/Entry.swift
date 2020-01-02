//
//  Entry.swift
//  TiMe
//
//  Created by Gerrit Louis on 02/01/2020.
//  Copyright © 2020 Gerrit Louis de Beuze. All rights reserved.
//

import Foundation

class Entry {
	
	let timeStamp: String
	let timeDescription: String
	
	init(description: String, time: String) {
		timeStamp = time
		timeDescription = description
	}
	
}
