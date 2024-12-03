//
//  DayConfig.swift
//  BinsOut
//
//  Created by Zac Murray on 28/3/2023.
//

import SwiftUI

struct dayConfig{
    let colour: Color
    
    static func determineColour(from date: Date) -> dayConfig {
        //let dayInt = Calendar.current.component(.day, from: date)
        
        return dayConfig(colour: .green)
    }
}


