//
//  DataTableViewCell.swift
//  HomeworkMVP
//
//  Created by Song Seaktheng on 12/15/16.
//  Copyright © 2016 Song Seaktheng. All rights reserved.
//

import UIKit

class DataTableViewCell: UITableViewCell {

   
    @IBOutlet weak var titleArticle: UILabel!
    @IBOutlet weak var imageArticle: UIImageView!
    @IBOutlet weak var descriptionArticle: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
              
    }

}
