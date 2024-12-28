//
//  ContentView.swift
//  BinsOut
//
//  Created by Zac Murray on 28/3/2023.
//

import SwiftUI
import WidgetKit

enum Day: String, CaseIterable, Identifiable {
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
    var id: Self { self }
}
enum Colour: String, CaseIterable, Identifiable {
    case Yellow, Red
    var id: Self { self }
}

struct ContentView: View {
    //@AppStorage("whichDayIsBinDay") var myString = ""
    
   // @State var binDay = [Day.Monday, Day.Monday, Day.Monday,  Day.Monday]//: [Day] = [Day.ID(rawValue: UserDefaults(suiteName: "group.bins")?.string(forKey:"binDay") ?? "Monday") ?? .Monday]
    //@State var binColour = [Colour.Yellow, Colour.Yellow, Colour.Yellow, Colour.Yellow]//: [Colour] = [Colour.ID(rawValue: UserDefaults(suiteName: "group.bins")?.string(forKey:"binColour") ?? "Yellow") ?? .Yellow]
    @State var binDay = setUpBinDay()
    //@State var binDay: [Day] = [Day.ID(rawValue: UserDefaults(suiteName: "group.bins")?.string(forKey:"binDay") ?? "Monday") ?? .Monday, .Monday, .Monday, .Monday]
    @State var binColour = setUpBinColour()
   // @State var binDay: Bin = Bin.ID(rawValue: UserDefaults(suiteName: "group.bins")?.string(forKey:"binDay") ?? "Monday") ?? .Monday
    //@State var binWeek: Week = Week.ID(rawValue: UserDefaults(suiteName: "group.bins")?.string(forKey:"binWeek") ?? "Yellow") ?? .Yellow
    @State var weekCount: Int = UserDefaults(suiteName: "group.bins")?.integer(forKey:"weekCount") ?? 0
    
    
    //@State var binn = "Monday"
    
    var body: some View {
        VStack() {
            //Text(meow[0].rawValue)
            Text("Set up your widget schedule")
                .padding()
            List(){
                //"Starting Today, "+nd(nextBinDate: Date())
                if (weekCount == 1){
                    Text("Schedule repeats every week")
                        .padding(0)
                }else{
                    Text("Schedule repeats every "+String(weekCount)+" weeks")
                        .padding(0)
                }
                //Image(systemName: "globe")
                  //  .imageScale(.large)
                    //.foregroundColor(.accentColor)

                //TextField("What is your bin day?", text: $binDay)
                Text("\n\nThis Week - "+nd(nextBinDate: determineDate(nextBinDay:  binDay[0].rawValue, weeksFromNow: 0)))
                //Week 1
                HStack{
                    Picker("", selection: $binDay[0]) {
                        Text("Monday").tag(Day.Monday)
                        Text("Tuesday").tag(Day.Tuesday)
                        Text("Wednesday").tag(Day.Wednesday)
                        Text("Thursday").tag(Day.Thursday)
                        Text("Friday").tag(Day.Friday)
                        Text("Saturday").tag(Day.Saturday)
                        Text("Sunday").tag(Day.Sunday)
                    }

                    //SELECT BINWEEK
                    Picker("", selection: $binColour[0]) {
                        Text("Yellow Lid").tag(Colour.Yellow)
                        Text("Red Lid").tag(Colour.Red)
                        //Text("None").tag(Colour.None)
                    }
                }
            
                if(weekCount > 1 || weekCount == 0){
                    
                    Text("\n\nNext Week - "+nd(nextBinDate: determineDate(nextBinDay:  binDay[1].rawValue, weeksFromNow: 1)))
                    //Week 2
                    HStack{
                        Picker("", selection: $binDay[1]) {
                            Text("Monday").tag(Day.Monday)
                            Text("Tuesday").tag(Day.Tuesday)
                            Text("Wednesday").tag(Day.Wednesday)
                            Text("Thursday").tag(Day.Thursday)
                            Text("Friday").tag(Day.Friday)
                            Text("Saturday").tag(Day.Saturday)
                            Text("Sunday").tag(Day.Sunday)
                        }

                        //SELECT BINWEEK
                        Picker("", selection: $binColour[1]) {
                            Text("Yellow Lid").tag(Colour.Yellow)
                            Text("Red Lid").tag(Colour.Red)
                            //Text("None").tag(Colour.None)
                        }
                    }
                }
                
                if(weekCount > 2){
                    
                    Text("\n\nWeek 3 - "+nd(nextBinDate: determineDate(nextBinDay:  binDay[2].rawValue, weeksFromNow: 2)))
                    //Week 2
                    HStack{
                        Picker("", selection: $binDay[2]) {
                            Text("Monday").tag(Day.Monday)
                            Text("Tuesday").tag(Day.Tuesday)
                            Text("Wednesday").tag(Day.Wednesday)
                            Text("Thursday").tag(Day.Thursday)
                            Text("Friday").tag(Day.Friday)
                            Text("Saturday").tag(Day.Saturday)
                            Text("Sunday").tag(Day.Sunday)
                        }

                        //SELECT BINWEEK
                        Picker("", selection: $binColour[2]) {
                            Text("Yellow Lid").tag(Colour.Yellow)
                            Text("Red Lid").tag(Colour.Red)
                            //Text("None").tag(Colour.None)
                        }
                    }
                }
                
                if(weekCount > 3){
                    
                    Text("\n\nWeek 4 - "+nd(nextBinDate: determineDate(nextBinDay:  binDay[3].rawValue, weeksFromNow: 3)))
                    //Week 2
                    HStack{
                        Picker("", selection: $binDay[3]) {
                            Text("Monday").tag(Day.Monday)
                            Text("Tuesday").tag(Day.Tuesday)
                            Text("Wednesday").tag(Day.Wednesday)
                            Text("Thursday").tag(Day.Thursday)
                            Text("Friday").tag(Day.Friday)
                            Text("Saturday").tag(Day.Saturday)
                            Text("Sunday").tag(Day.Sunday)
                        }

                        //SELECT BINWEEK
                        Picker("", selection: $binColour[3]) {
                            Text("Yellow Lid").tag(Colour.Yellow)
                            Text("Red Lid").tag(Colour.Red)
                            //Text("None").tag(Colour.None)
                        }
                    }
                }
                
                Button("Add Week", action:{
                    //For some reason unbeknownst to God, weekCount cannot be set to any number other than 0 for default
                    //Therefore, the program must assume that 0 is infact 2, as the only way to have a count of 0,
                    //is to have not touched any of the settings
                    
                    if (weekCount == 0){
                        weekCount = 3
                    }else if (weekCount<4){
                        weekCount += 1
                    }
                    //Check to see if enough weeks have been initialised, if not then add a week
                    if (binDay.count < weekCount){
                        binDay.append(Day.Monday)
                        binColour.append(Colour.Red)
                    }
                })
                
                Button("Remove Week", action:{
                    //For some reason unbeknownst to God, weekCount cannot be set to any number other than 0 for default
                    //Therefore, the program must assume that 0 is infact 2, as the only way to have a count of 0,
                    //is to have not touched any of the settings
                    if (weekCount == 0){
                        weekCount = 1
                    }else if (weekCount>1){
                        weekCount -= 1
                    }
                })
                /*
                .onChange(of: weekCount) { oldValue, newValue in
 
                }*/
                Button("Update Schedule", action:
                {
                    var rawDay = []
                    for i in binDay{
                        rawDay.append(i.rawValue)
                    }
                    var rawColour = []
                    for i in binColour{
                        rawColour.append(i.rawValue)
                    }
                    UserDefaults(suiteName: "group.bins")?.set(rawDay, forKey: "binDay")
                    UserDefaults(suiteName: "group.bins")?.set(rawColour, forKey: "binColour")
                    UserDefaults(suiteName: "group.bins")?.set(weekCount, forKey: "weekCount")
                    //UserDefaults.resetStandardUserDefaults()
                    WidgetCenter.shared.reloadAllTimelines()
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func setUpBinDay() -> [Day]{
    var d = [Day]()
    let s: [String] = UserDefaults(suiteName: "group.bins")?.stringArray(forKey:"binDay") ?? ["Monday", "Monday"]
    for i in s{
        d.append(Day(rawValue: i) ?? .Monday)
    }
    return d
}

func setUpBinColour() -> [Colour]{
    var d = [Colour]()
    let s: [String] = UserDefaults(suiteName: "group.bins")?.stringArray(forKey:"binColour") ?? ["Yellow", "Yellow"]
    for i in s{
        d.append(Colour(rawValue: i) ?? .Yellow)
    }
    return d
}

func nd(nextBinDate: Date) -> String {
    let dateFormatter = DateFormatter()

    // Set Date/Time Style
    dateFormatter.locale = Locale(identifier: "en_GB")
    dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd") // // set template after setting locale
    return dateFormatter.string(from: nextBinDate)
    
}

func determineDate(nextBinDay: String, weeksFromNow: Int) -> Date {
    //Figure out which date this week's binDay is on
    let currentDate = Date()
    let dayList = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var nextBinDate: Date
    
    if #available(iOSApplicationExtension 15.0, *) {
        //firstIndex to find where the day fits in list, then subtract where today fits in the list
        let daysAway = dayList.firstIndex(of: nextBinDay)! - dayList.firstIndex(of: currentDate.formatted( .dateTime.weekday(.wide)))!
        nextBinDate = Calendar.current.date(byAdding: .day, value: daysAway+(7*weeksFromNow), to: currentDate)!
    }else{
        nextBinDate = currentDate
    }
    return nextBinDate
}
