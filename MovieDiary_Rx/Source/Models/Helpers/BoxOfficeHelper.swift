//
//  BoxOfficeHelper.swift
//  BoxOffice
//
//  Created by KangMingyo on 2022/10/21.
//

import Foundation

struct BoxOfficeHelper {
    
    // 누적 관객 수 만 단위로 변경
    func audiAccCal(_ audiAcc: String) -> String {
        if 10000 <= Int(audiAcc) ?? 0 {
            let audiAccNum = (Int(audiAcc) ?? 0) / 10000
            return "\(audiAccNum)만"
        } else {
            return audiAcc
        }
    }
    
    // 전일 대비 증감 계산
    func rankIntenCal(_ rankInten: String) -> String {
        if rankInten == "0" {
            return "-"
        } else if 0 < Int(rankInten) ?? 0 {
            return "🔺\(rankInten)"
        } else {
            return "🔻\(abs(Int(rankInten) ?? 0))"
        }
    }
}
