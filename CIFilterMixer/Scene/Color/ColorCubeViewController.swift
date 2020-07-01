//
//  ColorCubeViewController.swift
//  CIFilterMixer
//
//  Created by 佐藤 慎 on 2020/06/26.
//  Copyright © 2020 STSN. All rights reserved.
//

import UIKit

class ColorCubeViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var radText: UITextField!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var greenText: UITextField!
    @IBOutlet weak var greenLabel: UILabel!
    
    @IBOutlet weak var blueText: UITextField!
    @IBOutlet weak var blueLabel: UILabel!
    
    private var red: Float = 1 {
        didSet {
            self.label.text = String(red)
        }
    }
    private var green: Float = 1 {
        didSet {
            self.greenLabel.text = String(green)
        }
    }
    private var blue: Float = 1 {
        didSet {
            self.blueLabel.text = String(blue)
        }
    }
    
    private var image: UIImage?
    private var filter: CIFilter?
    
    private var color: RGBColor {
        return RGBColor(red: self.red, green: self.green, blue: self.blue)
    }
    
    private var afterDismiss: ((_ uiImage: UIImage?, _ color: RGBColor, _ filterName: String) -> Void)?
    
    // MARK: - Initializer
    
    static func makeInstance(image: UIImage?,
                             filter: CIFilter,
                             dismissHandler: @escaping ((_ uiImage: UIImage?, _ color: RGBColor, _ filterName: String) -> Void) )
        -> ColorCubeViewController {
            guard let vc = UIStoryboard.makeInitialViewController(storyboardName: "ColorCube") as? ColorCubeViewController else {
                fatalError()
            }
            vc.image = image
            vc.filter = filter
            vc.afterDismiss = dismissHandler
            return vc
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = self.image
        self.red = 1
        self.green = 1
        self.blue = 1
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true) {
            if let afterDismiss = self.afterDismiss, let filter = self.filter {
                afterDismiss(self.imageView.image,
                             self.color,
                             String(describing: type(of: filter)))
            }
        }
    }
    
    @IBAction func setValue(_ sender: Any) {
        var error: Bool = false
        if let redValue = Float(self.radText.text ?? ""), redValue <= 1 {
            self.red = redValue
        } else {
            self.label.text = "error"
            error = true
        }
        if let greenValue = Float(self.greenText.text ?? ""), greenValue <= 1 {
            self.green = greenValue
        } else {
            self.greenLabel.text = "error"
            error = true
        }
        if let blueValue = Float(self.blueText.text ?? ""), blueValue <= 1 {
            self.blue = blueValue
        } else {
            self.blueLabel.text = "error"
            error = true
        }
        
        guard !error else {
            return
        }
        self.imageView.image = FilterHelper.colorCubeFilter(filter: self.filter, originImage: self.image, color: self.color)
    }

}
