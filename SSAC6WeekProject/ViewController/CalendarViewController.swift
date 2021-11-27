//
//  CarlendarViewController.swift
//  SSAC6WeekProject
//
//  Created by Sang hun Lee on 2021/11/01.
//

import UIKit
import FSCalendar
import RealmSwift

class CalendarViewController: UIViewController {
    let localRealm = try! Realm()
    var tasks: Results<UserDiary>!
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var allCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizableStrings.calendar_title.localized
        calendarView.delegate = self
        calendarView.dataSource = self
        
        tasks = localRealm.objects(UserDiary.self)
        let allCount = getAllDiaryCountFromUserDiary()
        allCountLabel.text = "총 \(allCount)개 일기를 작성했습니다"
        
        // let recent = localRealm.objects(UserDiary.self).sorted(byKeyPath: "writeDate", ascending: false).first?.diaryTitle
        // let contentFull = localRealm.objects(UserDiary.self).filter("diaryContent != nil").count
        // let favorite = localRealm.objects(UserDiary.self).filter("favorite == false")
        // let search = localRealm.objects(UserDiary.self).filter("diaryTitle CONTAINS[c] '일기' AND diaryContent CONTAINS[c] '내용'")
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        return "제목"
//    }
//
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//        return "부제목"
//    }
    
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        return UIImage(systemName: "star")
//    }
    
    // Date: 시분초까지 모두 동일해야 같다고 인식
    // 1. 영국 표준시 기준으로 표기: 2021-11-11 15:00:00 +0000 -> 11/12
    // 2. DateFormatter : 형식을 바꿔서 비교도 가능
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        let format = DateFormatter()
//        format.dateFormat = "yyyyMMdd"
//        let test =  "20211103"
//        if format.date(from: test) == date {
//            return 3
//        } else {
//            return 1
//        }
        
        // 11월 2일에 3개의 일기를 등록했다면 3개, 없다면 X, 1개면 1개
        return tasks.filter("writeDate == %@", date).count
    }
    
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        <#code#>
//    }
}
