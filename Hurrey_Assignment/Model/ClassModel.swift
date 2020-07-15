//
//  ClassModel.swift
//  Hurrey_Assignment
//
//  Created by Nuthan Raju Pesala on 14/07/20.
//  Copyright © 2020 Nuthan Raju Pesala. All rights reserved.
//

import Foundation

class SchoolModel {
    
    var school_email: String?
    var school_id : String?
    var school_mobile : String?
    var school_name: String?
    var classes: [ClassModel]?
}

class ClassModel {
    
    var name: String?
    var section: String?
    var students : [Student]?

}

class Student {
    
    var email : String?
    var latitude: String?
    var longitude: String?
    var mobile: String?
    var name : String?
    
}
