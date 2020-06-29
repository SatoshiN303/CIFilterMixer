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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let soko = CIFilter.gaussianBlur()
    }
}

//MARK: - Button Action
// How to use Core Image filters the type-safe way
// https://www.hackingwithswift.com/articles/204/how-to-use-core-image-filters-the-type-safe-way


extension ViewController {
    @IBAction func original(_ sender: Any) {
    }
    
    @IBAction func undo(_ sender: Any) {
    }

    @IBAction func CIColorInvert(_ sender: Any) {
    }
    
    @IBAction func CIColorMonochrome(_ sender: Any) {
    }
    
    @IBAction func CIColorPosterize(_ sender: Any) {
    }
    
    @IBAction func CIFalseColor(_ sender: Any) {
    }
    
    @IBAction func CIMaximumComponent(_ sender: Any) {
    }
    
    @IBAction func CIMinimumComponent(_ sender: Any) {
    }
    
    @IBAction func CIPhotoEffectChrome(_ sender: Any) {
    }
    
    @IBAction func CIPhotoEffectFade(_ sender: Any) {
    }
    
    @IBAction func CIPhotoEffectInstant(_ sender: Any) {
    }
    
    @IBAction func CIPhotoEffectMono(_ sender: Any) {
    }
    
    @IBAction func CIPhotoEffectNoir(_ sender: Any) {
    }
    
    @IBAction func CIPhotoEffectProcess(_ sender: Any) {
    }
    
    @IBAction func CIPhotoEffectTonal(_ sender: Any) {
    }
    
    @IBAction func CIPhotoEffectTransfer(_ sender: Any) {
    }
    
    @IBAction func CISepiaTone(_ sender: Any) {
    }
    
    @IBAction func CIBoxBlur(_ sender: Any) {
    }
    
    @IBAction func CIGaussianBlur(_ sender: Any) {
    }
    
    @IBAction func CIMedianFilter(_ sender: Any) {
    }
    
    @IBAction func CIVibrance(_ sender: Any) {
    }
    
    @IBAction func CIColorCube(_ sender: Any) {
    }
    
    @IBAction func CIColorCubeWithColorSpace(_ sender: Any) {
    }
    
}
