
//
//  NPHomeVC.swift
//  NAPA BILLING
//
//  Created by Admin on 17/04/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire
var recordId:String!
var strPatientName:String!

class NPHomeVC: UIViewController ,UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate,UITextFieldDelegate{
   
    @IBOutlet var txtLocation: UITextField!    
    @IBOutlet var img3: UIImageView!
    @IBOutlet var img2: UIImageView!
    @IBOutlet var img1: UIImageView!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var btnPrevious: UIButton!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var tblPatient: UITableView!
    var activeField: UITextField?
    var count:Int = 0
    var currentDate:NSString!
    var todayDate = Date()
    var formatter:DateFormatter = DateFormatter()
    var formatter1:DateFormatter = DateFormatter()
    var userID:String!
    @IBOutlet var viewBottomConstent: NSLayoutConstraint!
    var arrTemp:NSArray!
    var dictPatient:NSDictionary!
    var is_searching:Bool!
    var isCharacterTyping:Bool!
    var arrSearchTemp:NSMutableArray!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        is_searching                        = false
        arrSearchTemp                       = NSMutableArray()
       
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"nav.png"), for: UIBarMetrics.default)
        userID                              = defaults.value(forKey: kAPP_UserId) as! String!
        arrTemp                              = NSMutableArray()
        formatter.dateFormat                = "MMMM dd, yyyy"
        formatter1.dateFormat               = "yyyy-MM-dd"
        let currentDate                     = formatter.string(from: todayDate as Date)
        lblDate.text                        = currentDate
        img2.image                          = UIImage(named:"nav_Select")
        count                               = 0
      
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: txtLocation.frame.size.height))
        let imgView = UIImageView(frame:CGRect(x: 5, y: txtLocation.frame.size.height/2 - 12, width: 18, height: 24))
        imgView.image = UIImage.init(named: "location")
        paddingView.addSubview(imgView)
        txtLocation.leftView                = paddingView
        txtLocation.leftViewMode            = .always
        txtLocation.autocorrectionType      = UITextAutocorrectionType.no
        obj.roundedTextField(txtLocation)
        txtLocation.font                    =  font_Regular_medium
        txtLocation.delegate                = self
        txtLocation.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        tblPatient.tableFooterView          = UIView(frame: CGRect.zero)
        tblPatient.separatorInset           = UIEdgeInsets.zero

                // Do any additional setup after loading the view.
    }
    
    //MARK: methods.....
    @IBAction func btnNextTapped(_ sender: UIButton) {
        if count <= 0 {
             count += 1
            todayDate                           = Calendar.current.date(byAdding: .day, value: 1, to: todayDate as Date)!
            formatter.dateFormat                = "MMMM dd, yyyy"
            let currentDate                     = formatter.string(from: todayDate as Date)
            lblDate.text                        = currentDate
            self.dateProgress(countDate: count)
        }
       
        
    }
    
    
    @IBAction func btnPreviousTapped(_ sender: UIButton) {
        if count >= 0 {
            count -= 1
            todayDate                           = Calendar.current.date(byAdding: .day, value: -1, to: todayDate as Date)!
            formatter.dateFormat                = "MMMM dd, yyyy"
            let currentDate                     = formatter.string(from: todayDate as Date)
            lblDate.text                        = currentDate
            self.dateProgress(countDate: count)
        }
    }
    
    @IBAction func btnAddTapped(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc          = storyBoard.instantiateViewController(withIdentifier: "NPAddPatientVC") as! NPAddPatientVC
        //vc.strRecordId  = recordId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func dateProgress(countDate:Int){
        if countDate == -1 {
            img1.image                          = UIImage(named:"nav_Select")
            img2.image                          = UIImage(named:"nav_unselect")
            img3.image                          = UIImage(named:"nav_unselect")

        }else if countDate == 0
        {
            img1.image                          = UIImage(named:"nav_unselect")
            img2.image                          = UIImage(named:"nav_Select")
            img3.image                          = UIImage(named:"nav_unselect")

        }else{
            img1.image                          = UIImage(named:"nav_unselect")
            img2.image                          = UIImage(named:"nav_unselect")
            img3.image                          = UIImage(named:"nav_Select")
        }
            let strDate              = self.formatter1.string(from: todayDate)
            self.arrTemp             = self.dictPatient.object(forKey: strDate) as! NSArray!
            self.tblPatient.reloadData()
    }
    
  
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        txtLocation.resignFirstResponder()
        removeKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        userID      = defaults.value(forKey: kAPP_UserId) as! String!
        if userID != nil
        {
            PostData    = ["user_id":userID]
            PatientList(dict: PostData as NSDictionary)
        }
        registerForKeyboardNotifications()
    }
 //MARK:tableview delegate....
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if is_searching == true {
            return arrSearchTemp.count
        }else{
            return arrTemp.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let reuseIdentifier     = "prototypeCell"
        let cell                = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MGSwipeTableCell
        cell.tag                = indexPath.row
        
         var arrPatient:NSArray!
         if is_searching == true {
            arrPatient          = arrSearchTemp as NSArray
         }else{
            arrPatient          = arrTemp
        }
        
        let lblName             = cell.contentView.viewWithTag(1) as! UILabel
        let strName             = (arrPatient.value(forKey: "name") as AnyObject).object(at: indexPath.row) as! String
        lblName.text           = appDelegate.checkEmptyString(str: strName as NSString?) as String
        lblName.font           = font_bold_large
        let btnChargeAdded      = cell.contentView.viewWithTag(2) as! UIButton
        let btnQIAdded          = cell.contentView.viewWithTag(3) as! UIButton
        let btnImagesAdded      = cell.contentView.viewWithTag(4) as! UIButton

        let arrImages:NSMutableArray! = NSMutableArray()
  
        let strTotalImages      = (arrPatient.value(forKey: "totalImages") as AnyObject).object(at: indexPath.row) as! String
 
        
        let strQI               = (arrPatient.value(forKey: "is_qi") as AnyObject).object(at: indexPath.row) as! String
        
        if Int(strQI)! > 0{
               arrImages.add("chargecircle")
        }
        
        let strCharge           = (arrPatient.value(forKey: "is_charged") as AnyObject).object(at: indexPath.row) as! String
        if Int(strCharge)! > 0{
            arrImages.add("qicircle")
        }
        
        if Int(strTotalImages)! > 0{
            
            arrImages.add("cameracircle")
        }
        
        

        cell.delegate           = self //optional
        let status              = (arrPatient.value(forKey: "status") as AnyObject).object(at: indexPath.row) as! String
        
        if status == "6"
        {
            let btnReopen = MGSwipeButton(title: "Reopen", icon: UIImage(named:"reopen.png"), backgroundColor: UIColor(red:66.0/255.0, green: 196.0/255.0, blue: 112.0/255.0, alpha: 1.0))
            btnReopen.centerIconOverText()
            btnReopen.buttonWidth = SCREEN_WIDTH*0.24
            btnReopen.titleLabel?.font = font_Regular_small
            //configure left buttons
            cell.leftButtons = [btnReopen]
          
        }else{
            
            let btncancel = MGSwipeButton(title: "Cancel", icon: UIImage(named:"cancel.png"), backgroundColor: UIColor(red:240.0/255.0, green: 52.0/255.0, blue: 68.0/255.0, alpha: 1.0))
            btncancel.centerIconOverText()
            btncancel.titleLabel?.font = font_Regular_small
            btncancel.buttonWidth = SCREEN_WIDTH*0.24
            //configure left buttons
            cell.leftButtons = [btncancel]
        }
       
        cell.leftSwipeSettings.transition = .rotate3D
        
        let btncamera = MGSwipeButton(title: "Image", icon: UIImage(named:"camera.png"), backgroundColor: UIColor(red:230.0/255.0, green: 179.0/255.0, blue: 89.0/255.0, alpha: 1.0))
        btncamera.centerIconOverText()
        btncamera.buttonWidth  =  SCREEN_WIDTH*0.23
        let btnQI     = MGSwipeButton(title: "QI", icon: UIImage(named:"ai.png"), backgroundColor:UIColor(red: 103.0/255.0, green: 154.0/255.0, blue: 207.0/255.0, alpha: 1.0))
         btnQI.titleLabel?.font = font_Regular_small
         btnQI.centerIconOverText()
         btnQI.buttonWidth  =  SCREEN_WIDTH*0.22
        
        let btnCharge = MGSwipeButton(title: "Charge", icon: UIImage(named:"charge.png"), backgroundColor: UIColor(red:133.0/255.0, green: 174.0/255.0, blue: 211.0/255.0, alpha: 1.0))
        btnCharge.centerIconOverText()
        btnCharge.titleLabel?.font = font_Regular_small
        btnCharge.buttonWidth  =  SCREEN_WIDTH*0.24        //configure right buttons
        cell.rightButtons = [btncamera,btnQI,btnCharge]
        cell.rightSwipeSettings.transition = .rotate3D
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
  
        if arrImages.count>0 {
             lblName.frame              = CGRect(x:SCREEN_WIDTH*0.10, y:10, width:SCREEN_WIDTH*0.80, height:(lblName.frame.size.height))
        for i in 0 ..< arrImages.count
            {
           if i == 0
           {
            btnChargeAdded.isHidden = false
             btnChargeAdded.setImage(UIImage(named:arrImages.object(at: i) as! String), for: UIControlState.normal)
            
           }
            if i == 1 {
            btnQIAdded.isHidden = false
            btnQIAdded.setImage(UIImage(named:arrImages.object(at: i) as! String), for: UIControlState.normal)
           }
            if i == 2 {
            btnImagesAdded.isHidden = false
            btnImagesAdded.setImage(UIImage(named:arrImages.object(at: i) as! String), for: UIControlState.normal)

            }
            }
        }else{
            btnChargeAdded.isHidden = true
            btnQIAdded.isHidden = true
            btnImagesAdded.isHidden = true
            lblName.frame              = CGRect(x:SCREEN_WIDTH*0.10, y:cell.frame.size.height/2-(lblName.frame.size.height)/2, width:SCREEN_WIDTH*0.80, height:(lblName.frame.size.height))
        }
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset              = UIEdgeInsets.zero
        cell.layoutMargins               = UIEdgeInsets.zero
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "NPPatientDetailVC") as! NPPatientDetailVC
        var arrPatient:NSArray!
        if is_searching == true {
            arrPatient = arrSearchTemp as NSArray
        }else{
            arrPatient = arrTemp
        }
        recordId        = (arrPatient.value(forKey: "id") as AnyObject).object(at: indexPath.row) as! String
        strPatientName  = (arrPatient.value(forKey: "name") as AnyObject).object(at: indexPath.row) as! String
        vc.dictPatient  = arrTemp.object(at: indexPath.row) as! NSDictionary
        self.navigationController?.pushViewController(vc, animated: true)
       // self.performSegue(withIdentifier: "detail", sender: nil)
        
    }
    
    
    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        
        var arrPatient:NSArray!
        if is_searching == true {
            arrPatient = arrSearchTemp as NSArray
        }else{
            arrPatient = arrTemp
        }
         recordId           = (arrPatient.value(forKey: "id") as AnyObject).object(at: cell.tag) as! String
         strPatientName     = (arrPatient.value(forKey: "name") as AnyObject).object(at: cell.tag) as! String
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        if direction.rawValue == 0 {

            let status = (arrPatient.value(forKey: "status") as AnyObject).object(at: cell.tag) as! String
            
            if status == "6"
            {
                let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to reopen?" as String?, preferredStyle: .alert)
                
                let noAction = UIAlertAction(title: "No", style: .default) { (action) -> Void in
                    
                }
                
                let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) -> Void in
                    
                    var  dictReopen = [String: String]()
                    dictReopen    = ["user_id":self.userID!,"record_id":recordId]
                    self.ReopenCase(dict: dictReopen as NSDictionary)
                }
                
                alertController.addAction(noAction)
                alertController.addAction(yesAction)
                self.present(alertController, animated: true, completion: nil)
             
               
            }else{
                
                let vc          = storyBoard.instantiateViewController(withIdentifier: "NPCancelCaseVC") as! NPCancelCaseVC
                vc.strRecordId   = recordId
                self.navigationController?.pushViewController(vc, animated: true)
               
            }
           
        }else{
            if index == 0 {
                let strTotalImages       = (arrPatient.value(forKey: "totalImages") as AnyObject).object(at: cell.tag) as! String
                let vc:UIViewController!
                if Int(strTotalImages) == 0{
                    vc = storyBoard.instantiateViewController(withIdentifier: "NPTakePicVC") as! NPTakePicVC
                }else{
                    vc = storyBoard.instantiateViewController(withIdentifier: "NPImagesVC") as! NPImagesVC
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if index == 1 {
                 let vc = storyBoard.instantiateViewController(withIdentifier: "NPQIVC") as! NPQIVC
                self.navigationController?.pushViewController(vc, animated: true)
            }else if index == 2 {
                 let vc = storyBoard.instantiateViewController(withIdentifier: "NPChargeVC") as! NPChargeVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        return true
    }
    
    //MARK: textfield delegate.....
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField .resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text!.isEmpty{
            is_searching = false
            tblPatient.reloadData()
        } else
        {
            
            is_searching = true
            
            arrSearchTemp.removeAllObjects()
            UnloadArraysOnEachCharacterType()
            
            // search according subject.....
            for i in 0..<arrTemp.count {
                
                let strTitle                    = (arrTemp[i] as AnyObject).value(forKey: "location_name") as! String
                
                    // var s = CharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
                
 //               let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789")
//                if txtLocation.rangeOfCharacter(from: characterset.inverted) == nil {
//                    print("string contains special characters")
                
                    if (strTitle as NSString).range(of: txtLocation.text!, options: .caseInsensitive).location != NSNotFound {
                        arrSearchTemp.add(arrTemp[i])
                    }
                }
                
                
            }
        self.tblPatient.reloadData()
    }


func UnloadArraysOnEachCharacterType(){
    arrSearchTemp.removeAllObjects()
    isCharacterTyping = true
}

func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
}
    
func removeKeyboardNotifications() {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    }
    
    
func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
         //  if self.view.frame.origin.y == 0{
                viewBottomConstent.constant = keyboardSize.height
           // }
        }
        
}
    
func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
          //  if self.view.frame.origin.y != 0{
                viewBottomConstent.constant = 0
          //  }
        }
}
    
    
//MARK:Patient list webservice
func PatientList(dict:NSDictionary)
    {
        obj.ShowHud()
        
        Alamofire.request("\(web_SERWERURL)\(PatintListUrl)", method: .post, parameters:dict as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            print(response.request ?? "")
            switch(response.result) {
            case .success(_):
                if response.result.value != nil
                {
                    
                    print(response.result.value!)
                    let JSON        = response.result.value! as AnyObject
                    let response    = JSON["response"] as! NSDictionary
                    let status      = response.value(forKey: "status")
                    let message     = response.value(forKey: "message") as? String
                    if (status as AnyObject).doubleValue == 1
                    {
                       
                        self.dictPatient        = response.value(forKey:"Data") as! NSDictionary
                        let strDate              = self.formatter1.string(from: self.todayDate)
                        self.arrTemp             = self.dictPatient.object(forKey: strDate) as! NSArray!
                        self.tblPatient.dataSource               = self
                        self.tblPatient.delegate                 = self
                        self.tblPatient.reloadData()
                        obj.HideHud()
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
    
//MARK:ReopenCase webservice
func ReopenCase(dict:NSDictionary)
    {
        obj.ShowHud()
        
        Alamofire.request("\(web_SERWERURL)\(reopenUrl)", method: .post, parameters:dict as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
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
                        
                         self.PatientList(dict:PostData as NSDictionary)
                        
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
    
   

    
    
    
//    func keyboardWillShow(aNotification: NSNotification) {
//      //  let info = aNotification.userInfo as! [String: AnyObject],
//       // kbSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size,
//        self.viewBottomConstent.constant = 264.0
////        contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
////        
////        self.tblPatient.contentInset = contentInsets
////        self.tblPatient.scrollIndicatorInsets = contentInsets
////        
////        // If active text field is hidden by keyboard, scroll it so it's visible
////        // Your app might not need or want this behavior.
////        var aRect = self.view.frame
////        aRect.size.height -= kbSize.height
////        
////        if !aRect.contains(activeField!.frame.origin) {
////            self.tblPatient.scrollRectToVisible(activeField!.frame, animated: true)
////        }
//    }
//    
//    func keyboardWillHide(aNotification: NSNotification) {
//        self.viewBottomConstent.constant = 0
////        let contentInsets = UIEdgeInsets.zero
////        self.tblPatient.contentInset = contentInsets
////        self.tblPatient.scrollIndicatorInsets = contentInsets
//    }
//    
    
    
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
