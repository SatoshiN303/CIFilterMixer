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
    var filterName: String?
    var value: Float?
    var color1: UIColor?
    var color2: UIColor?
    var rgb: RGBColor?
}

protocol MainPresnterProtocol: class {
    var view: ViewProtocol? { get set }
    var settings: [FilterSettings] { get set }
    var effects: [String] { get set }
    
    func applyFilter(filter: CIFilter)
    func radiusSetting() -> ((_ uiImage: UIImage?, _ value: Float, _ filterName: String) -> Void)
    func amountSetting() -> ((_ uiImage: UIImage?, _ value: Float, _ filterName: String) -> Void)
    func colorSetting() -> ((_ uiImage: UIImage?, _ rgbColor: RGBColor, _ filterName: String) -> Void)
}

final class MainPresenter: MainPresnterProtocol {

    weak var view: ViewProtocol?
    var settings: [FilterSettings] = []
    var effects: [String] = []
    
    func applyFilter(filter: CIFilter) {
        print(String(describing: type(of: filter)))
        
        //TODO: colorControl() でセットされた色情報も追加
        guard let img = FilterHelper.filter(filter: filter,
                                            originImage: view?.mainImage,
                                            color1: nil,
                                            color2: nil) else {
                                                fatalError()
        }
        
        let filterName = String(describing: type(of: filter))
        self.executeFilter(effectName: filterName, img: img)
    }
    
    func radiusSetting() -> ((_ uiImage: UIImage?, _ value: Float, _ filterName: String) -> Void) {
        return { [weak self] img, val, filterName in
            guard let self = self else { return }
            let str = String(format: "%@ (inputRadius : %f)", filterName, val)
            self.executeFilter(effectName: str, img: img)
            
        }
    }
    
    func amountSetting() -> ((_ uiImage: UIImage?, _ value: Float, _ filterName: String) -> Void) {
        return { [weak self] img, val, filterName in
            guard let self = self else { return }
            let str = String(format: "%@ (inputAmount : %f)", filterName, val)
            self.executeFilter(effectName: str, img: img)
            
        }
    }
    
    func colorSetting() -> ((_ uiImage: UIImage?, _ rgbColor: RGBColor, _ filterName: String) -> Void) {
        return { [weak self] img, color, filterName in
            guard let self = self else { return }
            let str = String(format: "%@ (r : %.02f, g : %.02f, b : %.02f)", filterName, color.red, color.green, color.blue)
            self.executeFilter(effectName: str, img: img)
        }
    }
    
    private func executeFilter(effectName: String, img: UIImage?) {
        self.effects.append(effectName)
        self.view?.updateImageView(img)
        self.view?.updateEffectCount(count: self.effects.count)
    }

}

