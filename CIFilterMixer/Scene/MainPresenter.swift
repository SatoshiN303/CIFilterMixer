//
//  MainPresenter.swift
//  CIFilterMixer
//
//  Created by 佐藤 慎 on 2020/06/30.
//  Copyright © 2020 STSN. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct FilterSettings {
    var filterName: String
    var value: Float
    var color1: UIColor
    var color2: UIColor
    var rgb: RGBColor
}

protocol MainPresnterProtocol: class {
    var view: ViewProtocol? { get set }
    var settings: [FilterSettings] { get set }
    func applyFilter(filter: CIFilter)
}

final class MainPresenter: MainPresnterProtocol {

    weak var view: ViewProtocol?
    var settings: [FilterSettings] = []
    
    func applyFilter(filter: CIFilter) {
         print(String(describing: type(of: filter)))
    }

}

