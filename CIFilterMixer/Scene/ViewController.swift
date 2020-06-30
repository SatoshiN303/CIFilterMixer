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
    
    private func showAmountSetting(_ filter: CIFilter) {

    }
    
    private func showRadiusSetting(_ filter: CIFilter) {
        
    }
    
    private func showColorSetting(_ filter: CIFilter) {
        
    }
    
}

// MARK: - Button Action
// How to use Core Image filters the type-safe way
// https://www.hackingwithswift.com/articles/204/how-to-use-core-image-filters-the-type-safe-way


extension ViewController {
    
    @IBAction func original(_ sender: Any) {
    }
    
    @IBAction func result(_ sender: UIButton) {
    }
    
    @IBAction func undo(_ sender: Any) {
    }
    
    
    @IBAction func CIColorInvert(_ sender: Any) {
        presenter.applyFilter(filter: CIFilter.colorInvert())
    }
    
    @IBAction func CIColorMonochrome(_ sender: Any) {
        //TODO: ColorPicker表示
    }
    
    @IBAction func CIColorPosterize(_ sender: Any) {
        presenter.applyFilter(filter: CIFilter.colorPosterize())
    }
    
    @IBAction func CIFalseColor(_ sender: Any) {
        //TODO: ColorPicker表示
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
        //TODO: colorControl() 実行
    }
    
    
    @IBAction func brightnessChanged(_ sender: UISlider) {
        self.brightnessValue = sender.value
    }
    
    @IBAction func brightnessChageFinished(_ sender: UISlider) {
        //TODO: colorControl() 実行
    }
    
    
    @IBAction func saturationChanged(_ sender: UISlider) {
        self.saturationValue = sender.value
    }
    
    @IBAction func saturationChangeFinished(_ sender: UISlider) {
        //TODO: colorControl() 実行
    }

}
