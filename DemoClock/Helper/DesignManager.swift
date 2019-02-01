//
//  DesignManager.swift
//  DemoClock
//
//  Created by TribondInfosystems on 20/12/18.
//  Copyright © 2018 Deepti. All rights reserved.
//

import UIKit

class DesignManager: NSObject {

       static func showAlert(title:String, message:String , vc:UIViewController)  {
                let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                
                let alertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (UIAlertAction) in
                        
                }
                alert.addAction(alertAction)
                
                vc.present(alert, animated: true, completion: nil)
               // self.present(alert, animated: true, completion: nil)
        }
}
