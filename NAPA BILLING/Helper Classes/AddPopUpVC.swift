//
//  AddPopUpVC.swift
//  Techdeals
//
//  Created by Admin on 05/04/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire

var strviewType:String!
class AddPopUpVC: UIViewController {
    @IBOutlet var txtAdd: UITextView!
    @IBOutlet var lblTitle: UILabel!
    var page:String!
    var strRecordId:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtAdd.layer.cornerRadius   = SCREEN_HEIGHT*0.002
        txtAdd.layer.borderWidth    = SCREEN_HEIGHT*0.001
        txtAdd.layer.borderColor    = UIColor.lightGray.cgColor
        self.view.backgroundColor   = UIColor.black.withAlphaComponent(0.8)
        txtAdd.becomeFirstResponder()
        self.showAnimate()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var  dictAdd  = [String: String]()
        dictAdd    = ["user_id":defaults.value(forKey: kAPP_UserId) as! String!,"record_id":strRecordId,"page":page]
        GetNotes(dict: dictAdd as NSDictionary)
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
//MARK:Methods
    @IBAction func btnCreateTapped(_ sender: UIButton) {
        
        if txtAdd.text.isEmpty{
            appDelegate.alertShow(_objVC: self, msgString: "Please write note")
        }else{
            var  dictAdd  = [String: String]()
            dictAdd    = ["user_id":defaults.value(forKey: kAPP_UserId) as! String!,"record_id":strRecordId,"notes":txtAdd.text,"page":page]
            AddOREditNotes(dict: dictAdd as NSDictionary)
        }
        
    }
    @IBAction func btnCancelTapped(_ sender: Any) {
        
        self.removeAnimate()
    }

//MARK:AddOREditNotes webservice
    func AddOREditNotes(dict:NSDictionary)
    {
        obj.ShowHud()
        
        Alamofire.request("\(web_SERWERURL)\(addNotes)", method: .post, parameters:dict as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
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
                 //   let message     = response.value(forKey: "message") as? String
                    if (status as AnyObject).doubleValue == 1
                    {
                        
                         self.removeAnimate()
                        
                    }
                        
                    else
                    {
                        print("Fails")
                        obj.HideHud()
                       // appDelegate.alertShow(_objVC: self, msgString: message!)
                        
                        
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

//MARK:GET Notes webservice
    func GetNotes(dict:NSDictionary)
    {
        obj.ShowHud()
        
        Alamofire.request("\(web_SERWERURL)\(getNotesUrl)", method: .post, parameters:dict as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
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
                          let dictNotes       = response.value(forKey:"Data") as! NSDictionary
                          let note            = dictNotes.object(forKey: "notes") as! String
                          self.txtAdd.text    = appDelegate.checkEmptyString(str: note as NSString?) as String
                                               
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
