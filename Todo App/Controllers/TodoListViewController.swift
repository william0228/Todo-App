//
//  ViewController.swift
//  Todo App
//
//  Created by 王嵩允 on 9/5/24.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadAllItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        // Define alert format
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        // Define alert action
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if let safeMessage = textField.text {
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = safeMessage
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving new items, \(error)")
                    }
                }
                
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func loadAllItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

//MARK: - Search Bar Method

//extension TodoListViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        
//        loadAllItems(with: request, predicate: predicate)
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadAllItems()
//            
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//            
//        }
//    }
//}
