//
//  NewItemScreen.swift
//  TableViewTest
//
//  Created by Bradley Windybank on 28/01/20.
//  Copyright © 2020 Bradley Windybank. All rights reserved.
//

import UIKit
import CoreData

class NewItemScreen: UIViewController {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.action = #selector(buttonClicked(sender:))
        dateTimePicker.minimumDate = Date()
    }
    
    @objc func buttonClicked(sender: UIBarButtonItem) {
        guard let text = titleField.text else {
            return
        }
        
        save(title: text, date: dateTimePicker.date, completed: false)
        
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    func save(title: String, date: Date, completed: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: managedContext)!
        let task = NSManagedObject(entity: entity, insertInto: managedContext)
        
        task.setValue(title, forKeyPath: "title")
        task.setValue(date, forKeyPath: "date")
        task.setValue(completed, forKeyPath: "completed")
        
        do {
            try managedContext.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
