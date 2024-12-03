//
//  BinsOutWidget.swift
//  BinsOutWidget
//
//  Created by Zac Murray on 28/3/2023.
//

import WidgetKit
import SwiftUI
import Intents

//Puts it all together?
struct BinsOutWidget: Widget {
    let kind: String = "BinsOutWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            BinsOutWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("When is Bin Day?")
        .description("A handy little widget that tells you when to take out each of your bins.")
        .disableContentMarginsIfNeeded()
    }
}

extension WidgetConfiguration {
    func disableContentMarginsIfNeeded() -> some WidgetConfiguration {
        if #available(iOSApplicationExtension 17.0, *) {
            return self.contentMarginsDisabled()
        } else {
            return self
        }
    }
}



//A view of the model for the widget, needs a date var
struct SimpleEntry: TimelineEntry {
    //Add parameters for Timeline updates
    let date: Date
    let nextBinDate: Date
    let daysAway: Int
    let binWeek: String
    //let configuration: ConfigurationIntent
}
//Retrieve data for widget while in differents stages
//IntentTimelineProvider
struct Provider: IntentTimelineProvider {
    //Loading state of widget, as in like everything like images haven't loaded yet.
    func placeholder(in context: Context) -> SimpleEntry {
        let entry = SimpleEntry(date: Date(), nextBinDate: Date(), daysAway: 1, binWeek:"Yellow")
        return entry;
    }
    //Preview of widget, when user is going to add widget to home screen
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), nextBinDate: Date(), daysAway: 1, binWeek: "Yellow")
        completion(entry)
    }
    
    //Always has list of entries, basically once its added to home screen, create entries and put them into the time line
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        let dayList = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

        
        var token = 0
        var daysAway = 0
        var nextBinDate = Date()
        var binWeek = UserDefaults(suiteName: "group.bins")?.string(forKey:"binWeek") ?? "Yellow"
        let binDay = UserDefaults(suiteName: "group.bins")?.string(forKey:"binDay") ?? "Monday"
        var entryDaysAway = 0
        
        //Figure out which date this week's binDay is on, and how many daysAway it is
        if #available(iOSApplicationExtension 15.0, *) {
            daysAway = dayList.firstIndex(of: binDay)! - dayList.firstIndex(of: currentDate.formatted( .dateTime.weekday(.wide)))!
            nextBinDate = Calendar.current.date(byAdding: .day, value: daysAway, to: currentDate)!
        }
        
        //For each day, create an entry
        for dayOffset in 0 ..< 14 {
            
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let startOfDate = Calendar.current.startOfDay(for: entryDate)

            if #available(iOSApplicationExtension 15.0, *) {
                entryDaysAway = daysAway
                //Check when binDay is relative to the entry
                if (daysAway == 0){
                    //Bin day is today :)
                    //
                    nextBinDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)!
                    daysAway = 6
                    token = 0
                    
                }else if (daysAway > 0){
                    //Bin day is soon :O
                    //
                    if (token == 1){
                        //daysAway = 7
                        if (binWeek == "Yellow"){
                            binWeek = "Red"
                        }else{
                            binWeek = "Yellow"
                        }
                        token = 0
                    }
                    daysAway-=1
                }else{
                    //Bin day has passed :(
                    //
                    //Works opposite to if the bin day is soon, will set token to 1 after completion because a soon
                    //can only occur after a binDay is today, so it will be set to 1 anyway
                    if (token == 0){
                        nextBinDate = Calendar.current.date(byAdding: .day, value: 7+daysAway, to: entryDate)!
                        if (binWeek == "Yellow"){
                            binWeek = "Red"
                        }else{
                            binWeek = "Yellow"
                        }
                        token = 1
                    }
                    daysAway+=1
                }
            }

            //Pass all the parametres each entry is looking for
            let entry = SimpleEntry(date: startOfDate, nextBinDate: nextBinDate, daysAway: entryDaysAway, binWeek: binWeek)
            //let entry = SimpleEntry(date: startOfDate, week: weeek, next: dd(), check: nn(), configuration: configuration)
            entries.append(entry)
        }
        
        //let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

//UserDefaults.standard.object(forKey:"whichDayIsBinDay") as! String


//Root view of widget
struct BinsOutWidgetEntryView : View  {
    var entry: Provider.Entry
    
    // This is how we get the widget family (size)
    @Environment(\.widgetFamily) var widgetFamily: WidgetFamily
    
    let red = Color(red: 0.80, green: 0.30, blue: 0.30)
    let purple = Color(red: 0.65, green: 0.15, blue: 0.40)
    let yellow = Color(red: 0.95, green: 0.88, blue: 0.28)
    let orange = Color(red: 0.92, green: 0.70, blue: 0.15)
    let black = Color(red: 0.15, green: 0.15, blue: 0.15)
    let grey = Color(red: 0.11, green: 0.11, blue: 0.11)
    
    var body: some View {
        
        if #available(iOSApplicationExtension 15.0, *) {
            let binWeek = entry.binWeek
            let nextBinDate = entry.nextBinDate
            let daysAway = entry.daysAway
            
            ZStack {
                //Set backdrop
                /*
                if (binWeek == "Yellow" && daysAway == 0){
                    ContainerRelativeShape() .fill(//LinearGradient(colors: [yellow, orange], startPoint: .topLeading, endPoint: .bottomTrailing))}
                    orange)}
                else if (binWeek == "Red" && daysAway == 0){
                    ContainerRelativeShape() .fill(//LinearGradient(colors: [red, purple], startPoint: .topLeading, endPoint: .bottomTrailing))}
                    red)}
                else{
                    ContainerRelativeShape() .fill((black))
                }*/
                
                VStack{
                    HStack{
                        //UserDefaults(suiteName: "group.bins")?.set(binDay.rawValue, forKey: "binDay")
                        //set day value
                        /*
                        switch(daysAway){
                        case 1:
                            Text("Tomorrow\n" + binWeek + " Lid")
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.4))
                                .multilineTextAlignment(.center)
                        case 0:
                            Text("Today\n" + binWeek + " Lid")
                                .fontWeight(.bold)
                                .foregroundColor(.black.opacity(0.4))
                                .multilineTextAlignment(.center)
                        default:
                            let s = nextBinDate.formatted(.dateTime.day(.twoDigits))
                            let m = nextBinDate.formatted( .dateTime.weekday(.wide))
                            Text(s + m + "\n" + binWeek + " Lid")
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.4))
                                .multilineTextAlignment(.center)
                        }
                         */
                    }
                    
                    if (binWeek == "Yellow"){
                        if (daysAway != 0){
                            Image("nightYellow")
                                .resizable()
                                .scaledToFit()
                                //.containerRelativeFrame(.horizontal){ size, axis in size }
                                .frame(width: UIScreen.main.bounds.size.width/2.3, height: UIScreen.main.bounds.size.height/2.3)
                                //.position(x:0)
                        }else{
                            Image("dayYellow")
                                .resizable()
                                .scaledToFit()
                                //.containerRelativeFrame(.horizontal){ size, axis in size }
                                .frame(width: UIScreen.main.bounds.size.width/2.3, height: UIScreen.main.bounds.size.height/2.3)
                                //.position(x:0)
                        }
                    
                    }else{
                        if (daysAway != 0){
                            Image("nightRed")
                                .resizable()
                                .scaledToFit()
                                //.containerRelativeFrame(.horizontal){ size, axis in size }
                                .frame(width: UIScreen.main.bounds.size.width/2.3, height: UIScreen.main.bounds.size.height/2.3)
                                //.position(x:0)
                        }else{
                            Image("dayRed")
                                .resizable()
                                .scaledToFit()
                                //.containerRelativeFrame(.horizontal){ size, axis in size }
                                .frame(width: UIScreen.main.bounds.size.width/2.3, height: UIScreen.main.bounds.size.height/2.3)
                                //.position(x:0)
                        }
                        
                    }
                }
                .containerBackground(.black, for: .widget)
                
                switch(daysAway){
                case 1:
                    Text("\n\n\n\n\n\n\nTomorrow\n")
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.4))
                        .multilineTextAlignment(.center)
                case 0:
                    Text("\n\n\n\n\n\n\nToday\n")
                        .fontWeight(.bold)
                        .foregroundColor(.black.opacity(0.4))
                        .multilineTextAlignment(.center)
                default:
                    
                    //let s = nextBinDate.formatted(.dateTime.day(.twoDigits))
                    //let m = nextBinDate.formatted( .dateTime.weekday(.wide))
                    Text("\n\n\n\n\n\n\n"+nd(nextBinDate: nextBinDate)+"\n")
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.4))
                        .multilineTextAlignment(.center)
                }
                //.containerBackground(.red.gradient, for: .widget)
                //.contentMargins(0.0, for: .widget)
                
                // Now choose a view to display based on the widget family
                /*
                switch widgetFamily {
                case .systemSmall:
                    Text("I'm small")
                case .systemMedium:
                    Text("I'm medium")
                case .systemLarge:
                    Text("I'm large")
                default:
                    Text("You probably won’t see this one...")
                }
                 */
            }
        }
    }
}

func nd(nextBinDate: Date) -> String {
    let dateFormatter = DateFormatter()

    // Set Date/Time Style
    dateFormatter.locale = Locale(identifier: "en_GB")
    dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd") // // set template after setting locale
    return dateFormatter.string(from: nextBinDate)
    
}