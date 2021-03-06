//
//  Convert.swift
//  TimetableApp
//
//  Created by 大西玲音 on 2021/05/03.
//

import Foundation

struct Convert {
    
    var week: ManageableWeek?
    var period: ManageablePeriod?
    
    var number: Int {
        guard let week = week else { return -1 }
        guard let period = period else { return -1 }
        return week.number + ManageableWeek.allCases.count * period.number
    }
    
}

private extension ManageableWeek {
    
    var number: Int {
        switch self {
            case .monday: return 0
            case .tuesday: return 1
            case .wednesday: return 2
            case .thursday: return 3
            case .friday: return 4
            case .saturday: return 5
        }
    }
    
}

private extension ManageablePeriod {
    
    var number: Int {
        switch self {
            case .one: return 0
            case .two: return 1
            case .three: return 2
            case .four: return 3
            case .five: return 4
            case .six: return 5
        }
    }
    
}

