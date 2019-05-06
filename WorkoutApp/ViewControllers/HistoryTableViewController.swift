//
//  HistoryTableViewController.swift
//  WorkoutApp
//
//  Created by Orin Elmquist on 5/5/19.
//  Copyright © 2019 Orin Elmquist. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var exercisesDone = [Exercise]()
    var exerciseNames = Set<String>()
    @IBOutlet var historyTableView: UITableView!
    var selectedExercise = Exercise()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
    }
    
    func updateData() {
        let allWorkouts = try! Realm().objects(WorkoutDay.self)
        
        for workout in allWorkouts {
            for exercise in workout.workoutType!.exercises {
                if exercise.reps.count > 0 && !exerciseNames.contains(exercise.name) {
                    exercisesDone.append(exercise)
                    exerciseNames.insert(exercise.name)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
        historyTableView.reloadData()
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
        return exercisesDone.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyViewCell", for: indexPath) as? HistoryViewCell
        
        cell?.nameLabel.text = exercisesDone[indexPath.row].name

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedExercise = exercisesDone[indexPath.row]
        performSegue(withIdentifier: "goToChartView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ChartViewController {
            dest.chartExercise = selectedExercise
        }
    }
    
}

class HistoryViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
}
