//
//  StudentsListViewController.swift
//  Hurrey_Assignment
//
//  Created by Nuthan Raju Pesala on 14/07/20.
//  Copyright © 2020 Nuthan Raju Pesala. All rights reserved.
//

import UIKit
import MessageUI

class StudentsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var studentData = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Student List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "location.fill"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(getAllLocations))
        navigationItem.rightBarButtonItem?.tintColor = .gray
         navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backicon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(handledismiss))
        navigationItem.leftBarButtonItem?.tintColor = .gray
    }
    @objc func handledismiss() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func getAllLocations() {
           let mapVC = self.storyboard?.instantiateViewController(identifier: "MapViewController") as! MapViewController
           mapVC.studentData = studentData
           mapVC.isFromSchool = true
        self.navigationController?.pushViewController(mapVC, animated: true)
       }
    
    @IBAction func emailBtnTapped(_ sender: UIButton) {
        guard let email = studentData[sender.tag].email else { print("Email is nil")
            return
        }
      
        if isValidEmail(emailStr: email) == true {

        let mailCompose = configureMailController(email: email)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailCompose, animated: true, completion: nil)
        }else {
            showAlert(title: "Error", message: "Failed to Open Email")
        }
        }else {
            self.showAlert(title: "Error", message: "Email is not valid")
        }
    }
    
    @IBAction func mobileBtnTapped(_ sender: UIButton) {
        guard let phNumber = studentData[sender.tag].mobile  else {
            print("PhNumber is nil")
            return
        }
        print("phNumber",phNumber)
        if phNumber.count != 13 {
            self.showAlert(title: "Error", message: "phNumber is not Valid")
        }else {
        
        if let url = URL(string: phNumber) {
            if #available(iOS 13, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(phNumber): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(phNumber): \(success)")
            }
        }
        }
        
    }
    
    @IBAction func mapBtnTapped(_ sender: UIButton) {
        let mapVC = self.storyboard?.instantiateViewController(identifier: "MapViewController") as! MapViewController
        mapVC.latitude = Double(studentData[sender.tag].latitude!)!
        mapVC.longitude = Double(studentData[sender.tag].longitude!)!
        mapVC.studentName = studentData[sender.tag].name ?? ""
        mapVC.mobile = studentData[sender.tag].mobile ?? ""
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func showAlert(title: String, message: String) {
         let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
         alertController.addAction(okAction)
         self.present(alertController, animated: true, completion: nil)
     }
    //checking emailId format
        func isValidEmail(emailStr:String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: emailStr)
        }
}

extension StudentsListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ClassModelTableViewCell
        let data = studentData[indexPath.row]
        cell.nameLabel.text = data.name
        cell.emailBtn.tag = indexPath.row
        cell.mobileBtn.tag = indexPath.row
        cell.mapBtn.tag = indexPath.row
        
        return cell
    }
    
  
}

extension StudentsListViewController: MFMailComposeViewControllerDelegate {
    
    func configureMailController(email: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([email])
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
