//
//  ViewController.swift
//  NAPA BILLING
//
//  Created by Admin on 17/04/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire

var  PostData = [String: String]()
class ViewController: UIViewController {
    @IBOutlet var lblAnethesia: UILabel!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var viewCoding: UIView!
    @IBOutlet var txtEmail: UITextField!
  
    @IBOutlet var lblAris: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userID = defaults.value(forKey: kAPP_UserId) as! String!
        if userID != nil
        {
            self.performSegue(withIdentifier: "home", sender: nil)
        }
        lblAnethesia.font           = font_Regular_medium
        obj.viewBorder(viewCoding)
        btnLogin.titleLabel?.font   = font_bold_medium
        txtEmail.font               = font_Regular_large
        txtPassword.font            = font_Regular_large
        lblAris.font                = font_Regular_largeto
        txtEmail.keyboardType       = UIKeyboardType.emailAddress
        txtPassword.isSecureTextEntry = true
        
        obj.roundedButton(btnLogin)
        obj.roundedTextField(txtEmail)
        obj.roundedTextField(txtPassword)
        txtEmail.setLeftPaddingWithImage(40,"email")
        txtPassword.setLeftPaddingWithImage(40, "password")
//        txtEmail.text  = defaults.value(forKey: kAPP_EMAIL) as! String?
//        txtPassword.text = defaults.value(forKey: kAPP_PASS) as! String?
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        
        //  self.performSegue(withIdentifier: "home", sender: nil)
        
        if txtEmail.text! .isEmpty
        {
            obj.alertShow(_objVC: self, msgString: "Please Enter Email Address")
            
        }
        else  if obj.validateEmail(txtEmail.text!) == false
        {
            obj.alertShow(_objVC: self, msgString: "Please Enter Valid Email Address")
            
        }
        else if txtPassword.text! .isEmpty
        {
            obj.alertShow(_objVC: self, msgString: "Please Enter Password")
            
        }
        else if (txtPassword.text?.characters.count)! < 6
        {
            obj.alertShow(_objVC: self, msgString: "Please Enter Minimum 6 Character Password")
            
        }else{
            
         // let strdeviceToken =  UserDefaults.standard.value(forKey:"deviceToken") as! String
           let strdeviceToken =  "878fg8d7fg78dfg8dffd7g8df"
            PostData = ["email":txtEmail.text!,"pass":txtPassword.text!,"device_token":strdeviceToken,"device_type":"1"]
            loginWebCalling(dict: PostData as NSDictionary)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    
func loginWebCalling(dict:NSDictionary)
    {
        obj.ShowHud()
        
        Alamofire.request("\(web_SERWERURL)\(loginUrl)", method: .post, parameters:dict as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
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
                        // appDelegate.alertShow(_objVC: self, msgString: message!)
                        defaults.set(self.txtEmail.text, forKey: kAPP_EMAIL)
                        defaults.set(self.txtPassword.text, forKey: kAPP_PASS)
                        let arrUser = response.value(forKey: "Data") as? NSArray
                        let dictUser = arrUser?.object(at: 0) as! NSDictionary
                        defaults.set(dictUser.object(forKey:"user_id") as? String, forKey: kAPP_UserId)
                        defaults.set(dictUser.object(forKey:"name") as? String, forKey: kAPP_Name)
//                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                        let vc = storyBoard.instantiateViewController(withIdentifier: "CustomSideMenuController") as! CustomSideMenuController                   
//                       
//                        self.navigationController?.pushViewController(vc, animated: true)

                        self.performSegue(withIdentifier: "home", sender: nil)
//                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
//                        self.navigationController?.pushViewController(obj, animated: true)
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


}

