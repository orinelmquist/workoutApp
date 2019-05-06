//
//  exercises.swift
//  
//
//  Created by Orin Elmquist on 5/5/19.
//

import Foundation
import RealmSwift
import UIKit

func getExcersizeList() -> [Exercise] {
    let exerciseList = [
        Exercise(name: "Bench Press", type: 1),
        Exercise(name: "Calf Raise", type: 1),
        Exercise(name: "Chest Fly", type: 1),
        Exercise(name: "Curl", type: 1),
        Exercise(name: "Deadlift", type: 1),
        Exercise(name: "Lateral Raise", type: 1),
        Exercise(name: "Leg Curl", type: 1),
        Exercise(name: "Leg Extension", type: 1),
        Exercise(name: "Leg Press", type: 1),
        Exercise(name: "Pull Down", type: 1),
        Exercise(name: "Pull Up", type: 1),
        Exercise(name: "Pushdown", type: 1),
        Exercise(name: "Row", type: 1),
        Exercise(name: "Shoulder Press", type: 1),
        Exercise(name: "Shoulder Fly", type: 1),
        Exercise(name: "Shrug", type: 1),
        Exercise(name: "Squat", type: 1),
        Exercise(name: "Triceps Extension", type: 1)
    ]
    return exerciseList
}

func copyE(_ e: Exercise) -> Exercise {
    return Exercise(name: e.name, type: e.type)
}
