//
//  Item.swift
//  Todo App
//
//  Created by 王嵩允 on 9/13/24.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
