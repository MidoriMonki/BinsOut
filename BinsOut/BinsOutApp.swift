//
//  BinsOutApp.swift
//  BinsOut
//
//  Created by Zac Murray on 28/3/2023.
//

import SwiftUI

@main
struct BinsOutApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                //I think this defines the name space where we store shared variables
                //Setting "whichDayIsBinDay" to binDay.rawValue: UserDefaults(suiteName: "group.bins")?.set(binDay.rawValue, forKey: "whichDayIsBinDay") ?? "Monday"
                //Grabbing a string of value of "whichDayIsBinDay": UserDefaults(suiteName: "group.bins")?.string(forKey:"whichDayIsBinDay") ?? "Yellow"
                //Pretty sure the ?? is for if it fails, default will be what follows
                .defaultAppStorage(UserDefaults(suiteName: "group.bins")!)
        }
    }
}
