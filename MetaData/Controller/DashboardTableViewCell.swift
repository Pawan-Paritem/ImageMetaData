//
//  DashboardTableViewCell.swift
//  MetaData
//
//  Created by Pawan  on 27/11/2020.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
