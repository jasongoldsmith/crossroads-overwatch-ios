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
        if let years = Calendar.current.dateComponents([.year], from: date, to: self).year {
            return years
        }
        return 0
    }
    func monthsFrom(date:Date)  -> Int {
        if let months = Calendar.current.dateComponents([.month], from: date, to: self).month {
            return months
        }
        return 0
    }
    func weeksFrom(date:Date)   -> Int {
        if let weeks = Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear {
            return weeks
        }
        return 0
    }
    func daysFrom(date:Date)    -> Int {
        if let days = Calendar.current.dateComponents([.day], from: date, to: self).day {
            return days
        }
        return 0
    }
    func hoursFrom(date:Date)   -> Int {
        if let hours = Calendar.current.dateComponents([.hour], from: date, to: self).hour {
            return hours
        }
        return 0
    }
    func minutesFrom(date:Date) -> Int {
        if let minutes = Calendar.current.dateComponents([.minute], from: date, to: self).minute {
            return minutes
        }
        return 0
    }
    func secondsFrom(date:Date) -> Int {
        if let seconds = Calendar.current.dateComponents([.second], from: date, to: self).second {
            return seconds
        }
        return 0
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
