//
//  SettingsViewController.swift
//  TiMe
//
//  Created by Gerrit Louis on 02/01/2020.
//  Copyright © 2020 Gerrit Louis de Beuze. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
		
	@IBOutlet weak var tableView: UITableView!
	let userDefaults = UserDefaults.standard
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsColorCell", for: indexPath) as! CustomColorSettingsCell
		
		let selectedTheme = userDefaults.string(forKey: "Theme")
		
		deselectButtons(cell: cell)
		
		switch selectedTheme {
			
		case "red":
			cell.redThemeButton.backgroundColor = .cyan
		case "blue":
			cell.blueThemeButton.backgroundColor = .cyan
		case "dark":
			cell.darkThemeButton.backgroundColor = .cyan
		case "light":
			cell.lightThemeButton.backgroundColor = .cyan
		default:
			cell.darkThemeButton.backgroundColor = .none
			
		}
		
		return cell
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.allowsSelection = false
		self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor

    }
	
	func deselectButtons(cell: CustomColorSettingsCell) {
		cell.redThemeButton.backgroundColor = .none
		cell.blueThemeButton.backgroundColor = .none
		cell.darkThemeButton.backgroundColor = .none
		cell.lightThemeButton.backgroundColor = .none
		
	}
	@IBAction func redSelected(_ sender: UIButton) {
		userDefaults.set("red", forKey: "Theme")
		showAlert()
	}
	@IBAction func blueSelected(_ sender: UIButton) {
		userDefaults.set("blue", forKey: "Theme")
		showAlert()
	}
	
	@IBAction func darkSelected(_ sender: UIButton) {
		userDefaults.set("dark", forKey: "Theme")
		showAlert()
	}
	
	@IBAction func lightSelected(_ sender: UIButton) {
		userDefaults.set("light", forKey: "Theme")
		showAlert()
	}
	
	func showAlert() {
		let alert = UIAlertController(title: "Restart the app", message: "To apply the selected theme please restart the app.", preferredStyle: .alert)
		
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
		
		self.present(alert, animated: true, completion: nil)
		
		tableView.reloadData()
		self.viewDidLoad()
	}
	
}

class CustomColorSettingsCell: UITableViewCell {
	
	@IBOutlet weak var settingLabel: UILabel!
	
	@IBOutlet weak var redThemeButton: UIButton!
	@IBOutlet weak var blueThemeButton: UIButton!
	@IBOutlet weak var darkThemeButton: UIButton!
	@IBOutlet weak var lightThemeButton: UIButton!
	
}
