//
//  ErrorViewController.swift
//  ofo
//
//  Created by YXY on 2017/9/14.
//  Copyright © 2017年 YXY. All rights reserved.
//

import UIKit
import MIBlurPopup

class ErrorViewController: UIViewController {
    
    @IBOutlet weak var myPopupView: UIView!
    
    @IBAction func closeBtnTap(_ sender: Any) {
        close()
    }
    
    @IBAction func gestureTap(_ sender: UITapGestureRecognizer) {
        self.close()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    func close() {
        dismiss(animated: true)
    }

}


extension ErrorViewController:MIBlurPopupDelegate{
    var popupView: UIView{
        return myPopupView
    }
    
    var blurEffectStyle: UIBlurEffectStyle{
        return .dark
    }
    
    var initialScaleAmmount: CGFloat{
        return 0.2
    }
    
    var animationDuration: TimeInterval{
        return 0.2
    }
}








