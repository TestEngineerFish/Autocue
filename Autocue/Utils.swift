//
//  Utils.swift
//  Autocue
//
//  Created by 老沙 on 2023/7/30.
//

import Foundation

extension Date {
    func formatIMMessageTime() -> String {
        let calendar = Calendar.current
        let now = Date()

        if calendar.isDateInToday(self) {
            let components = calendar.dateComponents([.hour, .minute], from: self, to: now)

            if let hour = components.hour, let minute = components.minute {
                if hour > 0 {
                    return "\(hour)小时前"
                } else if minute > 0 {
                    return "\(minute)分钟前"
                } else {
                    return "刚刚"
                }
            }
        } else if calendar.isDateInYesterday(self) {
            return "昨天"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M月d日"
            return dateFormatter.string(from: self)
        }

        return ""
    }

}
