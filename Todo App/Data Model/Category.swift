//
//  Category.swift
//  Todo App
//
//  Created by 王嵩允 on 9/13/24.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
