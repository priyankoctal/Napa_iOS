//
//  NPSpecialServicesVC.swift
//  NAPA BILLING
//
//  Created by Admin on 21/04/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire

class NPSpecialServicesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var arrInvasive:NSArray!
    var arrOther:NSArray!
    var arrSection:NSArray!
    var arrSelected:NSMutableArray      = NSMutableArray()
    @IBOutlet var tblInvasive: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrInvasive                   = ["Invasive Lines","Post-op Pain Blocks","Cardiac and TEE"]
        arrOther                      = ["One lung ventillation","Controlled hypotension","Special catheter for CSF drainage"]
        tblInvasive.register(UINib(nibName: "ReasonCell", bundle: nil), forCellReuseIdentifier: "ReasonCell")
        tblInvasive.delegate                = self
        tblInvasive.dataSource              = self
        tblInvasive.tableFooterView         = UIView()
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
            let dictInvasive = NSMutableDictionary()
            
            for i in 0 ..< self.arrSelected.count
            {
                
                dictInvasive.setValue("yes", forKey: "\(self.arrOther.object(at: self.arrSelected.object(at: i) as! Int) as! String)")
            }
            
             var dict        = NSMutableDictionary()
            let userID      = defaults.value(forKey: kAPP_UserId) as! String!
            dict            = ["user_id" : userID!,"charge_measures" :dictInvasive,"record_id":recordId]
            
            self.SaveInvasiveSpecialService(dict:dict)
            
            
        }
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnEditTapped(_ sender: UIButton) {
        let popOverVC         = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddPopUpVC") as! AddPopUpVC
        self.addChildViewController(popOverVC)
        popOverVC.view.frame  = self.view.frame
        popOverVC.strRecordId = recordId
        popOverVC.page        = "4"
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
 
    }
    
    
    //MARK: tableView Delegate
 

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrInvasive.count
        }else{
            return arrOther.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell                        = tblInvasive.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text            = arrInvasive.object(at: indexPath.row) as? String
            cell.textLabel?.font            = font_bold_list
            cell.textLabel?.textColor       = color_list_font
            cell.accessoryType              = UITableViewCellAccessoryType.disclosureIndicator
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset             = UIEdgeInsets.zero
            cell.layoutMargins              = UIEdgeInsets.zero
            return cell
        }else{
            var cell = tblInvasive.dequeueReusableCell(withIdentifier: "ReasonCell") as? ReasonCell
            
            if cell == nil {
                cell = ReasonCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ReasonCell")
            }
            cell?.lblReason.text              = (arrOther.object(at: indexPath.row) as! NSString) as String
            cell?.lblReason.font              = font_Regular_medium
            cell?.lblReason.textColor         = UIColor.darkText
            cell?.btnReason.tag               =  indexPath.row
            cell?.btnReason.addTarget(self, action: #selector(self.btnEnableTapped(_:)), for: UIControlEvents.touchUpInside)
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset              = UIEdgeInsets.zero
            cell?.layoutMargins               = UIEdgeInsets.zero
            return cell!
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
                if indexPath.row==0 {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "NPInvaishivLinesVC") as! NPInvaishivLinesVC
                    
                        self.navigationController?.pushViewController(vc, animated: true)
                }else if indexPath.row == 1
                {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "NPPostOPVC") as! NPPostOPVC
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if indexPath.row == 2
                {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "NPCardiacVC") as! NPCardiacVC
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
        }

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if indexPath.section == 0 {
            return SCREEN_HEIGHT*0.07
         }else{
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader                  = UIView()
        viewHeader.frame                = CGRect(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT*0.07)
        if section == 0 {
            
            let lblHeader               = UILabel(frame:CGRect(x:15,y:0,width:SCREEN_WIDTH-25,height:SCREEN_HEIGHT*0.07))
            lblHeader.text              = appDelegate.checkEmptyString(str: strPatientName as NSString?) as String
            lblHeader.textAlignment     =  NSTextAlignment.center
            lblHeader.font              = font_bold_Exlarge
            viewHeader.addSubview(lblHeader)
            let lblline                 = UILabel(frame: CGRect(x:0, y:SCREEN_HEIGHT*0.069, width:SCREEN_WIDTH, height:SCREEN_HEIGHT * 0.001))
            lblline.backgroundColor     = UIColor.lightGray
            viewHeader.addSubview(lblline)
            

        }else{

            let imgOther             = UIImageView(frame:CGRect(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT*0.07))
            imgOther.image           = UIImage(named:"strip")
            viewHeader.addSubview(imgOther)

            let lblHeader           = UILabel(frame:CGRect(x:15,y:0,width:SCREEN_WIDTH-25,height:SCREEN_HEIGHT*0.07))
            lblHeader.text          = "Other"
            lblHeader.font          = font_bold_large
            lblHeader.textColor     = UIColor.white
            viewHeader.addSubview(lblHeader)
            
        }
        
        return viewHeader
}
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SCREEN_HEIGHT*0.07
    }
    
    @IBAction func btnEnableTapped(_ sender: UIButton) {
        
        let buttonPosition      = sender.convert(CGPoint.zero, to: self.tblInvasive)
        let indexPath           = self.tblInvasive.indexPathForRow(at: buttonPosition)
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

    
    //MARK:SaveInvasiveService webservice
    func SaveInvasiveSpecialService(dict:NSDictionary)
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
