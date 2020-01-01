//
//  ViewController.swift
//  TiMe
//
//  Created by Gerrit Louis on 12/12/2019.
//  Copyright © 2019 Gerrit Louis de Beuze. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var timerLabel: UILabel!
	@IBOutlet weak var projectTableView: UITableView!
	@IBOutlet weak var startStopButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
		cell.backgroundColor = self.view.backgroundColor;
		cell.textLabel?.text = "Project";
		cell.detailTextLabel?.text = "00:00:00";
		
		return cell;
	}
	
	@IBAction func startStopButtonPressed(_ sender: UIButton) {
		
		
	}
}

