//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Christopher Rene on 3/1/17.
//  Copyright © 2017 Christopher Rene. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, NSCoding {
    
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    override init() {
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    func toggleChecked() {
        checked = !checked
    }
    
    func scheduleNotification() {
        removeNotification()
        
        if shouldRemind && dueDate > Date() {
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default()
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("Scheduled notification \(request) for itemID \(itemID)")
        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "text")
        aCoder.encode(checked, forKey: "checked")
        aCoder.encode(dueDate, forKey: "dueDate")
        aCoder.encode(shouldRemind, forKey: "shouldRemind")
        aCoder.encode(itemID, forKey: "itemID")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "text") as! String
        checked = aDecoder.decodeBool(forKey: "checked")
        dueDate = aDecoder.decodeObject(forKey: "dueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "shouldRemind")
        itemID = aDecoder.decodeInteger(forKey: "itemID")
        
        super.init()
    }
    
    deinit {
        removeNotification()
    }
}
