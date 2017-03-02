//
//  SettingsVC.swift
//  Country
//
//  Created by Mario Kovacevic on 09/05/16.
//

import UIKit
import SwiftyUserDefaults
import Social
import Toaster
import SWRevealViewController
import SwiftKeychainWrapper

enum SettingsSections: String {
    case GENERAL = "General"
    case TELL_A_FRIEND = "Tell a Friend"
    case ABOUT = "About"
    static let allValues = [GENERAL, TELL_A_FRIEND, ABOUT]
}

enum SettingsGeneral: String {
    case AUTO_LOGIN = "Auto Login"
    static let allValues = [AUTO_LOGIN]
}

enum SettingsLoveTheApp: String {
    case SHARE_ON_FACEBOOK = "Share on Facebook"
    case SHARE_ON_TWITTER = "Share on Twitter"
    static let allValues = [SHARE_ON_FACEBOOK, SHARE_ON_TWITTER]
}

enum SettingsAbout: String {
    case VERSION = "Version"
    case ABOUT = "About"
    static let allValues = [VERSION, ABOUT]
}

class SettingsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var menuBtn:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav = self.navigationController?.navigationBar
        nav?.isTranslucent = false
        nav?.barTintColor = UIColor(hex: 0x028090)
        nav?.tintColor = UIColor(hex: 0xe8f1f0)
        
        self.navigationItem.title =  "Settings".uppercased()
        
        menuBtn = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(SettingsViewController.openNavigationMenu))
        self.navigationItem.leftBarButtonItem = menuBtn
        
        let logoutBtn = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(SettingsViewController.logout))
        self.navigationItem.rightBarButtonItem = logoutBtn
        
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        tableView.allowsSelection = true
        tableView.rowHeight = 44
        tableView.sectionHeaderHeight = 44
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
    }
    
    func openNavigationMenu() {
        self.revealViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSections.allValues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SettingsSections.allValues[section] {
        case .GENERAL:
            return SettingsGeneral.allValues.count
        case .TELL_A_FRIEND:
            return SettingsLoveTheApp.allValues.count
        case .ABOUT:
            return SettingsAbout.allValues.count
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.textLabel?.textAlignment = .center
        header.textLabel!.textColor = UIColor(hex: 0x028090)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SettingsSections.allValues[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section:SettingsSections = SettingsSections.allValues[(indexPath as NSIndexPath).section]
        
        let cell: SettingsTableViewCell = SettingsTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: SettingsTableViewCell.identifier)
        cell.contentView.layer.borderColor = UIColor(hex: 0xbcbdc1)?.cgColor
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.masksToBounds = true;
        cell.textLabel?.textColor = UIColor(hex: 0x028090)

        if (section == SettingsSections.GENERAL){
            cell.textLabel?.text = SettingsGeneral.allValues[(indexPath as NSIndexPath).row].rawValue
            if(SettingsGeneral.allValues[(indexPath as NSIndexPath).row] == SettingsGeneral.AUTO_LOGIN){
                let switchDemo=UISwitch(frame:CGRect(x: tableView.frame.width - 60, y: 6, width: 0, height: 0));
                switchDemo.isOn = true
                switchDemo.setOn(Defaults[.autologin], animated: false);
                switchDemo.onTintColor = UIColor(hex: 0x028090)
                switchDemo.addTarget(self, action: #selector(SettingsViewController.switchValueDidChange(_:)), for: .valueChanged);
                cell.addSubview(switchDemo)
            }
        } else if (section == SettingsSections.TELL_A_FRIEND) {
            cell.textLabel?.text = SettingsLoveTheApp.allValues[(indexPath as NSIndexPath).row].rawValue
        } else if (section == SettingsSections.ABOUT) {
            cell.textLabel?.text = SettingsAbout.allValues[(indexPath as NSIndexPath).row].rawValue
            if (SettingsAbout.allValues[(indexPath as NSIndexPath).row] == SettingsAbout.VERSION){
                if let text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    let versionLbl = UILabel(frame:CGRect(x: tableView.frame.width - 50, y: 10, width: 100, height: 22));
                    versionLbl.text = text
                    versionLbl.textColor = UIColor(hex: 0x028090)
                    cell.addSubview(versionLbl)
                    print(text)
                }
            } else {
                let arrowImage = UIImage(named: "arrowright")
                let arrowView = UIImageView(image: arrowImage)
                arrowView.tintColor = UIColor(hex: 0x028090)
                arrowView.frame = CGRect(x: tableView.frame.width - arrowView.frame.width - 10, y: tableView.rowHeight/2 - arrowView.frame.height/2, width: arrowView.frame.width, height: arrowView.frame.height)
                cell.addSubview(arrowView)
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section:SettingsSections = SettingsSections.allValues[(indexPath as NSIndexPath).section]

        if (section == SettingsSections.TELL_A_FRIEND) {
            if(SettingsLoveTheApp.allValues[(indexPath as NSIndexPath).row] == SettingsLoveTheApp.SHARE_ON_FACEBOOK){
                let serviceType = SLServiceTypeFacebook
                if SLComposeViewController.isAvailable(forServiceType: serviceType){
                    let controller = SLComposeViewController(forServiceType: serviceType)
                    controller?.setInitialText("This app is awesome!")
                    controller?.add(URL(string: "http://google.com/"))
                    controller?.completionHandler = {(result: SLComposeViewControllerResult) in
                        print("Completed")
                    }
                    present(controller!, animated: true, completion: nil)
                } else {
                    Toast(text: "The facebook service is not available").show()
                }
            } else if (SettingsLoveTheApp.allValues[(indexPath as NSIndexPath).row] == SettingsLoveTheApp.SHARE_ON_TWITTER) {
                let serviceType = SLServiceTypeTwitter
                if SLComposeViewController.isAvailable(forServiceType: serviceType){
                    let controller = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    controller?.setInitialText("This app is awesome!")
                    controller?.add(URL(string: "http://google.com/"))
                    controller?.completionHandler = {(result: SLComposeViewControllerResult) in
                        print("Completed")
                    }
                    present(controller!, animated: true, completion: nil)
                } else {
                    Toast(text: "The twitter service is not available").show()
                }
            }
        }
    }
    
    func switchValueDidChange(_ sender:UISwitch!) {
        if (sender.isOn == true){
            print("on", terminator: "")
        } else{
            print("off", terminator: "")
        }
        Defaults[.autologin] = sender.isOn
    }

    /**
     On logout, reset all of User Defaults, remove user's password from Keychain and dissmis to Intro View.
     */
    func logout() {
        Defaults.removeAll()        
        KeychainWrapper.standard.removeObject(forKey: KeychainKeys.password.rawValue)

        self.dismissModalStack(self, animated: true)
    }
    
    /**
     Go throw all views in stack and dismiss to last one.
     */
    func dismissModalStack(_ viewController: UIViewController, animated: Bool) {
        if viewController.presentingViewController != nil {
            var vc = viewController.presentingViewController!
            while (vc.presentingViewController != nil) {
                vc = vc.presentingViewController!;
            }
            vc.dismiss(animated: animated, completion: nil)
        }
    }
}
