//
//  CountriesViewController.swift
//  Country
//
//  Created by Mario Kovacevic on 09/05/16.

import Foundation
import UIKit
import SWRevealViewController
import SwiftyUserDefaults
import Async

class CountriesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!

    /**
     Array of CountryModel objects
     */
    var countries = [CountryModel]()
    
    /**
     Current Region selected in Navigation
     */
    var currentRegion:Navigation = Navigation.Africa
    
    var refreshControl:UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationPanel()
    
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(CountriesViewController.refresh(_:)), for: UIControlEvents.valueChanged)

        self.tableView.addSubview(refreshControl)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }

    /**
     Refresh fetch all countries from GET request, then countrie models are passed in CountryDataModel class where insert or update will be made. 
     After that, all countries are fetched from the database again in same array of country models as from server.
     */
    func refresh(_ sender:AnyObject) {
        APIHelper.countries { (countries) -> Void in
            CountryDataHelper.importCountries(countries, onCompletion: { () -> Void in
                self.countries = CountryDataHelper.findAll()!
                self.refreshControl.endRefreshing()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title =  currentRegion.rawValue
        self.countries = CountryDataHelper.findAllForRegion(currentRegion)!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.showNavigationOnStartup()
    }
    
    /**
     Navigation will slide open if user just opened the app.
     */
    func showNavigationOnStartup() {
        if Defaults[.showNavigation] == true {
            self.revealViewController().revealToggle(animated: true)
            Defaults[.showNavigation] = false
        }
    }

    func setNavigationPanel(){
        let nav = self.navigationController?.navigationBar
        nav?.isTranslucent = false
        nav?.barTintColor = UIColor(hex: 0x028090)
        nav?.tintColor = UIColor(hex: 0xe8f1f0)
        
        self.navigationItem.title =  currentRegion.rawValue
        
        let menuBtn:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(CountriesViewController.openNavigationMenu))
        self.navigationItem.leftBarButtonItems = [menuBtn]
        
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CountriesTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CountriesTableViewCell") as! CountriesTableViewCell
        cell.countryTitle.text = self.countries[(indexPath as NSIndexPath).row].name
        cell.countryDescription.text = self.countries[(indexPath as NSIndexPath).row].capital
        cell.countrySpecific.text = self.countries[(indexPath as NSIndexPath).row].region
        
        tableView.rowHeight = 64
        cell.textLabel?.font = UIFont.systemFont(ofSize: 22)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func openNavigationMenu() {
        self.revealViewController()
    }
}
