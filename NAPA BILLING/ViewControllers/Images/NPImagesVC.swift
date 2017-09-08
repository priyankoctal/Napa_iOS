//
//  NPImagesVC.swift
//  NAPA BILLING
//
//  Created by Admin on 19/04/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire


class NPImagesVC: UIViewController,UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate {
    @IBOutlet var lblName: UILabel!
    @IBOutlet var tblImages: UITableView!
    var strRecordId:String!
    
    var arrImages:NSArray!

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"nav.png"), for: UIBarMetrics.default)
        lblName.font                = font_bold_Exlarge
        lblName.text                = appDelegate.checkEmptyString(str: strPatientName as NSString?) as String
        tblImages.tableFooterView   = UIView() //Hiding blank cells.
        tblImages.separatorInset    = UIEdgeInsets.zero
        tblImages.rowHeight         = 80.0
        tblImages.estimatedRowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
    }

override func viewWillAppear(_ animated: Bool) {
    
    imageListOfPatient()

}
    //MARK: image list method.....
    func imageListOfPatient(){
        var  dictImage = [String: String]()
        dictImage    = ["record_id":recordId]
        ImageList(dict: dictImage as NSDictionary)
    }
    
    
    //MARK: methods.....
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    
    @IBAction func btnEditTapped(_ sender: UIButton) {
        let popOverVC         = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddPopUpVC") as! AddPopUpVC
        self.addChildViewController(popOverVC)
        popOverVC.view.frame  = self.view.frame
        popOverVC.strRecordId = recordId
        popOverVC.page        = "19"
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    @IBAction func btnAddAditioanlTapped(_ sender: UIButton) {
        let storyBoard : UIStoryboard   = UIStoryboard(name: "Main", bundle:nil)
        let vc                          = storyBoard.instantiateViewController(withIdentifier: "NPTakePicVC") as! NPTakePicVC
        vc.strRecordId                  = recordId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:tableview delegate....
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let reuseIdentifier = "imageCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MGSwipeTableCell
        
        // cell.textLabel!.text = "Title"
        // cell.detailTextLabel!.text = "Detail text"
        
        let lblName = cell.contentView.viewWithTag(100) as? UILabel
        let name    = (arrImages.value(forKey: "ImageName") as AnyObject).object(at: indexPath.row) as! String
        lblName?.text = appDelegate.checkEmptyString(str: name as NSString?) as String
        lblName?.font = font_reguler_list
        lblName?.textColor = color_list_font
        
       let imgView = cell.contentView.viewWithTag(101) as! UIImageView
        let picUrl = (arrImages.value(forKey: "url") as AnyObject).object(at: indexPath.row) as! String
        imgView.sd_setImage(with:NSURL(string:picUrl) as URL!, placeholderImage: UIImage(named:"placeholder"))
        imgView.layer.cornerRadius = SCREEN_HEIGHT*0.005;
        imgView.clipsToBounds = true
        
        cell.delegate = self
        
        let btnDelete = MGSwipeButton(title: "Delete", icon: UIImage(named:"cancel.png"), backgroundColor: UIColor(red:240.0/255.0, green: 52.0/255.0, blue: 68.0/255.0, alpha: 1.0))
        btnDelete.centerIconOverText()
        btnDelete.buttonWidth = SCREEN_WIDTH*0.24
        
        //configure right buttons
        cell.rightButtons = [btnDelete]
        cell.rightSwipeSettings.transition = .rotate3D
     //   cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  self.performSegue(withIdentifier: "detail", sender: nil)
        
    }    
    
    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        if index == 0 {
            let userID      = defaults.value(forKey: kAPP_UserId) as! String!
            let imageId     = (arrImages.value(forKey: "id") as AnyObject).object(at: index) as! String
            var  dictDelete = [String: String]()
            dictDelete      = ["record_id":recordId,"user_id":userID!,"image_id":imageId]
            DeleteImage(dict: dictDelete as NSDictionary)
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SCREEN_HEIGHT * 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader                  = UIView()
        viewHeader.frame                = CGRect(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT*0.07)
        let lblline                     = UILabel(frame: CGRect(x:0, y:0, width:SCREEN_WIDTH ,height:SCREEN_HEIGHT * 0.001))
        lblline.backgroundColor = UIColor.lightGray
        viewHeader.addSubview(lblline)
        return viewHeader

    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       
        return SCREEN_HEIGHT*0.08
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter                 = UIView()
        viewFooter.frame                = CGRect(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT*0.08)
        let btnAddImages                = UIButton(frame:CGRect(x:10,y:0,width:SCREEN_WIDTH-20,height:SCREEN_HEIGHT*0.07))
        btnAddImages.setTitle("Add additional image", for: UIControlState.normal)
        btnAddImages.setTitleColor(.white, for: UIControlState.normal)
        btnAddImages.titleLabel?.font   = font_bold_large
        btnAddImages.backgroundColor    = color_blue
        btnAddImages.addTarget(self, action: #selector(btnAddAditioanlTapped(_:)), for: UIControlEvents.touchUpInside)
        viewFooter.addSubview(btnAddImages)
        
        return viewFooter
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //MARK:ImageList list webservice
    func ImageList(dict:NSDictionary)
    {
        obj.ShowHud()
        
        Alamofire.request("\(web_SERWERURL)\(imageListUrl)", method: .post, parameters:dict as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
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
                       
                       self.arrImages                = response.value(forKey:"Data") as! NSArray
                         print("images=%@",self.arrImages)
                        self.tblImages.dataSource               = self
                        self.tblImages.delegate                 = self
                        self.tblImages.reloadData()
                        
                    }
                        
                    else
                    {
                        print("Fails")
                        obj.HideHud()
                        self.arrImages                = response.value(forKey:"Data") as! NSArray
                        self.tblImages.dataSource               = self
                        self.tblImages.delegate                 = self
                        self.tblImages.reloadData()
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

    
    //MARK:DeleteImage webservice
    func DeleteImage(dict:NSDictionary)
    {
        obj.ShowHud()
        
        Alamofire.request("\(web_SERWERURL)\(deleteImageUrl)", method: .post, parameters:dict as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
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
                      self.imageListOfPatient()
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
