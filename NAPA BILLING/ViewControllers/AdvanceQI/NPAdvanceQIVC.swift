//
//  NPAdvanceQIVC.swift
//  NAPA BILLING
//
//  Created by Admin on 19/04/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class NPAdvanceQIVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var arrQI:NSArray!
  @IBOutlet var tblQI: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        arrQI                   = ["Airway/Respiratory","Cardiovascular","Neurologic","Regional","Procedural","Pharmacy/Blood Bank","Morbidity/Mortality","Compliance","Patient Safety"]
        tblQI.delegate          = self
        tblQI.dataSource        = self
        tblQI.tableFooterView   = UIView()
        
        // Do any additional setup after loading the view.
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
        popOverVC.page        = "9"
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
 
    
    //MARK: tableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrQI.count
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell                        = tblQI.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text            = arrQI.object(at: indexPath.row) as? String
        cell.textLabel?.font            = font_bold_list
        cell.textLabel?.textColor       = color_list_font
        cell.accessoryType              = UITableViewCellAccessoryType.disclosureIndicator
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset             = UIEdgeInsets.zero
        cell.layoutMargins              = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row==0 {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "NPAirwaysVC") as! NPAirwaysVC
                self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "NPCardiaoQIVC") as! NPCardiaoQIVC
            self.navigationController?.pushViewController(vc, animated: true)

        }else if indexPath.row == 2
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "NPNeurologicVC") as! NPNeurologicVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 3
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "NPRegionalVC") as! NPRegionalVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 4
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "NPProcuduralVC") as! NPProcuduralVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 5
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "NPPharmacyVC") as! NPPharmacyVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 6
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "NPMorbidityVC") as! NPMorbidityVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 7
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "NPComplianceVC") as! NPComplianceVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 8
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "NPPatientSafetyVC") as! NPPatientSafetyVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
      
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_HEIGHT*0.07;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView()
        viewHeader.frame = CGRect(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT*0.07)
        
        let lblName            = UILabel(frame:CGRect(x:10,y:0,width:SCREEN_WIDTH-20,height:SCREEN_HEIGHT*0.07))
        lblName.text           = appDelegate.checkEmptyString(str: strPatientName as NSString?) as String
        lblName.textColor      = UIColor.darkText
        lblName.textAlignment  =  NSTextAlignment.center
        lblName.font           = font_bold_Exlarge
        viewHeader.addSubview(lblName)
        let lblline            = UILabel(frame: CGRect(x:0, y:SCREEN_HEIGHT*0.069, width:SCREEN_WIDTH, height:SCREEN_HEIGHT * 0.001))
        lblline.backgroundColor = UIColor.lightGray
        viewHeader.addSubview(lblline)
        
        return viewHeader
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SCREEN_HEIGHT*0.07
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
