//
//  DummyViewController.swift
//  Call Block
//
//  Created by Admin on 12/10/2017.
//  Copyright © 2017 globia Technologies. All rights reserved.
//

import UIKit
import ContactsUI
import GoogleMobileAds
import CallKit
class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, CNContactPickerDelegate {

    @IBOutlet weak var btnonoff: UIButton!
    @IBOutlet weak var Plabel: UIButton!
    @IBOutlet weak var Blabel: UIButton!
    @IBOutlet weak var bartitle: UIBarButtonItem!
    @IBOutlet weak var barlbl: UIBarButtonItem!
    
    var contactnumber = [String]()
    var contactnames = [String]()
    var dbnumbers = [Int64]()
    var dbnames = [String]()
 //   @IBOutlet weak var Contactlist: UITableView!
    @IBOutlet weak var onOff: UISwitch!
    var btnclick = 0
    @IBAction func btnonoff(_ sender: Any) {
        
        
        
        
        if btnclick == 0
        {
        btnonoff.layer.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.9190682159, blue: 0.09883598085, alpha: 1)
        btnonoff.setTitle("ON", for: .normal)
        btnclick = 1
        
            DBManager.shared.updateonoff(lbl: "ON")
            
            CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: "nomi.dev.blockcalldemo.callblockk")
        }
        else
        {
        btnonoff.layer.backgroundColor = #colorLiteral(red: 0.4425096512, green: 0.7010689378, blue: 0.9539292455, alpha: 1)
        btnonoff.setTitle("OFF", for: .normal)
        btnclick = 0
        DBManager.shared.updateonoff(lbl: "off")
            timer.invalidate()
            count = 0
            bartitle.image = UIImage.init(named: "icons8-No Reminders-32")
            bartitle.tintColor = UIColor.green
            bartitle.title = " "
        }
        
    }
    
    @IBOutlet weak var addview: GADBannerView!
    
    @IBOutlet weak var tbl: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dbnumbers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dbnames[indexPath.row]
        cell.detailTextLabel?.text = String(dbnumbers[indexPath.row])
        return cell
    }
    
    @IBAction func privatebtn(_ sender: Any) {
        Plabel.tintColor = UIColor.green
        Blabel.tintColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        tbl.isHidden = true
    }
    
    @IBAction func businessbtn(_ sender: Any) {
        tbl.isHidden = false
        Plabel.tintColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        Blabel.tintColor = UIColor.green
        
        
        
        tbl.reloadData()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        btnonoff.layer.cornerRadius = 35
//        btnonoff.layer.borderWidth = 6
       
        
        
        
        
        btnonoff.frame = CGRect(x: 100, y: 40, width: 130, height: 130)
        btnonoff.layer.borderWidth = 6
        btnonoff.layer.cornerRadius = 50

        btnonoff.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        
        btnonoff.layer.masksToBounds = true
        
        Plabel.tintColor = UIColor.green
        Blabel.tintColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        
        DispatchQueue.main.async {
            self.addview.adUnitID = "ca-app-pub-2828870879289463/1572902633"
            self.addview.rootViewController = self
            self.addview.load(GADRequest())
        }
        
           let b = DBManager.shared.createDatabase()
        
            if b == true
            {
                DBManager.shared.insrtintoblock()
            }
        
             print(b)
        
        
       
        tbl.isHidden = true
        
        dbnumbers = DBManager.shared.selectContacts()
        dbnames = DBManager.shared.selectContactsname()
    }

    
    @IBAction func Switcher(_ sender: Any) {
        if onOff.isOn == true
        {
            barlbl.title = "Off"
            onOff.isOn = false
        }
        else
        {
            barlbl.title = "On"
            onOff.isOn = true
        }
    }
    
    // https://www.appcoda.com/ios-contacts-framework/
    // https://developer.apple.com/documentation/callkit
    // https://stackoverflow.com/questions/36582670/swift-using-contacts-framework-search-using-phone-number-to-get-name-and-user-i
    @IBAction func Left(_ sender: UISwipeGestureRecognizer) {
     //   label.text = "Private"
        Plabel.tintColor = UIColor.green
        Blabel.tintColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        tbl.isHidden = true
        
    }
    
    @IBAction func Right(_ sender: UISwipeGestureRecognizer) {
       //  label.text = "Buisness"
         Plabel.tintColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
         Blabel.tintColor = UIColor.green
        tbl.isHidden = false
    }
    
    
    var count = 0
    var timer = Timer()
    @IBAction func bellHrs(_ sender: UIBarButtonItem) {
    //    count = (bartitle.title! as NSString).integerValue
       
       
//        if bartitle.title == "6 hours"
//        {
//            timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(blockunblock), userInfo: nil, repeats: true)
//
//        }
//
//        if bartitle.title == "12 hours"
//        {
//            timer.invalidate()
//
//            timer = Timer.scheduledTimer(timeInterval: 12 * 60 * 60, target: self, selector: #selector(blockunblock), userInfo: nil, repeats: true)
//
//        }
//        if bartitle.title == "18 hours"
//        {
//            timer.invalidate()
//
//            timer = Timer.scheduledTimer(timeInterval: 18 * 60 * 60, target: self, selector: #selector(blockunblock), userInfo: nil, repeats: true)
//
//        }
//        if bartitle.title == "24 hours"
//        {
//            timer.invalidate()
//
//            timer = Timer.scheduledTimer(timeInterval: 24 * 60 * 60, target: self, selector: #selector(blockunblock), userInfo: nil, repeats: true)
//
//        }
//        if bartitle.title != "6 hours" && bartitle.title != "12 hours" && bartitle.title != "18 hours" && bartitle.title != "24 hours"
//        {
//
//            timer.invalidate()
//
//        }
        
        
         if bartitle.title == "24 hours"
         {
            bartitle.image = UIImage.init(named: "icons8-No Reminders-32")
            bartitle.tintColor = UIColor.green
            bartitle.title = " "
            count = 0
        }
        else
        {
//            if count >= 24
//            {
//                count = 0
//            }
       
            if timer.isValid
            {
                timer.invalidate()
            }
        count = count + 6
        bartitle.title = String(count) + " hours"
        bartitle.tintColor = UIColor.white
        bartitle.image = UIImage.init(named: "")
           
          
            timerr(time: count)
        }
    }
    
    
    @objc func blockunblock()
    {
        DBManager.shared.updateonoff(lbl: "off")
        bartitle.image = UIImage.init(named: "icons8-No Reminders-32")
        bartitle.tintColor = UIColor.green
        bartitle.title = " "
        count = 0
    }
    
    func timerr(time:Int)
    {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(time * 60 * 60), target: self, selector: #selector(blockunblock), userInfo: nil, repeats: true)
    }
    
    @IBAction func ContactBtn(_ sender: UIButton) {
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        self.present(cnPicker, animated: true, completion: nil)
    }
    
    var namee = ""
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        contacts.forEach { contact in
            for number in contact.phoneNumbers {
                let phoneNumber = number.value
               // let name = contact.middleName
                contactnumber.append(String(describing: phoneNumber.stringValue))
                print("number is = \(phoneNumber.stringValue)")
                for name in contact.givenName {
                    let names = name.description
                    namee += names
                }
                contactnames.append(namee)
                namee = ""
            }
//            for name in contact.givenName {
//                let names = name.description
//                namee += names
//            }
            //contactnames.append(namee)
            
            print(namee)
        }
        if contactnumber.count != 0
        {
          

           
//            for ss in s.components(separatedBy: " ")
//            {
//                print(ss)
//
//            }
            
            
            tbl.reloadData()
            for i in 0...contactnumber.count - 1
            {
                
                
                let tem = contactnumber[i].replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression)
                
                print(tem)
                
//                var num = ""
//                var c =  Array(contactnumber[i].characters)
//
//                    for n in 0...c.count - 1
//                    {
//                        print(c[4])
//                        if n == 4
//                        {
//                            print("space")
//                        }
//                        else
//                        {
//                            let temp = c[n]
//                            num += String(temp)
//                        }
//                        print(num)
//                    }
//
//
  //              print(contactnames[i])
    //            print(contactnumber[i])
//                let ii = Int(num)
//                print(ii!)
//                var numf = String()
//                let num = contactnumber[i]
//                print(num)
//                var temp = num.components(separatedBy: " ")
//                print(temp[0])
//
//
//
//                //    numf = temp[0]+""+temp[1]
//
//                print(temp)
//                print(numf)
                
                let final = Int(tem)
                print(final!)
                DBManager.shared.insertContact(name: contactnames[i], number: final!)
                dbnumbers = [Int64]()
                dbnames = [String]()
                
                dbnumbers = DBManager.shared.selectContacts()
                dbnames = DBManager.shared.selectContactsname()
                tbl.reloadData()
                
                
            }
            
            
            
        }
    }
    
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }

  

}
