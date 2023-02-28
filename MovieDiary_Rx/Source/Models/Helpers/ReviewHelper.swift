//
//  ReviewHelper.swift
//  MovieDiary
//
//  Created by KangMingyo on 2022/10/30.
//

import Foundation
 
struct ReviewHelper {
    func evalImage(_ eval: String) -> String {
        if eval == "인생영화" || eval == "Best" {
            return "best"
        } else if eval == "꿀잼영화" || eval == "Good" {
            return "good"
        } else if eval == "보통영화" || eval == "Notbad" {
            return "notbad"
        } else {
            return "bad"
        }
    }
}
