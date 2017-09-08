//
//  NPCancelCaseVC.swift
//  NAPA BILLING
//
//  Created by Admin on 19/04/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire

class NPCancelCaseVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var  dictCancel = [String: String]()
    @IBOutlet var btnBefore: UIButton!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var btnAfter: UIButton!
    @IBOutlet var lblCase: UILabel!
    @IBOutlet var lblReason: UILabel!
    @IBOutlet var lblDateService: UILabel!
    @IBOutlet var tblReason: UITableView!
    var arrReason:NSArray!
    var strCase:String! = ""
    var strReason:String! = ""
    var strRecordId:String!
    

    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func btnEditTapped(_ sender: UIButton) {
        let popOverVC         = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddPopUpVC") as! AddPopUpVC
        self.addChildViewController(popOverVC)
        popOverVC.view.frame  = self.view.frame
        popOverVC.strRecordId = strRecordId
        popOverVC.page        = "2"
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    @IBAction func btnCaseTapped(_ sender: UIButton) {
        if sender.tag == 100 {
            btnAfter.isSelected = false
            btnBefore.isSelected = true
            strCase = "Before Induction"
        }else{
            btnAfter.isSelected = true
            btnBefore.isSelected = false
            strCase = "After Induction"
        }
        
    }
    
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        
        if (strCase?.isEmpty)! {
            appDelegate.alertShow(_objVC: self, msgString: "Please Select Case")
        }else if (strReason?.isEmpty)!
        {
            appDelegate.alertShow(_objVC: self, msgString: "Please Select atleast one reason")
        }else{
            var  dictCancel = [String: String]()
            let userID      = defaults.value(forKey: kAPP_UserId) as! String!
            dictCancel      = ["user_id":userID!,"record_id":strRecordId,"cancel_case":strCase!,"reason":strReason!]
            CancelCase(dict: dictCancel as NSDictionary)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblCase.font                = font_Regular
        lblReason.font              = font_Regular
        btnAfter.titleLabel?.font   = font_Regular_medium
        btnBefore.titleLabel?.font  = font_Regular_medium
        btnSubmit.titleLabel?.font  = font_bold_large
        arrReason                   = ["System","Medical","Patient"]
        tblReason.register(UINib(nibName: "ReasonCell", bundle: nil), forCellReuseIdentifier: "ReasonCell")
        tblReason.delegate          = self;
        tblReason.dataSource        = self
        tblReason.tableFooterView   = UIView()
        lblName.text                = appDelegate.checkEmptyString(str: strPatientName as NSString?) as String
        lblName.font                = font_bold_Exlarge
        // Do any additional setup after loading the view.
    }

    
    //MARK: tableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrReason.count
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tblReason.dequeueReusableCell(withIdentifier: "ReasonCell") as? ReasonCell
        
        if cell == nil {
            cell = ReasonCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ReasonCell")
        }
        cell?.lblReason.text              = (arrReason.object(at: indexPath.row) as! NSString) as String
        cell!.lblReason.font              = font_Regular_medium
        cell?.btnReason.tag               =  indexPath.row
        cell?.btnReason.addTarget(self, action: #selector(self.btnEnableTapped(_:)), for: UIControlEvents.touchUpInside)
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset              = UIEdgeInsets.zero
        cell?.layoutMargins               = UIEdgeInsets.zero
        return cell!
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
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let more = UITableViewRowAction(style: .normal, title: "More") { action, index in
            //self.isEditing = false
            
            print("more button tapped")
        }
        more.backgroundColor = UIColor.lightGray
        
        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
            //self.isEditing = false
            print("favorite button tapped")
        }
        
        favorite.backgroundColor = UIColor.orange
        
        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
            //self.isEditing = false
            print("share button tapped")
        }
        share.backgroundColor = UIColor.blue
        
        return [share, favorite, more]
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
        strReason =  (arrReason.object(at: sender.tag) as! NSString) as String
        if sender.isSelected == true {
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
    }
    
    //MARK:CancelCase webservice
    func CancelCase(dict:NSDictionary)
    {
        obj.ShowHud()
        
        Alamofire.request("\(web_SERWERURL)\(cancelUrl)", method: .post, parameters:dict as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
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
