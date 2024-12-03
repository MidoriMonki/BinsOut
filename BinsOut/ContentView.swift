//
//  ContentView.swift
//  BinsOut
//
//  Created by Zac Murray on 28/3/2023.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    //@AppStorage("whichDayIsBinDay") var myString = ""
    enum Bin: String, CaseIterable, Identifiable {
        case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
        var id: Self { self }
    }
    
    enum Week: String, CaseIterable, Identifiable {
        case Yellow, Red
        var id: Self { self }
    }
    
    @State var binDay: Bin = Bin.ID(rawValue: UserDefaults(suiteName: "group.bins")?.string(forKey:"binDay") ?? "Monday") ?? .Monday
    @State var binWeek: Week = Week.ID(rawValue: UserDefaults(suiteName: "group.bins")?.string(forKey:"binWeek") ?? "Yellow") ?? .Yellow
    //@State var binn = "Monday"


    var body: some View {
        VStack {
        
            //Image(systemName: "globe")
              //  .imageScale(.large)
                //.foregroundColor(.accentColor)

            //TextField("What is your bin day?", text: $binDay)
            Text("Set up your widget")
            
            Text("Your current selection:")
            
            List{
                //SELECT BINDAY
                Picker("Your bin day", selection: $binDay) {
                    Text("Monday").tag(Bin.Monday)
                    Text("Tuesday").tag(Bin.Tuesday)
                    Text("Wednesday").tag(Bin.Wednesday)
                    Text("Thursday").tag(Bin.Thursday)
                    Text("Friday").tag(Bin.Friday)
                    Text("Saturday").tag(Bin.Saturday)
                    Text("Sunday").tag(Bin.Sunday)
                }
                //SELECT BINWEEK
                Picker("Current bin week", selection: $binWeek) {
                    Text("Yellow Lid").tag(Week.Yellow)
                    Text("Red Lid").tag(Week.Red)
                }
                
                Button("Update", action:
                {
                    //UserDefaults(suiteName: "group.bins")?.set(binDay, forKey: "binTag")
                    UserDefaults(suiteName: "group.bins")?.set(binDay.rawValue, forKey: "binDay")
                    UserDefaults(suiteName: "group.bins")?.set(binWeek.rawValue, forKey: "binWeek")
                    
                    WidgetCenter.shared.reloadAllTimelines()
                })
                //Text(boy)
                
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func submit()
{
    
}
// What day is your bin day?
// Which bin week is it? <- Yellow + Green || Red + Green
