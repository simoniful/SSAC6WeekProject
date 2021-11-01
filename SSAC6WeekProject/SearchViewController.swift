//
//  SearchViewController.swift
//  SSAC6WeekProject
//
//  Created by Sang hun Lee on 2021/11/01.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        let nibName = UINib(nibName: SearchTableViewCell.identifier, bundle: nil)
        searchTableView.register(nibName, forCellReuseIdentifier: SearchTableViewCell.identifier)
        
        navigationItem.title = LocalizableStrings.search_title.localized
        
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        cell.diaryTitleLabel.font = UIFont().title
        cell.diaryMainLabel.font = UIFont().main
        cell.writingDateLabel.font = UIFont().sub
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

