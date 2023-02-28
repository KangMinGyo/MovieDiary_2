//
//  UIImage+Extension.swift
//  MovieDiary
//
//  Created by KangMingyo on 2022/10/31.
//

import UIKit

extension UIImage {
    enum ImageName: String {
        case gearshape = "gearshape.fill"
        case magnifyingglass = "magnifyingglass"
        case chart = "chart.bar"
    }
    
    convenience init?(systemName: ImageName) {
        self.init(systemName: systemName.rawValue)
    }
}
