//
//  ListScreenViewController.swift
//  TableViewTest
//
//  Created by Bradley Windybank on 28/01/20.
//  Copyright © 2020 Bradley Windybank. All rights reserved.
//

import UIKit
import CoreData

class ListScreenViewController: UIViewController {
    var items: [NSManagedObject] = []

    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()
        mainTableView.reloadData()
    }
    
    func toggleComplete(row: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tasks")
        
        do {
            let tempItems = try managedContext.fetch(fetchRequest)
            let itemUpdate = tempItems[row]
            let completed = itemUpdate.value(forKey: "completed") as! Bool
            itemUpdate.setValue(!completed, forKeyPath: "completed")
            
            do {
                try managedContext.save()
                reloadData()
            }
            catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
            
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func reloadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tasks")
        
        do {
            items = try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deleteItem(row: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tasks")
        
        do {
            let tempItems = try managedContext.fetch(fetchRequest)
            let itemDelete = tempItems[row]
            managedContext.delete(itemDelete)
            try managedContext.save()
            reloadData()
            mainTableView.reloadData()
        }
            
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @objc func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view?.superview?.superview as? UITableViewCell else {
            fatalError()
        }
        
        guard let indexPath = mainTableView.indexPath(for: cell) else {
            return
        }
        
        toggleComplete(row: indexPath.row)
        mainTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    @objc func deleteIconTapped(gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view?.superview?.superview as? UITableViewCell else {
            fatalError()
        }
        
        guard let indexPath = mainTableView.indexPath(for: cell) else {
            return
        }
        
        deleteItem(row: indexPath.row)
//        mainTableView.reloadRows(at: [indexPath], with: .automatic)
    }

}

extension ListScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
        
        cell.setItem(item: items[indexPath.row])
        cell.checkIcon.isUserInteractionEnabled = true
        cell.checkIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        cell.selectionStyle = .none
        
        let completed = items[indexPath.row].value(forKey: "completed") as! Bool
        if !completed {
            cell.deleteIcon?.isUserInteractionEnabled = false
            cell.deleteIcon?.tintColor = .systemBackground
        } else {
            cell.deleteIcon?.isUserInteractionEnabled = true
            cell.deleteIcon?.tintColor = .darkGray
            cell.deleteIcon?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteIconTapped(gestureRecognizer:))))
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItem(row: indexPath.row)
        }
    }
}
