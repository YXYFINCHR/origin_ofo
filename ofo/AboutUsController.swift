//
//  AboutUsController.swift
//  ofo
//
//  Created by YXY on 2017/9/3.
//  Copyright © 2017年 YXY. All rights reserved.
//

import UIKit
import SWRevealViewController

class AboutUsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let revealVC = revealViewController(){   //获取容器，若获取成功，使用if let进行一个绑定
            revealVC.rearViewRevealWidth = 270  //侧边栏展开宽度，和图片一致
            navigationItem.leftBarButtonItem?.target = revealVC //点击左上角头像后的场景是(个人信息)容器
            navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
            //点击左上角头像后的动作是打开个人信息菜单 方法#selector是OC方法
            view.addGestureRecognizer(revealVC.panGestureRecognizer())  //平移手势
        }
        
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
