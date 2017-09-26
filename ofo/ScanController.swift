//
//  ScanController.swift
//  ofo
//
//  Created by YXY on 2017/9/7.
//  Copyright © 2017年 YXY. All rights reserved.
//

import UIKit
import swiftScan
import FTIndicator

class ScanController: LBXScanViewController {
    
    var isFlashOn = false
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var flashBtn: UIButton!
    
    @IBAction func flashBtnTap(_ sender: UIButton) {
        isFlashOn = !isFlashOn
        
        scanObj?.changeTorch()  //真正控制硬件
        
        if isFlashOn {
            flashBtn.setImage(#imageLiteral(resourceName: "btn_enableTorch_w"), for: .normal)
        } else {
            flashBtn.setImage(#imageLiteral(resourceName: "btn_unenableTorch_w"), for: .normal)
        }
        
    }
    
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        if let result = arrayResult.first {
            let msg = result.strScanned
            
            FTIndicator.setIndicatorStyle(.dark)
            FTIndicator.showToastMessage(msg)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "扫码用车"
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.navigationBar.tintColor = UIColor.white
        
        //view.bringSubview(toFront: panelView)   //添加QR Scan控制器后原面板被覆盖无法点击使用
        //view加载完成不一定显示完成，所以依然存在无法使用(可能等待时间更长后即可),所以在函数viewDidAppera中再启用
        
        //引用bundle中的图片需要使用它的样式
        var style = LBXScanViewStyle()
        style.anmiationStyle = .NetGrid
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_part_net")   //文件扩展名可以不写
        
        scanStyle = style
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)   //不加好像也可以
        view.bringSubview(toFront: panelView)   //添加QR Scan控制器后原面板被覆盖无法点击使用；待视图完全加载并显示完成后再放在前面
    }
    
    //引用的QR Scan控制器有bug：返回后主页面导航条变为黑色，此处进行一个恢复
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

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
