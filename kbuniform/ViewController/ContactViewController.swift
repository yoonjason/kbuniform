//
//  ContactViewController.swift
//  kbuniform
//
//  Created by twave on 2020/10/19.
//  Copyright © 2020 seokyu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Contacts
import MessageUI

class ContactCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!

    override func prepareForReuse() {
        nameLabel.text = nil
        numberLabel.text = nil
    }

    func setView(_ contactData: CNContact) {
        nameLabel.text = contactData.familyName + contactData.middleName + contactData.givenName

        contactData.phoneNumbers.forEach { [self] phonenumber in
            let number = phonenumber.value.stringValue
            self.numberLabel.text = number
        }
    }

}

class ContactViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var contacts = BehaviorSubject<[CNContact]>(value: [])
    var tempContacts = [CNContact]()

    override func viewDidLoad() {
        super.viewDidLoad()
        readContacts()

        tableView
            .rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)

        contacts.bind(to: tableView.rx.items(cellIdentifier: "ContactCell", cellType: ContactCell.self)) { (index, contactData, cell) in
            cell.setView(contactData)
            cell.selectionStyle = .none
        }
            .disposed(by: rx.disposeBag)

        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(CNContact.self))
            .subscribe(onNext: { [self] (indexPath, item) in
                let cell = self.tableView.cellForRow(at: indexPath) as? ContactCell
                cell?.backgroundColor = .green
                item.phoneNumbers.forEach{ [self] phonenumber in
                    self.requestSMS(phonenumber.value.stringValue)
                }
                print("itemSelected")
            })
            .disposed(by: rx.disposeBag)
        tableView
            .rx
            .itemDeselected
            .subscribe(onNext: { indexPath in
                let cell = self.tableView.cellForRow(at: indexPath) as? ContactCell
                cell?.backgroundColor = .white
                print("itemDeSelected")
            })
            .disposed(by: rx.disposeBag)

    }

}

extension ContactViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }


    private func readContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (status, error) in
            guard status else {
                return
            }
            let request: CNContactFetchRequest = self.getContactFetchRequest()

            request.sortOrder = CNContactSortOrder.userDefault
            try! store.enumerateContacts(with: request) { [self] (contact, stop) in
                if !contact.phoneNumbers.isEmpty {
                    tempContacts.append(contact)
                    self.contacts.onNext(tempContacts)
                }
            }
        }
    }


    private func getContactFetchRequest() -> CNContactFetchRequest {
        let keys: [CNKeyDescriptor] = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactJobTitleKey,
            CNContactPostalAddressesKey

        ] as! [CNKeyDescriptor]

        return CNContactFetchRequest(keysToFetch: keys)
    }


    private func saveContact() {
        let store = CNContactStore()

        store.requestAccess(for: .contacts) { (status, error) in
            guard status else {
                return
            }
            let contact: CNMutableContact = self.getNewContact()
            let request = CNSaveRequest()
            request.add(contact, toContainerWithIdentifier: nil)

            try! store.execute(request)

        }
    }

    private func getNewContact() -> CNMutableContact {
        let contact = CNMutableContact()
        contact.givenName = "name"
        contact.familyName = "familyName"

        let phone = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: "010-0000-0000"))
        let tel = CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: "031-0000-0000"))

        contact.phoneNumbers = [phone, tel]

        let email: NSString = "yeong806@gmail.com"
        contact.emailAddresses = [CNLabeledValue(label: CNLabelWork, value: email)]
        return contact
    }

    private func requestSMS(_ number: String) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "안전한 송급입니다. 님께 송금여부를 직접 확인해보세요. \n 금액 : 3,000원 \n 아래 링크를 통해 받아주세요. \n https://www.etoland.co.kr/plugin/mobile/"
            controller.recipients = [number]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
}
