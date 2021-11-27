//
//  HomeViewController.swift
//  SSAC6WeekProject
//
//  Created by Sang hun Lee on 2021/11/01.
//

import UIKit

// [To-Do] realm에 있는 데이터를 구분(즐겨찾기, 완료한 일 등)하여 보여주는 것으로 홈 구성

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let array = [
        Array(repeating: "a", count: 20),
        Array(repeating: "b", count: 10),
        Array(repeating: "c", count: 15),
        Array(repeating: "d", count: 5),
        Array(repeating: "e", count: 20),
        Array(repeating: "f", count: 15),
        Array(repeating: "g", count: 10),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
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
        let storyboard = UIStoryboard(name: "Content", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        let nav =  UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath ) as? HomeTableViewCell else { return UITableViewCell() }
        
        // HomeTableViewCell로 데이터 전달
        cell.data = array[indexPath.row]
        cell.collectionView.tag = indexPath.row
        // HomeViewController과 HomeTableViewCell일 때 HomeTableViewCell가 먼저 실행되고 스택에 따라 HomeViewController가 실행되기 때문에 덮어쓰게 됨
        cell.collectionView.backgroundColor = .orange

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 높이 고려 및 인셋을 통한 미관적인 개선 필요
        return indexPath.row == 1 ? 268 : 170
    }
}

