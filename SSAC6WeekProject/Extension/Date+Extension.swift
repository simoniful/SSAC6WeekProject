//
//  Date+Extension.swift
//  SSAC6WeekProject
//
//  Created by Sang hun Lee on 2021/11/05.
//

import Foundation

// 반복되는 로직의 비지니스 로직과 분리 
extension DateFormatter {
    static var customFormat: DateFormatter {
        let date = DateFormatter()
        date.dateFormat = "yyyy년 MM월 dd일"
        return date
    }
}
