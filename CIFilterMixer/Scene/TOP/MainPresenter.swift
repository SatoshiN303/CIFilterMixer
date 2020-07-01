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
    var selectedColor: UIColor? { get set }
    var selectedColor2: UIColor? { get set }
    
    func applyFilter(filter: CIFilter)
    func applyColorFilter(filter: CIFilter, color: UIColor)
    func applyColorControlFilter()
    func radiusSetting() -> ((_ uiImage: UIImage?, _ value: Float, _ filterName: String) -> Void)
    func amountSetting() -> ((_ uiImage: UIImage?, _ value: Float, _ filterName: String) -> Void)
    func colorSetting() -> ((_ uiImage: UIImage?, _ rgbColor: RGBColor, _ filterName: String) -> Void)
}

final class MainPresenter: MainPresnterProtocol {

    weak var view: ViewProtocol?
    var settings: [FilterSettings] = []
    var effects: [String] = []
    var selectedColor: UIColor? = nil
    var selectedColor2: UIColor?  = nil
    
    func applyFilter(filter: CIFilter) {
        print(String(describing: type(of: filter)))
        guard let img = FilterHelper.filter(filter: filter,
                                            originImage: view?.mainImage,
                                            color1: selectedColor ?? UIColor.clear,
                                            color2: selectedColor2 ?? UIColor.clear) else {
                                                fatalError()
        }
        
        let filterName = String(describing: type(of: filter))
        self.executeFilter(effectName: filterName, img: img)
    }
    
    func applyColorFilter(filter: CIFilter, color: UIColor) {
        if filter.name == String(describing: CIFalseColor.self) {
            if selectedColor == nil {
                selectedColor = color
                self.view?.showColorPicker(filter)
                return
            } else if selectedColor2 == nil {
                selectedColor2 = color
            }
            
            if selectedColor != nil, selectedColor != nil {
                applyFilter(filter: filter)
            }
        } else {
            selectedColor = color
            applyFilter(filter: filter)
        }
    }
    
    func applyColorControlFilter() {
        guard
            let colorControls = view?.colorControls,
            let img = FilterHelper.colorControlsFilter(originImage:view?.mainImage, colorControls:colorControls) else {
                fatalError()
        }
        let filterName = String(describing: CIColorControls.self)
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
        var effectName = effectName
        if effectName == String(describing: CIColorMonochrome.self) {
            let color1: UIColor = selectedColor ?? UIColor.clear
            let colorTxt = getColorText(color: color1)
            effectName += " (" + colorTxt + ")"
        } else if effectName == String(describing: CIFalseColor.self) {
            let color1: UIColor = selectedColor ?? UIColor.clear
            let color2: UIColor = selectedColor2 ?? UIColor.clear
            var colorTxt = getColorText(color: color1)
            colorTxt += "," +  getColorText(color: color2)
            effectName += " (" + colorTxt + ")"
        }
        
        self.effects.append(effectName)

        self.view?.updateImageView(img)
        self.view?.updateEffectCount(count: self.effects.count)

        self.selectedColor = nil
        self.selectedColor2 = nil
    }
    
    // MARK - MISC
    
    private func getColorText(color: UIColor) -> String {
        guard let components = color.cgColor.components else {
            return String("#ffffff")
        }
        if components.count >= 3 {
            return String(format: "#%02x%02x%02x", Int(components[0] * 255), Int(components[1] * 255),Int(components[2] * 255))
        } else { // White
            return String("#ffffff")
        }
    }

}

