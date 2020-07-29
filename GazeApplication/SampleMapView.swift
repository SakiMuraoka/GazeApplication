//
//  SampleMapView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/07/20.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SampleMapView:UIViewController, CLLocationManagerDelegate{
    
    var locManager: CLLocationManager!
    var latitudeDelta: CLLocationDegrees!
    var longitudeDelta: CLLocationDegrees!
    var showsUserLocation: Bool!
    var userTrackingMode: MKUserTrackingMode!
    var mapView: MapView!
    var mapInit: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MapViewの表示（今回はマップのみ）
        mapView = MapView(frame: self.view.bounds)
        initMap()
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(mapView)
        
        //現在地取得の処理
        locManager = CLLocationManager()
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                // 座標の表示
                locManager.startUpdatingLocation()
                break
            default:
                break
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        //現在地が変わるたびに，マップの中心を移動
        self.mapView.updateCurrentPos((locations.last?.coordinate)!, mapInit: self.mapInit)
        self.mapInit = false
    }
    
    //マップの初期化
    func initMap() {
        self.latitudeDelta = 0.02
        self.longitudeDelta = 0.02
        // 現在位置表示の有効化
        self.showsUserLocation = true
        // 現在位置設定（デバイスの動きとしてこの時の一回だけ中心位置が現在位置で更新される）
        self.userTrackingMode = .follow
        
        self.mapView.initMap(latitudeDelta: self.latitudeDelta, longitudeDelta: self.longitudeDelta, showsUserLocation: self.showsUserLocation, userTrackingMode: self.userTrackingMode)
    }

}
