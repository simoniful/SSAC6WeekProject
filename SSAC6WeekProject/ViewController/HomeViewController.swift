//
//  HomeViewController.swift
//  SSAC6WeekProject
//
//  Created by Sang hun Lee on 2021/11/01.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addBtnClicked))
        navigationItem.title = LocalizableStrings.home_title.localized
        
        if let tabBarItems = self.tabBarController?.tabBar.items {
            tabBarItems[0].title = LocalizableStrings.tabbar_home.localized
            tabBarItems[1].title = LocalizableStrings.tabbar_calendar.localized
            tabBarItems[2].title = LocalizableStrings.tabbar_search.localized
            tabBarItems[3].title = LocalizableStrings.tabbar_setting.localized
            tabBarItems[0].image = UIImage(systemName: "house")
            tabBarItems[1].image = UIImage(systemName: "calendar")
            tabBarItems[2].image = UIImage(systemName: "magnifyingglass")
            tabBarItems[3].image = UIImage(systemName: "gearshape.fill")
        }
        
    }
    
    @objc func addBtnClicked() {
        // 1. 어떤 스토리 보드
        let storyboard = UIStoryboard(name: "Content", bundle: nil)
        // 2. 어떤 VC
        let vc = storyboard.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        let nav =  UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
}
