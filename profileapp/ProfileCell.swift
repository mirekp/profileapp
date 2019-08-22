//
//  ProfileCell.swift
//  profileapp
//
//  Created by Mirek Petricek on 21/08/2019.
//  Copyright © 2019 Dependency Injection. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    func configure(_ model: Profile) {
        summaryLabel.text = model.summary
    }
}
