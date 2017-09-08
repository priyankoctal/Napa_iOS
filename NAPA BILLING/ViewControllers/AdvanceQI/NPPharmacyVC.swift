//
//  NPPharmacyVC.swift
//  NAPA BILLING
//
//  Created by Admin on 02/05/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire

class NPPharmacyVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    var arrPharmacy:NSArray!
    @IBOutlet var lblIntra: UILabel!
    @IBOutlet var lblPost: UILabel!
    @IBOutlet var tblPharmacy: UITableView!
    var dictSelected:NSMutableDictionary!
    var arrSelected:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dictSelected                 = NSMutableDictionary()
        arrSelected                  = NSMutableArray()
        arrPharmacy                   = ["Malignant hyperthermia","Anaphylaxis","Medication Error"]
        
        tblPharmacy.register(UINib(nibName: "QIMultiCell", bundle: nil), forCellReuseIdentifier: "QIMultiCell")
        tblPharmacy.tableFooterView   = UIView()
        tblPharmacy.allowsSelection   = false
        tblPharmacy.estimatedRowHeight = UITableViewAutomaticDimension
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
            
            
            for i in 0 ..< self.arrSelected.count
            {
                
                dictSlectedQI.setValue(self.dictSelected.value(forKey: self.arrSelected.object(at: i) as! String) as! String, forKey: "\(self.arrSelected.object(at: i) as! String)")
                
            }
            
            
            var dictQINew = NSMutableDictionary()
            let userID      = defaults.value(forKey: kAPP_UserId) as! String!
            dictQINew = [
                "user_id" : userID!
                ,"qi_measures" :dictSlectedQI
                ,"record_id":recordId
            ]
            
            self.QIServiceRegional(dict: dictQINew)
        }
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)

    }
    
    @IBAction func btnEnableTapped(_ sender: UIButton) {
        let buttonPosition      = sender.convert(CGPoint.zero, to: self.tblPharmacy)
        let indexPath           = self.tblPharmacy.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            
            
            let cell = tblPharmacy.cellForRow(at: indexPath!) as! QIMultiCell
            if cell.btnSelect == sender
            {
                
                if dictSelected.object(forKey: arrPharmacy.object(at: (indexPath?.row)!) as! String) as? String == "Intra Op"
                {
                    dictSelected.setValue(" ", forKey: arrPharmacy.object(at: (indexPath?.row)!) as! String)
                    cell.btnSelect.isSelected = false
                    cell.btnUnSelect.isSelected = false
                    arrSelected.remove(arrPharmacy.object(at: (indexPath?.row)!) as! String)
                }else{
                    dictSelected.setValue("Intra Op", forKey: arrPharmacy.object(at: (indexPath?.row)!) as! String)
                    arrSelected.add(arrPharmacy.object(at: (indexPath?.row)!) as! String)
                    cell.btnSelect.isSelected = true
                    cell.btnUnSelect.isSelected = false
                }
            }else{
                
                if dictSelected.object(forKey: arrPharmacy.object(at: (indexPath?.row)!) as! String) as? String == "Post Op"
                {
                    dictSelected.setValue(" ", forKey: arrPharmacy.object(at: (indexPath?.row)!) as! String)
                    arrSelected.remove(arrPharmacy.object(at: (indexPath?.row)!) as! String)
                    cell.btnSelect.isSelected = false
                    cell.btnUnSelect.isSelected = false
                }else{
                    dictSelected.setValue("Post Op", forKey: arrPharmacy.object(at: (indexPath?.row)!) as! String)
                    arrSelected.add(arrPharmacy.object(at: (indexPath?.row)!) as! String)
                    cell.btnSelect.isSelected = false
                    cell.btnUnSelect.isSelected = true
                }
                
            }
            
        }
        

    }
    
    
    //QIService webservice
    func QIServiceRegional(dict:NSDictionary)
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
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPharmacy.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tblPharmacy.dequeueReusableCell(withIdentifier: "QIMultiCell") as? QIMultiCell
        
        if cell == nil {
            cell = QIMultiCell(style: UITableViewCellStyle.value1, reuseIdentifier: "QIMultiCell")
        }
        cell?.lblTitle.text              = (arrPharmacy.object(at: indexPath.row) as! NSString) as String
         cell!.lblTitle.font             = font_bold_medium       
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
        viewHeader.frame                = CGRect(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT*0.001)
        let lblline                     = UILabel(frame:viewHeader.bounds)
        lblline.backgroundColor         = UIColor.lightGray
        viewHeader.addSubview(lblline)
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SCREEN_HEIGHT*0.001
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
