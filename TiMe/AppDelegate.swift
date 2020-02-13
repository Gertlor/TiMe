//
//  AppDelegate.swift
//  TiMe
//
//  Created by Gerrit Louis on 12/12/2019.
//  Copyright © 2019 Gerrit Louis de Beuze. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		let defaults = UserDefaults.standard

		let selectedTheme = defaults.string(forKey: "Theme")

		switch selectedTheme {
			
			case "red":
				ThemeManager.applyTheme(theme: .redTheme)
			case "blue":
				ThemeManager.applyTheme(theme: .blueTheme)
			case "dark":
				ThemeManager.applyTheme(theme: .darkTheme)
			case "light":
				ThemeManager.applyTheme(theme: .lightTheme)
			default:
			ThemeManager.applyTheme(theme: .darkTheme)
		}
		
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		self.saveContext()
	}

	// MARK: - Core Data stack

	lazy var persistentContainer: NSPersistentContainer = {
	    
	    let container = NSPersistentContainer(name: "DataModel")
	    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
	        if let error = error as NSError? {
	            fatalError("Unresolved error \(error), \(error.userInfo)")
	        }
	    })
	    return container
	}()

	// MARK: - Core Data Saving support

	func saveContext () {
	    let context = persistentContainer.viewContext
	    if context.hasChanges {
	        do {
	            try context.save()
	        } catch {
	            let nserror = error as NSError
	            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
	        }
	    }
	}
}

