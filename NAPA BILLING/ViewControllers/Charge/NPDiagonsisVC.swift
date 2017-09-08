//
//  NPDiagonsisVC.swift
//  NAPA BILLING
//
//  Created by Admin on 05/05/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire
var strDiagnosis:String! = ""

class NPDiagonsisVC: UIViewController ,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    var searchCategory:String!
    var strTitle:String!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblList: UITableView!
    var arrSearch:NSMutableArray!
    var is_searching:Bool!
    var isCharacterTyping:Bool!
    
    @IBOutlet var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        is_searching                = false
        arrSearch                   = NSMutableArray()
        
        tblList.register(UINib(nibName: "DiagnosisCell", bundle: nil), forCellReuseIdentifier: "DiagnosisCell")
        tblList.tableFooterView     = UIView()
        tblList.delegate            = self
        tblList.dataSource          = self
        tblList.rowHeight           = 44.0
        
        // Do any additional setup after loading the view.
    }
    //MARK: methods.....
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    
    //MARK: tableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrSearch.count
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tblList.dequeueReusableCell(withIdentifier: "DiagnosisCell") as? DiagnosisCell
        
        if cell == nil {
            cell = DiagnosisCell(style: UITableViewCellStyle.value1, reuseIdentifier: "DiagnosisCell")
        }
        
        let title                       = (arrSearch.value(forKey: "title")as AnyObject).object(at: indexPath.row) as! String
    
        let refCode                     = (arrSearch.value(forKey: "ref_code")as AnyObject).object(at: indexPath.row) as! String
        
        //   let first = String(format: "(%@) Per Level (%@)", Fname, refCode)
        let strName                     = title + " " + "\u{28}" +  refCode + "\u{29}"
        //        strName.append(")")
        //  let first = "(\(Fname)) Per Level (\(refCode))hfsdhf"
        
        //let  strName                     = "\(Fname)\(Lname) ( \(refCode)\(")"))"
        cell?.lblTitle?.text            = appDelegate.checkEmptyString(str: strName as NSString?) as String
        
        cell?.lblTitle?.font            = font_bold_list
        cell?.lblTitle?.textColor       = color_list_font
        cell?.btnSelect.tag             =  indexPath.row
        cell?.btnSelect.addTarget(self, action: #selector(self.btnEnableTapped(_:)), for: UIControlEvents.touchUpInside)
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset              = UIEdgeInsets.zero
        cell?.layoutMargins               = UIEdgeInsets.zero
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let title                       = (arrSearch.value(forKey: "title")as AnyObject).object(at: indexPath.row) as! String
        let refCode                     = (arrSearch.value(forKey: "ref_code")as AnyObject).object(at: indexPath.row) as! String
        
        //   let first = String(format: "(%@) Per Level (%@)", Fname, refCode)
        strDiagnosis                      = title + " " + "\u{28}" + refCode + "\u{29}"
        self.navigationController!.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //MARK: Search bar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text!.isEmpty{
            is_searching = false
            tblList.isHidden = true
        }
        //        else{
        //            tblList.isHidden = false
        //
        //            }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        is_searching = false
        tblList.isHidden = true
        
    }
    
    // called when search button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        myLabel.text = "Searching"
        searchBar .resignFirstResponder()
        self.view.endEditing(true)
        var  dictSearch = [String: String]()
        
        dictSearch = ["record_id":recordId,"user_id":defaults.value(forKey: kAPP_UserId) as! String!,"listing_type":searchCategory,"ref_code":searchBar.text!]
        SearchListing(dict: dictSearch as NSDictionary)
        
    }
    
    func UnloadArraysOnEachCharacterType(){
        arrSearch.removeAllObjects()
        isCharacterTyping = true
    }
    
    @IBAction func btnEnableTapped(_ sender: UIButton) {
        strSurgeon =  (arrSearch.value(forKey: "title")as AnyObject).object(at: sender.tag) as! String
        if sender.isSelected == true {
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    //MARK:search Listing
    func SearchListing(dict:NSDictionary)
    {
        obj.ShowHud()
        
        Alamofire.request("\(web_SERWERURL)\(chargeListUrl)", method: .post, parameters:dict as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            print(response.request ?? "")
            switch(response.result) {
            case .success(_):
                if response.result.value != nil
                {
                    obj.HideHud()
                  //  print(response.result.value!)
                    let JSON        = response.result.value! as AnyObject
                    let response    = JSON["response"] as! NSDictionary
                    let status      = response.value(forKey: "status")
                    let message     = response.value(forKey: "message") as? String
                    if (status as AnyObject).doubleValue == 1
                    {
                        // appDelegate.alertShow(_objVC: self, msgString: message!)
                        
                        let arrList             = response.value(forKey: "Data") as? NSArray
                        self.arrSearch          = arrList?.mutableCopy() as! NSMutableArray!
                        self.tblList.isHidden   = false
                        self.tblList.reloadData()
                        //                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        //                        let vc = storyBoard.instantiateViewController(withIdentifier: "CustomSideMenuController") as! CustomSideMenuController
                        //
                        //                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        // self.performSegue(withIdentifier: "home", sender: nil)
                        //                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
                        //                        self.navigationController?.pushViewController(obj, animated: true)
                    }
                    else
                    {
                        print("Fails")
                        obj.HideHud()
                         self.tblList.isHidden   = true
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
