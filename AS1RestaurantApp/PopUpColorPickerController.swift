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

class PopUpColorPickerController: UIViewController {
    
    @IBOutlet weak var colorPickerView: SwiftHSVColorPicker!
    var delegate: ChangeColorDelegate?
    var defaultColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorPickerView.setViewColor(self.defaultColor!)
        

        // Do any additional setup after loading the view.
    }

    @IBAction func closePopUp(_ sender: Any) {
        self.delegate?.setColor(colorPickerView.color)
        self.view.removeFromSuperview()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
