//
//  WorkoutTableViewController.swift
//  WorkoutApp
//
//  Created by Orin Elmquist on 4/18/19.
//  Copyright © 2019 Orin Elmquist. All rights reserved.
//

import UIKit
import RealmSwift

class WorkoutTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var workoutList = try! Realm().objects(WorkoutDay.self)
    @IBOutlet var workoutTableView: UITableView!
    var viewingWorkout = false
    var workoutToDisplay = WorkoutDay()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "New Workout"
        workoutTableView.reloadData()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutViewCell", for: indexPath) as? workoutViewCell
        cell?.titleLabel?.text = workoutList[indexPath.row].workoutType?.name
        
        let viewDate = DateFormatter()
        viewDate.dateFormat = "MM/dd/yy"
        
        cell?.dateLabel?.text = viewDate.string(from: Date(timeIntervalSince1970: workoutList[indexPath.row].date))

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            try! self.realm.write {
                self.realm.delete(workoutList[indexPath.row])
            }
            workoutList = try! Realm().objects(WorkoutDay.self)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewingWorkout = true
        workoutToDisplay = workoutList[indexPath.row]
        performSegue(withIdentifier: "viewWorkout", sender: self)
    }
    
    @IBAction func newWorkout(_ sender: Any) {
        performSegue(withIdentifier: "newWorkout", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if viewingWorkout {
            if let dest = segue.destination as? ViewWorkoutViewController {
                dest.currentWorkout = workoutToDisplay
            }
        }
    }
    
}

class workoutViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
