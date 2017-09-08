//
//  NPQIVC.swift
//  NAPA BILLING
//
//  Created by Admin on 19/04/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire

var dictQI:NSMutableDictionary!
var dictSlectedQI:NSMutableDictionary!

class NPQIVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    var arrPhysical:NSArray!
    var arrAddmission:NSArray!
    var arrOSA:NSArray!
    var tblCharge:UITableView!
    var btnAbove:UIButton!
    var btnBelow:UIButton!
    var btnPerHandOff:UIButton!
    var btnNotPerHandoff:UIButton!
    var strAttestation:String!
    var strNoListed:String!
    var strTemp:String!
    var strPACU:String!
    var strAdmissionPain:String!
    var strASAPhysician:String!
    var strOSAScore:String!
    var strKnownOSA:String!
    
    @IBOutlet var TpScrollView: TPKeyboardAvoidingScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrPhysical     = ["1","2","3","4","5","6"]
        arrAddmission   = ["NA","1","2","3","4","5","6","7","8","9","10"]
        arrOSA          = ["1","2","3","4","5","6","7","8","X"]
        self.setQualityInformationView()
        strAttestation  = ""
        strNoListed     = ""
        strTemp         = ""
        strPACU         = ""
        strAdmissionPain = ""
        strOSAScore     = ""
        strKnownOSA     = ""
        

        // Do any additional setup after loading the view.
    }
    
//MARK: setQualityInformationView
    func setQualityInformationView(){
        var top                = 0.0 as CGFloat
        let gap                = SCREEN_HEIGHT*0.02 as CGFloat
        let lblName            = UILabel(frame:CGRect(x:10,y:top,width:SCREEN_WIDTH-20,height:SCREEN_HEIGHT*0.07))
        lblName.text           = appDelegate.checkEmptyString(str: strPatientName as NSString?) as String
        lblName.textColor      = UIColor.darkText
        lblName.textAlignment  =  NSTextAlignment.center
        lblName.font           = font_bold_Exlarge
        TpScrollView.addSubview(lblName)
        
        top                         += lblName.frame.size.height + gap
        
        let lblline            = UILabel(frame: CGRect(x:0,y:top, width:SCREEN_WIDTH, height:SCREEN_HEIGHT*0.001))
        lblline.backgroundColor = UIColor.gray
        TpScrollView.addSubview(lblline)
        
         top                         +=  gap
        
        let btnAttension           = UIButton(frame:CGRect(x:10,y:top+SCREEN_HEIGHT*0.025,width:SCREEN_HEIGHT*0.04,height:SCREEN_HEIGHT*0.04))
        btnAttension.setImage(UIImage(named:"radiobuttonunselec"), for: UIControlState.normal)
        btnAttension.setImage(UIImage(named:"radiobuttonselect"), for: UIControlState.selected)
        btnAttension.addTarget(self, action: #selector(self.btnAttestationTapped(_:)), for: UIControlEvents.touchUpInside)
        TpScrollView.addSubview(btnAttension)
        
        let lblAttension            = UILabel(frame:CGRect(x:20+SCREEN_HEIGHT*0.04,y:top,width:SCREEN_WIDTH-(20+SCREEN_HEIGHT*0.04),height:SCREEN_HEIGHT*0.10))
        lblAttension.text           = "Attestation of current medications documented in the medical record(based on resources available)"
        lblAttension.textColor      = color_list_font
        lblAttension.font           = font_Regular_medium
        lblAttension.numberOfLines  = 4;
        TpScrollView.addSubview(lblAttension)
        lblAttension.sizeToFit()
        
        top                         += lblAttension.frame.size.height + gap
        
        
        let lblline1                = UILabel(frame: CGRect(x:0,y:top, width:SCREEN_WIDTH, height:SCREEN_HEIGHT*0.001))
        lblline1.backgroundColor    = UIColor.gray
        TpScrollView.addSubview(lblline1)
        
        top                     +=  gap
        
        let btnIntraop           = UIButton(frame:CGRect(x:10,y:top+SCREEN_HEIGHT*0.07/2-SCREEN_HEIGHT*0.02,width:SCREEN_HEIGHT*0.04,height:SCREEN_HEIGHT*0.04))
        btnIntraop.setImage(UIImage(named:"radiobuttonunselec"), for: UIControlState.normal)
        btnIntraop.setImage(UIImage(named:"radiobuttonselect"), for: UIControlState.selected)
        btnIntraop.addTarget(self, action: #selector(self.btnNoListedTapped(_:)), for: UIControlEvents.touchUpInside)
        TpScrollView.addSubview(btnIntraop)
        
        let lblIntraop            = UILabel(frame:CGRect(x:20+SCREEN_HEIGHT*0.04,y:top,width:SCREEN_WIDTH-(20+SCREEN_HEIGHT*0.04),height:SCREEN_HEIGHT*0.07))
        lblIntraop.text           = "No Listed Events Intra-op"
        lblIntraop.textColor      = color_list_font
        lblIntraop.font           = font_Regular_medium
        TpScrollView.addSubview(lblIntraop)
        
        top                         += lblIntraop.frame.size.height+gap
        
        let imgTemp            = UIImageView(frame:CGRect(x:0,y:top,width:SCREEN_WIDTH,height:SCREEN_HEIGHT*0.07))
        imgTemp.image          = UIImage(named:"strip")
        TpScrollView.addSubview(imgTemp)
        
        let lblTemp            = UILabel(frame:CGRect(x:10,y:top,width:SCREEN_WIDTH-20,height:SCREEN_HEIGHT*0.07))
        lblTemp.text           = "Admission Temperature 98.5"
        lblTemp.textColor      = UIColor.white
        lblTemp.font           = font_bold_large
        TpScrollView.addSubview(lblTemp)
        
        top                          += imgTemp.frame.size.height + gap
   
        
        btnAbove           = UIButton(frame:CGRect(x:10,y:top+SCREEN_HEIGHT*0.07/2-SCREEN_HEIGHT*0.02,width:SCREEN_HEIGHT*0.04,height:SCREEN_HEIGHT*0.04))
        btnAbove.setImage(UIImage(named:"radiobuttonunselec"), for: UIControlState.normal)
        btnAbove.setImage(UIImage(named:"radiobuttonselect"), for: UIControlState.selected)
        btnAbove.tag            = 100
        btnAbove.addTarget(self, action: #selector(self.btnAboveBelowTapped(_:)), for: UIControlEvents.touchUpInside)
        TpScrollView.addSubview(btnAbove)
        
        let lblAbove            = UILabel(frame:CGRect(x:20+SCREEN_HEIGHT*0.04,y:top,width:SCREEN_WIDTH-(20+SCREEN_HEIGHT*0.04),height:SCREEN_HEIGHT*0.07))
        lblAbove.text           = "Above/equal"
        lblAbove.textColor      = color_list_font
        lblAbove.font           = font_Regular_medium
        TpScrollView.addSubview(lblAbove)
        
        top                         += lblAbove.frame.size.height + gap
        
        let lblline3            = UILabel(frame: CGRect(x:0,y:top, width:SCREEN_WIDTH, height:SCREEN_HEIGHT*0.001))
        lblline3.backgroundColor = color_list_font
        TpScrollView.addSubview(lblline3)
        
        
        btnBelow                = UIButton(frame:CGRect(x:10,y:top+SCREEN_HEIGHT*0.07/2-SCREEN_HEIGHT*0.02,width:SCREEN_HEIGHT*0.04,height:SCREEN_HEIGHT*0.04))
         btnBelow.tag            = 101
        btnBelow.setImage(UIImage(named:"radiobuttonunselec"), for: UIControlState.normal)
        btnBelow.setImage(UIImage(named:"radiobuttonselect"), for: UIControlState.selected)
        btnBelow.addTarget(self, action: #selector(self.btnAboveBelowTapped(_:)), for: UIControlEvents.touchUpInside)
        TpScrollView.addSubview(btnBelow)
        
        let lblBelow            = UILabel(frame:CGRect(x:20+SCREEN_HEIGHT*0.04,y:top,width:SCREEN_WIDTH-(20+SCREEN_HEIGHT*0.04),height:SCREEN_HEIGHT*0.07))
        lblBelow.text           = "Below"
        lblBelow.textColor      = color_list_font
        lblBelow.font           = font_Regular_medium
        TpScrollView.addSubview(lblBelow)
        
        top                         += lblBelow.frame.size.height + gap

        let imgPACU            = UIImageView(frame:CGRect(x:0,y:top,width:SCREEN_WIDTH,height:SCREEN_HEIGHT*0.07))
        imgPACU.image          = UIImage(named:"strip")
        TpScrollView.addSubview(imgPACU)
        
        let lblPACU            = UILabel(frame:CGRect(x:10,y:top,width:SCREEN_WIDTH-20,height:SCREEN_HEIGHT*0.07))
        lblPACU.text           = "PACU Direct Handoff"
        lblPACU.textColor      = UIColor.white
        lblPACU.font           = font_bold_large
        TpScrollView.addSubview(lblPACU)
        
        top                          += imgPACU.frame.size.height + gap
        
        btnPerHandOff           = UIButton(frame:CGRect(x:10,y:top+SCREEN_HEIGHT*0.07/2-SCREEN_HEIGHT*0.02,width:SCREEN_HEIGHT*0.04,height:SCREEN_HEIGHT*0.04))
        btnPerHandOff.tag       = 102
        btnPerHandOff.setImage(UIImage(named:"radiobuttonunselec"), for: UIControlState.normal)
        btnPerHandOff.setImage(UIImage(named:"radiobuttonselect"), for: UIControlState.selected)
        btnPerHandOff.addTarget(self, action: #selector(self.btnPACUTapped(_:)), for: UIControlEvents.touchUpInside)
        TpScrollView.addSubview(btnPerHandOff)
        
        let lblPerHandOff            = UILabel(frame:CGRect(x:20+SCREEN_HEIGHT*0.04,y:top,width:SCREEN_WIDTH-(20+SCREEN_HEIGHT*0.04),height:SCREEN_HEIGHT*0.07))
        lblPerHandOff.text           = "Per handoff protocols"
        lblPerHandOff.textColor      = color_list_font
        lblPerHandOff.font           = font_Regular_medium
        TpScrollView.addSubview(lblPerHandOff)
        
        top                         += lblPerHandOff.frame.size.height + gap
        
        let lblline4            = UILabel(frame: CGRect(x:0,y:top, width:SCREEN_WIDTH, height:SCREEN_HEIGHT*0.001))
        lblline4.backgroundColor = UIColor.gray
        TpScrollView.addSubview(lblline4)
        
        
        btnNotPerHandoff           = UIButton(frame:CGRect(x:10,y:top+SCREEN_HEIGHT*0.07/2-SCREEN_HEIGHT*0.02,width:SCREEN_HEIGHT*0.04,height:SCREEN_HEIGHT*0.04))
        btnNotPerHandoff.tag        = 103
        btnNotPerHandoff.setImage(UIImage(named:"radiobuttonunselec"), for: UIControlState.normal)
        btnNotPerHandoff.setImage(UIImage(named:"radiobuttonselect"), for: UIControlState.selected)
        btnNotPerHandoff.addTarget(self, action: #selector(self.btnPACUTapped(_:)), for: UIControlEvents.touchUpInside)
        TpScrollView.addSubview(btnNotPerHandoff)
        
        let lblNotPerHandoff            = UILabel(frame:CGRect(x:20+SCREEN_HEIGHT*0.04,y:top,width:SCREEN_WIDTH-(20+SCREEN_HEIGHT*0.04),height:SCREEN_HEIGHT*0.07))
        lblNotPerHandoff.text           = "Not per handoff protocols"
        lblNotPerHandoff.textColor      = color_list_font
        lblNotPerHandoff.font           = font_Regular_medium
        TpScrollView.addSubview(lblNotPerHandoff)
        
        top                         += lblNotPerHandoff.frame.size.height + gap
        
        let imgAddmission            = UIImageView(frame:CGRect(x:0,y:top,width:SCREEN_WIDTH,height:SCREEN_HEIGHT*0.07))
        imgAddmission.image          = UIImage(named:"strip")
        TpScrollView.addSubview(imgAddmission)
        
        let lblAddmission            = UILabel(frame:CGRect(x:10,y:top,width:SCREEN_WIDTH-20,height:SCREEN_HEIGHT*0.07))
        lblAddmission.text           = "Admission Pain Score"
        lblAddmission.textColor      = UIColor.white
        lblAddmission.font           = font_bold_large
        TpScrollView.addSubview(lblAddmission)
        
        top                          += lblAddmission.frame.size.height+gap
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (SCREEN_WIDTH-20)/11, height: (SCREEN_WIDTH-20)/11)
        layout.scrollDirection      = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collAddmission                = UICollectionView(frame:CGRect(x:10,y:top,width:SCREEN_WIDTH-20,height:SCREEN_HEIGHT*0.05),collectionViewLayout: layout)
        collAddmission.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collAddmission.delegate           = self
        collAddmission.dataSource         = self
        collAddmission.backgroundColor    = UIColor.white
        collAddmission.bounces            = false
        collAddmission.tag                = 1000
        collAddmission.bounces            = false
        TpScrollView.addSubview(collAddmission)
        
        top                             += collAddmission.frame.size.height+gap
        
        
        let imgOSA            = UIImageView(frame:CGRect(x:0,y:top,width:SCREEN_WIDTH,height:SCREEN_HEIGHT*0.07))
        imgOSA.image          = UIImage(named:"strip")
        TpScrollView.addSubview(imgOSA)
        
        let lblOSA            = UILabel(frame:CGRect(x:10,y:top,width:SCREEN_WIDTH-20,height:SCREEN_HEIGHT*0.07))
        lblOSA.text           = "OSA Score"
        lblOSA.textColor      = UIColor.white
        lblOSA.font           = font_bold_large
        TpScrollView.addSubview(lblOSA)
        
        top                          += lblAddmission.frame.size.height+gap
        
        
        let layoutOSA: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutOSA.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutOSA.itemSize = CGSize(width: SCREEN_HEIGHT*0.05, height: SCREEN_HEIGHT*0.05)
        layoutOSA.scrollDirection      = .horizontal
        layoutOSA.minimumInteritemSpacing = 0
        layoutOSA.minimumLineSpacing = 0
        
        let collOSA                = UICollectionView(frame:CGRect(x:10,y:top,width:SCREEN_WIDTH-20,height:SCREEN_HEIGHT*0.05),collectionViewLayout: layoutOSA)
        collOSA.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellOSA")
        collOSA.delegate           = self
        collOSA.dataSource         = self
        collOSA.backgroundColor    = UIColor.white
        collOSA.bounces            = false
        collOSA.tag                = 1002
        TpScrollView.addSubview(collOSA)
        
        top                             += collOSA.frame.size.height+gap
        
        
        let lblline5            = UILabel(frame: CGRect(x:0,y:top, width:SCREEN_WIDTH, height:SCREEN_HEIGHT*0.001))
        lblline5.backgroundColor = UIColor.gray
        TpScrollView.addSubview(lblline5)
        
        top                     +=  gap
        
        let btnOSA           = UIButton(frame:CGRect(x:10,y:top+SCREEN_HEIGHT*0.07/2-SCREEN_HEIGHT*0.02,width:SCREEN_HEIGHT*0.04,height:SCREEN_HEIGHT*0.04))
        btnOSA.setImage(UIImage(named:"radiobuttonunselec"), for: UIControlState.normal)
        btnOSA.setImage(UIImage(named:"radiobuttonselect"), for: UIControlState.selected)
        btnOSA.addTarget(self, action: #selector(self.btnKnownOSAScoreTapped(_:)), for: UIControlEvents.touchUpInside)
        TpScrollView.addSubview(btnOSA)
        
        let lblOSA1            = UILabel(frame:CGRect(x:20+SCREEN_HEIGHT*0.04,y:top,width:SCREEN_WIDTH-(20+SCREEN_HEIGHT*0.04),height:SCREEN_HEIGHT*0.07))
        lblOSA1.text           = "Known OSA,Previously Diagnosed"
        lblOSA1.textColor      = color_list_font
        lblOSA1.font           = font_Regular_medium
        TpScrollView.addSubview(lblOSA1)
        
        top                     += lblOSA.frame.size.height + gap
        
        let lblline6            = UILabel(frame: CGRect(x:0,y:top, width:SCREEN_WIDTH, height:SCREEN_HEIGHT*0.001))
        lblline6.backgroundColor = UIColor.gray
        TpScrollView.addSubview(lblline6)

        
        let btnAdvance           = UIButton(frame:CGRect(x:0,y:top,width:SCREEN_WIDTH,height:SCREEN_HEIGHT*0.07))
        btnAdvance.setTitle("Advanced Options", for: UIControlState.normal)
        btnAdvance.titleLabel?.font = font_bold_large
        btnAdvance.setTitleColor(.white, for: UIControlState.normal)
        btnAdvance.backgroundColor = color_blue
        btnAdvance.addTarget(self, action: #selector(self.btnAdvancedTapped(_:)), for: UIControlEvents.touchUpInside)
        TpScrollView.addSubview(btnAdvance)
        
        top                     += btnAdvance.frame.size.height
        
        
        
        TpScrollView.contentSize = CGSize(width:SCREEN_WIDTH,height:top)
        
        
    }
    
    
    //MARK: methods.....
    @IBAction func btnBackTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to save?" as String?, preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "No", style: .default) { (action) -> Void in
            self.navigationController!.popViewController(animated: true)
        }
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) -> Void in
  
            let userID      = defaults.value(forKey: kAPP_UserId) as! String!
            dictQI          = NSMutableDictionary()
            dictSlectedQI   = NSMutableDictionary()
            dictSlectedQI     = ["Attestation of Current medications documented in the medical record (Based on resources available)":self.strAttestation,"No listed Events Intra-op":self.strNoListed,"Admission Temperature 98.5":self.strTemp,"PACU Direct Handoff":self.strPACU,"Admission Pain Score":self.strAdmissionPain,"OSA Score":self.strOSAScore,"Known OSA,Previously Diagnosed":self.strKnownOSA]
            
            dictQI = [
                "user_id" : userID!
                ,"qi_measures" :dictSlectedQI
                ,"record_id":recordId
            ]            
            self.QIService(dict: dictQI)
        }
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
    
    }
    
    
    @IBAction func btnAdvancedTapped(_ sender: UIButton) {
        let userID      = defaults.value(forKey: kAPP_UserId) as! String!
        dictQI          = NSMutableDictionary()
        dictSlectedQI   = NSMutableDictionary()
        dictSlectedQI     = ["Attention of current medications documented in the medical record(based on record available)":strAttestation,"No listed Events Intra-op":strNoListed,"Admission Temperature 98.5":self.strTemp,"PACU Direct Handoff":self.strPACU,"Admission Pain Score":strAdmissionPain,"OSA Score":strOSAScore,"Known OSA,Previously Diagnosed":strKnownOSA]
        
        dictQI = [
            "user_id" : userID!
            ,"qi_measures" :dictSlectedQI
            ,"record_id":recordId
        ]
      
         QIService(dict: dictQI)
        
    }
    
    @IBAction func btnEditTapped(_ sender: UIButton) {
        let popOverVC         = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddPopUpVC") as! AddPopUpVC
        self.addChildViewController(popOverVC)
        popOverVC.view.frame  = self.view.frame
        popOverVC.strRecordId = recordId
        popOverVC.page        = "8"
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    @IBAction func btnAboveBelowTapped(_ sender: UIButton) {
        
        if sender.tag == 100 {
            btnAbove.isSelected = true
            btnBelow.isSelected = false
            strTemp        = "Above/Equal"
            
        }else{
            
            btnAbove.isSelected = false
            btnBelow.isSelected = true
            strTemp        = "Below"
        }
    }
    
    @IBAction func btnNoListedTapped(_ sender: UIButton) {
        
        if sender.isSelected == true {
            sender.isSelected = false
            strNoListed       = "no"
        }else{
            sender.isSelected = true
            strNoListed       = "yes"
        }
        
    }
    
    @IBAction func btnAttestationTapped(_ sender: UIButton) {
        
        if sender.isSelected == true {
            sender.isSelected = false
            strAttestation    = "no"
        }else{
            sender.isSelected = true
            strAttestation    = "yes"
        }
        
    }
    
//    @IBAction func btnTemparatureTapped(_ sender: UIButton) {
//        
//        if sender.tag == 100 {
//            btnAbove.isSelected = true
//            btnBelow.isSelected = false
//            strAboveTemp        = "yes"
//            strBelowTemp        = "no"
//        }else{
//           
//            btnAbove.isSelected = false
//            btnBelow.isSelected = true
//            strAboveTemp        = "no"
//            strBelowTemp        = "yes"
//        }
//        
//    }
    
    @IBAction func btnPACUTapped(_ sender: UIButton) {
        
        if sender.tag == 102 {
            btnPerHandOff.isSelected    = true
            btnNotPerHandoff.isSelected = false
            strPACU                     = "Per Handoff Protocols"
           
        }else{
            btnPerHandOff.isSelected    = false
            btnNotPerHandoff.isSelected = true
           strPACU                      = "Not per handoff protocols"
        }
        
    }
    @IBAction func btnEnableTapped(_ sender: UIButton) {
        
        if sender.isSelected == true {
            sender.isSelected = false
           // strPACU           = "no"
        }else{
            sender.isSelected = true
            //strPACU           = "yes"
        }
        
    }
 
    @IBAction func btnKnownOSAScoreTapped(_ sender: UIButton) {
        
        if sender.isSelected == true {
            sender.isSelected = false
            strKnownOSA       = "no"
        }else{
            sender.isSelected = true
            strKnownOSA       = "yes"
        }
        
    }

    
    //MARK:collectionview delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1000 {
            return arrAddmission.count
        }else if collectionView.tag == 1001
        {
           return arrPhysical.count
        }
        else{
            return arrOSA.count
            
        }
        
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView.tag == 1000 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        
        let lblCount            = UILabel(frame:CGRect(x:0,y:0,width:(SCREEN_WIDTH-20)/11,height:(SCREEN_WIDTH-20)/11))
        
        lblCount.text          = arrAddmission.object(at: indexPath.row) as? String
      
        lblCount.textColor      = color_list_font
        lblCount.font           = font_Regular_medium
        lblCount.textAlignment  = NSTextAlignment.center
        cell.addSubview(lblCount)
        cell.backgroundColor    = UIColor.white
        cell.layer.borderWidth = SCREEN_HEIGHT*0.001
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        // cell.backgroundColor = UIColor.orange
        return cell
            
        }else if collectionView.tag == 1001
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellNew", for: indexPath as IndexPath)
            
            let lblCount            = UILabel(frame:CGRect(x:0,y:0,width:SCREEN_HEIGHT*0.05,height:SCREEN_HEIGHT*0.05))
            
            lblCount.text          = arrPhysical.object(at: indexPath.row) as? String
            
            lblCount.textColor      = color_list_font
            lblCount.font           = font_Regular_medium
            lblCount.textAlignment  = NSTextAlignment.center
            cell.addSubview(lblCount)
            cell.backgroundColor    = UIColor.white
            cell.layer.borderWidth = SCREEN_HEIGHT*0.001
            cell.layer.borderColor = UIColor.lightGray.cgColor
            
            // cell.backgroundColor = UIColor.orange
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellOSA", for: indexPath as IndexPath)
            
            let lblCount            = UILabel(frame:CGRect(x:0,y:0,width:SCREEN_HEIGHT*0.05,height:SCREEN_HEIGHT*0.05))
            
            lblCount.text          = arrOSA.object(at: indexPath.row) as? String
            
            lblCount.textColor      = color_list_font
            lblCount.font           = font_Regular_medium
            lblCount.textAlignment  = NSTextAlignment.center
            cell.addSubview(lblCount)
            cell.backgroundColor    = UIColor.white
            cell.layer.borderWidth = SCREEN_HEIGHT*0.001
            cell.layer.borderColor = UIColor.lightGray.cgColor
            
            // cell.backgroundColor = UIColor.orange
            return cell

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 1000 {
        strAdmissionPain = String(format:"%@",arrAddmission.object(at: indexPath.row) as! CVarArg)
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.backgroundColor = UIColor.darkGray
            
        }else if collectionView.tag == 1001{
        strASAPhysician = String(format:"%@",arrPhysical.object(at: indexPath.row) as! CVarArg)
        }else{
        strOSAScore = String(format:"%@",arrOSA.object(at: indexPath.row) as! CVarArg)
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.backgroundColor = UIColor.darkGray

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1000 {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.backgroundColor = UIColor.clear
            
        }else if collectionView.tag == 1001{
            strASAPhysician = String(format:"%@",arrPhysical.object(at: indexPath.row) as! CVarArg)
        }else{
            strOSAScore = String(format:"%@",arrOSA.object(at: indexPath.row) as! CVarArg)
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.backgroundColor = UIColor.clear
            
        }
    }
    
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
          if collectionView.tag == 1000 {
            
                return CGSize(width:(SCREEN_WIDTH-20)/11, height:(SCREEN_WIDTH-20)/11)
            
          }
          else{
                return CGSize(width:SCREEN_HEIGHT*0.05, height:SCREEN_HEIGHT*0.05)
            }
    }

    //QIService webservice
    func QIService(dict:NSDictionary)
    {
        obj.ShowHud()
        
        Alamofire.request("\(web_SERWERURL)\(saveQIUrl)", method: .post, parameters:dict as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
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
                        
                        let storyBoard : UIStoryboard   = UIStoryboard(name: "Main", bundle:nil)
                        let vc                          = storyBoard.instantiateViewController(withIdentifier: "NPAdvanceQIVC") as! NPAdvanceQIVC
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
