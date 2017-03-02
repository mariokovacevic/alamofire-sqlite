//
//  NavigationViewController.swift
//  Country
//
//  Created by Mario Kovacevic on 09/05/16.

import UIKit
import SwiftyUserDefaults

/**
Enum of all items in Navigation list
 */
enum Navigation: String {
    case Asia = "Asia"
    case Europe = "Europe"
    case Africa = "Africa"
    case Oceania = "Oceania"
    case Americas = "Americas"
    case Settings = "Settings"

    static let allValues = [Asia, Europe, Africa, Oceania, Americas, Settings]
}

class NavigationViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var defaultNav: Bool!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationPanel()
        
        let displayHeight = UIScreen.main.nativeBounds.height
        if displayHeight <= 960 {
            tableView.rowHeight = 34
        } else if displayHeight > 960 {
            tableView.rowHeight = 42
        }
        
        defaultNav = false
        
        tableView.backgroundColor = UIColor(hex: 0x028090)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (!defaultNav){
            let indexPath:IndexPath = IndexPath(row: 0, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
            defaultNav = true;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Navigation.allValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NavigationTableViewCell = NavigationTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: NavigationTableViewCell.identifier)
        cell.textLabel?.text = Navigation.allValues[(indexPath as NSIndexPath).row].rawValue
        cell.imageView?.image = UIImage(named: Navigation.allValues[(indexPath as NSIndexPath).row].rawValue)

        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor(white: 0xE8F1F2, alpha: 0.5).cgColor
        border.frame = CGRect(x: -1, y: cell.textLabel!.frame.size.height - width, width: UIScreen.main.nativeBounds.width, height: cell.frame.size.height)
        
        border.borderWidth = width
        cell.layer.addSublayer(border)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        if let menu = Navigation(rawValue: Navigation.allValues[(indexPath as NSIndexPath).row].rawValue) {
            switch menu {
            case .Settings:
                self.performSegue(withIdentifier: SegueIdentifier.Settings.rawValue, sender: self)
                break
            default:
                self.performSegue(withIdentifier: SegueIdentifier.Countries.rawValue, sender: self)
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == SegueIdentifier.Countries.rawValue){
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destinationNavigationController = segue.destination as! UINavigationController
                let vc:CountriesViewController = destinationNavigationController.topViewController as! CountriesViewController
                vc.currentRegion = Navigation.allValues[(indexPath as NSIndexPath).row]
            }
        }
    }
    
    func setNavigationPanel(){
        let nav = self.navigationController?.navigationBar
        nav?.isTranslucent = false
        nav?.barTintColor = UIColor(hex: 0xffffff)
        nav?.tintColor = UIColor(hex: 0x028090)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "Logo")
        imageView.image = image
        
        navigationItem.titleView = imageView
    }
}
