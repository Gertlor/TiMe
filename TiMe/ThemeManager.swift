//
//  ThemeManager.swift
//  TiMe
//
//  Created by Gerrit Louis on 03/02/2020.
//  Copyright © 2020 Gerrit Louis de Beuze. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    func colorFromHexString (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
enum Theme: Int {

    case redTheme, blueTheme, darkTheme, lightTheme

    var mainColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor().colorFromHexString("ffffff")
        case .darkTheme:
            return UIColor().colorFromHexString("000000")
		case .redTheme:
			return UIColor().colorFromHexString("CB4335")
		case .blueTheme:
			return UIColor().colorFromHexString("2471A3")
		}
    }

    var barStyle: UIBarStyle {
        switch self {
        case .lightTheme:
			return .default
        case .darkTheme:
			return .black
		case .redTheme:
			return .black
		case .blueTheme:
			return .black
		}
    }
	
	var barTitleColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor().colorFromHexString("000000")
        case .darkTheme:
            return UIColor().colorFromHexString("ffffff")
		case .redTheme:
			return UIColor().colorFromHexString("000000")
		case .blueTheme:
			return UIColor().colorFromHexString("000000")
		}
    }

    var navigationBackgroundImage: UIImage? {
        return self == .lightTheme ? UIImage(named: "navBackground") : nil
    }

    var tabBarBackgroundImage: UIImage? {
        return self == .lightTheme ? UIImage(named: "tabBarBackground") : nil
    }

    var backgroundColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor().colorFromHexString("ffffff")
        case .darkTheme:
            return UIColor().colorFromHexString("000000")
		case .redTheme:
			return UIColor().colorFromHexString("f1948a")
		case .blueTheme:
			return UIColor().colorFromHexString("5dade2")
		}
    }

    var secondaryColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor().colorFromHexString("ffffff")
        case .darkTheme:
            return UIColor().colorFromHexString("000000")
		case .redTheme:
			return UIColor().colorFromHexString("CB4335")
		case .blueTheme:
			return UIColor().colorFromHexString("2471A3")
		}
    }
    
    var titleTextColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor().colorFromHexString("000000")
        case .darkTheme:
            return UIColor().colorFromHexString("ffffff")
		case .redTheme:
			return UIColor().colorFromHexString("CC0000")
		case .blueTheme:
			return UIColor().colorFromHexString("000099")
		}
    }
	
    var subtitleTextColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor().colorFromHexString("000000")
        case .darkTheme:
            return UIColor().colorFromHexString("ffffff")
		case .redTheme:
			return UIColor().colorFromHexString("DF0606")
		case .blueTheme:
			return UIColor().colorFromHexString("0080FF")
		}
    }
	
	var tabBarItemColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor().colorFromHexString("000000")
        case .darkTheme:
            return UIColor().colorFromHexString("ffffff")
		case .redTheme:
			return UIColor().colorFromHexString("FF9999")
		case .blueTheme:
			return UIColor().colorFromHexString("99CCFF")
		}
	}
		
	var selectedTabBarItemColor: UIColor {
		switch self {
		case .lightTheme:
			return UIColor().colorFromHexString("808080")
		case .darkTheme:
			return UIColor().colorFromHexString("808080")
		case .redTheme:
			return UIColor().colorFromHexString("330000")
		case .blueTheme:
			return UIColor().colorFromHexString("99CCFF")
			}
	}
	
	var cellBackgroundColor: UIColor {
		switch self {
		case .lightTheme:
			return UIColor().colorFromHexString("ffffff")
		case .darkTheme:
			return UIColor().colorFromHexString("000000")
		case .redTheme:
			return UIColor().colorFromHexString("FF9999")
		case .blueTheme:
			return UIColor().colorFromHexString("99CCFF")
			}
	}
}

// Enum declaration
let SelectedThemeKey = "SelectedTheme"

// This will let you use a theme in the app.
class ThemeManager {

    // ThemeManager
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .darkTheme
        }
    }

    static func applyTheme(theme: Theme) {
        // First persist the selected theme using NSUserDefaults.
        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()

        // You get your current (selected) theme and apply the main color to the tintColor property of your application’s window.
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.mainColor

        UINavigationBar.appearance().barStyle = theme.barStyle
        UINavigationBar.appearance().setBackgroundImage(theme.navigationBackgroundImage, for: .default)
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backArrow")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMaskFixed")

        UITabBar.appearance().barStyle = theme.barStyle
        UITabBar.appearance().backgroundImage = theme.tabBarBackgroundImage

        let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.withRenderingMode(.alwaysTemplate)
        let tabResizableIndicator = tabIndicator?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
        UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator

        let controlBackground = UIImage(named: "controlBackground")?.withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        let controlSelectedBackground = UIImage(named: "controlSelectedBackground")?
            .withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))

        UISegmentedControl.appearance().setBackgroundImage(controlBackground, for: .normal, barMetrics: .default)
        UISegmentedControl.appearance().setBackgroundImage(controlSelectedBackground, for: .selected, barMetrics: .default)

        UIStepper.appearance().setBackgroundImage(controlBackground, for: .normal)
        UIStepper.appearance().setBackgroundImage(controlBackground, for: .disabled)
        UIStepper.appearance().setBackgroundImage(controlBackground, for: .highlighted)
        UIStepper.appearance().setDecrementImage(UIImage(named: "fewerPaws"), for: .normal)
        UIStepper.appearance().setIncrementImage(UIImage(named: "morePaws"), for: .normal)
 
        UISlider.appearance().setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
        UISlider.appearance().setMaximumTrackImage(UIImage(named: "maximumTrack")?
            .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 6.0)), for: .normal)
        UISlider.appearance().setMinimumTrackImage(UIImage(named: "minimumTrack")?
            .withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 6.0, bottom: 0, right: 0)), for: .normal)

        UISwitch.appearance().onTintColor = theme.mainColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = theme.mainColor
		
		UINavigationBar.appearance().barTintColor = theme.mainColor
		UINavigationBar.appearance().tintColor = theme.barTitleColor
		UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.barTitleColor]
		
		UILabel.appearance().textColor = theme.titleTextColor
		UITextField.appearance().textColor = theme.subtitleTextColor
		
		UIButton.appearance().tintColor = theme.subtitleTextColor
		
		UITabBar.appearance().tintColor = theme.selectedTabBarItemColor
		UITabBar.appearance().barTintColor = theme.mainColor
		UITabBar.appearance().unselectedItemTintColor = theme.tabBarItemColor
		
		UITableView.appearance().backgroundColor = theme.mainColor
		UITableView.appearance().tintColor = theme.subtitleTextColor
		
		UITableViewCell.appearance().backgroundColor = theme.cellBackgroundColor
		
		UISearchBar.appearance().barTintColor = theme.backgroundColor
    }
}
