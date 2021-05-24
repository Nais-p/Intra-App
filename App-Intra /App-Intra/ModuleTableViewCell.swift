//
//  ModuleTableViewCell.swift
//  App-Intra
//
//  Created by Anaïs Puig on 13/04/2021.
//

import UIKit

class ModuleTableViewCell: UITableViewCell {
    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var insc: UILabel!
    @IBOutlet weak var inscH: UILabel!
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var end: UILabel!
    @IBOutlet weak var grp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
