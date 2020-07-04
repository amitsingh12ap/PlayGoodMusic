//
//  ProfileVM.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 04/07/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import Foundation
import UIKit

struct ProfileVM {
    private enum sections: CaseIterable {
        case header
        case profileInfo
        case footerInfo
        var value: Int {
            switch self {
            case .header:
                return 0
            case .profileInfo:
                return 1
            case .footerInfo:
                return 2
            }
        }
    }
    private enum headerRow: CaseIterable {
        case profile
    }
    
    private enum profileRow: CaseIterable {
        case email
        case phone
        case gender
        case age
        var text: String {
            switch self {
            case .email:
                return "EMAIL ID"
            case .phone:
                return "PHONE NUMBER"
            case .gender:
                return "GENDER"
            case .age:
                return "AGE GROUP"
            }
        }
    }
    private enum footerRow: CaseIterable {
        case subscribedEvent
    }
    
    var rows:(Int)-> Int = { (section) in
        switch section {
        case sections.header.value: return headerRow.allCases.count
        case sections.profileInfo.value: return profileRow.allCases.count
        case sections.footerInfo.value: return footerRow.allCases.count
        default:
            return 0
        }
    }
    var tableSections: Int {
        return sections.allCases.count
    }
    
    var profileTitleForRow:(Int)-> String = { (row) in
        switch row {
        case 0 : return profileRow.email.text
        case 1 : return profileRow.phone.text
        case 2 : return profileRow.gender.text
        case 3 : return profileRow.age.text
        default:
            return ""
        }
    }
    
    var textForIndex:(Int, LoginModel?)-> String = { (row, model) in
        switch row {
        case 0 : return model?.loginResponseResult?.email ?? ""
        case 1 : return model?.loginResponseResult?.contactNo ?? ""
        case 2 : return model?.loginResponseResult?.gender ?? ""
        case 3 : return model?.loginResponseResult?.ageGroup ?? ""
        default:
            return ""
        }
    }
    
    
    var cellForRow:(Int,Int, UITableView)-> UITableViewCell = { (section,row,table) in
        switch section {
        case sections.header.value: return table.dequeueReusableCell(withIdentifier: "profile") as! ProfilePicCell
        case sections.profileInfo.value,sections.footerInfo.value: return table.dequeueReusableCell(withIdentifier: "form") as! FormCell
        default:
            return UITableViewCell()
        }
    }
    
    var heightForRowInSection:(Int) -> Int = {  (section) in
        switch section {
        case sections.header.value: return 130
        case sections.profileInfo.value,sections.footerInfo.value: return 90
        default:
            return 0
        }
    }
}
extension ProfileVM {
    func registerCell(_ table: UITableView) {
        table.register(UINib(nibName: "ProfilePicCell", bundle: Bundle.main), forCellReuseIdentifier: "profile")
        table.register(UINib(nibName: "FormCell", bundle: Bundle.main), forCellReuseIdentifier: "form")
    }
}

