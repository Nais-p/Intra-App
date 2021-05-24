//
//  PlanningTableViewCell.swift
//  App-Intra
//
//  Created by Jacques Liao on 15/04/2021.
//

import UIKit

class PlanningTableViewCell: UITableViewCell {

    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var end: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var uv_name: UILabel!
    @IBOutlet weak var activity_name: UILabel!
    @IBOutlet weak var location: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
