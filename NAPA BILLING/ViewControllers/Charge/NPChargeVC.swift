//
//  NPChargeVC.swift
//  NAPA BILLING
//
//  Created by Admin on 19/04/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire

var dictCharge:NSMutableDictionary!
var dictSlectedCharge:NSMutableDictionary!

class NPChargeVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource {
    var arrDepartMent:NSArray!
    var arrSpecialist:NSMutableArray!
    var arrPhysical:NSArray!
    var arrlistingType:NSArray!
    var tblCharge:UITableView!          = UITableView()
    var txtReason:UITextField!          = UITextField()
    var txtPreStartTime:UITextField!    = UITextField()
    var txtPreEndTime:UITextField!      = UITextField()
    var btnPreStartTime:UIButton!       = UIButton()
    var btnPreEndTime:UIButton!         = UIButton()
    var btnInOrTime:UIButton!           = UIButton()
    var btnPACUTime:UIButton!           = UIButton()
    var txtInOrTime:UITextField!        = UITextField()
    var txtPacuTime:UITextField!        = UITextField()
    var txtStartDate:UITextField!       = UITextField()
    var btnStartDate:UIButton           = UIButton()
    var txtEndDate:UITextField!         = UITextField()
    var btnEndDate:UIButton             = UIButton()    
    var strASAStatus:String!
    var strEnable:String!
    
    @IBOutlet var TpScrollView: TPKeyboardAvoidingScrollView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrDepartMent = ["Surgeon","Anesthesiologist","CRNA","Resident","SRNA","Procedure","Diagnosis","Position","Mode of Anesthesia"]
        
        arrlistingType = ["surgeon","anesthesiologist","CRNA","Resident","srna","Procedure","Diagnose","Position","ModeOA"]
        arrSpecialist = NSMutableArray()
        //  arrSpecialist = ["Smit,J","Smit,K","Smit,L","Smit,M","Smit,M","Smit,N","Smit,O","Smit,P","Smit,T"]
        arrPhysical = ["1","2","3","4","5","6"]
        self.setChargeView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       // self.setChargeView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        tblCharge.delegate = self
        tblCharge.dataSource = self
        tblCharge.reloadData()
        
        
    }
    func setChargeView(){
        var top                     = 0.0 as CGFloat
        let gap                     = SCREEN_HEIGHT*0.02
        let tblHeight               = (SCREEN_HEIGHT * 0.07) * CGFloat(arrDepartMent.count+1)
        
        tblCharge.removeFromSuperview()
        tblCharge                   = UITableView()
        tblCharge.frame             = CGRect(x:0,y:top,width:SCREEN_WIDTH,height:tblHeight)
        tblCharge.register(UINib(nibName: "chargeCell", bundle: nil), forCellReuseIdentifier: "chargeCell")
        tblCharge.delegate          = self
        tblCharge.dataSource        = self
        tblCharge.tableFooterView   = UIView()
        tblCharge.bounces           = false
        TpScrollView.addSubview(tblCharge)
        
        top                         += tblHeight
        
        
        let imgPhysical             = UIImageView(frame:CGRect(x:0,y:top,width:SCREEN_WIDTH,height:SCREEN_HEIGHT*0.07))
        imgPhysical.image           = UIImage(named:"strip")
        TpScrollView.addSubview(imgPhysical)
        
        let lblPhysical             = UILabel(frame:CGRect(x:10,y:top,width:SCREEN_WIDTH-20,height:SCREEN_HEIGHT*0.07))
        lblPhysical.text            = "ASA Physical Status"
        lblPhysical.textColor       = UIColor.white
        lblPhysical.font            = font_bold_large
        TpScrollView.addSubview(lblPhysical)
        
        top                         += imgPhysical.frame.size.height+gap
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: SCREEN_HEIGHT*0.07, height: SCREEN_HEIGHT*0.07)
        layout.scrollDirection      = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collView                = UICollectionView(frame:CGRect(x:10,y:top,width:SCREEN_HEIGHT*0.07 * CGFloat(arrPhysical.count),height:SCREEN_HEIGHT*0.07),collectionViewLayout: layout)
        collView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collView.delegate           = self
        collView.dataSource         = self
        collView.backgroundColor    = UIColor.white
        collView.bounces            = false
        TpScrollView.addSubview(collView)
        
        let btnEnable           = UIButton(frame:CGRect(x:collView.frame.size.width+20,y:top+SCREEN_HEIGHT*0.015,width:SCREEN_HEIGHT*0.04,height:SCREEN_HEIGHT*0.04))
        btnEnable.setImage(UIImage(named:"radiobuttonunselec"), for: UIControlState.normal)
        btnEnable.setImage(UIImage(named:"radiobuttonselect"), for: UIControlState.selected)
        btnEnable.addTarget(self, action: #selector(self.btnEnableTapped(_:)), for: UIControlEvents.touchUpInside)
        TpScrollView.addSubview(btnEnable)
        
        let lblEnable            = UILabel(frame:CGRect(x:collView.frame.size.width+btnEnable.frame.size.width+30,y:top+SCREEN_HEIGHT*0.015,width:SCREEN_HEIGHT*0.04,height:SCREEN_HEIGHT*0.04))
        lblEnable.text           = "E"
        lblEnable.textColor      = color_blue
        lblEnable.font           = font_bold_large
        TpScrollView.addSubview(lblEnable)
        
        top                         += collView.frame.size.height + gap
        
        let imgAnesthesia            = UIImageView(frame:CGRect(x:0,y:top,width:SCREEN_WIDTH,height:SCREEN_HEIGHT*0.07))
        imgAnesthesia.image          = UIImage(named:"strip")
        TpScrollView.addSubview(imgAnesthesia)
        
        let lblAnesthesia            = UILabel(frame:CGRect(x:10,y:top,width:SCREEN_WIDTH-20,height:SCREEN_HEIGHT*0.07))
        lblAnesthesia.text           = "Anesthesia Time"
        lblAnesthesia.textColor      = UIColor.white
        lblAnesthesia.font           = font_bold_large
        TpScrollView.addSubview(lblAnesthesia)
        
        top                          += imgAnesthesia.frame.size.height
        
        let lblPreOpTime             = UILabel(frame:CGRect(x:10,y:top,width:SCREEN_WIDTH-20,height:SCREEN_HEIGHT*0.07))
        lblPreOpTime.text            = "Pre-op Time"
        lblPreOpTime.textColor       = UIColor.darkText
        lblPreOpTime.font            = font_bold_list
        lblPreOpTime.textColor       = color_list_font
        TpScrollView.addSubview(lblPreOpTime)
        
        top                         += lblPreOpTime.frame.size.height+gap
        
        let lblStart                = UILabel(frame:CGRect(x:10,y:top,width:SCREEN_WIDTH*0.15,height:SCREEN_HEIGHT*0.05))
        lblStart.text               = "Start"
        lblStart.textColor          = UIColor.lightGray
        lblStart.font               = font_Regular_medium
        TpScrollView.addSubview(lblStart)
        
        txtPreStartTime.removeFromSuperview()
        txtPreStartTime                     = UITextField(frame:CGRect(x:SCREEN_WIDTH*0.15+20,y:top,width:SCREEN_WIDTH*0.20,height:SCREEN_HEIGHT*0.05))
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
        
        
        let lblEnd                          = UILabel(frame:CGRect(x:SCREEN_WIDTH*0.50,y:top,width:SCREEN_WIDTH*0.15,height:SCREEN_HEIGHT*0.05))
        lblEnd.text                         = "End"
        lblEnd.textColor                    = UIColor.lightGray
        lblEnd.font                         = font_Regular_medium
        TpScrollView.addSubview(lblEnd)
        
        txtPreEndTime.removeFromSuperview()
        txtPreEndTime         = UITextField(frame:CGRect(x:SCREEN_WIDTH*0.65+20,y:top,width:SCREEN_WIDTH*0.20,height:SCREEN_HEIGHT*0.05))
        txtPreEndTime.layer.cornerRadius    = SCREEN_HEIGHT*0.002
        txtPreEndTime.layer.borderWidth     = SCREEN_HEIGHT*0.001
        txtPreEndTime.layer.borderColor     = UIColor.lightGray.cgColor
        txtPreEndTime.font                  = font_Regular_medium
        TpScrollView.addSubview(txtPreEndTime)
        
        btnPreEndTime.removeFromSuperview()
        btnPreEndTime                     = UIButton()
        btnPreEndTime.frame               = txtPreEndTime.frame
        btnPreEndTime.addTarget(self, action: #selector(PreEndTimeTapped(_:)), for: UIControlEvents.touchUpInside)
        TpScrollView.addSubview(btnPreEndTime)

        
        top                             += lblEnd.frame.size.height+gap
        
        
        let lblStartDate                = UILabel(frame:CGRect(x:10,y:top,width:SCREEN_WIDTH*0.22,height:SCREEN_HEIGHT*0.05))
        lblStartDate.text               = "Start Date"
        lblStartDate.textColor          = UIColor.lightGray
        lblStartDate.font               = font_Regular_medium
        TpScrollView.addSubview(lblStartDate)
        
        txtStartDate.removeFromSuperview()
        txtStartDate                     = UITextField(frame:CGRect(x:SCREEN_WIDTH*0.22+12,y:top,width:SCREEN_WIDTH*0.25,height:SCREEN_HEIGHT*0.05))
        txtStartDate.layer.cornerRadius  = SCREEN_HEIGHT*0.002
        txtStartDate.layer.borderWidth   = SCREEN_HEIGHT*0.001
        txtStartDate.layer.borderColor   = UIColor.lightGray.cgColor
        txtStartDate.font                = font_Regular_medium
        TpScrollView.addSubview(txtStartDate)
        
        btnStartDate.removeFromSuperview()
        btnStartDate                     = UIButton()
        btnStartDate.frame               = txtStartDate.frame
        btnStartDate.addTarget(self, action: #selector(StartTapped(_:)), for: UIControlEvents.touchUpInside)
        TpScrollView.addSubview(btnStartDate)
        
        
        let lblEndDate                          = UILabel(frame:CGRect(x:SCREEN_WIDTH*0.47+14,y:top,width:SCREEN_WIDTH*0.20,height:SCREEN_HEIGHT*0.05))
        lblEndDate.text                         = "End Date"
        lblEndDate.textColor                    = UIColor.lightGray
        lblEndDate.font                         = font_Regular_medium
        TpScrollView.addSubview(lblEndDate)
        
        txtEndDate.removeFromSuperview()
        txtEndDate         = UITextField(frame:CGRect(x:SCREEN_WIDTH*0.67+16,y:top,width:SCREEN_WIDTH*0.25,height:SCREEN_HEIGHT*0.05))
        txtEndDate.layer.cornerRadius    = SCREEN_HEIGHT*0.002
        txtEndDate.layer.borderWidth     = SCREEN_HEIGHT*0.001
        txtEndDate.layer.borderColor     = UIColor.lightGray.cgColor
        txtEndDate.font                  = font_Regular_medium
        TpScrollView.addSubview(txtEndDate)
        
        btnEndDate.removeFromSuperview()
        btnEndDate                     = UIButton()
        btnEndDate.frame               = txtEndDate.frame
        btnEndDate.addTarget(self, action: #selector(EndDateTapped(_:)), for: UIControlEvents.touchUpInside)
        TpScrollView.addSubview(btnEndDate)
        top                         += lblEndDate.frame.size.height+gap

        
        txtReason.removeFromSuperview()
        txtReason         = UITextField(frame:CGRect(x:10,y:top,width:SCREEN_WIDTH-20,height:SCREEN_HEIGHT*0.10))
        txtReason.layer.cornerRadius = SCREEN_HEIGHT*0.002
        txtReason.layer.borderWidth = SCREEN_HEIGHT*0.001
        txtReason.layer.borderColor = UIColor.lightGray.cgColor
        txtReason.font               = font_Regular_medium
        txtReason.placeholder       = "Reason for pre-op-Time"
        TpScrollView.addSubview(txtReason)
        
        top                             += txtReason.frame.size.height+gap
        
        let lblInOr               = UILabel(frame:CGRect(x:10,y:top,width:SCREEN_WIDTH*0.25,height:SCREEN_HEIGHT*0.05))
        lblInOr.text               = "In Or Time"
        lblInOr.textColor          = UIColor.lightGray
        lblInOr.font               = font_Regular_medium
        TpScrollView.addSubview(lblInOr)
        lblInOr.sizeToFit()
        
        txtInOrTime.removeFromSuperview()
        txtInOrTime                     = UITextField(frame:CGRect(x:lblInOr.frame.size.width+20,y:top,width:SCREEN_WIDTH*0.30,height:SCREEN_HEIGHT*0.05))
        txtInOrTime.layer.cornerRadius = SCREEN_HEIGHT*0.002
        txtInOrTime.layer.borderWidth = SCREEN_HEIGHT*0.001
        txtInOrTime.layer.borderColor = UIColor.lightGray.cgColor
        txtInOrTime.font      = font_Regular_medium
        TpScrollView.addSubview(txtInOrTime)
        
        btnInOrTime.removeFromSuperview()
        btnInOrTime                     = UIButton()
        btnInOrTime.frame               = txtInOrTime.frame
        btnInOrTime.addTarget(self, action: #selector(InOrTimeTapped(_:)), for: UIControlEvents.touchUpInside)
        TpScrollView.addSubview(btnInOrTime)
        
        top                             += txtInOrTime.frame.size.height+gap
        
        let lblPacu               = UILabel(frame:CGRect(x:10,y:top,width:SCREEN_WIDTH*0.60,height:SCREEN_HEIGHT*0.05))
        lblPacu.text               = "PACU Transfer of care time"
        lblPacu.textColor          = UIColor.lightGray
        lblPacu.font               = font_Regular_medium
        TpScrollView.addSubview(lblPacu)
        lblPacu.sizeToFit()
        
        txtPacuTime         = UITextField(frame:CGRect(x:lblPacu.frame.size.width+20,y:top,width:(SCREEN_WIDTH-(lblPacu.frame.size.width+25)) ,height:SCREEN_HEIGHT*0.05))
        txtPacuTime.layer.cornerRadius = SCREEN_HEIGHT*0.002
        txtPacuTime.layer.borderWidth = SCREEN_HEIGHT*0.001
        txtPacuTime.layer.borderColor = UIColor.lightGray.cgColor
        txtPacuTime.font      = font_Regular_medium
        TpScrollView.addSubview(txtPacuTime)
        
        btnPACUTime.removeFromSuperview()
        btnPACUTime                     = UIButton()
        btnPACUTime.frame               = txtPacuTime.frame
        btnPACUTime.addTarget(self, action: #selector(PACUTimeTapped(_:)), for: UIControlEvents.touchUpInside)
        TpScrollView.addSubview(btnPACUTime)
        
        top                     += lblPacu.frame.size.height + 2*gap
        
        let btnBlocks           = UIButton(frame:CGRect(x:0,y:top,width:SCREEN_WIDTH,height:SCREEN_HEIGHT*0.07))
        btnBlocks.setTitle("Lines/Blocks/Other", for: UIControlState.normal)
        btnBlocks.titleLabel?.font = font_bold_large
        btnBlocks.setTitleColor(.white, for: UIControlState.normal)
        btnBlocks.backgroundColor = color_blue
        btnBlocks.addTarget(self, action: #selector(self.btnBlockTapped(_:)), for: UIControlEvents.touchUpInside)
        TpScrollView.addSubview(btnBlocks)
        
        top                     += btnBlocks.frame.size.height
        
        TpScrollView.contentSize = CGSize(width:SCREEN_WIDTH,height:top)
        
        
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
    
    
    func InOrTimeTapped(_ textField: UITextField) {
        txtPreEndTime.resignFirstResponder()
        
         DatePickerDialog().show("Select Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate:NSDate() as Date , maximumDate:nil , datePickerMode: .time)  { (date) in
            if let dt = date {
                //Convert string to date object
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                let strDate = formatter.string(from: dt) as String
                self.txtInOrTime.text = "\(strDate)"
                self.txtInOrTime.resignFirstResponder()
            }
        }
    }
    
    
    func PACUTimeTapped(_ textField: UITextField) {
        txtPreEndTime.resignFirstResponder()
        
        DatePickerDialog().show("Select Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate:NSDate() as Date , maximumDate:nil , datePickerMode: .time)  { (date) in
            if let dt = date {
                //Convert string to date object
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                let strDate = formatter.string(from: dt) as String
                self.txtPacuTime.text = "\(strDate)"
                self.txtPacuTime.resignFirstResponder()
            }
        }
    }
    
    func StartTapped(_ textField: UITextField) {
       DatePickerDialog().show("select date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate:NSDate() as Date , maximumDate:nil , datePickerMode: .date)  { (date) in
            if let dt = date {
                //Convert string to date object
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/dd/mm"
                let strDate = formatter.string(from: dt) as String
                self.txtStartDate.text = "\(strDate)"
            }
        }
    }
    
    func EndDateTapped(_ textField: UITextField) {
            DatePickerDialog().show("Select Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate:NSDate() as Date , maximumDate:nil , datePickerMode: .date) { (date) in
            if let dt  = date {
            //Convert string to date object
            let formatter           = DateFormatter()
            formatter.dateFormat    = "yyyy/dd/mm"
            let strDate             = formatter.string(from: dt) as String
            self.txtEndDate.text    = "\(strDate)"
            }
            }
    }
    //MARK: methods.....
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    
    @IBAction func btnBlockTapped(_ sender: UIButton) {
        
        let userID          = defaults.value(forKey: kAPP_UserId) as! String!
        dictCharge          = NSMutableDictionary()
        dictSlectedCharge   = NSMutableDictionary()
        
        dictCharge = ["user_id" : userID!,"record_id":recordId,"end_date" :txtEndDate.text!,"start_date":txtStartDate.text!,"start_time":txtPreStartTime.text!,"end_time":txtPreEndTime.text!,"adjust_time":txtInOrTime.text!,"pacu_time":txtPacuTime.text!,"Surgeon":strSurgeonCode,"Anesthesiologist":stranesthesiologistCode,"CRNA":strCRNACode,"Resident":strResidentCode,"SRNA":strsrnaCode,"Position":strPosition,"Mode of Anesthesia":strModeOfAnes]
        
        SaveChargeService(dict: dictCharge)
      
    }
    
    
    //MARK:SaveChargeService webservice
    func SaveChargeService(dict:NSDictionary)
    {
        obj.ShowHud()
        
        Alamofire.request("\(web_SERWERURL)\(saveChargeUrl)", method: .post, parameters:dict as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
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
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "NPSpecialServicesVC") as! NPSpecialServicesVC
                        self.navigationController?.pushViewController(vc, animated: true)
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
        popOverVC.page        = "3"
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    @IBAction func btnEnableTapped(_ sender: UIButton) {
            if sender.isSelected == true {
                sender.isSelected = false
                strEnable         = "no"
            }else{
                sender.isSelected = true
                strEnable         = "yes"
            }
    }
    
    
    //MARK: tableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrDepartMent.count
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tblCharge.dequeueReusableCell(withIdentifier: "chargeCell") as? chargeCell
        
        if cell == nil {
            cell = chargeCell(style: UITableViewCellStyle.value1, reuseIdentifier: "chargeCell")
        }
        
        cell!.lblDepartment.text          = arrDepartMent.object(at: indexPath.row) as? String
        cell!.lblDepartment.font          = font_bold_list
        cell?.lblDepartment.textColor     = color_list_font
        //  cell!.lblSpecialist.text          = (arrSpecialist.object(at: indexPath.row) as! NSString) as String
        
        if indexPath.row == 0
        {
            cell!.lblSpecialist.text     = appDelegate.checkEmptyString(str: strSurgeon as NSString?) as String
            
        }else if indexPath.row == 1
        {
            cell!.lblSpecialist.text     = appDelegate.checkEmptyString(str: stranesthesiologist as NSString?) as String
            
        }else if indexPath.row == 2
        {
            cell!.lblSpecialist.text     = appDelegate.checkEmptyString(str: strCRNA as NSString?) as String
            
            
        }else if indexPath.row == 3
        {
            cell!.lblSpecialist.text     = appDelegate.checkEmptyString(str: strResident as NSString?) as String
            
        }else if indexPath.row == 4
        {
            cell!.lblSpecialist.text     = appDelegate.checkEmptyString(str: strsrna as NSString?) as String
            
            
        }else if indexPath.row == 6
        {
            cell!.lblSpecialist.text     = appDelegate.checkEmptyString(str: strDiagnosis as NSString?) as String
            
            
        }
        else if indexPath.row == 7
        {
            cell!.lblSpecialist.text     = appDelegate.checkEmptyString(str: strPosition as NSString?) as String
            
            
        } else if indexPath.row == 8
        {
            cell!.lblSpecialist.text     = appDelegate.checkEmptyString(str: strModeOfAnes as NSString?) as String
            
            
        }
        cell!.lblSpecialist.font          = font_reguler_list
        cell?.lblSpecialist.textColor     = color_blue
        
        cell!.accessoryType               = UITableViewCellAccessoryType.disclosureIndicator
        cell!.preservesSuperviewLayoutMargins = false
        cell!.separatorInset              = UIEdgeInsets.zero
        cell!.layoutMargins               = UIEdgeInsets.zero
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if indexPath.row == 5{
            
            let vc = storyBoard.instantiateViewController(withIdentifier: "NPProcedureVC") as! NPProcedureVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 6
        {
            let vc = storyBoard.instantiateViewController(withIdentifier: "NPDiagonsisVC") as! NPDiagonsisVC
            vc.searchCategory = arrlistingType.object(at: indexPath.row) as? String
            vc.strTitle       = arrDepartMent.object(at: indexPath.row) as? String
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 7 || indexPath.row == 8
        {
            let vc            = storyBoard.instantiateViewController(withIdentifier: "NPModeAnesthsiaVC") as! NPModeAnesthsiaVC
            vc.searchCategory = arrlistingType.object(at: indexPath.row) as? String
            vc.strTitle       = arrDepartMent.object(at: indexPath.row) as? String
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            let vc            = storyBoard.instantiateViewController(withIdentifier: "NPSurgeonVC") as! NPSurgeonVC
            vc.searchCategory = arrlistingType.object(at: indexPath.row) as? String
            vc.strTitle       = arrDepartMent.object(at: indexPath.row) as? String
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_tableView: UITableView,
                   willDisplayCell cell: UITableViewCell,
                   forRowAtIndexPath indexPath: NSIndexPath) {
         }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_HEIGHT*0.07;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView()
        viewHeader.frame = CGRect(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT*0.07)
        
        let lblHeader = UILabel(frame:CGRect(x:10,y:0,width:SCREEN_WIDTH-20,height:SCREEN_HEIGHT*0.069))
        lblHeader.text = appDelegate.checkEmptyString(str: strPatientName as NSString?) as String
        lblHeader.textAlignment =  NSTextAlignment.center
        lblHeader.font = font_bold_Exlarge
        
        viewHeader.addSubview(lblHeader)
        
        let lblline            = UILabel(frame: CGRect(x:0, y:SCREEN_HEIGHT*0.069, width:SCREEN_WIDTH, height:SCREEN_HEIGHT*0.001))
        lblline.backgroundColor = UIColor.lightGray
        viewHeader.addSubview(lblline)
        
        return viewHeader
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SCREEN_HEIGHT*0.07
    }
    
    
    //MARK:collectionview delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        
        let lblCount            = UILabel(frame:CGRect(x:0,y:0,width:SCREEN_HEIGHT*0.07,height:SCREEN_HEIGHT*0.07))
        lblCount.text           = arrPhysical.object(at: indexPath.row) as? String
        lblCount.textColor      = UIColor.darkText
        lblCount.font           = font_Regular_medium
        lblCount.textAlignment  = NSTextAlignment.center
        cell.addSubview(lblCount)
        cell.backgroundColor    = UIColor.white
        cell.layer.borderWidth = SCREEN_HEIGHT*0.001
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        // cell.backgroundColor = UIColor.orange
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        strASAStatus = String(format:"%@",arrPhysical.object(at: indexPath.row) as! CVarArg)
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.darkGray
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.clear
        
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width:SCREEN_HEIGHT*0.07, height:SCREEN_HEIGHT*0.07)
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
