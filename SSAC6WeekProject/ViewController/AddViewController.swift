//
//  AddViewController.swift
//  SSAC6WeekProject
//
//  Created by Sang hun Lee on 2021/11/01.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {
    
    // 샌드박스 내 document 위치를 알려주는 역할
    let localRealm = try! Realm()
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageSelectBtn: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dateBtn: UIButton!
    
    // UIMenu와 Button을 이용한 카메라 / 갤러리 접근 enum을 통한 상태 switch case 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocalizableStrings.save_btn_title.localized, style: .plain, target: self, action:  #selector(saveData))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeBtnClicked))
        title = LocalizableStrings.content_title.localized
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        print("Realm is located at", localRealm.configuration.fileURL!)
    }
    
    @objc func saveData() {
        print("saveData: 일기가 저장되었습니다")
        // 하나의 레코드 생성
        // let format = DateFormatter()
        // format.dateFormat = "yyyy년 MM월 dd일"
        
        // let date = dateBtn.currentTitle!
        // let value = format.date(from: date)
        
        guard let date = dateBtn.currentTitle, let value = DateFormatter.customFormat.date(from: date) else { return }
        
        let task = UserDiary(diaryTitle: titleTextField.text!,
                             diaryContent: contentTextView.text!,
                             writeDate: value,
                             regDate: Date())
        
        try! localRealm.write {
            localRealm.add(task)
            // [To-Do] 이미지가 없더라도 저장이 진행되도록 분기 처리
            if let checkedImage = selectedImage.image {
                saveImageToDocuments(imageName: "\(task._id).jpg", image: checkedImage)
            }
        }
    }
    
    // alert 커스터마이징
    @IBAction func dateBtnClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "날짜 선택", message: "날짜를 선택해주세요", preferredStyle: .alert)
        
        // 1. 얼럿 안에 들어와서 그런가?
        // 2. 스토리 보드가 인식이 안되나? - 연관성X, 해당 클래스만 가져온 것
        // 3. 스토리보드 씬 + 클래스 -> 화면 전환 코드 
        // let contentView = DatePickerViewController()
        guard let contentView = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController") as? DatePickerViewController else {
            print("DatePickerVC에 오류가 있음")
            return
        }
        // contentView.view.backgroundColor = .green
        // contentView.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        contentView.preferredContentSize.height = 200
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            let format = DateFormatter()
            format.dateFormat = "yyyy년 MM월 dd일"
            let value = format.string(from: contentView.datePicker.date)
            self.dateBtn.setTitle("\(value)", for: .normal)
            
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler:nil)
        
        alert.setValue(contentView, forKey: "contentViewController")
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func selectImageBtnClicked(_ sender: UIButton) {
        // 1. UIAlertController 생성: 밑바탕 + 타이틀 + 본문
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 2. UIAlertAction 생성: 버튼들..
        let camera = UIAlertAction(title: "사진 촬영", style: .default, handler: nil)
        let photoLibrary = UIAlertAction(title: "앨범에서 가져오기", style: .default) { (action: UIAlertAction!) in
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler:nil)
        
        // 3. 1+2
        alert.addAction(camera)
        alert.addAction(photoLibrary)
        alert.addAction(cancel)
        
        // 4. Present
        present(alert, animated: true, completion: nil)
    }
    
    @objc func closeBtnClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveImageToDocuments(imageName: String, image: UIImage) {
        // 1. 이미지를 저장할 경로 설정: 도큐먼트 폴더(.documentDirectory), FileManger
        // Desktop/simon/iOS/folder - 샌드박스 시스템에 의한 이동으로 해당 메서드로 접근
        // (To-Do) 폴더를 나누어 구성할 경우 추가 학습
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // 2. 이미지 파일 이름
        // Desktop/simon/iOS/folder/222.png
        let imageURL = documentDirectory.appendingPathComponent(imageName)
        
        // 3. 이미지 압축(선택 사항, )
        // 압축이 실패하는 경우를 대비하여 return 상부 alert 작성
        // png는 압축 정도 설정 X, jpeg는 압축 정도 설정가능(낮을 수록 많이 압축)
        guard let data = image.jpegData(compressionQuality: 0.3) else { return }
        
        // 4. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기
        // 4-1. 이미지 경로 여부 확인
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
        
        // 5. 이미지를 도큐먼트에 저장
        do {
            try data.write(to: imageURL)
        } catch {
            print("이미지 저장 실패")
        }
 
    }
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 사진을 촬영하거나, 갤러리에서 사진을 선택한 직후에 실행
    // 사진을 읽는 접근에 대해서는 권한 요청 X
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        // 1. 선택한 사진 가져오기 - originalIamge
        // - allowsEditing: false -> editedImage: nil
        // - allowsEditing: true -> editedImage / originalImage
        
        if let value = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            // 2.사진을 이미지 뷰에 선택한 사진 보여주기
            selectedImage.image = value
        }
        // 3.picker dismiss 실행
        picker.dismiss(animated: true, completion: nil)
    }
    
    // cancel 클릭 시
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        // picker dismiss 실행
        picker.dismiss(animated: true, completion: nil)
    }
}
