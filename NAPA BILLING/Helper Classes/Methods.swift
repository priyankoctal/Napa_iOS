//
//  Methods.swift
//  Meya
//
//  Created by Eway on 12/09/16.
//  Copyright © 2016 Deepak Vaishnav. All rights reserved.
//

import UIKit
import Alamofire

let NaviGationColor = UIColor(red: 33.0/255.0, green: 27.0/255.0, blue: 107.0/255.0, alpha: 1.0)
let color_graylight = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0)
let color_blue = UIColor(red: 26.0/255.0, green: 54.0/255.0, blue: 101.0/255.0, alpha: 1.0)

extension UITextField
{
    func setBottomBorder(borderColor: UIColor)
    {
        
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        let width = 1.0
        
        let borderLine = UIView()
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - width, width: Double(SCREEN_WIDTH), height: width)
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setLeftPaddingWithImage(_ amount:CGFloat, _ imgname:String) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        let imgView = UIImageView(frame:CGRect(x: 5, y: self.frame.size.height/2 - 12, width: 24, height: 24))
        imgView.image = UIImage.init(named: imgname)
        paddingView.addSubview(imgView)
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}



class Methods: NSObject,UITextFieldDelegate {
    
    
    var imageCache = NSCache<AnyObject, AnyObject>()
     var imageURL  = String()
    var imageviews = UIImageView()
    var label = UILabel()
    let prefs = UserDefaults.standard
    
    
    func viewBorder(_ view:UIView)
    {
        
        view.layer.borderWidth = 0.50
        view.layer.cornerRadius = 5.0
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.lightGray.cgColor
        
    }

    // MARK: Rounded Image

    func roundedimage(_ images:UIImageView)
    {
        images.layer.cornerRadius = images.frame.width/2
        images.clipsToBounds = true
        
    }
     // MARK: Rounded Button
    func roundedButton(_ Button:UIButton)
    {
        Button.layer.cornerRadius = 5.0
        Button.clipsToBounds = true
        
    }
    
    // MARK: Rounded Button
    func roundedTextField(_ TextField:UITextField)
    {
        TextField.layer.cornerRadius = 5.0
        TextField.clipsToBounds = true
        TextField.layer.borderWidth = 0.50
        TextField.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
     // MARK: Rounded Label
    func roundedLabel(_ label:UILabel)
    {
        label.layer.cornerRadius = label.frame.width/2
        label.clipsToBounds = true
        
    }
    func CircleLabel(_ label:UILabel)
    {
        label.layer.cornerRadius = label.frame.width/2
        label.clipsToBounds = true
        
    }
    func setplaceHoldertextUserName(_ text:String,textField:UITextField)
    {
        
        let attrString = NSAttributedString (
            string: text,
            attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        textField.attributedPlaceholder = attrString
        textField.delegate = self
        textField.textColor = UIColor.black
        textField.resignFirstResponder()
    }
    
     // MARK: Placeholder text
    func setplaceHoldertext(_ text:String,textField:UITextField)
    {
        let attrString = NSAttributedString (
            string: text,
            attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        textField.attributedPlaceholder = attrString
        textField.delegate = self
        textField.textColor = UIColor.black
        textField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func ButtonBorder(_ view:UIButton)
    {
        
        view.layer.borderWidth = 0.80
        view.layer.cornerRadius = 4.0
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.white.cgColor
        
    }

    func applyBlurEffect(_ image: UIImage){
        let imageToBlur = CIImage(image: image)
        let blurfilter = CIFilter(name: "CIGaussianBlur")
        blurfilter!.setValue(5, forKey: kCIInputRadiusKey)
        blurfilter!.setValue(imageToBlur, forKey: "inputImage")
        let resultImage = blurfilter!.value(forKey: "outputImage") as! CIImage
        var blurredImage = UIImage(ciImage: resultImage)
        let cropped:CIImage=resultImage.cropping(to: CGRect(x: 0, y: 0,width: imageToBlur!.extent.size.width, height: imageToBlur!.extent.size.height))
        blurredImage = UIImage(ciImage: cropped)
        self.imageviews.image = blurredImage
    }
    
 // MARK: NSUserDefault
    
    func Save(_ str:String,keyname:String)
    {
        prefs.setValue(str, forKey: keyname)
        prefs.synchronize()
    }
    
    func Retrive(_ str:String)-> AnyObject
    {
       let retrivevalue =  prefs.value(forKey: str)
        
        if retrivevalue != nil
        {
            return retrivevalue! as AnyObject
        }
        return "" as AnyObject
    }
    
    func RemoveKey(_ str:String)
    {
        prefs.removeObject(forKey: str)
    }
    

    
    func alertemptyNewRemove(_ view:UIView)
    {
        
        
       // view.removeFromSuperview()
        label.willRemoveSubview(view)
    }
    
    
    func ShowHud()
    {
        ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
            //print("Showed with completion block")
        }
    }
    
    func HideHud()
    {
        ARSLineProgress.hideWithCompletionBlock({ () -> Void in
          //  print("Hidden with completion block")
        })
    }

    
    
    func Imageloading(str_Url:String,image:UIImageView)
{
  //  let remoteUrl : NSURL? = NSURL(string: str_Url)
    
   // manager.loadImage(with: (remoteUrl! as NSURL) as URL, into: image)
    }
 
//MARK: validation.....
 //MARK: validate email
func validateEmail(_ enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
}

//MARK: Alert view
func alertShow(_objVC:UIViewController,msgString:String){
        
        let alertController = UIAlertController(title: "Alert", message: msgString as String?, preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "Ok", style: .default) { (action) -> Void in
            print("The user is not okay.")
        }
        
        alertController.addAction(noAction)
        
        _objVC.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: Check Empty Screen
    func checkEmptyString(str:NSString?)->NSString
    {
        var strEmpty = str;
        if strEmpty?.length == 0 || strEmpty == nil || strEmpty!.isEqual(NSNull.self)
        {
            strEmpty = ""
        }
        return strEmpty!
    }

    
    
    
}
