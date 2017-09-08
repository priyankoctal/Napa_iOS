//
//  NPTakePicVC.swift
//  NAPA BILLING
//
//  Created by Admin on 19/04/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire

class NPTakePicVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
  var strRecordId:String!
  @IBOutlet var txtTitle: UITextField!
  @IBOutlet var imgPic: UIImageView!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        txtTitle.font                = font_bold_large
        txtTitle.setBottomBorder(borderColor: UIColor.lightGray)
        // Do any additional setup after loading the view.
    }

//MARK: methods.....
@IBAction func btnBackTapped(_ sender: UIButton) {
        txtTitle.resignFirstResponder()
        if (!(txtTitle.text?.isEmpty)! && imgPic.image != nil){
            let alert:UIAlertController=UIAlertController(title: "Are you sure you want to save?", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            let saveAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
            {
                UIAlertAction in
                self.txtTitle.resignFirstResponder()
                self.UploadImageServiceCall(image: self.imgPic.image!)
            }
            let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel)
            {
                UIAlertAction in
                
                 self.navigationController!.popViewController(animated: true)
                
            }
            
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        }else{
            self.navigationController!.popViewController(animated: true)
        }

}
    
    
@IBAction func btnEditTapped(_ sender: UIButton) {
        let popOverVC         = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddPopUpVC") as! AddPopUpVC
        self.addChildViewController(popOverVC)
        popOverVC.view.frame  = self.view.frame
        popOverVC.strRecordId = recordId
        popOverVC.page        = "18"
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
}
    
@IBAction func btnCameraTapped(_ sender: UIButton) {
        openCamera()
}
    
@IBAction func btnRetakeTapped(_ sender: UIButton) {
        
}
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
         self.UploadImageServiceCall(image:imgPic.image!)
    }
    
    func openCamera()
    {
        // Add the actions
        imagePicker.delegate = self
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }
        else
        {

            appDelegate.alertShow(_objVC: self, msgString: "You don't have camera")
        }
    }
    
    //PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:  [String : Any])
    {
        
        if (info[UIImagePickerControllerReferenceURL] as? NSURL) != nil
        {
         //   let pickedURLs = info[UIImagePickerControllerReferenceURL] as? NSURL
            
          //  let fileName = NSString(string:"\(pickedURLs)").lastPathComponent
        }
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        imgPic.image = pickedImage
        picker .dismiss(animated: true, completion: nil)
        
       
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        // println("picker cancel.")
    }
    
    func UploadImageServiceCall(image :UIImage)
    {
        obj.ShowHud()
        let strAPI              = web_SERWERURL + "image_add"
        PostData                = ["user_id":(defaults.value(forKey: kAPP_UserId) as! String?)!,"record_id":recordId,"image_name":txtTitle.text!]
        let dict                = PostData as NSDictionary
        let imageData           = UIImageJPEGRepresentation(image, 0.6)
        let jsonData            = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        
        // convert json data to json string
//        let jsonString           = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString)
        let url = try! URLRequest(url: URL(string:strAPI)!, method: .post, headers: nil)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData!, withName: "files", fileName: "pic.png", mimeType: "image/png")
                multipartFormData.append(jsonData, withName: "data")
                
        },
            with: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        obj.HideHud()
                        if((response.result.value) != nil) {
                            let dict = response.result.value as! NSDictionary
                            print("dict=%",dict)
                             self.navigationController!.popViewController(animated: true)
                          //  self.arrAttachment.setValue(dict.value(forKey: "upload_filename"), forKey: "filename")
                            
                        }
                    }
                case .failure( _):
                    obj.HideHud()
                    break
                    
                }
        }
        )
        
    }

    
    //MARK: textfield delegate.....
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField .resignFirstResponder()
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
