//
//  ViewController.swift
//  Hurrey_Assignment
//
//  Created by Nuthan Raju Pesala on 13/07/20.
//  Copyright © 2020 Nuthan Raju Pesala. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

  
    var classData = [ClassModel]()
    var students = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getSchoolData()
        tableView.tableFooterView = UIView()
        navigationItem.title = "Class List"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "location.fill"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(getAllLocations))
        navigationItem.rightBarButtonItem?.tintColor = .gray
    }
    
    @objc func getAllLocations() {
        let mapVC = self.storyboard?.instantiateViewController(identifier: "MapViewController") as! MapViewController
        mapVC.studentData = students
        mapVC.isClustering = true
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
   func getSchoolData() {
           guard let url = URL(string: "https://www.w3dnetwork.com/api/08fe8af137d079a82cc1cb7035e66086.json") else {
               print("Invalid Url")
               return
           }
           URLSession.shared.dataTask(with: url) { (data, response, error) in
               if error != nil {
                   print("Error:",error?.localizedDescription as Any)
                   return
               }
               if let response = response as? HTTPURLResponse {
                   if response.statusCode == 200 {
                       guard let data = data else { print("Data is nill")
                           return  }
                       do {
                           if let json =  try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                              
                               //Array to hold all the classes in the response
                                var classArray = [ClassModel]()
                               
                             
                               if let classes = json["classes"] as? [[String: Any]]  {
                                   for classData in classes {
                                       //Class object that represents each class in the class array
                                       let classModel = ClassModel()
                                       
                                       if let name = classData["name"] as? String {
                                           classModel.name = name
                                          
                                       }
                                       if let section = classData["section"] as? String {
                                           classModel.section = section
                                            print(classModel.section)
                                       }
                                       if let students = classData["students"] as? [[String: Any]] {
                                           //Students list to represent all students in each class
                                        var studentsArray = [Student]()
                                           for studData in students {
                                               //Individual student object
                                               let student = Student()
                                               if let name = studData["name"] as? String, let email = studData["email"] as? String, let mobile = studData["mobile"] as? String, let latitude = studData["latitude"] as? String, let longitude = studData["longitude"] as? String {
                                                   student.name = name
                                                   student.email = email
                                                   student.latitude = latitude
                                                   student.longitude = longitude
                                                   student.mobile = mobile
                                                  
                                                   self.students.append(student)
                                                   studentsArray.append(student)
                                                   
                                               }
                                              
                                           }
                                           //adding all the students to individual class
                                          classModel.students = studentsArray
                                          
                                       }
                                       //add each class to class array
                                       classArray.append(classModel)
                                      
                                       //update the model
                                       self.classData = classArray
                                     
                                   }
                               }
                               DispatchQueue.main.async {
                                   self.tableView.reloadData()
                               }
                           }
                       }catch let err {
                          print("Error:",err.localizedDescription as Any)
                       }
                       
                   }
               }
           }.resume()
       }
    
    func imageFromInitials(firstName: String?, lastName: String?,  completion: @escaping (_ image: UIImage) -> Void) {
        var text : String?
        var size: CGFloat = 36.0
        
        if (firstName != nil && lastName != nil) {
            text = String((firstName?.first)!).uppercased() + String((lastName?.first)!).uppercased()
           
        }else if firstName != nil {
            text = String((firstName?.first)!)
            size = 36
        }
        
        let label = UILabel()
        label.frame.size = CGSize(width: 100, height: 100)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = .systemIndigo
        label.font = UIFont(name: label.font.familyName, size: size)
        label.text = text
        
        UIGraphicsBeginImageContext(label.frame.size)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
        completion(image)
        }
    }

   
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = classData[indexPath.row]
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as! SchoolListTableViewCell
       
        cell.className.text = "Class \(data.name ?? "0")"
        cell.sectionName.text = "section" + data.section!
        cell.noOfStudentsLabel.text = "Number Of Students,\(data.students?.count ?? 0)"
        self.imageFromInitials(firstName: data.name, lastName: nil, completion: { (image) in
             cell.profilePic.image = image
        })
  
       
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = classData[indexPath.row]
        let studentsVc = self.storyboard?.instantiateViewController(identifier: "StudentsListViewController") as! StudentsListViewController
        studentsVc.studentData = data.students!
        self.navigationController?.pushViewController(studentsVc, animated: true)
    }
    
}
