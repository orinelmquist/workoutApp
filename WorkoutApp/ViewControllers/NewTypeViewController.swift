//
//  NewTypeViewController.swift
//  WorkoutApp
//
//  Created by Orin Elmquist on 4/18/19.
//  Copyright © 2019 Orin Elmquist. All rights reserved.
//

import UIKit
import RealmSwift

class NewTypeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var workoutTypeName: UITextField!
    @IBOutlet weak var addPicker: UIPickerView!
    @IBOutlet weak var existingPicker: UIPickerView!
    let realm = try! Realm()
    var exerciseList = getExcersizeList()
    var existingList = Set<Exercise>()
    var addSelected = Exercise()
    var existingSelected = Exercise()
    var type = 0
    var editType = WorkoutType()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPicker.delegate = self
        addPicker.dataSource = self
        
        existingPicker.delegate = self
        existingPicker.dataSource = self
        
        if type == 1 {
            existingList = Set(editType.exercises)
            workoutTypeName.text = editType.name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "New Type"
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == addPicker {
            return exerciseList.count
        } else {
            return existingList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == addPicker {
            return exerciseList[row].name
        } else {
            return Array(existingList)[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == addPicker {
            addSelected = exerciseList[row]
        } else {
            existingSelected = Array(existingList)[row]
        }
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        if existingList.contains(addSelected) {
            let alert = UIAlertController(title: "Exercise already in set.", message: "Select a different exercise to add.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if exerciseList.count == 0 {
            let alert = UIAlertController(title: "No exercises to add", message: "Create exercises to build a new workout.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if !existingList.contains(addSelected) {
            existingList.insert(addSelected)
            existingPicker.reloadAllComponents()
        }
        
    }
    
    @IBAction func removeButton(_ sender: Any) {
        
        if exerciseList.count == 0 {
            let alert = UIAlertController(title: "No exercises to remove", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if existingList.contains(existingSelected) {
            existingList.remove(existingSelected)
            existingPicker.reloadAllComponents()
        }
    }
    
    @IBAction func doneButton(_ sender: Any) {
        if workoutTypeName.text == nil {
            let alert = UIAlertController(title: "Choose a name", message: "Enter a name for your workout.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        if existingList.count == 0 {
            let alert = UIAlertController(title: "Must select exercises.", message: "Select at least one exercise.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
            
        if type == 1 {
            try! realm.write {
                editType.exercises.removeAll()
                for e in existingList {
                    editType.exercises.append(e)
                }
            }
        } else {
            
            let addWorkoutType = WorkoutType(name: workoutTypeName.text!)
            for e in existingList {
                addWorkoutType.exercises.append(e)
            }
            try! realm.write {
                realm.add(addWorkoutType)
            }
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
}
