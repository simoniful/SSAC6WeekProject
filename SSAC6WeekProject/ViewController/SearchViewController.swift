//
//  SearchViewController.swift
//  SSAC6WeekProject
//
//  Created by Sang hun Lee on 2021/11/01.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
    // default.realm 탐색
    let localRealm = try! Realm()
    var tasks: Results<UserDiary>!
    
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        let nibName = UINib(nibName: SearchTableViewCell.identifier, bundle: nil)
        searchTableView.register(nibName, forCellReuseIdentifier: SearchTableViewCell.identifier)
        
        title = LocalizableStrings.search_title.localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // realm 데이터 전체를 불러오기(원하는 형태로 가져오기 가능)
        tasks = localRealm.objects(UserDiary.self)
        searchTableView.reloadData()
        print(tasks!)
    }
    
    func loadImageFromDocuments(imageName: String) -> UIImage? {
        // 1. documents 경로 가져오기
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let directoryPath = path.first {
            // 2. path 경로 문자열 URL 변환
            let imageURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(imageName)
            // 3. UIImage 변환
            return UIImage(contentsOfFile: imageURL.path)
        }
        return nil
    }
    
    func deleteImageInDocuments(imageName: String) {
        // 1. 이미지를 저장할 경로 설정: 도큐먼트 폴더(.documentDirectory), FileManger
        // Desktop/simon/iOS/folder - 샌드박스 시스템에 의한 이동으로 해당 메서드로 접근
        // (To-Do) 폴더를 나누어 구성할 경우 추가 학습
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // 2. 이미지 파일 이름
        // Desktop/simon/iOS/folder/222.png
        let imageURL = documentDirectory.appendingPathComponent(imageName)
        
        // 3. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기
        // 3-1. 이미지 경로 여부 확인
        if FileManager.default.fileExists(atPath: imageURL.path) {
            // 4-2. 기존 경로에 있는 이미지 삭제
            // do try 구문으로 우선순위가 높게 실행 - 오류 방지
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제 완료")
            } catch {
                print("이미지 삭제 실패")
            }
        }
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        let row = tasks[indexPath.row]
        cell.configureCell(row: row)
        // extension을 통한 개선 필요
        cell.diaryImage.image = loadImageFromDocuments(imageName: "\(row._id).jpg")
        
        return cell
    }
    
    // 본래 화면 전환 + 값 전달 후 새로운 화면에서 수정이 적합
    // 반드시 try 문 제대로, 1번 유형이 가장 일반적
    // [To Do] 상세페이지 present, realm 데이터 전달 - 뷰간 데이터 전달 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = tasks[indexPath.row]
        
        // 1. 수정 - 레코드 값에 대한 수정
        // try! localRealm.write {
            // taskToUpdate.diaryTitle = "새로운 수정"
            // taskToUpdate.diaryContent = "수정된 내용입니다"
            // searchTableView.reloadData()
        // }
        
        // 2. 일괄 수정
        // try! localRealm.write {
            // tasks.setValue(Date(), forKey: "writeDate")
            // tasks.setValue("알괄적 변경된 타이틀", forKey: "diaryTitle")
            // searchTableView.reloadData()
        // }
        
        // 3. 수정: PK 기준으로 수정할 때 사용
        // try! localRealm.write {
            // 기입한 프로퍼티 이 외 모든 값 초기값으로 설정
            // let update = UserDiary(value: ["_id": taskToUpdate._id, "diaryTitle": "이 녀석만 수정하겠습니다"])
            // localRealm.add(update, update: .modified)
            // searchTableView.reloadData()
        // }
        
        // 4. 1번과 유사하게 적용, 과거 Realm 코드
        // try! localRealm.write {
            // localRealm.create(UserDiary.self, value: ["_id": taskToUpdate._id, "diaryTitle": "이 녀석만 수정하겠습니다"], update: .modified)
            // searchTableView.reloadData()
        // }
        
        // 1. 어떤 스토리 보드
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        // 2. 어떤 VC
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.diaryData = row
        vc.imageData = loadImageFromDocuments(imageName: "\(row._id).jpg")
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        try! localRealm.write {
            // 할당을 통하여 1번 방지
            let row = tasks[indexPath.row]
            // Realm에서 이미지를 먼저 DB를 지워야 인덱스가 꼬이는 경우를 방지
            deleteImageInDocuments(imageName: "\(row._id).jpg")
            localRealm.delete(row)
            tableView.reloadData()
        }
    }
    
}

