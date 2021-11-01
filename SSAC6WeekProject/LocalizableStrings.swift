//
//  LocalizableStrings.swift
//  SSAC6WeekProject
//
//  Created by Sang hun Lee on 2021/11/01.
//

import Foundation

enum LocalizableStrings: String {
    case home_title
    case calendar_title
    case content_title
    case save_btn_title
    case search_title
    case setting_title
    
    case tabbar_home
    case tabbar_calendar
    case tabbar_search
    case tabbar_setting
    
    var localized: String {
        return self.rawValue.localized() // Localizable.strings
    }
}
