//
//  DatePickerViewController.swift
//  SSAC6WeekProject
//
//  Created by Sang hun Lee on 2021/11/05.
//

import UIKit

class DatePickerViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.preferredDatePickerStyle = .wheels
        // 데이트 포멧터로 저장해야 한국 표준시로 저장
        
    }
    

}
