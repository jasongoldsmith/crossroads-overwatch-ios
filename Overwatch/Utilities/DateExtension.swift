//
//  DateExtension.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/20/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

extension Date {
    func yearsFrom(date:Date)   -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year!
    }
    func monthsFrom(date:Date)  -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month!
    }
    func weeksFrom(date:Date)   -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear!
    }
    func daysFrom(date:Date)    -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day!
    }
    func hoursFrom(date:Date)   -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour!
    }
    func minutesFrom(date:Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute!
    }
    func secondsFrom(date:Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second!
    }
    
    func relative () -> String {
        let now = Date()
        if now.yearsFrom(date: self)   > 0 {
            return now.yearsFrom(date: self).description  + " year"  + { return now.yearsFrom(date: self)   > 1 ? "s" : "" }() + " ago"
        }
        if now.monthsFrom(date: self)  > 0 {
            return now.monthsFrom(date: self).description + " month" + { return now.monthsFrom(date: self)  > 1 ? "s" : "" }() + " ago"
        }
        if now.weeksFrom(date: self)   > 0 {
            return now.weeksFrom(date: self).description  + " week"  + { return now.weeksFrom(date: self)   > 1 ? "s" : "" }() + " ago"
        }
        if now.daysFrom(date: self)    > 0 {
            if now.daysFrom(date: self) == 1 { return "Yesterday" }
            return now.daysFrom(date: self).description + " days ago"
        }
        if now.hoursFrom(date: self)   > 0 {
            return "\(now.hoursFrom(date: self)) hour"     + { return now.hoursFrom(date: self)   > 1 ? "s" : "" }() + " ago"
        }
        if now.minutesFrom(date: self) > 0 {
            return "\(now.minutesFrom(date: self)) minute" + { return now.minutesFrom(date: self) > 1 ? "s" : "" }() + " ago"
        }
        if now.secondsFrom(date: self) > 0 {
            if now.secondsFrom(date: self) < 15 { return "Just now"  }
            return "\(now.secondsFrom(date: self)) second" + { return now.secondsFrom(date: self) > 1 ? "s" : "" }() + " ago"
        }
        return ""
    }
    
    var relativeTime: String {
        let now = Date()
        if now.yearsFrom(date: self)   > 0 {
            return now.yearsFrom(date: self).description  + " year"  + { return now.yearsFrom(date: self)   > 1 ? "s" : "" }() + " ago"
        }
        if now.monthsFrom(date: self)  > 0 {
            return now.monthsFrom(date: self).description + " month" + { return now.monthsFrom(date: self)  > 1 ? "s" : "" }() + " ago"
        }
        if now.weeksFrom(date: self)   > 0 {
            return now.weeksFrom(date: self).description  + " week"  + { return now.weeksFrom(date: self)   > 1 ? "s" : "" }() + " ago"
        }
        if now.daysFrom(date: self)    > 0 {
            if now.daysFrom(date: self) == 1 { return "Yesterday" }
            return now.daysFrom(date: self).description + " days ago"
        }
        if now.hoursFrom(date: self)   > 0 {
            return "\(now.hoursFrom(date: self)) hour"     + { return now.hoursFrom(date: self)   > 1 ? "s" : "" }() + " ago"
        }
        if now.minutesFrom(date: self) > 0 {
            return "\(now.minutesFrom(date: self)) minute" + { return now.minutesFrom(date: self) > 1 ? "s" : "" }() + " ago"
        }
        if now.secondsFrom(date: self) > 0 {
            if now.secondsFrom(date: self) < 15 { return "Just now"  }
            return "\(now.secondsFrom(date: self)) second" + { return now.secondsFrom(date: self) > 1 ? "s" : "" }() + " ago"
        }
        return ""
    }
}
