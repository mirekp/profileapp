//
//  WorkExperienceCell.swift
//  profileapp
//
//  Created by Mirek Petricek on 21/08/2019.
//  Copyright © 2019 Dependency Injection. All rights reserved.
//


import UIKit

class WorkExperienceCell: UITableViewCell {
    
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var roleName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var summary: UILabel!
    
    private static var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }
    
    func configure(_ model: Profile.WorkExperience) {
        companyName.text = model.client
        roleName.text = model.role
        location.text = model.location
        if let from = model.from, let to = model.to {
            duration.text = WorkExperienceCell.formatter.string(from: from) + " - " + WorkExperienceCell.formatter.string(from: to)
        } else {
            duration.text = nil
        }
        summary.text = model.summary
    }
}
