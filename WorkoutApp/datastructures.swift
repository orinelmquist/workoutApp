//
//  datastructures.swift
//  
//
//  Created by Orin Elmquist on 5/5/19.
//

import Foundation
import UIKit
import RealmSwift

class WorkoutDay: Object {
    @objc dynamic var workoutType: WorkoutType? = WorkoutType()
    @objc dynamic var date: Double = 0
    @objc dynamic var index: Int = 0
    
    convenience init(workoutType: WorkoutType, date: Double, index: Int) {
        self.init()
        self.workoutType = workoutType
        self.date = date
        self.index = index
    }
}


class WorkoutType: Object {
    @objc dynamic var name: String = ""
    let exercises = List<Exercise>()
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}

class Exercise: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var type: Int = 0
    let reps = List<Int>()
    let weights = List<Int>()
    
    convenience init(name: String, type: Int) {
        self.init()
        self.name = name
        self.type = type
    }
}
