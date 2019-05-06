//
//  ViewWorkoutViewController.swift
//  WorkoutApp
//
//  Created by Orin Elmquist on 5/5/19.
//  Copyright © 2019 Orin Elmquist. All rights reserved.
//

import UIKit
import RealmSwift

class ViewWorkoutViewController: UITableViewController {
    
    let realm = try! Realm()
    var currentWorkout = WorkoutDay()
    var indexPicker: [NSIndexPath]?
    @IBOutlet var viewWorkoutTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let viewDate = DateFormatter()
        viewDate.dateFormat = "MM/dd/yy"
        
        navigationItem.title = viewDate.string(from: Date(timeIntervalSince1970: currentWorkout.date))
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentWorkout.workoutType?.exercises.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutDisplayViewCell", for: indexPath) as! workoutDisplayViewCell
        
        cell.exerciseName.text = currentWorkout.workoutType?.exercises[indexPath.row].name
        
        var sets = ""
        
        print("REPS:       " + String(currentWorkout.workoutType?.exercises[indexPath.row].reps.count ?? 0))
        print("WEIGHTS:    " + String(currentWorkout.workoutType?.exercises[indexPath.row].weights.count ?? 0))
        
        let setNum = currentWorkout.workoutType?.exercises[indexPath.row].reps.count ?? 0
        if (setNum > 0) {
            
            if setNum > 1 {
                for i in (0 ... setNum - 2) {
                    sets += String(currentWorkout.workoutType?.exercises[indexPath.row].reps[i] ?? 0)
                    sets += " "
                    sets += String(currentWorkout.workoutType?.exercises[indexPath.row].weights[i] ?? 0)
                    sets += "\n"
                }
            }
            sets += String(currentWorkout.workoutType?.exercises[indexPath.row].reps[setNum-1] ?? 0)
            sets += " "
            sets += String(currentWorkout.workoutType?.exercises[indexPath.row].weights[setNum-1] ?? 0)
        }
        
        cell.textField.text = sets
        
        cell.add.tag = indexPath.row
        cell.add.addTarget(self, action: Selector(("addButtonPressed:")), for: .touchUpInside)
        
        return cell
    }
    
    @objc func addButtonPressed(_ sender: UIButton) {
        let index = sender.tag
        let alert = UIAlertController(title: "New Set", message: "Add reps and weight", preferredStyle: .alert)
        alert.addTextField()
        alert.addTextField()
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            guard let repField = alert.textFields?.first else {return}
            repField.keyboardType = .numberPad
            guard let repSave = Int(repField.text!) else { return }
            guard let weightField = alert.textFields?[1] else {return}
            weightField.keyboardType = .numberPad
            guard let weightSave = Int(weightField.text!) else { return }
            try! self.realm.write {
                self.currentWorkout.workoutType?.exercises[index].reps.append(repSave)
                self.currentWorkout.workoutType?.exercises[index].weights.append(weightSave)
            }
            self.viewWorkoutTableView.reloadData()
        }
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
        
        
    }

}

class workoutDisplayViewCell: UITableViewCell {
    
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var textField: UITextView!
}
