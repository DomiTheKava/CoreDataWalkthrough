//
//  ViewController.swift
//  CoreDataWalkthrough
//
//  Created by Dominik Penkava on 10/24/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var lableBottom: UILabel!
    @IBOutlet weak var aboutText: UITextField!
    
    var dataManager: NSManagedObjectContext!
    var listArray = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.persistentContainer.viewContext
        lableBottom.text?.removeAll()
        fetchData()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func btnSave(_ sender: Any) {
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: "Item", into: dataManager)
        newEntity.setValue(aboutText.text, forKey: "about")
        
        do {
            try self.dataManager.save()
            listArray.append(newEntity)
        } catch {
            print("Error saving data")
        }
        lableBottom.text?.removeAll()
        aboutText.text?.removeAll()
        fetchData()
        
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        
        let deleteItem = aboutText.text
        for item in listArray {
            if (item.value(forKey: "about") as! String) == deleteItem {
                dataManager.delete(item)
            }
            
            do {
                try self.dataManager.save()
            } catch {
                print("Error deleting data")
            }
            lableBottom.text?.removeAll()
            aboutText.text?.removeAll()
            fetchData()
            
        }
        
    }
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
        do {
            let result = try dataManager?.fetch(fetchRequest)
            listArray = result as! [NSManagedObject]
            for item in listArray {
                let product = item.value(forKey: "about") as! String
                lableBottom.text? += product
                
            }
        } catch {
            print("Failed to fetch data")
        }
        
    }
}

