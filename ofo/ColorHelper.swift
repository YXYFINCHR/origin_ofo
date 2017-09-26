//
//  ColorHelper.swift
//  ofo
//
//  Created by YXY on 2017/9/9.
//  Copyright © 2017年 YXY. All rights reserved.
//

extension UIColor{  //对现有的UIColor做一个扩展
    //UIColor(red: 247/255, green: 215/255, blue: 80/255, alpha: 1)
    static var ofo: UIColor {   //直接UIColor.blue这样调用说明后面的颜色是一个静态属性，所以要加一个static
        //这儿的var实际是varget
        return UIColor(red: 247/255, green: 215/255, blue: 80/255, alpha: 1)
    }
    
//    var ofo = UIColor(red: 247/255, green: 215/255, blue: 80/255, alpha: 1) 这样写报错
}
