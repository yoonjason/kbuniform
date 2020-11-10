//
//  EventViewController.swift
//  kbuniform
//
//  Created by twave on 2020/10/23.
//  Copyright © 2020 seokyu. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import RxSwift
import RxCocoa
import NSObject_Rx

class EventViewController: UIViewController, EKEventEditViewDelegate, EKCalendarChooserDelegate {

    @IBOutlet weak var addChooseBtn: UIButton!
    @IBOutlet weak var addEventBtn: UIButton!
    var eventStore = EKEventStore()
    var midnight = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "일정 등록하기"

        switch EKEventStore.authorizationStatus(for: .event) {
        case .notDetermined:
            eventStore.requestAccess(to: .event) { [self] (grant, error) in
                if grant {
//                    showEventView()

                }
                print("grant is \(grant)")
            }
        case .authorized:
            print("authorized")
//            showEventView()
        case .restricted:
            // iPhone 설정의 '사용자 정보 보호'에서 달력에 대한 접근을 제한하는 경우
            //"일정 앱에 접근 권한이 없습니다."
            print("restricted /// 일정 앱에 접근 권한이 없습니다.")
        case .denied:
            //달력에 대한 접근을 사용자가 거부한 경우
            //"일정 앱에 접근 권한이 없습니다."
            print("denied")
//        @unknown default:
//            print("")
        }


        getToday()

        addEventBtn
            .rx
            .tap
            .subscribe(onNext: {
                self.showEventView()
            })
            .disposed(by: rx.disposeBag)

        addChooseBtn
            .rx
            .tap
            .subscribe(onNext: {
                self.showCalendarChooser()
            })
            .disposed(by: rx.disposeBag)

    }

    private func showEventView() {
        let eventVC = EKEventEditViewController()
        eventVC.editViewDelegate = self
        eventVC.eventStore = self.eventStore

        let event = EKEvent(eventStore: eventVC.eventStore)
        event.title = "아임인 입금 날짜 입력 테스트"

        event.startDate = Date().midnight //날짜
        event.endDate = midnight
        event.isAllDay = true


        eventVC.event = event
        present(eventVC, animated: true, completion: nil)
    }

    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        print("dismiss")
        dismiss(animated: true, completion: nil)
    }

    func getToday() {
        let now = Date()
        print(now)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let tomorrow = Date(timeInterval: 86400, since: now)
        let tomorrowString = dateFormatter.string(from: tomorrow)
        let today = dateFormatter.string(from: now)
        let todayMidnight = tomorrowString + " 00:00:00"
        let tt = dateFormatter.date(from: todayMidnight)
        print("tomorrow date is \(tt), tomorrow string is \(todayMidnight)")
        self.midnight = tomorrow.midnight
        print("now...!\(today)")
        print("tomorrow.midnight ?? \(tomorrow.midnight)")
    }

    func showCalendarChooser() {
        let vc = EKCalendarChooser(selectionStyle: .multiple, displayStyle: .allCalendars, entityType: .event, eventStore: self.eventStore)
        vc.showsDoneButton = true
        vc.showsCancelButton = true
        vc.delegate = self
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
    }

    // Called whenever the selection is changed by the user
    func calendarChooserSelectionDidChange(_ calendarChooser: EKCalendarChooser) {
        
        print(#function)
    }


    // These are called when the corresponding button is pressed to dismiss the
    // controller. It is up to the recipient to dismiss the chooser.
    func calendarChooserDidFinish(_ calendarChooser: EKCalendarChooser) {
        dismiss(animated: true, completion: nil)
        print(#function)
    }

    func calendarChooserDidCancel(_ calendarChooser: EKCalendarChooser) {
        dismiss(animated: true, completion: nil)
        print(#function)
    }
}




extension Date {
    func localString(dateStyle: DateFormatter.Style = .medium,
                     timeStyle: DateFormatter.Style = .medium) -> String {
        return DateFormatter.localizedString(
            from: self,
            dateStyle: dateStyle,
            timeStyle: timeStyle)
    }

    var midnight: Date {
        let cal = Calendar(identifier: .gregorian)
        return cal.startOfDay(for: self)
    }
}
