//
//  NPAddPatientVC.swift
//  NAPA BILLING
//
//  Created by Admin on 09/05/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire

class NPAddPatientVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var btnLocation: UIButton!
    @IBOutlet var btnGender: UIButton!
    @IBOutlet var txtDOB: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtStartDate: UITextField!
    var arrGender:NSArray!
    var arrLocatiion:NSArray!
    var strType:String!
    var strLocationId:String!
    var strStateId:String!
    var strGender:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.isHidden             = true
        toolBar.isHidden                = true
        arrGender                       = ["Male","Female"]
        txtFirstName.setLeftPaddingPoints(10)
        txtFirstName.font               = font_Regular
        obj.roundedTextField(txtFirstName)
        obj.roundedTextField(txtLastName)
        obj.roundedTextField(txtDOB)
        obj.roundedTextField(txtStartDate)
        txtLastName.setLeftPaddingPoints(10)
        txtLastName.font                = font_Regular
        
        txtDOB.setLeftPaddingPoints(10)
        txtDOB.font                     = font_Regular
        
        txtStartDate.setLeftPaddingPoints(10)
        txtStartDate.font                     = font_Regular
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtDOB.delegate = self
        txtStartDate.delegate = self
        
        obj.roundedButton(btnGender)
        obj.roundedButton(btnLocation)
        btnGender.layer.borderWidth     = 0.50
        btnGender.layer.borderColor     = UIColor.lightGray.cgColor
        btnGender.imageEdgeInsets       = UIEdgeInsetsMake(0, btnGender.frame.size.width, 0, 0)
        btnGender.titleEdgeInsets       = UIEdgeInsetsMake(0, -10, 0, 0)
        btnGender.titleLabel?.font      = font_Regular
        btnLocation.layer.borderWidth   = 0.50
        btnLocation.layer.borderColor   = UIColor.lightGray.cgColor
        btnLocation.imageEdgeInsets     = UIEdgeInsetsMake(0, btnLocation.frame.size.width, 0, 0)
        btnLocation.titleEdgeInsets     = UIEdgeInsetsMake(0, -10, 0, 0)
        btnLocation.titleLabel?.font    = font_Regular
        LocationList()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        txtFirstName.resignFirstResponder()
        txtLastName.resignFirstResponder()
        txtDOB.resignFirstResponder()
        txtStartDate.resignFirstResponder()
    }

  
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func btnGenderTapped(_ sender: UIButton) {
        strType = "gender"
        
        pickerView.isHidden = false
        toolBar.isHidden = false
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.reloadAllComponents()
    }
    
    
    @IBAction func btnDOBTapped(_ sender: UIButton) {
        txtFirstName.resignFirstResponder()
        txtLastName.resignFirstResponder()
        txtDOB.resignFirstResponder()
        txtStartDate.resignFirstResponder()
        DatePickerDialog().show("select date", doneButtonTitle: "done", cancelButtonTitle: "cancel", minimumDate: nil, maximumDate:NSDate() as Date , datePickerMode: .date) { (date) in
            if let dt = date {
                //Convert string to date object
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/dd/mm"
                let strDate = formatter.string(from: dt) as String
                self.txtDOB.text = "\(strDate)"
            }
        }

    }
    
    @IBAction func btnStartDateTapped(_ sender: UIButton) {
        txtFirstName.resignFirstResponder()
        txtLastName.resignFirstResponder()
        txtDOB.resignFirstResponder()
        txtStartDate.resignFirstResponder()
        DatePickerDialog().show("select date", doneButtonTitle: "done", cancelButtonTitle: "cancel", minimumDate:nil , maximumDate:NSDate() as Date , datePickerMode: .date) { (date) in
            if let dt = date {
                //Convert string to date object
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/dd/mm"
                let strDate = formatter.string(from: dt) as String
                self.txtStartDate.text = "\(strDate)"
            }
        }
    }
    
    @IBAction func btnLocationTapped(_ sender: UIButton) {
        txtFirstName.resignFirstResponder()
        txtLastName.resignFirstResponder()
        txtDOB.resignFirstResponder()
        txtStartDate.resignFirstResponder()
        strType             = "location"
        pickerView.isHidden = false
        toolBar.isHidden    = false
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.reloadAllComponents()
    }
    
    @IBAction func btnAddTapped(_ sender: UIButton) {
        
        if txtFirstName.text! .isEmpty
        {
            appDelegate.alertShow(_objVC: self, msgString: "Please enter first name")
        }
        else if (txtLastName.text!.isEmpty)        {
            appDelegate.alertShow(_objVC: self, msgString: "Please enter last name")
        }
        else if txtDOB.text! .isEmpty
        {
            appDelegate.alertShow(_objVC: self, msgString: "Please select DOB")
        }
        else if txtStartDate.text! .isEmpty
        {
            appDelegate.alertShow(_objVC: self, msgString: "Please select start date")
            
        }else if (btnGender.titleLabel?.text == "Gender")
        {
            appDelegate.alertShow(_objVC: self, msgString: "Please select gender")
            
        }else  if btnLocation.titleLabel?.text == "Location"
        {
            
            appDelegate.alertShow(_objVC: self, msgString: "Please select location")
        }
        else
        {
           if btnGender.titleLabel?.text == "Male"
           {
            strGender = "M"
           }else{
            strGender = "F"
            }
            var  dictAdd = [String: String]()
            let userID      = defaults.value(forKey: kAPP_UserId) as! String!
            dictAdd      = ["user_id":userID!,"location_id":strLocationId,"state_id":strStateId!,"fname":txtFirstName.text!,"lname":txtLastName.text!,"dob":txtDOB.text!,"start_date":txtStartDate.text!,"gender":strGender]
            
            AddPatientService(dict: dictAdd as NSDictionary)
            
        }

    }
    
    //MARK:PickerView Delegate.....
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if strType == "gender" {
        return arrGender.count
        }else{
          return arrLocatiion.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         if strType == "gender" {
            return arrGender.object(at: row) as? String
         }else{
           return (arrLocatiion.value(forKey: "name") as AnyObject).object(at:row) as? String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    @IBAction func DoneTapped(_ sender: UIBarButtonItem) {
        
        pickerView.isHidden = true
        toolBar.isHidden    = true
        if strType == "gender" {
            
          //  btnGender.titleLabel?.text = arrGender.object(at: pickerView.selectedRow(inComponent: 0)) as? String
            btnGender.setTitle(arrGender.object(at: pickerView.selectedRow(inComponent: 0)) as? String, for: .normal)
            
            
        }else if strType == "location" {
           // btnLocation.titleLabel?.text = (arrLocatiion.value(forKey: "name") as AnyObject).object(at: pickerView.selectedRow(inComponent: 0)) as? String
            
            btnLocation.setTitle((arrLocatiion.value(forKey: "name") as AnyObject).object(at: pickerView.selectedRow(inComponent: 0)) as? String, for: .normal)
            strLocationId                = (arrLocatiion.value(forKey: "id") as AnyObject).object(at: pickerView.selectedRow(inComponent: 0)) as? String
            strStateId                   = (arrLocatiion.value(forKey: "state_id") as AnyObject).object(at: pickerView.selectedRow(inComponent: 0)) as? String
            
        }
        
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        pickerView.isHidden = true
        toolBar.isHidden    = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        pickerView.isHidden = true;
        
    }
    
    //MARK:LocationList webservice
    func LocationList()
    {
       // obj.ShowHud()
        
        Alamofire.request("\(web_SERWERURL)\(locationUrl)", method: .post, parameters:nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            print(response.request ?? "")
            switch(response.result) {
            case .success(_):
                if response.result.value != nil
                {
                   // obj.HideHud()
                    print(response.result.value!)
                    let JSON        = response.result.value! as AnyObject
                    let response    = JSON["response"] as! NSDictionary
                    let status      = response.value(forKey: "status")
                    let message     = response.value(forKey: "message") as? String
                    if (status as AnyObject).doubleValue == 1
                    {
                         self.arrLocatiion        = response.value(forKey:"Data") as! NSArray
                       
                    }
                        
                    else
                    {
                        print("Fails")
                     //   obj.HideHud()
                        appDelegate.alertShow(_objVC: self, msgString: message!)
                        
                        
                    }
                    
                    
                }
                break
                
            case .failure(_):
                print(response.result.error ?? "Fail")
               // obj.HideHud()
                break
                
            }
        }
        
    }

    //MARK:Add Patient webservice
    func AddPatientService(dict:NSDictionary)
    {
        obj.ShowHud()
        
        Alamofire.request("\(web_SERWERURL)\(addPatientUrl)", method: .post, parameters:dict as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
