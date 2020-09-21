//
//  MyWidget.swift
//  MyWidget
//
//  Created by twave on 2020/09/21.
//  Copyright © 2020 seokyu. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

//위젯을 새로고침할 타임라인을 결정하는 객체이다.
struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "()")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date(), configuration: configuration)
        var entry : SimpleEntry

        if context.isPreview {
            entry = SimpleEntry(date: Date(), title: "sadf")
            switch context.family {
            case .systemSmall:
                entry = SimpleEntry(date: Date(), title: "Previce && systemSmall")
            case .systemMedium :
                entry = SimpleEntry(date: Date(), title: "Previce && systemMedium")
            case .systemLarge:
                entry = SimpleEntry(date: Date(), title: "Previce && systemMLarge")
            @unknown default:
                entry = SimpleEntry(date: Date(), title: "default")
            }
        }else {
            entry = SimpleEntry(date: Date(), title: "configuration")
        }
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        //1시간씩 6번 반복함
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, title: "configuration")
            entries.append(entry)
        }
        /*
         예를들어 6시에 끝났으면 6시 넘어서 timeline을 요청하고
         새로운 timeline배열은
         [6시, 7시, 8시, 9시, 10시]가 되는거죠.
         */
        
        //entries -> 시간을 담은 배열, policy는 가장 이른 날짜를 나타내는 타입
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let title : String
//    let configuration: ConfigurationIntent
    
}

struct PRListEntry : TimelineEntry {
    var date = Date()
    let prList : [String]
}

struct MyWidgetEntryView: View {
    @Environment(\.widgetFamily) private var widgetFamily

    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
        switch widgetFamily {
        case .systemSmall:
            Text("systemSmall")
        case .systemMedium:
            Text("systemMedium")
        case .systemLarge: Text("systemLarge")
        @unknown default: Text("unknown")
        }
    }
}

@main
struct MyWidget: Widget {
    let kind: String = "MyWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MyWidgetEntryView(entry: entry)

        }
            .configurationDisplayName("집에 가고 싶다.")
            .description("요새 할 일이 그리 많지 않아서 참 좋다.")
            .supportedFamilies([.systemLarge, .systemMedium, .systemSmall])
    }


}

struct MyWidget_Previews: PreviewProvider {
    static var previews: some View {
        MyWidgetEntryView(entry: SimpleEntry(date: Date(), title:""))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
