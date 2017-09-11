//
//  PopUpColorPickerController.swift
//  AS1RestaurantApp
//
//  Created by XuanZhang on 2/9/17.
//  Copyright © 2017 Monash. All rights reserved.
//

import UIKit

protocol ChangeColorDelegate {
    func setColor(_ color: UIColor)
}

//This is the color picker controller
class PopUpColorPickerController: UIViewController {
    
    @IBOutlet weak var colorPickerView: SwiftHSVColorPicker!
    var delegate: ChangeColorDelegate?
    var defaultColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorPickerView.setViewColor(self.defaultColor!)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
         self.view.removeFromSuperview()
    }

    @IBAction func closePopUp(_ sender: Any) {
        self.delegate?.setColor(colorPickerView.color)
        self.view.removeFromSuperview()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
