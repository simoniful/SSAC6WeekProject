//
//  AddViewController.swift
//  SSAC6WeekProject
//
//  Created by Sang hun Lee on 2021/11/01.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateSelectBtn: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocalizableStrings.save_btn_title.localized, style: .plain, target: self, action:  #selector(saveData))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeBtnClicked))
        navigationItem.title = LocalizableStrings.content_title.localized
        
    }
    
    @objc func saveData() {
        print("saveData: 일기가 저장되었습니다")
    }
    
    @objc func closeBtnClicked() {
        self.dismiss(animated: true, completion: nil)
    }


}
