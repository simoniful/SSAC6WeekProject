//
//  SettingViewController.swift
//  SSAC6WeekProject
//
//  Created by Sang hun Lee on 2021/11/01.
//

import UIKit
import Zip
import MobileCoreServices
/*
 백업하기
 1. [To-Do] 사용자의 아이폰 저장 공간이 최소 얼마나 남아있는지 확인 - 부족할 경우: 백업 불가
 2. 백업 진행
     - 어떤 데이터도 없는 경우면 백업할 데이터가 없다고 안내
     - realm, folder
     - 프로그레스 바 + UI 인터렉션 금지
 3. 압축파일(zip)으로 구성
     - 백업 완료 시점에 프로그레스 바 + UI 인터렉션 허용
 4. 공유화면
 
 복구하기
 1. 사용자의 아이폰 저장 공간 확인
 2. 파일 앱 실행 후
    - zip 형식인지, zip 선택(압축 파일에 대한 확인)
 3. 압축해제
    - 백업 파일 이름 확인
    - 압축 해제
        - 백업 파일 확인: 폴더, 파일 이름
        - 정상적인 파일인가
 4. 백업 당시 데이터랑 지금 현재 앱에서 사용 중인 데이터 어떻게 합칠건 지에 대한 고려
    - 백업 데이터 선택
*/

class SettingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizableStrings.setting_title.localized
    }
    
    func documentsDirectoryPath() -> String? {
        let documentsDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentsDirectory, userDomainMask, true)
        if let directoryPath = path.first {
            return directoryPath
        } else {
            return nil
        }
    }
    
    // 7. 공유
    func presentActivityViewController() {
        let fileName = (documentsDirectoryPath()! as NSString).appendingPathComponent("archive.zip")
        let fileURL = URL(fileURLWithPath: fileName)
        
        let vc = UIActivityViewController(activityItems: [fileURL], applicationActivities: [])
        self.present(vc, animated: true, completion:  nil)
    }
    
    @IBAction func backupBtnClicked(_ sender: UIButton) {
        // 4. 백업할 파일에 대한 URL 배열
        var urlPaths = [URL]()
        
        // 1. 도큐먼트 폴더 위치
        if let path = documentsDirectoryPath() {
            // 2. 백업하고자 하는 파일 URL 확인
            // NSString 타입으로 타입 캐스팅을 해야 URL적인 부분에서 통제 가능
            // 이미지의 경우 백업 편의성을 위해 폴더를 생성하고, 폴더 내 이미지를 저장하는 것이 효율
            let realm = (path as NSString).appendingPathComponent("default.realm")
            // 3. 백업하고자 하는 파일 존재 여부 확인
            if FileManager.default.fileExists(atPath: realm) {
                // 5. URL 배열에 백업파일 URL 추가
                urlPaths.append(URL(string: realm)!)
            } else {
                // 사용지 alert
                print("백업할 파일이 없습니다")
            }
        }
        
        // 6. 4번 배열에 대한 압축 파일 만들기
        do {
            // 독립성을 위해 날짜 등 고유값 활용하여 naming
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "archive")
            print("압축경로: \(zipFilePath)")
            presentActivityViewController()
        }
        catch {
          print("Something went wrong")
        }

    }
    // 8. 복구
    @IBAction func restoreBtnClicked(_ sender: UIButton) {
        // 8-1. 파일앱 열기, 확장자
        // import MobileCoreServices
        // 프로토콜 기반 picker 모두 딜리게이트 유의
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeArchive as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        self.present(documentPicker, animated: true, completion: nil)
    }
}

extension SettingViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // 8-2. 선택한 파일에 대한 경로를 가져와야 함(여러 개도 가능하게 구현가능)
        // 현재 app의 documents 까지의 파일 위치 경로 + 추가 경로(압축파일)
        guard let selectedFileURL = urls.first else { return }
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = directory.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        // 8-3. 압축해제
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            // 기존에 복구하고자 하는 zip 파일을 도큐먼트에 가지고 있을 경우, 도큐먼트에 위치한 zip 파일을
            do {
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentDirectory.appendingPathComponent("archive.zip")
                
                try Zip.unzipFile(fileURL, destination: documentDirectory, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    // 복구가 완료되었습니다 메세지, alert을 통한 앱 재실행
                    print("unzippedFile: \(unzippedFile)")
                })
            } catch {
                print("ERROR")
            }
        } else {
            // 파일 앱의 zip -> 도큐먼트 폴더에 복사
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentDirectory.appendingPathComponent("archive.zip")
                
                try Zip.unzipFile(fileURL, destination: documentDirectory, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    // 복구가 완료되었습니다 메세지, alert을 통한 앱 재실행
                    print("unzippedFile: \(unzippedFile)")
                })
            } catch {
                print("ERROR")
            }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
}
