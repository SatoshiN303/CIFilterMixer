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

    func reset()
    func undo()
}

final class MainPresenter: MainPresnterProtocol {

    weak var view: ViewProtocol?
    var settings: [FilterSettings] = []
    var effects: [String] = []
    var selectedColor: UIColor? = nil
    var selectedColor2: UIColor?  = nil
    
    // MARK: - Filter
    
    func applyFilter(filter: CIFilter) {
        print(String(describing: type(of: filter)))
        guard let img = FilterHelper.filter(filter: filter,
                                            originImage: view?.mainImage,
                                            color1: selectedColor ?? UIColor.clear,
                                            color2: selectedColor2 ?? UIColor.clear) else {
                                                fatalError()
        }
        
        let filterName = String(describing: type(of: filter))
        
        // For redo
        let setting = FilterSettings(filterName: filterName, value: nil, color1: selectedColor, color2: selectedColor2, rgb: nil)
        self.settings.append(setting)
        
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
        
        if effectName != String(describing: CIColorControls.self) {
            self.effects.append(effectName)
        }
        
        self.view?.updateImageView(img)
        self.view?.updateEffectCount(count: self.effects.count)

        self.selectedColor = nil
        self.selectedColor2 = nil
    }
    
    // MARK: - clojure
    
    func radiusSetting() -> ((_ uiImage: UIImage?, _ value: Float, _ filterName: String) -> Void) {
        return { [weak self] img, val, filterName in
            guard let self = self else { return }
            let str = String(format: "%@ (inputRadius : %f)", filterName, val)
            
            // For redo
            let setting = FilterSettings(filterName: str, value: val, color1: nil, color2: nil, rgb: nil)
            self.settings.append(setting)
            
            self.executeFilter(effectName: str, img: img)
            
        }
    }
    
    func amountSetting() -> ((_ uiImage: UIImage?, _ value: Float, _ filterName: String) -> Void) {
        return { [weak self] img, val, filterName in
            guard let self = self else { return }
            let str = String(format: "%@ (inputAmount : %f)", filterName, val)
            
            // For redo
            let setting = FilterSettings(filterName: str, value: val, color1: nil, color2: nil, rgb: nil)
            self.settings.append(setting)
            
            self.executeFilter(effectName: str, img: img)
            
        }
    }
    
    func colorSetting() -> ((_ uiImage: UIImage?, _ rgbColor: RGBColor, _ filterName: String) -> Void) {
        return { [weak self] img, color, filterName in
            guard let self = self else { return }
            let str = String(format: "%@ (r : %.02f, g : %.02f, b : %.02f)", filterName, color.red, color.green, color.blue)
            
            // For redo
            let setting = FilterSettings(filterName: str, value: nil, color1: nil, color2: nil, rgb: color)
            self.settings.append(setting)
            
            self.executeFilter(effectName: str, img: img)
        }
    }
    
    // MARK: - Rest & Undo
    
    func reset() {
        effects.removeAll()
        settings.removeAll()
        selectedColor = nil
        selectedColor2 = nil
    }
    
    func undo() {
        guard settings.count > 0 else {
            return
        }
        
        settings.removeLast()
        view?.updateImageView(#imageLiteral(resourceName: "main"))
        
        for setting in settings {
            guard
                let name = setting.filterName,
                let filter: CIFilter = CIFilter(name: name),
                let img: UIImage = view?.mainImage
            else {
                fatalError()
            }
           
            if name == "CIGaussianBlur" || name == "CIBoxBlur" {
                guard let radius = setting.value else { fatalError() }
                let img = FilterHelper.blurFilter(filter: filter,
                                        originImage: img,
                                        radius: radius)
                view?.updateImageView(img)
            } else if name == "CIVibrance" {
                guard let amount = setting.value else { fatalError() }
                let img = FilterHelper.amountFilter(filter: filter,
                                                    originImage: img,
                                                    amount: amount)
                view?.updateImageView(img)
            } else if name == "CIColorCube" || name == "CIColorCubeWithColorSpace" {
                guard let color = setting.rgb else { fatalError() }
                let img = FilterHelper.colorCubeFilter(filter: filter,
                                                       originImage: img,
                                                       color: color)
                view?.updateImageView(img)
            } else {
                let img =  FilterHelper.filter(filter: filter,
                                               originImage: img,
                                               color1: setting.color1 ?? UIColor.clear,
                                               color2: setting.color2 ?? UIColor.clear)
                view?.updateImageView(img)
            }
            
        }
        view?.updateEffectCount(count: settings.count)
        view?.resetColorControls()
    }
    
    // MARK: - MISC
    
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

