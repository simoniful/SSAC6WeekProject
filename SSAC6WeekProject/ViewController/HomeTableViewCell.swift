//
//  HomeTableViewCell.swift
//  SSAC6WeekProject
//
//  Created by Sang hun Lee on 2021/11/08.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    var data: [String] = [] {
        didSet {
            // data 기준으로 달라지게끔 개선
            collectionView.reloadData()
            categoryLabel.text = "\(data.count)"
        }
    }
    
    static let identifier = "HomeTableViewCell"
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        // likeViewDidLoad
        super.awakeFromNib()
        
        categoryLabel.backgroundColor = .green
        collectionView.backgroundColor = .blue
        // 페이징 기능 - 디바이스 넓이의 기준으로 넘어감
        collectionView.isPagingEnabled = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 테이블 뷰의 재사용 메커니즘으로 index가 꼬이는 현상 발생
        // 다시 그려질 때 마다 컬렉션 뷰를 초기화를 하면서 시점의 차이를 해결 가능 - cell.collectionView.reloadData()
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if collectionView.tag == 0 {
            cell.imageView.backgroundColor = .gray
        } else {
            cell.imageView.backgroundColor = .yellow
        }
        
        cell.contentLabel.text = data[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // tableView의 인덱스 패스를 기반으로 한 태그 활용
        // How to closure
        if collectionView.tag == 0 {
            return CGSize(width: UIScreen.main.bounds.width, height: 100)
        } else {
            return CGSize(width: 150, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // 섹션 인셋 조정 가능
        if collectionView.tag == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 0 {
            return 0
        } else {
            return 8
        }
    }
}
