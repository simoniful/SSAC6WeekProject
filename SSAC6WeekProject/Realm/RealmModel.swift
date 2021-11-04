//
//  RealmModel.swift
//  SSAC6WeekProject
//
//  Created by Sang hun Lee on 2021/11/02.
//

import Foundation
import RealmSwift

// 스키마, 테이블, 컬럼
// 1. 테이블 이름 변경
class UserDiary: Object {
    // 2. 각 컬럼 정립
    // 3. PK키 구성
    @Persisted(primaryKey: true) var _id: ObjectId // AutoIncreasement
    @Persisted var diaryTitle: String // 필수
    @Persisted var diaryContent: String? // 선택
    @Persisted var writeDate = Date()
    @Persisted var regDate = Date()
    @Persisted var favorite: Bool

    convenience init(diaryTitle: String, diaryContent: String?, writeDate: Date, regDate: Date) {
        self.init()
        
        self.diaryTitle = diaryTitle
        self.diaryContent = diaryContent
        self.writeDate = writeDate
        self.regDate = regDate
        self.favorite = false
    }
}
