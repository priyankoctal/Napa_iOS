//
//  NPAirwaysVC.swift
//  NAPA BILLING
//
//  Created by Admin on 02/05/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire

class NPAirwaysVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var arrAirway:NSArray!
    var arrRespiratory:NSArray!
    var dictSelected:NSMutableDictionary!
    var arrResposSelected:NSMutableArray!
    var arrAirwaySelected:NSMutableArray!
    @IBOutlet var lblIntra: UILabel!
    @IBOutlet var lblPost: UILabel!
    @IBOutlet var tblAirway: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dictSelected                = NSMutableDictionary()
        arrResposSelected           = NSMutableArray()
        arrAirwaySelected           = NSMutableArray()
        arrAirway                   = ["Planned use of difficult airway equipment","Unplanned use of difficult airway equipment","Unable to intubate","Surgical airway required"]
        arrRespiratory               = ["Aspiration","Laryngospasm with intervention","Bronchospasm with intervention","Non-dental upper airway trauma","Pulmonary edema","Pulmonary embolus","Air embolus","Unplanned (re)intubation","Post-Op mechanical ventilation","Narcan given"]
        
        tblAirway.register(UINib(nibName: "QISingleSelcetionCell", bundle: nil), forCellReuseIdentifier: "QISingleSelcetionCell")
        tblAirway.register(UINib(nibName: "QIMultiCell", bundle: nil), forCellReuseIdentifier: "QIMultiCell")
        tblAirway.allowsSelection   = false
        tblAirway.tableFooterView   = UIView()
        tblAirway.estimatedRowHeight = UITableViewAutomaticDimension
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

            
            for i in 0 ..< self.arrAirwaySelected.count
            {
              
                dictSlectedQI.setValue(self.dictSelected.value(forKey: self.arrAirwaySelected.object(at: i) as! String) as! String, forKey: "\(self.arrAirwaySelected.object(at: i) as! String)")
                     }
            
            for i in 0 ..< self.arrResposSelected.count
            {
                
              dictSlectedQI.setValue(self.dictSelected.value(forKey: self.arrResposSelected.object(at: i) as! String) as! String, forKey: "\(self.arrResposSelected.object(at: i) as! String)")
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
        
        let buttonPosition      = sender.convert(CGPoint.zero, to: self.tblAirway)
        let indexPath           = self.tblAirway.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            
                 if indexPath?.section == 0
                       {
                                let cell = tblAirway.cellForRow(at: indexPath!) as! QISingleSelcetionCell
                               if cell.btnSelect == sender
                               {
                                if dictSelected.object(forKey: arrAirway.object(at: (indexPath?.row)!) as! String) as? String == "Intra Op"
                                {
                                    
                                dictSelected.setValue(" ", forKey: arrAirway.object(at: (indexPath?.row)!) as! String)
                                cell.btnSelect.isSelected = false
                                    arrAirwaySelected.remove(arrAirway.object(at: (indexPath?.row)!) as! String)
                                }else{
                                    dictSelected.setValue("Intra Op", forKey: arrAirway.object(at: (indexPath?.row)!) as! String)
                                    arrAirwaySelected.add(arrAirway.object(at: (indexPath?.row)!) as! String)
                                    cell.btnSelect.isSelected = true
                                }
                                }
                        }
                       else{
                                let cell = tblAirway.cellForRow(at: indexPath!) as! QIMultiCell
                        if cell.btnSelect == sender
                        {
                         
                                if dictSelected.object(forKey: arrRespiratory.object(at: (indexPath?.row)!) as! String) as? String == "Intra Op"
                                {
                                    dictSelected.setValue(" ", forKey: arrRespiratory.object(at: (indexPath?.row)!) as! String)
                                    cell.btnSelect.isSelected = false
                                     cell.btnUnSelect.isSelected = false
                                     arrResposSelected.remove(arrRespiratory.object(at: (indexPath?.row)!) as! String)
                                }else{
                                    dictSelected.setValue("Intra Op", forKey: arrRespiratory.object(at: (indexPath?.row)!) as! String)
                                    arrResposSelected.add(arrRespiratory.object(at: (indexPath?.row)!) as! String)
                                    cell.btnSelect.isSelected = true
                                    cell.btnUnSelect.isSelected = false
                                }
                          }else{
                            
                                if dictSelected.object(forKey: arrRespiratory.object(at: (indexPath?.row)!) as! String) as? String == "Post Op"
                                {
                                    dictSelected.setValue(" ", forKey: arrRespiratory.object(at: (indexPath?.row)!) as! String)
                                    arrResposSelected.remove(arrRespiratory.object(at: (indexPath?.row)!) as! String)
                                    cell.btnSelect.isSelected = false
                                    cell.btnUnSelect.isSelected = false
                                }else{
                                    dictSelected.setValue("Post Op", forKey: arrRespiratory.object(at: (indexPath?.row)!) as! String)
                                    arrResposSelected.add(arrRespiratory.object(at: (indexPath?.row)!) as! String)
                                    cell.btnSelect.isSelected = false
                                     cell.btnUnSelect.isSelected = true
                                }
                            
                            }
                        }
            
            }
            
        
    }
    
    
    //MARK: tableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrAirway.count
        }else{
            return arrRespiratory.count
        }
       
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            var cell = tblAirway.dequeueReusableCell(withIdentifier: "QISingleSelcetionCell") as? QISingleSelcetionCell
            
            if cell == nil {
                cell = QISingleSelcetionCell(style: UITableViewCellStyle.value1, reuseIdentifier: "QISingleSelcetionCell")
            }
            cell?.lblTitle.text              = (arrAirway.object(at: indexPath.row) as! NSString) as String
            if indexPath.row<2 {
                  cell!.lblTitle.font        = font_bold_medium
            }else{
                  cell!.lblTitle.font              = font_Regular_medium
            }
            cell?.lblTitle.textColor         = UIColor.darkText
            cell?.lblTitle.textAlignment     = NSTextAlignment.center
            cell?.btnSelect.tag              =  indexPath.row
            cell?.btnSelect.addTarget(self, action: #selector(self.btnEnableTapped(_:)), for: UIControlEvents.touchUpInside)
            
            //  cell?.accessoryType               = UITableViewCellAccessoryType.disclosureIndicator
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset              = UIEdgeInsets.zero
            cell?.layoutMargins               = UIEdgeInsets.zero
            return cell!
        }else{
            var cell = tblAirway.dequeueReusableCell(withIdentifier: "QIMultiCell") as? QIMultiCell
            
            if cell == nil {
                cell = QIMultiCell(style: UITableViewCellStyle.value1, reuseIdentifier: "QIMultiCell")
            }
            cell?.lblTitle.text              = (arrRespiratory.object(at: indexPath.row) as! NSString) as String
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
            lblHeader.text          = "Difficult Airway"
            lblHeader.font          = font_bold_large
            lblHeader.textColor     = UIColor.white
            viewHeader.addSubview(lblHeader)
            
            
        }else{
            
            let imgOther             = UIImageView(frame:CGRect(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT*0.07))
            imgOther.image           = UIImage(named:"strip")
            viewHeader.addSubview(imgOther)
            
            let lblHeader           = UILabel(frame:CGRect(x:15,y:0,width:SCREEN_WIDTH-25,height:SCREEN_HEIGHT*0.07))
            lblHeader.text          = "Respiratory"
            lblHeader.font          = font_bold_large
            lblHeader.textColor     = UIColor.white
            viewHeader.addSubview(lblHeader)
            
        }
        
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SCREEN_HEIGHT*0.07
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
