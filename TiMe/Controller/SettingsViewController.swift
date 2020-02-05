//
//  SettingsViewController.swift
//  TiMe
//
//  Created by Gerrit Louis on 02/01/2020.
//  Copyright © 2020 Gerrit Louis de Beuze. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsColorCell", for: indexPath) as! CustomColorSettingsCell
		
		return cell
	}
	

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor

    }
    
}

class CustomColorSettingsCell: UITableViewCell {
	
	@IBOutlet weak var settingLabel: UILabel!
	
	@IBOutlet weak var redThemeButton: UIButton!
	@IBOutlet weak var blueThemeButton: UIButton!
	@IBOutlet weak var darkThemeButton: UIButton!
	@IBOutlet weak var lightThemeButton: UIButton!
	
	let userDefaults = UserDefaults.standard
	
	@IBAction func redThemeSelected(_ sender: UIButton) {
		
		userDefaults.set("red", forKey: "Theme")
		
		print("red cell")
	}
	
	@IBAction func blueThemeSelected(_ sender: UIButton) {
		
		userDefaults.set("blue", forKey: "Theme")
		
		print("blue cell")
	}
	
	@IBAction func darkThemeSelected(_ sender: UIButton) {
		
		userDefaults.set("dark", forKey: "Theme")
		
		print("dark cell")
	}
	
	@IBAction func lightThemeSelected(_ sender: UIButton) {
		
		userDefaults.set("light", forKey: "Theme")
		
		print("light cell")
	}
	
}
