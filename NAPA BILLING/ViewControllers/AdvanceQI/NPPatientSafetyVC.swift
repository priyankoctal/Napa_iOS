//
//  NPPatientSafetyVC.swift
//  NAPA BILLING
//
//  Created by Admin on 02/05/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire

class NPPatientSafetyVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    var arrOtherI:NSArray!
    var arrOtherS:NSArray!
    var arrOtherFire:NSArray!
    @IBOutlet var lblIntra: UILabel!
    @IBOutlet var lblPost: UILabel!
    @IBOutlet var tblRegional: UITableView!
    var dictSelected:NSMutableDictionary!
    var arrInjurySelected:NSMutableArray!
    var arrSafetySelected:NSMutableArray!
    var arrFireSelected:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dictSelected                 = NSMutableDictionary()
        arrInjurySelected            = NSMutableArray()
        arrSafetySelected            = NSMutableArray()
        arrFireSelected              = NSMutableArray()
        arrOtherI                    = ["Dental injury","Corneal abrasion","New pressure sore or breakdown","Eyelid injury","Laceration/skin tear","Agitation requiring restraints","Patient fall","Incorrect surgical site,side,patient,procedure or implant"]
        arrOtherS                    = ["Unintended awareness under GA","Equipment malfunction"]
        arrOtherFire                 = ["Surface burn","Airway fire","OR fire"]

        
        tblRegional.register(UINib(nibName: "QIMultiCell", bundle: nil), forCellReuseIdentifier: "QIMultiCell")
        tblRegional.tableFooterView   = UIView()
        tblRegional.allowsSelection   = false
        tblRegional.estimatedRowHeight = UITableViewAutomaticDimension
        lblIntra.font               = font_bold_large
        lblPost.font                = font_bold_large
        
        
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
            
            
            for i in 0 ..< self.arrInjurySelected.count
            {

                dictSlectedQI.setValue(self.dictSelected.value(forKey: self.arrInjurySelected.object(at: i) as! String) as! String, forKey: "\(self.arrInjurySelected.object(at: i) as! String)")

            }
            
            for i in 0 ..< self.arrSafetySelected.count
            {
                
               dictSlectedQI.setValue(self.dictSelected.value(forKey: self.arrSafetySelected.object(at: i) as! String) as! String, forKey: "\(self.arrSafetySelected.object(at: i) as! String)")
            }
            
            for i in 0 ..< self.arrFireSelected.count
            {                

                dictSlectedQI.setValue(self.dictSelected.value(forKey: self.arrFireSelected.object(at: i) as! String) as! String, forKey: "\(self.arrFireSelected.object(at: i) as! String)")
            }
            
            var dictQINew = NSMutableDictionary()
            let userID      = defaults.value(forKey: kAPP_UserId) as! String!
            dictQINew = [
                "user_id" : userID!
                ,"qi_measures" :dictSlectedQI
                ,"record_id":recordId
            ]
            
            self.QIService(dict: dictQINew)
            
            
        }
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)


    }
    
    @IBAction func btnEnableTapped(_ sender: UIButton) {
        
        let buttonPosition      = sender.convert(CGPoint.zero, to: self.tblRegional)
        let indexPath           = self.tblRegional.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            
            if indexPath?.section == 0
            {
                let cell = tblRegional.cellForRow(at: indexPath!) as! QIMultiCell
                if cell.btnSelect == sender
                {
                    
                    if dictSelected.object(forKey: arrOtherI.object(at: (indexPath?.row)!) as! String) as? String == "Intra Op"
                    {
                        dictSelected.setValue(" ", forKey: arrOtherI.object(at: (indexPath?.row)!) as! String)
                        cell.btnSelect.isSelected = false
                        cell.btnUnSelect.isSelected = false
                        arrInjurySelected.remove(arrOtherI.object(at: (indexPath?.row)!) as! String)
                    }else{
                        dictSelected.setValue("Intra Op", forKey: arrOtherI.object(at: (indexPath?.row)!) as! String)
                        arrInjurySelected.add(arrOtherI.object(at: (indexPath?.row)!) as! String)
                        cell.btnSelect.isSelected = true
                        cell.btnUnSelect.isSelected = false
                    }
                }else{
                    
                    if dictSelected.object(forKey: arrOtherI.object(at: (indexPath?.row)!) as! String) as? String == "Post Op"
                    {
                        dictSelected.setValue(" ", forKey: arrOtherI.object(at: (indexPath?.row)!) as! String)
                        arrInjurySelected.remove(arrOtherI.object(at: (indexPath?.row)!) as! String)
                        cell.btnSelect.isSelected = false
                        cell.btnUnSelect.isSelected = false
                    }else{
                        dictSelected.setValue("Post Op", forKey: arrOtherI.object(at: (indexPath?.row)!) as! String)
                        arrInjurySelected.add(arrOtherI.object(at: (indexPath?.row)!) as! String)
                        cell.btnSelect.isSelected = false
                        cell.btnUnSelect.isSelected = true
                    }
                    
                }
            }else  if indexPath?.section == 1
            {
                let cell = tblRegional.cellForRow(at: indexPath!) as! QIMultiCell
                if cell.btnSelect == sender
                {
                    
                    if dictSelected.object(forKey: arrOtherS.object(at: (indexPath?.row)!) as! String) as? String == "Intra Op"
                    {
                        dictSelected.setValue(" ", forKey: arrOtherS.object(at: (indexPath?.row)!) as! String)
                        cell.btnSelect.isSelected = false
                        cell.btnUnSelect.isSelected = false
                        arrSafetySelected.remove(arrOtherS.object(at: (indexPath?.row)!) as! String)
                    }else{
                        dictSelected.setValue("Intra Op", forKey: arrOtherS.object(at: (indexPath?.row)!) as! String)
                        arrSafetySelected.add(arrOtherS.object(at: (indexPath?.row)!) as! String)
                        cell.btnSelect.isSelected = true
                        cell.btnUnSelect.isSelected = false
                    }
                }else{
                    
                    if dictSelected.object(forKey: arrOtherS.object(at: (indexPath?.row)!) as! String) as? String == "Post Op"
                    {
                        dictSelected.setValue(" ", forKey: arrOtherS.object(at: (indexPath?.row)!) as! String)
                        arrSafetySelected.remove(arrOtherS.object(at: (indexPath?.row)!) as! String)
                        cell.btnSelect.isSelected = false
                        cell.btnUnSelect.isSelected = false
                    }else{
                        dictSelected.setValue("Post Op", forKey: arrOtherS.object(at: (indexPath?.row)!) as! String)
                        arrSafetySelected.add(arrOtherS.object(at: (indexPath?.row)!) as! String)
                        cell.btnSelect.isSelected = false
                        cell.btnUnSelect.isSelected = true
                    }
                    
                }
            }
            else{
                let cell = tblRegional.cellForRow(at: indexPath!) as! QIMultiCell
                if cell.btnSelect == sender
                {
                    
                    if dictSelected.object(forKey: arrOtherFire.object(at: (indexPath?.row)!) as! String) as? String == "Intra Op"
                    {
                        dictSelected.setValue(" ", forKey: arrOtherFire.object(at: (indexPath?.row)!) as! String)
                        cell.btnSelect.isSelected = false
                        cell.btnUnSelect.isSelected = false
                        arrFireSelected.remove(arrOtherFire.object(at: (indexPath?.row)!) as! String)
                    }else{
                        dictSelected.setValue("Intra Op", forKey: arrOtherFire.object(at: (indexPath?.row)!) as! String)
                        arrFireSelected.add(arrOtherFire.object(at: (indexPath?.row)!) as! String)
                        cell.btnSelect.isSelected = true
                        cell.btnUnSelect.isSelected = false
                    }
                }else{
                    
                    if dictSelected.object(forKey: arrOtherFire.object(at: (indexPath?.row)!) as! String) as? String == "Post Op"
                    {
                        dictSelected.setValue(" ", forKey: arrOtherFire.object(at: (indexPath?.row)!) as! String)
                        arrFireSelected.remove(arrOtherFire.object(at: (indexPath?.row)!) as! String)
                        cell.btnSelect.isSelected = false
                        cell.btnUnSelect.isSelected = false
                    }else{
                        dictSelected.setValue("Post Op", forKey: arrOtherFire.object(at: (indexPath?.row)!) as! String)
                        arrFireSelected.add(arrOtherFire.object(at: (indexPath?.row)!) as! String)
                        cell.btnSelect.isSelected = false
                        cell.btnUnSelect.isSelected = true
                    }
                    
                }
            }
            
        }
    }
    
    //QIService webservice
    func QIService(dict:NSDictionary)
    {
        obj.ShowHud()
        
        Alamofire.request("\(web_SERWERURL)\(saveQIUrl)", method: .post, parameters:dict as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
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
    

    //MARK: tableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3;
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrOtherI.count
        }else if section == 1{
            return arrOtherS.count
        }else{
             return arrOtherFire.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
             var cell = tblRegional.dequeueReusableCell(withIdentifier: "QIMultiCell") as? QIMultiCell
            
            if cell == nil {
                cell = QIMultiCell(style: UITableViewCellStyle.value1, reuseIdentifier: "QIMultiCell")
            }
            cell?.lblTitle.text              = (arrOtherI.object(at: indexPath.row) as! NSString) as String
            if indexPath.row<2 {
                cell!.lblTitle.font          = font_bold_medium
            }else{
                cell!.lblTitle.font          = font_Regular_medium
            }
            cell?.lblTitle.textColor         = UIColor.darkText
            cell?.lblTitle.textAlignment     = NSTextAlignment.center
            cell?.btnSelect.tag              =  indexPath.row
            cell?.btnUnSelect.tag            =  indexPath.row
            cell?.btnSelect.addTarget(self, action: #selector(self.btnEnableTapped(_:)), for: UIControlEvents.touchUpInside)
            cell?.btnUnSelect.addTarget(self, action: #selector(self.btnEnableTapped(_:)), for: UIControlEvents.touchUpInside)
            //  cell?.accessoryType               = UITableViewCellAccessoryType.disclosureIndicator
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset              = UIEdgeInsets.zero
            cell?.layoutMargins               = UIEdgeInsets.zero
            return cell!
        }else if indexPath.section == 1 {
            var cell = tblRegional.dequeueReusableCell(withIdentifier: "QIMultiCell") as? QIMultiCell
            
            if cell == nil {
                cell = QIMultiCell(style: UITableViewCellStyle.value1, reuseIdentifier: "QIMultiCell")
            }
            cell?.lblTitle.text              = (arrOtherS.object(at: indexPath.row) as! NSString) as String
            cell!.lblTitle.font              = font_Regular_medium
            cell?.lblTitle.textColor         = UIColor.darkText
            cell?.lblTitle.textAlignment     = NSTextAlignment.center
            cell?.btnSelect.tag              =  indexPath.row
            cell?.btnUnSelect.tag            =  indexPath.row
            cell?.btnSelect.addTarget(self, action: #selector(self.btnEnableTapped(_:)), for: UIControlEvents.touchUpInside)
            cell?.btnUnSelect.addTarget(self, action: #selector(self.btnEnableTapped(_:)), for: UIControlEvents.touchUpInside)
            //  cell?.accessoryType               = UITableViewCellAccessoryType.disclosureIndicator
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset              = UIEdgeInsets.zero
            cell?.layoutMargins               = UIEdgeInsets.zero
            return cell!
        }else{
            var cell = tblRegional.dequeueReusableCell(withIdentifier: "QIMultiCell") as? QIMultiCell
            
            if cell == nil {
                cell = QIMultiCell(style: UITableViewCellStyle.value1, reuseIdentifier: "QIMultiCell")
            }
            cell?.lblTitle.text              = (arrOtherFire.object(at: indexPath.row) as! NSString) as String
            if indexPath.row>0 {
                cell!.lblTitle.font          = font_bold_medium
            }else{
                cell!.lblTitle.font          = font_Regular_medium
            }
            cell?.lblTitle.textColor         = UIColor.darkText
            cell?.lblTitle.textAlignment     = NSTextAlignment.center
            cell?.btnSelect.tag              =  indexPath.row
            cell?.btnUnSelect.tag            =  indexPath.row
            cell?.btnSelect.addTarget(self, action: #selector(self.btnEnableTapped(_:)), for: UIControlEvents.touchUpInside)
            cell?.btnUnSelect.addTarget(self, action: #selector(self.btnEnableTapped(_:)), for: UIControlEvents.touchUpInside)
            //  cell?.accessoryType               = UITableViewCellAccessoryType.disclosureIndicator
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset              = UIEdgeInsets.zero
            cell?.layoutMargins               = UIEdgeInsets.zero
            return cell!
        }


        
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader                  = UIView()
        viewHeader.frame                = CGRect(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT*0.07)
        if section == 0 {
            
            let imgOther             = UIImageView(frame:CGRect(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT*0.07))
            imgOther.image           = UIImage(named:"strip")
            viewHeader.addSubview(imgOther)
            
            let lblHeader           = UILabel(frame:CGRect(x:15,y:0,width:SCREEN_WIDTH-25,height:SCREEN_HEIGHT*0.07))
            lblHeader.text          = "Other Injury"
            lblHeader.font          = font_bold_large
            lblHeader.textColor     = UIColor.white
            viewHeader.addSubview(lblHeader)
            
            
        }else if section == 1{
            
            let imgOther             = UIImageView(frame:CGRect(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT*0.07))
            imgOther.image           = UIImage(named:"strip")
            viewHeader.addSubview(imgOther)
            
            let lblHeader           = UILabel(frame:CGRect(x:15,y:0,width:SCREEN_WIDTH-25,height:SCREEN_HEIGHT*0.07))
            lblHeader.text          = "Other safety"
            lblHeader.font          = font_bold_large
            lblHeader.textColor     = UIColor.white
            viewHeader.addSubview(lblHeader)
            
        }else{
            let imgOther             = UIImageView(frame:CGRect(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT*0.07))
            imgOther.image           = UIImage(named:"strip")
            viewHeader.addSubview(imgOther)
            
            let lblHeader           = UILabel(frame:CGRect(x:15,y:0,width:SCREEN_WIDTH-25,height:SCREEN_HEIGHT*0.07))
            lblHeader.text          = "OR fire/burn"
            lblHeader.font          = font_bold_large
            lblHeader.textColor     = UIColor.white
            viewHeader.addSubview(lblHeader)
        }
        
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SCREEN_HEIGHT*0.07
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
