//
//  CalendarVC.swift
//  DemoClock
//
//  Created by TribondInfosystems on 21/12/18.
//  Copyright © 2018 Deepti. All rights reserved.
//

import UIKit
import  EventKit
import FSCalendar


class CalendarVC: UIViewController,FSCalendarDelegate,FSCalendarDataSource {
         var eventStore : EKEventStore = EKEventStore()
        @IBOutlet weak var btnNext: UIButton!
        @IBOutlet weak var calendar: FSCalendar!
        var events = Array<EKEvent>()
        var selectedDate = Array<Date>()
        override func viewDidLoad() {
                super.viewDidLoad()
                calendar.allowsMultipleSelection = true
                // Do any additional setup after loading the view.
        }
        override func viewWillAppear(_ animated: Bool) {
                events = Array<EKEvent>()
                selectedDate = Array<Date>()
        }
        @IBAction func btnNextClick(_ sender: UIButton) {
                if selectedDate.count != 0
                {
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
                                                //event.title = "Test Title"
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
                                        DispatchQueue.main.sync {
                                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondVC") as! SecondVC
                                                vc.events = self.events
                                                vc.eventStore = self.eventStore
                                                self.navigationController?.pushViewController(vc, animated: true)
                                        }
                                       
                                        
                                }
                                else{
                                        
                                        print("failed to save event with error : \(error ?? "default" as! Error) or access not granted")
                                        DesignManager.showAlert(title: "error", message: "failed to save event \(error ?? "" as! Error)", vc: self)
                                }
                              
                                
                        }
                }
                else
                {
                        DesignManager.showAlert(title: "error", message: "please select event date", vc: self)
                }
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
                if monthPosition == .previous || monthPosition == .next {
                        calendar.setCurrentPage(date, animated: true)
                }
                selectedDate.append(date)
        }
        func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
                if selectedDate.contains(date)
                {
                        let index = selectedDate.firstIndex(of: date)
                        selectedDate.remove(at: index!)
                }
        }
        
}
