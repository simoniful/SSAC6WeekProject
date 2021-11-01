//
//  UIFont+Extension.swift
//  SSAC6WeekProject
//
//  Created by Sang hun Lee on 2021/11/01.
//

import UIKit

extension UIFont {
    // main, sub, title, body 등으로 구별
    var title: UIFont {
        return UIFont(name: "NanumGyuRiEuiIrGi", size: 24)!
    }
    
    var main: UIFont {
        // 사용자 선택에 대한 조건 분기 처리 가능
        // name은 커스텀 폰트에 있어서는 필수적, 시스템 폰트의 경우 사이즈만 필요
        return UIFont(name: "NanumGyuRiEuiIrGi", size: 22)!
    }
    
    var sub: UIFont {
        // 사용자 선택에 대한 조건 분기 처리 가능
        // name은 커스텀 폰트에 있어서는 필수적, 시스템 폰트의 경우 사이즈만 필요
        return UIFont(name: "NanumGyuRiEuiIrGi", size: 22)!
    }
}

