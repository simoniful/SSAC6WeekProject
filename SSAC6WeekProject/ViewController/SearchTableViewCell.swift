//
//  SearchTableViewCell.swift
//  SSAC6WeekProject
//
//  Created by Sang hun Lee on 2021/11/01.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    static let identifier = "SearchTableViewCell"
    
    @IBOutlet weak var diaryTitleLabel: UILabel!
    @IBOutlet weak var writingDateLabel: UILabel!
    @IBOutlet weak var diaryMainLabel: UILabel!
    @IBOutlet weak var diaryImage: UIImageView!
    
    func configureCell(row: UserDiary) {
        diaryTitleLabel.text = row.diaryTitle
        diaryMainLabel.text = row.diaryContent
        let format = DateFormatter()
        format.dateFormat = "yyyy년 MM월 dd일"
        writingDateLabel.text = format.string(from: row.writeDate)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
