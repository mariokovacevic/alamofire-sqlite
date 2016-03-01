//
//  CountriesViewController.swift
//  AlamofireSQLiteExample
//
//  Created by Mario Kovacevic on 16/10/15.
//  Copyright © 2015 Mario Kovacevic. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class CountriesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var countries = [CountryModel]()
    var refreshControl:UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationPanel()
    
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        tableView.tableFooterView = UIView(frame: CGRectZero)

    }
    
    func refresh(sender:AnyObject) {
        APIHelper.countries { (countries) -> Void in
            CountryDataHelper.importCountries(countries, onCompletion: { () -> Void in
                self.countries = CountryDataHelper.findAll()!
                self.refreshControl.endRefreshing()
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.countries = CountryDataHelper.findAll()!
    }
    
    override func viewDidAppear(animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    func setNavigationPanel(){
        let nav = self.navigationController?.navigationBar
        nav?.translucent = false
        nav?.barTintColor = UIColor.blackColor()
        nav?.tintColor = UIColor.whiteColor()
        
        self.navigationItem.title =  "Activity"
        let attributes = [
            NSFontAttributeName : UIFont(name: "Helvetica Neue", size: 18.0)!,
            NSUnderlineStyleAttributeName : 1,
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSTextEffectAttributeName : NSTextEffectLetterpressStyle,
            NSStrokeWidthAttributeName : 3.0]
        nav?.titleTextAttributes = attributes
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:CountriesTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("CountriesTableViewCell") as! CountriesTableViewCell
        cell.countryTitle.text = self.countries[indexPath.row].name
        cell.countryDescription.text = self.countries[indexPath.row].capital
        cell.countrySpecific.text = self.countries[indexPath.row].region
        
        tableView.rowHeight = 64
        cell.textLabel?.font = UIFont.systemFontOfSize(22)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }

}
