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
	@IBOutlet weak var selectDateButton: UIButton!
	@IBOutlet weak var selectDatePicker: UIDatePicker!
	@IBOutlet weak var entriesTableView: UITableView!
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "DateEntryCell", for: indexPath) as! CustomDateEntryTableViewCell
		
		return cell
		
	}
	

    override func viewDidLoad() {
        super.viewDidLoad()

    }
	
	
	@IBAction func showHideDatePicker(_ sender: UIButton) {
	}

}

class CustomDateEntryTableViewCell: UITableViewCell {
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var entryNameLabel: UILabel!
	@IBOutlet weak var durationLabel: UILabel!
	
}
