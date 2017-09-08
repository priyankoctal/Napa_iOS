//
//  NPSubPostOpVC.swift
//  NAPA BILLING
//
//  Created by Admin on 25/04/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire
var strCatType:String!

class NPSubPostOpVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    var arrSubCat:NSArray!
    var arrSelected:NSMutableArray      = NSMutableArray()
    @IBOutlet var tblSubCategory:UITableView!
    @IBOutlet var lblNavTitle: UILabel!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblNavTitle.text = strviewType
        
        if strviewType == "Lower Extremity" {
            arrSubCat   = ["Femoral","Adductor Canal","Lumbar plexus","Sciatic","Popliteal","Popliteal sciatic","Saphenous"];
            
        }else if strviewType == "Upper Extremity" {
            arrSubCat   = ["Brachial Plexus","Supraclavicular","Interscalene","Axillary"];
            
        }else if strviewType == "Neuraxial" {
            arrSubCat   = ["Thoracic epidural","Lumbar epidural","Spinal (single shot)","Caudal (single shot)Continuous Caudal"]
            
        }else if strviewType == "Chest and Abdomen" {
            arrSubCat   = ["Paravertebral","thoracic","single level Paravertebral","additional levels","Intercostal block","single Intercostal block","multipl TAP or rectus sheath block"];
        }
        tblSubCategory.register(UINib(nibName: "ReasonCell", bundle: nil), forCellReuseIdentifier: "ReasonCell")
        tblSubCategory.tableFooterView = UIView()
         // Do any additional setup after loading the view.
    }
    
    
    //MARK: methods.....
    @IBAction func btnBackTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to save?" as String?, preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "No", style: .default) { (action) -> Void in
            self.navigationController!.popViewController(animated: true)
        }
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) -> Void in
            // let arrQIAll = NSMutableArray()
            let dictCardiac = NSMutableDictionary()
            
            for i in 0 ..< self.arrSelected.count
            {
                
                dictCardiac.setValue("yes", forKey: "\(self.arrSubCat.object(at: self.arrSelected.object(at: i) as! Int) as! String)")
            }
            
              var dict        = NSMutableDictionary()
            let userID      = defaults.value(forKey: kAPP_UserId) as! String!
            dict            = ["user_id" : userID!,"charge_measures" :dictCardiac,"record_id":recordId]
            
            self.SavePostOPService(dict:dict)           
            
        }
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)

    
}
    
    @IBAction func btnEditTapped(_ sender: UIButton) {
        
    }
    
    //MARK: tableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrSubCat.count
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tblSubCategory.dequeueReusableCell(withIdentifier: "ReasonCell") as? ReasonCell
        
        if cell == nil {
            cell = ReasonCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ReasonCell")
        }
        cell?.lblReason.text              = (arrSubCat.object(at: indexPath.row) as! NSString) as String
        cell!.lblReason.font              = font_Regular_medium
        cell?.lblReason.textColor         = UIColor.darkText
        cell?.btnReason.tag               =  indexPath.row
        cell?.btnReason.addTarget(self, action: #selector(self.btnEnableTapped(_:)), for: UIControlEvents.touchUpInside)
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset              = UIEdgeInsets.zero
        cell?.layoutMargins               = UIEdgeInsets.zero
              
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        if indexPath.row==0 {
        //            strType = "active"
        //        }else if indexPath.row==1
        //        {
        //            strType = "revenue"
        //        }else{
        //            strType = "cost"
        //        }
        //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //        let vc = storyBoard.instantiateViewController(withIdentifier: "TDDashboardDetailVC") as! TDDashboardDetailVC
        //        vc.strContractType = strType
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_tableView: UITableView,
                   willDisplayCell cell: UITableViewCell,
                   forRowAtIndexPath indexPath: NSIndexPath) {
        
        //        if cell.respondsToSelector(Selector("setSeparatorInset:")) {
        //            cell.separatorInset = UIEdgeInsetsZero
        //        }
        //        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
        //
        //            if #available(iOS 8.0, *) {
        //                cell.layoutMargins = UIEdgeInsetsZero
        //            } else {
        //                // Fallback on earlier versions
        //            }
        //
        //        }
        //        if cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:")) {
        //
        //            if #available(iOS 8.0, *) {
        //                cell.preservesSuperviewLayoutMargins = false
        //            } else {
        //                // Fallback on earlier versions
        //            }
        //
        //        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44;
    }
    
    @IBAction func btnEnableTapped(_ sender: UIButton) {
        
        let buttonPosition      = sender.convert(CGPoint.zero, to: self.tblSubCategory)
        let indexPath           = self.tblSubCategory.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            if arrSelected.contains(sender.tag) {
                arrSelected.remove(sender.tag)
                sender.isSelected = false
            }else{
                arrSelected.add(sender.tag)
                sender.isSelected = true
                
            }
        }
        

    }
    
    //SavePostOPService webservice
    func SavePostOPService(dict:NSDictionary)
    {
        obj.ShowHud()
        
        Alamofire.request("\(web_SERWERURL)\(invaishiveUrl)", method: .post, parameters:dict as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            print(response.request ?? "")
            switch(response.result) {
            case .success(_):
                if response.result.value != nil
                {
                    obj.HideHud()
                    print(response.result.value!)
                    let JSON        = response.result.value! as AnyObject
                    let response    = JSON["response"] as! NSDictionary
                    let status      = response.value(forKey: "status")
                    let message     = response.value(forKey: "message") as? String
                    if (status as AnyObject).doubleValue == 1
                    {
                        self.navigationController!.popViewController(animated: true)
                        
                    }
                        
                    else
                    {
                        print("Fails")
                        obj.HideHud()
                        appDelegate.alertShow(_objVC: self, msgString: message!)
                        
                        
                    }
                    
                    
                }
                break
                
            case .failure(_):
                print(response.result.error ?? "Fail")
                obj.HideHud()
                break
                
            }
        }
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
