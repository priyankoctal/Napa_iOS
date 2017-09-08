//
//  NPProcedureVC.swift
//  NAPA BILLING
//
//  Created by Admin on 11/05/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class NPProcedureVC: UIViewController {

    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var txtICDThree: UITextField!
    @IBOutlet var txtICDTwo: UITextField!
    @IBOutlet var txtICDFour: UITextField!
    @IBOutlet var txtICDone: UITextField!
    @IBOutlet var btnMod3: UIButton!
    @IBOutlet var btnMod2: UIButton!
    @IBOutlet var btnMod1: UIButton!
    @IBOutlet var txtCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtCode.setLeftPaddingPoints(10)
        txtCode.font               = font_Regular
        obj.roundedTextField(txtCode)
        
        txtICDone.setLeftPaddingPoints(10)
        txtICDone.font             = font_Regular
        obj.roundedTextField(txtICDone)

        txtICDTwo.setLeftPaddingPoints(10)
        txtICDTwo.font             = font_Regular
        obj.roundedTextField(txtICDTwo)
        
        txtICDThree.setLeftPaddingPoints(10)
        txtICDThree.font             = font_Regular
        obj.roundedTextField(txtICDThree)
        
        txtICDFour.setLeftPaddingPoints(10)
        txtICDFour.font             = font_Regular
        obj.roundedTextField(txtICDFour)
        
        obj.roundedButton(btnMod1)
        obj.roundedButton(btnMod2)
        obj.roundedButton(btnMod1)

        btnMod1.layer.borderWidth     = 0.50
        btnMod1.layer.borderColor     = UIColor.lightGray.cgColor
        btnMod1.imageEdgeInsets       = UIEdgeInsetsMake(0, btnMod1.frame.size.width, 0, 0)
        btnMod1.titleEdgeInsets       = UIEdgeInsetsMake(0, -10, 0, 0)
        btnMod1.titleLabel?.font      = font_Regular
        
        btnMod2.layer.borderWidth   = 0.50
        btnMod2.layer.borderColor   = UIColor.lightGray.cgColor
        btnMod2.imageEdgeInsets     = UIEdgeInsetsMake(0, btnMod2.frame.size.width, 0, 0)
        btnMod2.titleEdgeInsets     = UIEdgeInsetsMake(0, -10, 0, 0)
        btnMod2.titleLabel?.font    = font_Regular
        
        btnMod3.layer.borderWidth   = 0.50
        btnMod3.layer.borderColor   = UIColor.lightGray.cgColor
        btnMod3.imageEdgeInsets     = UIEdgeInsetsMake(0, btnMod3.frame.size.width, 0, 0)
        btnMod3.titleEdgeInsets     = UIEdgeInsetsMake(0, -10, 0, 0)
        btnMod3.titleLabel?.font    = font_Regular


        // Do any additional setup after loading the view.
    }
    @IBAction func btnAddTapped(_ sender: UIButton) {
    }

    @IBAction func btnModTwoTapped(_ sender: UIButton) {
    }
    @IBAction func btnBackTapped(_ sender: UIButton) {
         self.navigationController!.popViewController(animated: true)
    }
    @IBAction func btnModeOneTapped(_ sender: UIButton) {
    }
    @IBAction func btnModThreeTapped(_ sender: UIButton) {
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
