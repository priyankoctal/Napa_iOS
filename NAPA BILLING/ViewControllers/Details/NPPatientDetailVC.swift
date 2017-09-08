//
//  NPPatientDetailVC.swift
//  NAPA BILLING
//
//  Created by Admin on 19/04/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class NPPatientDetailVC: UIViewController {
    @IBOutlet var btnCharge: UIButton!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDOB: UILabel!
    @IBOutlet var btnQI: UIButton!
    @IBOutlet var btnReopen: UIButton!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var lblDateService: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnCamera: UIButton!
    @IBOutlet var lblMRN: UILabel!
    @IBOutlet var lblMRNNo: UILabel!
    var dictPatient:NSDictionary!
    var strRecordId:String!
    var strTotalImages:String!

    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        strRecordId             = appDelegate.checkEmptyString(str: dictPatient.object(forKey: "id") as! NSString?) as String
        
        strTotalImages          = appDelegate.checkEmptyString(str: dictPatient.object(forKey: "totalImages") as! NSString?) as String
        
        lblName.font            = font_Regular
        
        let  name               = appDelegate.checkEmptyString(str: dictPatient.object(forKey: "name") as! NSString?) as String
        
        let myAttribute         = [ NSFontAttributeName: font_bold_large]
        let myName              = NSMutableAttributedString(string: name, attributes: myAttribute )
        
        if let gender = dictPatient.object(forKey: "gender") as? String {
            let strGeneder:String!
            if gender == "M" {
                strGeneder          = " (Male)"
            }else{
                strGeneder          = " (Female)"
            }
            let attrString          = NSAttributedString(string:strGeneder)
            myName.append(attrString)
        }
        
        let myRange             = NSRange(location: 0, length: name.characters.count) // range starting at location 17 with a lenth of 7: "Strings"
        myName.addAttribute(NSForegroundColorAttributeName, value: color_blue, range: myRange)
        
        lblName.attributedText  = myName
        
        lblDateService.sizeToFit()
        
        lblDOB.text            =  appDelegate.checkEmptyString(str: dictPatient.object(forKey: "dob") as! NSString?) as String
        lblDOB.textAlignment   = NSTextAlignment.left
        lblDate.text           =  appDelegate.checkEmptyString(str: dictPatient.object(forKey: "start_date") as! NSString?) as String
        lblDate.textAlignment   = NSTextAlignment.left
        
        let status              = appDelegate.checkEmptyString(str: dictPatient.object(forKey: "status") as! NSString?) as String
        
        if status != "6"{
           btnReopen.setImage(UIImage(named: "reopengrey.png"), for: UIControlState.normal)
           btnReopen.isUserInteractionEnabled = false
        }

        // Do any additional setup after loading the view.
    }
    
    //MARK:Methods...
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func btnEditTapped(_ sender: UIButton) {
        let popOverVC         = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddPopUpVC") as! AddPopUpVC
        self.addChildViewController(popOverVC)
        popOverVC.view.frame  = self.view.frame
        popOverVC.strRecordId = recordId
        popOverVC.page        = "1"
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }

    @IBAction func btnChargeTapped(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "NPChargeVC") as! NPChargeVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnQITapped(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc          = storyBoard.instantiateViewController(withIdentifier: "NPQIVC") as! NPQIVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnCameraTapped(_ sender: UIButton) {
        
        if  Int(strTotalImages)! > 0
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc          = storyBoard.instantiateViewController(withIdentifier: "NPImagesVC") as! NPImagesVC
            vc.strRecordId  = recordId
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc          = storyBoard.instantiateViewController(withIdentifier: "NPTakePicVC") as! NPTakePicVC
            vc.strRecordId  = recordId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
    }
    
    @IBAction func btnReopenTapped(_ sender: UIButton) {
        
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
