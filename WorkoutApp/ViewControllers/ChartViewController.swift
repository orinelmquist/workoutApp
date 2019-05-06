//
//  ChartViewController.swift
//  WorkoutApp
//
//  Created by Orin Elmquist on 5/5/19.
//  Copyright © 2019 Orin Elmquist. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

class ChartViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var chartView: BarChartView!
    var chartExercise = Exercise()
    var days = [String]()
    var avg = [Double]()

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = chartExercise.name
        
        let allWorkouts = try! Realm().objects(WorkoutDay.self)
        
        var totalW = 0.0
        var totalR = 0.0
        
        for workout in allWorkouts {
            for exercise in workout.workoutType!.exercises {
                if exercise.reps.count > 0 && chartExercise.name == exercise.name {
                    let viewDate = DateFormatter()
                    viewDate.dateFormat = "MM/dd/yy"
                    days.append(viewDate.string(from: Date(timeIntervalSince1970: workout.date)))
                    totalR = 0.0
                    totalW = 0.0
                    for i in (0 ... exercise.reps.count - 1) {
                        totalR += Double(exercise.reps[i])
                        totalW += Double(exercise.weights[i])
                    }
                    avg.append(totalW / totalR)
                }
            }
        }
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in (0 ... days.count - 1) {
            let dataEntry = BarChartDataEntry(x: Double(i), y: avg[i])
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Average weights by day")
        let chartData = BarChartData(dataSet: chartDataSet)
        chartView.data = chartData
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
}
