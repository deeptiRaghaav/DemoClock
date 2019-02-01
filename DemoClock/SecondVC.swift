//
//  SecondVC.swift
//  DemoClock
//
//  Created by TribondInfosystems on 21/12/18.
//  Copyright © 2018 Deepti. All rights reserved.
//

import UIKit
import  EventKit


class SecondVC: UIViewController,UITextFieldDelegate,UITextViewDelegate {

         var eventStore : EKEventStore = EKEventStore()
        @IBOutlet weak var btnSave: UIButton!
        @IBOutlet weak var txtVDescription: UITextView!
        @IBOutlet weak var txtFTitle: UITextField!
        @IBOutlet weak var txtFMail: UITextField!
        private var notePlaceholder: UILabel!
        var events = Array<EKEvent>()
        override func viewDidLoad() {
        super.viewDidLoad()
                notePlaceholder = UILabel()
                notePlaceholder.text = "Enter Description for leave"
                txtVDescription.addPlaceholder(notePlaceholder)
               // txtVDescription.placeholderText = "Enter Description for leave"
        // Do any additional setup after loading the view.
    }
    
        @IBAction func btnbackClick(_ sender: Any) {
                self.navigationController?.popViewController(animated: true)
        }
        @IBAction func btnSaveClick(_ sender: Any) {
                if self.txtFMail.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).length <= 0
                {
                        DesignManager.showAlert(title:"" , message: "Please enter email address", vc: self)
                }
                        
                else if CommonMethod.isValidEmail(emailStr: self.txtFMail.text!) == false
                {
                        DesignManager.showAlert(title:"" , message: "Please enter valid email address", vc: self)
                }
                else if self.txtFTitle.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).length <= 0
                {
                        DesignManager.showAlert(title:"" , message: "Please enter title for leave", vc: self)
                }
                else if self.txtVDescription.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).length <= 0
                {
                        DesignManager.showAlert(title:"" , message: "Please enter Description for leave", vc: self)
                }
                else
                {
                        var strSuccessEventdate = ""
                        var strfailEventdate = ""
                        for event in events
                        {
                                var attendees = [EKParticipant]()
                                if let attendee = self.createParticipant(email: self.txtFMail.text!) {
                                        attendees.append(attendee)
                                }
                                event.setValue(attendees, forKey: "attendees")
                                //event.setValue(attendees, forKey: "attendees")
                                event.title = self.self.txtFTitle.text
                                event.notes = self.self.txtVDescription.text
                                print("event before save ", event)
                                
                                do {
                                        try self.eventStore.save(event, span:.futureEvents , commit: true)
                                        strSuccessEventdate.append("\(event.endDate) \n  )")
                                } catch let error as NSError {
                                        print("failed to save event with error : \(error)")
                                        strfailEventdate.append("event of date \(String(describing: event.endDate)) failed  \n ")
                                        //  DesignManager.showAlert(title: "fail", message: "failed to save event with error : \(error)", vc: self)
                                }
                        }
                        var strMessage = ""
                        if strSuccessEventdate != ""
                        {
                         strMessage = "Event of date \(strSuccessEventdate) saved"
                        }
                        if strfailEventdate != ""
                        {
                             strMessage.append("Event of date \(strfailEventdate) failed ")
                        }
                        //DesignManager.showAlert(title: "", message: strMessage, vc: self)
                        let alert = UIAlertController(title: "", message: "event saved ", preferredStyle: UIAlertController.Style.alert)
                        
                          let action = UIAlertAction(title: "Ok", style:.default , handler: { (UIAlertAction) in
                                
                              self.navigationController?.popViewController(animated: true)
                                
                        })
                                
                        alert.addAction(action)
                        
                        self.present(alert, animated: false, completion: nil)
                       
                }
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                textField.resignFirstResponder()
                return true
        }
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
                if(text == "\n") {
                        textView.resignFirstResponder()
                        return false
                }
                return true
        }
        private func createParticipant(email: String) -> EKParticipant? {
                let clazz: AnyClass? = NSClassFromString("EKAttendee")
                if let type = clazz as? NSObject.Type {
                        let attendee = type.init()
                        attendee.setValue(email, forKey: "emailAddress")
                        return attendee as? EKParticipant
                }
                return nil
        }
        func textViewDidChange(_ textView: UITextView) {
                textView.updateVisibility(notePlaceholder)
              
        }
 

}
