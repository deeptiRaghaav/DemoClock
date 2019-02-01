//
//  ViewController.swift
//  DemoClock
//
//  Created by TribondInfosystems on 18/12/18.
//  Copyright © 2018 Deepti. All rights reserved.
//

import UIKit
import FSCalendar
import  EventKit
import MessageUI


class ViewController: UIViewController , FSCalendarDataSource, FSCalendarDelegate,UITextFieldDelegate,MFMailComposeViewControllerDelegate
{
        @IBOutlet weak var btnCalendar: UIButton!
        @IBOutlet weak var btnSubmit: UIButton!
        @IBOutlet weak var txtFEmail: UITextField!
        let eventStore : EKEventStore = EKEventStore()
        var vieww:UIView = UIView(frame: UIScreen.main.bounds)
        private weak var calendar: FSCalendar!
        var events = Array<EKEvent>()
        override func viewDidLoad() {
                super.viewDidLoad()
               
                btnCalendar.layer.borderColor = UIColor.black.cgColor
                btnCalendar.layer.borderWidth = 1
                btnCalendar.layer.cornerRadius = 5
                txtFEmail.layer.borderColor = UIColor.black.cgColor
                txtFEmail.layer.borderWidth = 1
                txtFEmail.layer.cornerRadius = 5
                // Do any additional setup after loading the view, typically from a nib.
        }

        @IBAction func btnCalenderClick(_ sender: UIButton) {
                events = Array<EKEvent>()
                txtFEmail.resignFirstResponder()
                vieww.backgroundColor = UIColor.groupTableViewBackground
                //self.view = vieww
                 //let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 400 : 300
                let calendar = FSCalendar(frame: CGRect(x:0, y: 200, width: self.view.bounds.width, height: self.view.frame.height/2 ))
                calendar.dataSource = self
                calendar.delegate = self
                calendar.backgroundColor = UIColor.white
                calendar.allowsMultipleSelection = true
                let btn = UIButton(frame: CGRect(x: 80, y: Int(calendar.frame.origin.y + calendar.frame.size.height + 20.0) , width: Int(view.frame.width/3)  , height: 50))
                btn.backgroundColor = UIColor.lightGray
                
                btn.setTitle("Done", for: .normal)
                 btn.addTarget(self, action: #selector(btnDoneInCalendarClick(_:)) , for: .touchUpInside)
                let btnCancel = UIButton(frame: CGRect(x: Int(80 + btn.frame.width + 20), y: Int(calendar.frame.origin.y + calendar.frame.size.height + 20.0) , width: Int(view.frame.width/3)  , height: 50))
                btnCancel.backgroundColor = UIColor.lightGray
                
                btnCancel.setTitle("Cancel", for: .normal)
                btnCancel.addTarget(self, action: #selector(btnCancelInCalendarClick(_:)) , for: .touchUpInside)
                self.vieww.addSubview(btnCancel)
                self.vieww.addSubview(btn)
                self.vieww.addSubview(calendar)
                self.view.addSubview(vieww)
                
                self.calendar = calendar
               
                
        }
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
                if monthPosition == .previous || monthPosition == .next {
                        calendar.setCurrentPage(date, animated: true)
                }
        }
        
        @IBAction func btnSubmitClick(_ sender: UIButton) {
                if txtFEmail.text?.count != 0
                {
                
                        if events.count != 0
                        {
                                var strSuccessEventdate = ""
                                var strfailEventdate = ""
                                for event in events
                                {
                                        var attendees = [EKParticipant]()
                                        if let attendee = self.createParticipant(email: self.txtFEmail.text!) {
                                                 attendees.append(attendee)
                                        }
                                        event.setValue(attendees, forKey: "attendees")
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
                                DesignManager.showAlert(title: "", message: "Event of date \(strSuccessEventdate) saved , Event of date \(strfailEventdate) failed ", vc: self)
                        }
                        else
                        {
                                  DesignManager.showAlert(title: "error", message: "please select event date", vc: self)
                        }
               
                }
                else
                {
                         DesignManager.showAlert(title: "error", message: "please enter email", vc: self)
                }
                
          
                
//                var emailTitle = "Feedback"
//                var messageBody = "Feature request or bug report?"
//                var toRecipents = [btnSubmit.titleLabel?.text]
//                var mc: MFMailComposeViewController = MFMailComposeViewController()
//                mc.mailComposeDelegate = self
//                mc.setSubject(emailTitle)
//                let calendar = Calendar.current
//
//
////                let iCalString = calendar.t
////                print(iCalString)
////                mc.addAttachmentData(<#T##attachment: Data##Data#>, mimeType: "text/calendar", fileName: "/abc.ical")
//                mc.setMessageBody(messageBody, isHTML: false)
//                mc.setToRecipients(toRecipents)
//
//                self.presentViewController(mc, animated: true, completion: nil)
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
//        func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError) {
//                switch result {
//                case MFMailComposeResultCancelled:
//                        print("Mail cancelled")
//                case MFMailComposeResultSaved:
//                        print("Mail saved")
//                case MFMailComposeResultSent:
//                        print("Mail sent")
//                case MFMailComposeResultFailed:
//                        print("Mail sent failure: \(error?.localizedDescription)")
//                default:
//                        break
//                }
//                self.dismissViewControllerAnimated(true, completion: nil)
//        }

        
        @IBAction func btnDoneInCalendarClick(_ sender: UIButton) {
                eventStore.requestAccess(to: .event) { (granted, error) in
                        
                        if (granted) && (error == nil) {
                                for date in self.calendar.selectedDates
                                {
                                        print(date)
                                        let formater = DateFormatter()
                                        formater.dateFormat = "yyyy-MM-dd"
                                        formater.timeZone = NSTimeZone.default
                                        
                                        let str = formater.string(from: date)
                                        let dt = formater.date(from: str)
                                        let event:EKEvent = EKEvent(eventStore: self.eventStore)
                                        event.timeZone = NSTimeZone.local
                                        event.isAllDay = true
                                        event.title = "Test Title"
                                        event.endDate = date
                                        event.startDate = event.endDate
                                         print ( event.endDate)
                                        print (String(describing: event.endDate))
                                        
                                          //event.notes = "This is a note"
                                        event.calendar = self.eventStore.defaultCalendarForNewEvents
                                        //print(event)
                                        self.events.append(event)
                                        print("Saved Event")
                                }
                                print("granted \(granted)")
                        }
                        else{
                                
                                print("failed to save event with error : \(error ?? "default" as! Error) or access not granted")
                        }
                        DispatchQueue.main.async {
                                self.vieww.removeFromSuperview()
                        }
                        
        }
}
        @IBAction func btnCancelInCalendarClick(_ sender: UIButton) {
               
                DispatchQueue.main.async {
                                self.vieww.removeFromSuperview()
                        }
       }
  
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                textField.resignFirstResponder()
                return true
        }
}

