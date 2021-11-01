//
//  String+Extension.swift
//  SSAC6WeekProject
//
//  Created by Sang hun Lee on 2021/11/01.
//

import Foundation

extension String {
//    var localized: String {
//         return NSLocalizedString(self, comment: "")
//    }
    
    func localized(tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: .main, value: "", comment: "")
    }
}
