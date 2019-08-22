//
//  Profile.swift
//  profileapp
//
//  Created by Mirek Petricek on 21/08/2019.
//  Copyright © 2019 Dependency Injection. All rights reserved.
//

import Foundation

struct Profile: Decodable {
    let name: String
    let summary: String
    let workExperience: [WorkExperience]
    
    enum CodingKeys: String, CodingKey {
        case name
        case summary
        case workExperience = "work_experience"
    }
    
    struct WorkExperience: Decodable {
        let client: String
        let location: String
        private let fromString: String
        private let toString: String
        var from: Date? {
            return ISO8601DateFormatter().date(from: fromString)
        }
        var to: Date? {
            return ISO8601DateFormatter().date(from: toString)
        }
        let role: String
        let summary: String
        
        enum CodingKeys: String, CodingKey {
            case client
            case location
            case fromString = "date_from"
            case toString = "date_to"
            case role
            case summary
        }
        
        init(client: String, location: String, from: Date, to: Date, role: String, summary: String) {
            self.client = client
            self.location = location
            self.fromString = ISO8601DateFormatter().string(from: from)
            self.toString = ISO8601DateFormatter().string(from: to)
            self.role = role
            self.summary = summary
        }
    }
}

extension Profile: Equatable {
    public static func == (lhs: Profile, rhs: Profile) -> Bool {
        return lhs.workExperience == rhs.workExperience && lhs.name == rhs.name && lhs.summary == rhs.summary
    }
}

extension Profile.WorkExperience: Equatable {
    public static func == (lhs:Profile.WorkExperience, rhs: Profile.WorkExperience) -> Bool {
        return lhs.client == rhs.client && lhs.location == rhs.location && lhs.role == lhs.role && lhs.summary == rhs.summary
    }
}
