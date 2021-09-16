//
//  Date+Format.swift
//  Lesson_21_App
//
//  Created by Мария Манжос on 30.08.21.
//

import UIKit

extension Date {
    func getCurrentDate(from dateFormat: String = "dd MMMM yyyy HH:mm", locale: Locale = Locale.current, timeZone: TimeZone = TimeZone.current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = locale
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
}
