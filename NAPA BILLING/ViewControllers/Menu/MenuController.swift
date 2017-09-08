//
//  MenuController.swift
//  Example
//
//  Created by Teodor Patras on 16/06/16.
//  Copyright © 2016 teodorpatras. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {
    var arrMenu : NSMutableArray!
   // let segues = ["showCenterController1", "showCenterController2", "showCenterController3"]
    private var previousIndex: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrMenu = NSMutableArray()
        
        let versionString:String!
        let version     = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionString   = "Version " + version! as String
        arrMenu         = ["Home","Logout",versionString]
        
        self.tableView.tableFooterView = UIView()
      
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
        override func tableView(_ tableView: UITableView,
                                cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell                = tableView.dequeueReusableCell(withIdentifier: "menuCell")!
        cell.textLabel?.font    = font_Regular_large
        cell.textLabel?.text    = arrMenu.object(at: indexPath.row) as? String
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset     = UIEdgeInsets.zero
        cell.layoutMargins      = UIEdgeInsets.zero
        return cell
    }
    
        override func tableView(_ tableView: UITableView,
                                didSelectRowAt indexPath: IndexPath)  {
        
        if let index = previousIndex {
            tableView.deselectRow(at: index as IndexPath, animated: true)
        }
        
       // sideMenuController?.performSegue(withIdentifier: segues[indexPath.row], sender: nil)
        previousIndex = indexPath as NSIndexPath?
        if indexPath.row == 1 {
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
    
}
