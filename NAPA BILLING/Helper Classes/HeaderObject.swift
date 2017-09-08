//
//  HeaderObject.swift
//  PickPack
//
//  Created by Octal on 26/12/16.
//  Copyright © 2016 Octal. All rights reserved.
//

import Foundation
import UIKit


let appDelegate     = UIApplication.shared.delegate as! AppDelegate
let SCREEN_WIDTH    = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT   = UIScreen.main.bounds.size.height
let color_nav       = UIColor(red: 48.0/255.0, green: 155.0/255.0, blue: 59.0/255.0, alpha: 1.0)
let color_status    = UIColor(red: 40.0/255.0, green: 134.0/255.0, blue: 52.0/255.0, alpha: 1.0)
let color_tabbar    = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)

let color_list_font    = UIColor(red: 72.0/255.0, green: 73.0/255.0, blue: 75.0/255.0, alpha: 1.0)
let color_blue_font    = UIColor(red: 117.0/255.0, green: 185.0/255.0, blue: 231.0/255.0, alpha: 1.0)


let font_bold_small     = UIFont(name: "Helvetica-Bold", size: SCREEN_HEIGHT*0.016)
let font_bold           = UIFont(name: "Helvetica-Bold", size: SCREEN_HEIGHT*0.020)
let font_bold_medium    = UIFont(name: "Helvetica-Bold", size: SCREEN_HEIGHT*0.024)
let font_bold_list     = UIFont(name: "Helvetica-Bold", size: SCREEN_HEIGHT*0.026)
let font_bold_large     = UIFont(name: "Helvetica-Bold", size: SCREEN_HEIGHT*0.028)
let font_bold_largeto   = UIFont(name: "Helvetica-Bold", size: SCREEN_HEIGHT*0.032)
let font_bold_Exlarge   = UIFont(name: "Helvetica-Bold", size: SCREEN_HEIGHT*0.040)

let font_Regular_small     = UIFont(name: "Roboto-Regular", size: SCREEN_HEIGHT*0.014)
let font_Regular           = UIFont(name: "Roboto-Regular", size: SCREEN_HEIGHT*0.020)
let font_Regular_medium    = UIFont(name: "Roboto-Regular", size: SCREEN_HEIGHT*0.024)
let font_reguler_list      = UIFont(name: "Roboto-Regular", size: SCREEN_HEIGHT*0.026)
let font_Regular_large     = UIFont(name: "Roboto-Regular", size: SCREEN_HEIGHT*0.028)
let font_Regular_largeto   = UIFont(name: "Roboto-Regular", size: SCREEN_HEIGHT*0.032)
let font_Regular_Exlarge   = UIFont(name: "Roboto-Regular", size: SCREEN_HEIGHT*0.040)

let obj = Methods()

let kAPPIS_REMEMBER  = "Remember"
let kAPP_EMAIL       = "email"
let kAPP_PASS        = "password"
let kAPP_UserId      = "user_id"
let kAPP_Name        = "name"
let kAPP_ACC_TYPE    = "user_account_type"
let kAPP_FNAME       = "user_first_name"
let kAPP_LNAME       = "user_last_name"
let kAPP_SUBSCRIBE   = "subscription"
let kAPP_PROFILE     = "user_profile_image"
let kAPP_PARENTID    = "parent_user_id"
let kAPP_USERTYPE    = "user_type"

let defaults         = UserDefaults.standard

//webservice url
let web_SERWERURL   = "http://192.168.1.83/projects/coding_system/Api/"

//let web_SERWERURL   = "http://stage.ariscoding.napacloud.net/Api/"
let loginUrl        = "login"
let PatintListUrl   = "home"
let reopenUrl       = "reopen_record"
let cancelUrl       = "cancel_record"
let imageListUrl    = "images_list"
let deleteImageUrl  = "images_delete"
let addNotes        = "add_notes"
let getNotesUrl     = "get_notes"
let chargeListUrl   = "all_list"
let saveQIUrl       = "save_qi"
let locationUrl     = "locations"
let addPatientUrl   = "add_patient"
let saveChargeUrl   = "save_charge"
let invaishiveUrl   = "save_invasive_charge"
