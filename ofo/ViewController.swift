//
//  ViewController.swift
//  ofo
//
//  Created by YXY on 2017/9/2.
//  Copyright © 2017年 YXY. All rights reserved.
//

import UIKit
import SWRevealViewController
import FTIndicator

class ViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate, AMapNaviWalkManagerDelegate {
    
    var mapView:MAMapView!
    var search: AMapSearchAPI!  //定义搜索API
    var pin:MyPinAnnotation!
    var pinView:MAAnnotationView!
    var nearBySearch = true     //默认一开始是在用户周围进行搜索
    var start,end:CLLocationCoordinate2D!
    var walkManager:AMapNaviWalkManager!
    

    @IBOutlet weak var panelView: UIView!
    @IBAction func locationBtnType(_ sender: UIButton) {    //"定位"按钮执行的功能
        nearBySearch = true
        searchBikeNearby()
    }
    
    //搜索周边的小黄车请求
    func searchBikeNearby() {
        searchCustomLocation(mapView.userLocation.coordinate)
    }
    
    func searchCustomLocation(_ center:CLLocationCoordinate2D) {//CLLocationCoordinate2D 经纬度坐标位置
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
        //center类型和高德中的位置类型不一样，所以需要利用center类型中的经纬度转化为高德地图中的位置类型
        request.keywords = "餐馆"
        request.radius = 500    //单位为米
        request.requireExtension = true //是否返回扩展信息(相关信息)
        search.aMapPOIAroundSearch(request) //执行搜索
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MAMapView(frame: view.bounds) //初始化高德地图
        view.addSubview(mapView)    //将初始化后的高德地图加到视图上
        view.bringSubview(toFront: panelView)   //教程中下方用车区域的面板未出现在地图之上，用此语句调整
        
        mapView.delegate = self
        
        mapView.zoomLevel = 17 //先缩放，再定位
        //定位功能
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow  //持续追踪
        
        search = AMapSearchAPI()    //初始化
        search.delegate = self  //http://lbs.amap.com/api/ios-sdk/guide/map-data/poi
        
        walkManager = AMapNaviWalkManager() //初始化
        walkManager.delegate = self  //self为这个控制器
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.titleView = UIImageView(image:#imageLiteral(resourceName: "ofoLogo"))   //导航条中间ofoLogo
        self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "leftTopImage").withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "rightTopImage").withRenderingMode(.alwaysOriginal)
        //图片渲染模式用原图
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //热门活动页面返回处只要箭头，不要箭头加Back
        
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
    
    // MARK: - 大头针动画
    func pinAnimation() {
        //坠落效果，y轴加位移
        let endFrame = pinView.frame    //保留目前坐标
        pinView.frame = endFrame.offsetBy(dx: 0, dy: -15)   //当前位移沿y轴上移15个单位
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: {
            self.pinView.frame = endFrame   //动画是大头针回到原位置
        }, completion: nil)
    }
    
    
    // MARK: - MapView Delegate
    
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay is MAPolyline{
            pin.isLockedToScreen = false    //下一步之前先把大头针位置锁定，即不在屏幕中心
            mapView.visibleMapRect = overlay.boundingMapRect    //绘制路线前先缩放至路线图层的区域
            
            let renderer = MAPolylineRenderer(overlay: overlay)
            renderer?.lineWidth = 8.0
            renderer?.strokeColor = UIColor.cyan
            
            return renderer
            
        }
        return nil  //如果是别的overlay则返回nil
    }
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {    //点击小黄车后显示步行导航路线
        
        start = pin.coordinate
        end = view.annotation.coordinate    //选中的view的标注 的坐标
        
        let startPoint = AMapNaviPoint.location(withLatitude:CGFloat(start.latitude),longitude:CGFloat(start.longitude))!
        let endPoint = AMapNaviPoint.location(withLatitude:CGFloat(end.latitude),longitude:CGFloat(end.longitude))!
        
        walkManager.calculateWalkRoute(withStart: [startPoint], end: [endPoint])
        
    }
    
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        let aViews = views as! [MAAnnotationView]   //数组强制转换
        for aView in aViews {
            guard aView.annotation is MAPointAnnotation else{
                continue
            }
            aView.transform = CGAffineTransform(scaleX: 0, y: 0)    //affine-仿射 大小缩放为0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: {
                aView.transform = .identity     //动画是变为原来的大小
            }, completion: nil)
        }
    }
    
    /// 用户移动地图(后)的交互
    ///
    /// - Parameters:
    ///   - mapView: mapView
    ///   - wasUserAction: 是否为用户移动
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        if wasUserAction{
            pin.isLockedToScreen = true //移动地图后大头针保持不动(不进行自动调整)
            pinAnimation()
            searchCustomLocation(mapView.centerCoordinate)
        }
    }
    
    
    /// 地图初始化完成后
    ///
    /// - Parameter mapView: mapView
    func mapInitComplete(_ mapView: MAMapView!) {
        pin = MyPinAnnotation()
        pin.coordinate = mapView.centerCoordinate   //地理坐标
        pin.lockedScreenPoint = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)    //大头针屏幕上的坐标
        pin.isLockedToScreen = true
        
        mapView.addAnnotation(pin)
        mapView.showAnnotations([pin], animated: true)
        
        searchBikeNearby()  //初次启动自动搜索周围可用车辆
    }
    
    
    /// 自定义大头针视图
    ///
    /// - Parameters:
    ///   - mapView: mapView
    ///   - annotation: 标注
    /// - Returns: 大头针视图
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {   //自定义小黄车显示ICON
        
        //如果是用户的位置，icon不需要自定义
        if annotation is MAUserLocation{
            return nil
        }
        
        if annotation is MyPinAnnotation{
            let reuseid = "anchor"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseid)
            if annotationView == nil{
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuseid)
            }
            
            annotationView?.image = #imageLiteral(resourceName: "homePage_wholeAnchor")
            annotationView?.canShowCallout = false
            pinView = annotationView
            
            return annotationView
        }
        
        let reuseid = "myid"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseid) as? MAPinAnnotationView //如果重用不成功则后面那个 是啥 不知道
        //该方法详见http://lbs.amap.com/api/ios-sdk/guide/draw-on-map/draw-marker
        if annotationView == nil{   //如果重用不成功 也就是第一次新建一个图标
            annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuseid)  //则初始化一个
        }
        if annotation.title == "正常可用" {
            annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBike")
        } else {
            annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBikeRedPocket")
        }
        
        annotationView?.canShowCallout = true   //显示一个气泡
        annotationView?.animatesDrop = true     //标记点从上而下掉落
        
        return annotationView
    }
    
    
    
    
    // MARK: - Map Search Delegate
    //搜索完成后数据解析
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        guard response.count > 0 else{
            print("周边没有小黄车")
            return
        }
        
        var annotations:[MAPointAnnotation] = []
        annotations = response.pois.map{    //用map函数将pois数组转换为annotations数组
            let annotation = MAPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees($0.location.latitude), longitude: CLLocationDegrees($0.location.longitude))
            if $0.distance < 300{
                annotation.title = "红包区域内开锁任意小黄车"
                annotation.subtitle = "骑行10分钟可获得现金红包"
            }else{
                annotation.title = "正常可用"
            }
            
            return annotation
        }
        mapView.addAnnotations(annotations)
        if nearBySearch{    //如果是在用户周围进行搜索，则自动缩放以显示所有小黄车
            mapView.showAnnotations(annotations, animated: true)    //将地图缩放以便显示标注
            nearBySearch = !nearBySearch    //!：取反
        }
    }
    
    // MARK: - AMapNaviWalkManagerDelegate 导航代理
    func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager) {
        print("路线规划成功！")
        mapView.removeOverlays(mapView.overlays)    //每次路线规划成功即点击一辆小黄车后，删除之前规划过并显示的路线，之后显示当前选中的小黄车的导航路线
        
        var coordinates = walkManager.naviRoute!.routeCoordinates!.map({    //数组型转换
            return CLLocationCoordinate2D(latitude: CLLocationDegrees($0.latitude), longitude: CLLocationDegrees($0.longitude))
        })
        
        let polyline = MAPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
        mapView.add(polyline)
        
        //提示距离和用时
        let walkMinute = walkManager.naviRoute!.routeTime / 60  //walkMinute取值应该是整数
        
        var timeDesc = "1分钟以内"
        if walkMinute > 0 {
            timeDesc = walkMinute.description + "分钟"    //整数转换为字符串(A textual representation of this instance)
        }
        let hintTitle = "步行" + timeDesc
        let hintSubtitle = "距离" + walkManager.naviRoute!.routeLength.description + "米"
        
//        系统默认提示框样式
//        let ac = UIAlertController(title: hintTitle, message: hintSubtitle, preferredStyle: .alert)
//        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//        ac.addAction(action)
//        self.present(ac, animated: true, completion: nil)
//        使用FTIndicator样式进行提示
        FTIndicator.setIndicatorStyle(.dark)
        FTIndicator.showNotification(with: #imageLiteral(resourceName: "clock"), title: hintTitle, message: hintSubtitle)
    }
    
    
    func walkManager(_ walkManager: AMapNaviWalkManager, onCalculateRouteFailure error: Error) {
        print("路线规划失败：",error)
    }


}

