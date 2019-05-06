//
//  newWorkoutViewController.swift
//  WorkoutApp
//
//  Created by Orin Elmquist on 4/18/19.
//  Copyright © 2019 Orin Elmquist. All rights reserved.
//

import UIKit
import RealmSwift

class NewWorkoutViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var workoutDate: UIDatePicker!
    var editPressed = false
    let realm = try! Realm()
    var workoutList = try! Realm().objects(WorkoutType.self)
    lazy var selectedWorkout = workoutList[0]
    var newIndex = 0
    var viewingWorkout = false
    var workoutToDisplay = WorkoutDay()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typePicker.delegate = self
        typePicker.dataSource = self
        
        let workouts = try! Realm().objects(WorkoutDay.self)
        newIndex = workouts.count + 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "New Workout"
        workoutList = try! Realm().objects(WorkoutType.self)
        typePicker.reloadAllComponents()
        editPressed = false
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
        return workoutList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return workoutList[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedWorkout = workoutList[row]
    }

    @IBAction func newType(_ sender: Any) {
        performSegue(withIdentifier: "newEditType", sender: self)
    }
    
    @IBAction func editType(_ sender: Any) {
        
        if workoutList.count == 0 {
            let alert = UIAlertController(title: "No workout type", message: "Create a new workout type.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        editPressed = true
        performSegue(withIdentifier: "newEditType", sender: self)
    }
    
    @IBAction func createWorkout(_ sender: Any) {
        
        if workoutList.count == 0 {
            let alert = UIAlertController(title: "No workout type", message: "Create a new workout type to proceed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        let newWorkout = WorkoutDay(workoutType: selectedWorkout, date: workoutDate.date.timeIntervalSince1970, index: newIndex)
        
        try! realm.write {
            realm.add(newWorkout)
        }
        viewingWorkout = true
        workoutToDisplay = newWorkout
        
        performSegue(withIdentifier: "goToNewWorkout", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if editPressed {
            if let dest = segue.destination as? NewTypeViewController {
                dest.type = 1
                dest.editType = selectedWorkout
            }
        }
        if viewingWorkout {
                if let dest = segue.destination as? ViewWorkoutViewController {
                    dest.currentWorkout = workoutToDisplay
                }
        }
    }
    
}
