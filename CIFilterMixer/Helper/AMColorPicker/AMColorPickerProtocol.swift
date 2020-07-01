//
//  AMColorPickerProtocol.swift
//  SampleAMColorPicker
//
//  Created by am10 on 2019/04/21.
//  Copyright © 2019 am10. All rights reserved.
//

import UIKit

public protocol AMColorPickerViewDelegate: class {
    func colorPicker(_ colorPicker: UIView, didSelect color: UIColor)
}

public protocol AMColorPickerDelegate: class {
    func colorPicker(_ colorPicker: AMColorPickerViewController, didSelect color: UIColor)
    func finalColor(color: UIColor, selectedFilter: CIFilter?)
}
