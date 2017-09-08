//
//  NPPostOPVC.swift
//  NAPA BILLING
//
//  Created by Admin on 25/04/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire

class NPPostOPVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var arrPostOp:NSArray!
    var tblInsertation:UITableView!
    var arrSelected:NSMutableArray      = NSMutableArray()
    var txtPreStartTime:UITextField!    = UITextField()
    var txtPreEndTime:UITextField!      = UITextField()
    var btnPreStartTime:UIButton!       = UIButton()
    var btnPreEndTime:UIButton!         = UIButton()
    
    
    @IBOutlet var TpScrollView: TPKeyboardAvoidingScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrPostOp   = ["Prep area","In OR prior to induction","In OR after induction","Unilateral","Bilateral","Ultrasound guided","Continuous catheter","Single shot","Image saved","Lower Extremity","Upper Extremity","Neuraxial","Chest and Abdomen"];
        setPostOpBlocksView()
        // Do any additional setup after loading the view.
    }
    
    //MARK: setInavsivelinesView
    func setPostOpBlocksView(){
        var top                     = 0.0 as CGFloat
        let gap                     = SCREEN_HEIGHT*0.02 as CGFloat
        
        let lblName            = UILabel(frame:CGRect(x:10,y:top,width:SCREEN_WIDTH-20,height:SCREEN_HEIGHT*0.07))
        lblName.text           = appDelegate.checkEmptyString(str: strPatientName as NSString?) as String
        lblName.textColor      = UIColor.darkText
        lblName.textAlignment  =  NSTextAlignment.center
        lblName.font           = font_bold_Exlarge
        TpScrollView.addSubview(lblName)
        
        top                         += lblName.frame.size.height + gap/2
        
        let lblline            = UILabel(frame: CGRect(x:0,y:top, width:SCREEN_WIDTH, height:SCREEN_HEIGHT*0.001))
        lblline.backgroundColor = UIColor.gray
        TpScrollView.addSubview(lblline)
        
        
        let lblProvider            = UILabel(frame:CGRect(x:10,y:top,width:SCREEN_WIDTH/2,height:SCREEN_HEIGHT*0.07))
        lblProvider.text           = "Provider"
        lblProvider.textColor      = color_list_font
        lblProvider.textAlignment  = NSTextAlignment.left
        lblProvider.font           = font_bold_list
        TpScrollView.addSubview(lblProvider)
        
        let lblProviderName            = UILabel(frame:CGRect(x:SCREEN_WIDTH/2,y:top,width:SCREEN_WIDTH/2-10,height:SCREEN_HEIGHT*0.07))
        lblProviderName.text           = ""
        lblProviderName.textColor      = color_blue
        lblProviderName.textAlignment  = NSTextAlignment.right
        lblProviderName.font           = font_reguler_list
        TpScrollView.addSubview(lblProviderName)
        
        top                     += lblProviderName.frame.size.height + gap/2
        
        
        let imgInsertation            = UIImageView(frame:CGRect(x:0,y:top,width:SCREEN_WIDTH,height:SCREEN_HEIGHT*0.07))
        imgInsertation.image          = UIImage(named:"strip")
        TpScrollView.addSubview(imgInsertation)
        
        let lblInsertation            = UILabel(frame:CGRect(x:10,y:top,width:SCREEN_WIDTH-20,height:SCREEN_HEIGHT*0.07))
        lblInsertation.text           = "Insertion"
        lblInsertation.textColor      = UIColor.white
        lblInsertation.font           = font_bold_large
        TpScrollView.addSubview(lblInsertation)
        
        top                          += imgInsertation.frame.size.height + gap
        
        
        let lblStart                  = UILabel(frame:CGRect(x:10,y:top,width:SCREEN_WIDTH*0.25,height:SCREEN_HEIGHT*0.05))
        lblStart.text                 = "Start Time"
        lblStart.textColor            = color_list_font
        lblStart.font                 = font_Regular_medium
        TpScrollView.addSubview(lblStart)
        lblStart.sizeToFit()
        
        txtPreStartTime                 = UITextField(frame:CGRect(x:lblStart.frame.size.width+20,y:top,width:SCREEN_WIDTH*0.20,height:SCREEN_HEIGHT*0.05))
        txtPreStartTime.layer.cornerRadius  = SCREEN_HEIGHT*0.002
        txtPreStartTime.layer.borderWidth   = SCREEN_HEIGHT*0.001
        txtPreStartTime.layer.borderColor   = UIColor.lightGray.cgColor
        txtPreStartTime.font                = font_Regular_medium
        TpScrollView.addSubview(txtPreStartTime)
        
        btnPreStartTime.removeFromSuperview()
        btnPreStartTime                     = UIButton()
        btnPreStartTime.frame               = txtPreStartTime.frame
        btnPreStartTime.addTarget(self, action: #selector(PreStartTimeTapped(_:)), for: UIControlEvents.touchUpInside)
        TpScrollView.addSubview(btnPreStartTime)
        
        let lblEnd                      = UILabel(frame:CGRect(x:txtPreStartTime.frame.origin.x+txtPreStartTime.frame.size.width+5,y:top,width:SCREEN_WIDTH*0.22,height:SCREEN_HEIGHT*0.05))
        lblEnd.text               = "End Time"
        lblEnd.textColor          = color_list_font
        lblEnd.font               = font_Regular_medium
        TpScrollView.addSubview(lblEnd)
        lblEnd.sizeToFit()
        
        txtPreEndTime         = UITextField(frame:CGRect(x:lblEnd.frame.origin.x+lblEnd.frame.size.width+5,y:top,width:SCREEN_WIDTH*0.20,height:SCREEN_HEIGHT*0.05))
        txtPreEndTime.layer.cornerRadius = SCREEN_HEIGHT*0.002
        txtPreEndTime.layer.borderWidth = SCREEN_HEIGHT*0.001
        txtPreEndTime.layer.borderColor = UIColor.lightGray.cgColor
        txtPreEndTime.font               = font_Regular_medium
        TpScrollView.addSubview(txtPreEndTime)

        btnPreEndTime.removeFromSuperview()
        btnPreEndTime                     = UIButton()
        btnPreEndTime.frame               = txtPreEndTime.frame
        btnPreEndTime.addTarget(self, action: #selector(PreEndTimeTapped(_:)), for: UIControlEvents.touchUpInside)
        TpScrollView.addSubview(btnPreEndTime)
        
        top                             += lblStart.frame.size.height+gap
        
        tblInsertation        = UITableView(frame:CGRect(x:0,y:top,width:SCREEN_WIDTH, height: CGFloat(44 * arrPostOp.count)))
        tblInsertation.register(UINib(nibName: "ReasonCell", bundle: nil), forCellReuseIdentifier: "ReasonCell")
        tblInsertation.delegate = self;
        tblInsertation.dataSource = self
        tblInsertation.tableFooterView = UIView()
        //        tblInsertation.allowsSelection = false
        
        TpScrollView.addSubview(tblInsertation)
        
        top                     += tblInsertation.frame.size.height + gap
        
        TpScrollView.contentSize = CGSize(width:SCREEN_WIDTH,height:top)
        
        
    }
    
    
    //MARK: methods.....
    @IBAction func btnBackTapped(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to save?" as String?, preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "No", style: .default) { (action) -> Void in
            self.navigationController!.popViewController(animated: true)
        }
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) -> Void in
        
            let dictPostOP = NSMutableDictionary()
            
            for i in 0 ..< self.arrSelected.count
            {
                
                dictPostOP.setValue("yes", forKey: "\(self.arrPostOp.object(at: self.arrSelected.object(at: i) as! Int) as! String)")
            }
            
            dictPostOP.setValue(self.txtPreStartTime.text, forKey: "Start Time")
            dictPostOP.setValue(self.txtPreEndTime.text, forKey: "End Time")
            dictPostOP.setValue("", forKey: "postop_pain_block_provider")
        
            var dict        = NSMutableDictionary()
            let userID      = defaults.value(forKey: kAPP_UserId) as! String!
            dict            = ["user_id" : userID!,"charge_measures" :dictPostOP,"record_id":recordId]
            
            self.SavePostOpService(dict:dict)
            
            
        }
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

    
    func PreStartTimeTapped(_ textField: UITextField) {
        txtPreStartTime.resignFirstResponder()
        
        DatePickerDialog().show("Select Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate:NSDate() as Date , maximumDate:nil , datePickerMode: .time) { (date) in
            if let dt = date {
                //Convert string to date object
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                let strDate = formatter.string(from: dt) as String
                self.txtPreStartTime.text = "\(strDate)"
                self.txtPreStartTime.resignFirstResponder()
            }
        }
    }
    
    func PreEndTimeTapped(_ textField: UITextField) {
        txtPreEndTime.resignFirstResponder()
        
        DatePickerDialog().show("Select Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate:NSDate() as Date , maximumDate:nil , datePickerMode: .time)  { (date) in
            if let dt = date {
                //Convert string to date object
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                let strDate = formatter.string(from: dt) as String
                self.txtPreEndTime.text = "\(strDate)"
                self.txtPreEndTime.resignFirstResponder()
            }
        }
    }
    
    
    //SavePostOpService webservice
    func SavePostOpService(dict:NSDictionary)
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

    
    
    @IBAction func btnEditTapped(_ sender: UIButton) {
        let popOverVC         = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddPopUpVC") as! AddPopUpVC
        self.addChildViewController(popOverVC)
        popOverVC.view.frame  = self.view.frame
        popOverVC.strRecordId = recordId
        popOverVC.page        = "6"
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    @IBAction func btnEnableTapped(_ sender: UIButton) {
        
        let buttonPosition      = sender.convert(CGPoint.zero, to: self.tblInsertation)
        let indexPath           = self.tblInsertation.indexPathForRow(at: buttonPosition)
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
    
    
    //MARK: tableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrPostOp.count
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tblInsertation.dequeueReusableCell(withIdentifier: "ReasonCell") as? ReasonCell
        
        if cell == nil {
            cell = ReasonCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ReasonCell")
        }
        cell?.lblReason.text              = (arrPostOp.object(at: indexPath.row) as! NSString) as String
        cell!.lblReason.font              = font_Regular_medium
        cell?.lblReason.textColor         = UIColor.darkText
        cell?.btnReason.tag               =  indexPath.row
        cell?.btnReason.addTarget(self, action: #selector(self.btnEnableTapped(_:)), for: UIControlEvents.touchUpInside)
        //  cell?.accessoryType               = UITableViewCellAccessoryType.disclosureIndicator
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset              = UIEdgeInsets.zero
        cell?.layoutMargins               = UIEdgeInsets.zero
        
        if(indexPath.row == 2) {
            let bottomBorder = CALayer()
            bottomBorder.backgroundColor = UIColor.black.cgColor
            bottomBorder.frame = CGRect(x:0,y:(cell?.frame.size.height)! - 2, width:SCREEN_WIDTH, height:2)
            cell?.layer.addSublayer(bottomBorder)
        }else if (indexPath.row == 8)
        {
            let bottomBorder = CALayer()
            bottomBorder.backgroundColor = UIColor.black.cgColor
            bottomBorder.frame = CGRect(x:0,y:(cell?.frame.size.height)! - 2, width:SCREEN_WIDTH, height:2)
            cell?.layer.addSublayer(bottomBorder)
        }
        
        if indexPath.row>8 {
            cell?.btnReason.isHidden        = true
            cell?.lblReason.isHidden        = true
            cell?.textLabel?.text           = (arrPostOp.object(at: indexPath.row) as! NSString) as String
            cell?.textLabel?.font            = font_bold_list
            cell?.textLabel?.textColor       = color_list_font
            cell?.accessoryType              = UITableViewCellAccessoryType.disclosureIndicator
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset             = UIEdgeInsets.zero
            cell?.layoutMargins              = UIEdgeInsets.zero
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row>8
        {
            let strCat      =   (arrPostOp.object(at: indexPath.row) as! NSString) as String
            if strCat == "Lower Extremity" {
                strviewType = "Lower Extremity"
                
            }else if strCat == "Upper Extremity" {
                strviewType = "Upper Extremity"
                
            }else if strCat == "Neuraxial" {
                strviewType = "Neuraxial"
                
            }else if strCat == "Chest and Abdomen" {
                strviewType = "Chest and Abdomen"
                
            }            
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "NPSubPostOpVC") as! NPSubPostOpVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
