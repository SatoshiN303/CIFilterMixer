//
//  ViewController.swift
//  CIFilterMixer
//
//  Created by 佐藤 慎 on 2020/06/25.
//  Copyright © 2020 STSN. All rights reserved.
//
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

protocol ViewProtocol: class {
    var mainImage: UIImage { get }
    var colorControls: ColorControls { get }
    
    func updateImageView(_ img: UIImage?)
    func updateEffectCount(count: Int)
    func showColorPicker(_ filter: CIFilter)
    func resetColorControls()
}

class ViewController: UIViewController, ViewProtocol {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var effectCountLabel: UILabel!
    
    @IBOutlet weak var contrastSlider: UISlider!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var saturationSlider: UISlider!

    @IBOutlet weak var contrastValueLabel: UILabel!
    @IBOutlet weak var brightnessValueLabel: UILabel!
    @IBOutlet weak var saturationValueLabel: UILabel!
    
    private var contrastValue: Float = 1 {
        willSet {
            self.contrastSlider.value = newValue
            self.contrastValueLabel.text = String(self.contrastSlider.value)
        }
    }
    
    private var brightnessValue: Float = 0 {
        willSet {
            self.brightnessSlider.value = newValue
            self.brightnessValueLabel.text = String(self.brightnessSlider.value)
        }
    }
    private var saturationValue: Float = 1 {
        willSet {
            self.saturationSlider.value = newValue
            self.saturationValueLabel.text = String(self.saturationSlider.value)
        }
    }
    
    private var presenter: MainPresnterProtocol!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = MainPresenter()
        self.presenter.view = self
        
    }
    
    // MARK: - Show Other ViewController
    
    func showColorPicker(_ filter: CIFilter) {
        let colorPicker = AMColorPickerViewController()
        colorPicker.selectedColor = UIColor.white
        colorPicker.delegate = self
        colorPicker.selectedFilter = filter
        self.present(colorPicker, animated: true, completion: nil)
    }
    
    private func showAmountSetting(_ filter: CIFilter) {
        let vc  = AmountSettingViewController.makeInstance(image: imageView.image,
                                                           filter: filter,
                                                           dismissHandler: presenter.amountSetting())
        self.present(vc, animated: true, completion: nil)
    }
    
    private func showRadiusSetting(_ filter: CIFilter) {
        let vc = RadiusSettingViewController.makeInstance(image: imageView.image,
                                                          filter: filter,
                                                          dismissHandler: presenter.radiusSetting())
        self.present(vc, animated: true, completion: nil)
    }
    
    private func showColorSetting(_ filter: CIFilter) {
        let vc = ColorCubeViewController.makeInstance(image: imageView.image,
                                                      filter: filter,
                                                      dismissHandler: presenter.colorSetting())
        self.present(vc, animated: true, completion: nil)
    }
    
    private func showResult() {
        var effects = presenter.effects
        effects.append(String(format: "Contrast : %f", self.contrastValue))
        effects.append(String(format: "Brightness : %f", self.brightnessValue))
        effects.append(String(format: "Saturation : %f", self.saturationValue))

        let vc = ResultViewController.makeInstance(effects: effects)
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - View Protocol
    
    var mainImage: UIImage {
        guard let img = imageView.image else {
            fatalError()
        }
        return img
    }
    
    var colorControls: ColorControls {
        get {
            return ColorControls(contrast: self.contrastValue,
                                 brightness: self.brightnessValue,
                                 saturation: self.saturationValue)
        }
    }
    
    func updateImageView(_ img: UIImage?) {
        guard let img = img else {
            return
        }
        self.imageView.image = img
    }
    
    func updateEffectCount(count: Int) {
        self.effectCountLabel.text = String(count)
    }
    
    func resetColorControls() {
        self.contrastValue = 1
        self.brightnessValue = 0
        self.saturationValue = 1
    }
    
    // MARK: - MISC
    
    private func reset() {
        self.imageView.image = #imageLiteral(resourceName: "main")
        resetColorControls()
        updateEffectCount(count: 0)
        presenter.reset()
    }
    
    private func undo() {
        presenter.undo()
    }
}

// MARK: - Button Action
// How to use Core Image filters the type-safe way
// https://www.hackingwithswift.com/articles/204/how-to-use-core-image-filters-the-type-safe-way


extension ViewController {
    
    @IBAction func reset(_ sender: UIButton) {
        reset()
    }
    
    @IBAction func result(_ sender: UIButton) {
        showResult()
    }
    
    @IBAction func undo(_ sender: Any) {
        undo()
    }
    
    
    @IBAction func CIColorInvert(_ sender: Any) {
        presenter.applyFilter(filter: CIFilter.colorInvert())
    }
    
    @IBAction func CIColorMonochrome(_ sender: Any) {
        self.showColorPicker(CIFilter.colorMonochrome())
    }
    
    @IBAction func CIColorPosterize(_ sender: Any) {
        presenter.applyFilter(filter: CIFilter.colorPosterize())
    }
    
    @IBAction func CIFalseColor(_ sender: Any) {
        self.showColorPicker(CIFilter.falseColor())
    }
    
    @IBAction func CIMaximumComponent(_ sender: Any) {
        presenter.applyFilter(filter: CIFilter.maximumComponent())
    }
    
    @IBAction func CIMinimumComponent(_ sender: Any) {
        presenter.applyFilter(filter: CIFilter.minimumComponent())
    }
    
    @IBAction func CIPhotoEffectChrome(_ sender: Any) {
        presenter.applyFilter(filter: CIFilter.photoEffectChrome())
    }
    
    @IBAction func CIPhotoEffectFade(_ sender: Any) {
        presenter.applyFilter(filter: CIFilter.photoEffectFade())
    }
    
    @IBAction func CIPhotoEffectInstant(_ sender: Any) {
        presenter.applyFilter(filter: CIFilter.photoEffectInstant())
    }
    
    @IBAction func CIPhotoEffectMono(_ sender: Any) {
        presenter.applyFilter(filter: CIFilter.photoEffectMono())
    }
    
    @IBAction func CIPhotoEffectNoir(_ sender: Any) {
        presenter.applyFilter(filter: CIFilter.photoEffectNoir())
    }
    
    @IBAction func CIPhotoEffectProcess(_ sender: Any) {
        presenter.applyFilter(filter: CIFilter.photoEffectProcess())
    }
    
    @IBAction func CIPhotoEffectTonal(_ sender: Any) {
        presenter.applyFilter(filter: CIFilter.photoEffectTonal())
    }
    
    @IBAction func CIPhotoEffectTransfer(_ sender: Any) {
        presenter.applyFilter(filter: CIFilter.photoEffectTransfer())
    }
    
    @IBAction func CISepiaTone(_ sender: Any) {
        presenter.applyFilter(filter: CIFilter.sepiaTone())
    }
    
    @IBAction func CIBoxBlur(_ sender: Any) {
        showRadiusSetting(CIFilter.boxBlur())
    }
    
    @IBAction func CIGaussianBlur(_ sender: Any) {
        showRadiusSetting(CIFilter.gaussianBlur())
    }
    
    @IBAction func CIMedianFilter(_ sender: Any) {
        presenter.applyFilter(filter: CIFilter.median())
    }
    
    @IBAction func CIVibrance(_ sender: Any) {
        showAmountSetting(CIFilter.vibrance())
    }
    
    @IBAction func CIColorCube(_ sender: Any) {
        showColorSetting(CIFilter.colorCube())
    }
    
    @IBAction func CIColorCubeWithColorSpace(_ sender: Any) {
        showColorSetting(CIFilter.colorCubeWithColorSpace())
    }
    
}

// MARK: - Slider Action

extension ViewController {
    
    @IBAction func contrastChnaged(_ sender: UISlider) {
        self.contrastValue = sender.value
    }

    @IBAction func contrastChnageFinished(_ sender: UISlider) {
        presenter.applyColorControlFilter()
    }
    
    
    @IBAction func brightnessChanged(_ sender: UISlider) {
        self.brightnessValue = sender.value
    }
    
    @IBAction func brightnessChageFinished(_ sender: UISlider) {
        presenter.applyColorControlFilter()
    }
    
    
    @IBAction func saturationChanged(_ sender: UISlider) {
        self.saturationValue = sender.value
    }
    
    @IBAction func saturationChangeFinished(_ sender: UISlider) {
        presenter.applyColorControlFilter()
    }

}

// MARK: - AMColorPickerDelegate

extension ViewController: AMColorPickerDelegate {
    func colorPicker(_ colorPicker: AMColorPickerViewController, didSelect color: UIColor) {
        print(color)
    }
    
    func finalColor(color: UIColor, selectedFilter: CIFilter?) {
        guard let filter = selectedFilter else {
            return
        }
        presenter.applyColorFilter(filter: filter, color: color)
    }
}
