//
//  MapView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/07/20.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit
import MapKit

class MapView:UIView, UIGestureRecognizerDelegate, UITextFieldDelegate {
    let mapView: MKMapView!
    var mapRegion: MKCoordinateRegion!
    
    let trackingButton: MKUserTrackingButton!
    
    let scale: MKScaleView!
    let compass: MKCompassButton!
    
    let mapViewTypeButton: UIButton!
    
    let searchField: UITextField!
    var searchPin: MKPointAnnotation!
    
    let gazePointer: GazePointer!
    
    var doubleTapGesture: UITapGestureRecognizer!
    let maxScale: CGFloat = 10
    
    var operationType = "none"
    
    override init(frame: CGRect) {
        //MKMapViewを作成と初期化
        self.mapView = MKMapView()
        mapRegion = mapView.region
        
        //MKUserTrackingButtonの作成と初期化
        self.trackingButton = MKUserTrackingButton(mapView: mapView)
        trackingButton.layer.backgroundColor = UIColor(white: 1, alpha: 0.7).cgColor
        
        //MKScaleViewの作成と初期化
        self.scale = MKScaleView(mapView: mapView)
        scale.legendAlignment = .leading
        scale.scaleVisibility = .visible
        
        //MKCompassButtonの作成と初期化
        self.compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .visible
        mapView.showsCompass = false
        
        //マップの表示タイプ切り替えボタンの作成と初期化
        self.mapViewTypeButton = UIButton(type: UIButton.ButtonType.detailDisclosure)
        mapViewTypeButton.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        
        
        //検索窓の作成と初期化
        self.searchField = UITextField(frame: frame)
        searchField.placeholder = "場所または住所を検索します"
        // キーボードタイプを指定
        searchField.keyboardType = .default
        // 枠線のスタイルを設定
        searchField.borderStyle = .roundedRect
        // 改行ボタンの種類を設定記入して
        searchField.returnKeyType = .done
        // テキストを全消去するボタンを表示
        searchField.clearButtonMode = .always
        
        //視線カーソルの作成と初期化
        gazePointer = GazePointer(frame: frame)
        
        //初期化が終わったら，super
        super.init(frame: frame)
        //Viewを追加
        self.addSubview(mapView)
        self.addSubview(gazePointer)
        self.addSubview(trackingButton)
        self.addSubview(scale)
        self.addSubview(compass)
        self.addSubview(mapViewTypeButton)
        self.addSubview(searchField)
        
        //マップの表示タイプ切り替えボタンの初期化（タップ時の処理の追加）
        mapViewTypeButton.addTarget(self, action: #selector(self.mapViewTypeButtonThouchDown(_:)), for: .touchDown)
        //ダブルタップジェスチャの作成と初期化
        doubleTapGesture = UITapGestureRecognizer(target: self, action:#selector(self.doubleTapAction(gesture:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGesture)
        
        searchField.delegate = self
        doubleTapGesture.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //追加したUIのレイアウト設定
    override func layoutSubviews() {

        super.layoutSubviews()
        
        //画面サイズ
        let flameSize = frame.size

        //mapViewのレイアウト
        let mapSize = flameSize
        let mapOrigin = CGPoint(x: 0, y: 0)
        self.mapView.frame = CGRect(origin: mapOrigin, size: mapSize)
        
        //trackingButtonのレイアウト
        let trackingButtonSize = CGSize(width: 40, height: 40)
        let trackingButtonOrigin = CGPoint(x: 40, y: flameSize.height - 82)
        self.trackingButton.frame = CGRect(origin: trackingButtonOrigin, size: trackingButtonSize)
        
        //scaleのレイアウト
        let scaleSize = scale.intrinsicContentSize
        let scaleOrigin = CGPoint(x: 15, y: 45)
        self.scale.frame = CGRect(origin: scaleOrigin, size: scaleSize)
        
        //compassのレイアウト
        let compassSize = CGSize(width: 40, height: 40)
        let compassOrigin = CGPoint(x: flameSize.width - 50, y: 150)
        self.compass.frame = CGRect(origin: compassOrigin, size: compassSize)
        
        //mapViewTypeButtonのレイアウト
        let mapViewTypeButtonSize = CGSize(width: 40, height: 40)
        let mapViewTypeButtonOrigin = CGPoint(x:flameSize.width - 50, y: 100)
        self.mapViewTypeButton.frame = CGRect(origin: mapViewTypeButtonOrigin, size: mapViewTypeButtonSize)
        // 枠線の幅
        mapViewTypeButton.layer.borderWidth = 0.5
        // 枠線の色
        mapViewTypeButton.layer.borderColor = UIColor.blue.cgColor
        
        //searchFieldのレイアウト
        let searchFieldSize = CGSize(width: flameSize.width - 80, height: 40)
        let searchFieldOrigin = CGPoint(x:20, y: 100)
        searchField.frame = CGRect(origin: searchFieldOrigin, size: searchFieldSize)
     }
    
    //マップの初期化（今回は現在地表示のため）
    func initMap(latitudeDelta: CLLocationDegrees, longitudeDelta: CLLocationDegrees, showsUserLocation: Bool, userTrackingMode: MKUserTrackingMode){
        mapRegion.span.latitudeDelta = latitudeDelta
        mapRegion.span.longitudeDelta = longitudeDelta
        mapView.setRegion(mapRegion,animated:true)
       // 現在位置表示の有効化
       mapView.showsUserLocation = showsUserLocation
       // 現在位置設定（デバイスの動きとしてこの時の一回だけ中心位置が現在位置で更新される）
       mapView.userTrackingMode = userTrackingMode
    }
    
    //現在地にマップの中心を移動
    func updateCurrentPos(_ coordinate:CLLocationCoordinate2D, mapInit: Bool) {
        //最初だけ
        if(mapInit) {
            mapRegion.center = coordinate
            mapView.setRegion(mapRegion,animated:true)
        }
   }
    
    //マップの表示タイプ切り替えボタンの処理
    @objc func mapViewTypeButtonThouchDown(_ sender: UIButton) {
        self.operationType = "typeButton"
        switch mapView.mapType {
        case .standard:         // 標準の地図
            mapView.mapType = .satellite
            break
        case .satellite:        // 航空写真
            mapView.mapType = .hybrid
            break
        case .hybrid:           // 標準の地図＋航空写真
            mapView.mapType = .satelliteFlyover
            break
        case .satelliteFlyover: // 3D航空写真
            mapView.mapType = .hybridFlyover
            break
        case .hybridFlyover:    // 3D標準の地図＋航空写真
            mapView.mapType = .mutedStandard
            break
        case .mutedStandard:    // 地図よりもデータを強調
            mapView.mapType = .standard
            break
        default:
            break
        }
    }
    //テキストフィールドが改行された時（doneが押された時）の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.operationType = "returnTextField"
        //キーボードを閉じる
        textField.resignFirstResponder()
        if let searchKey = textField.text {
            //CLGeocoderインスタンスを取得
            let geocoder = CLGeocoder()
            //入力された文字から位置情報を取得
            geocoder.geocodeAddressString(searchKey, completionHandler: { (placemarks, error) in
                //位置情報が存在する場合（定数geocoderに値が入ってる場合)はunwrapPlacemarksに取り出す。
                if let unwrapPlacemarks = placemarks {
                    //1件目の情報を取り出す
                    if let firstPlacemark = unwrapPlacemarks.first {
                        //位置情報を取り出す
                        if let location = firstPlacemark.location {
                            //位置情報から緯度経度をtargetCoordinateに取り出す
                            let targetCoordinate = location.coordinate
                            //緯度経度をデバッグエリアに表示
                            print(targetCoordinate)                            
                            //ピンを作成し，マップの中心にする
                            self.createPin(coordinate: targetCoordinate, title: searchKey)
                        }
                    }
                }
                })
        }
        print("Return")
        return true
    }

    // クリアボタンが押された時の処理
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("Clear")
        return true
    }

    // テキストフィールドがフォーカスされた時の処理
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.operationType = "BeginTextField"
        print("Start")
        return true
    }

    // テキストフィールドでの編集が終了する直前での処理
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("End")
        return true
    }
    var exsistPin = false
    //ピンを作成し，マップの中心にする
    func createPin(coordinate:CLLocationCoordinate2D, title: String) {
        self.operationType = "createPin"
        //すでにピンがある場合は，削除
        if(exsistPin) {
            self.operationType = "deletePin"
            self.mapView.removeAnnotation(searchPin)
        }
        self.searchPin = MKPointAnnotation()
        self.searchPin.coordinate = coordinate
        self.searchPin.title = title
        self.mapView.addAnnotation(self.searchPin)
        self.mapView.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
        exsistPin = true
    }
    
    //GazePointerをドラッグで移動
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let view = touch.view else { return }
        self.operationType = "drug"
        if view == self.gazePointer {
            self.operationType = "drugPointer"
            movePointer(to: touch.location(in: self))
        }
    }
    
    //GazePointerを移動させる
    func movePointer(to: CGPoint){
        self.gazePointer.center = to
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    //ダブルタップで，gazePointerの位置でズーム
    var gazePointInit = true
    @objc func doubleTapAction(gesture: UITapGestureRecognizer) {
        self.operationType = "doubleTap"
        let offset: CGFloat!
        offset = 4.8

        let gazePointOrigin = CGPoint(x: gazePointer.frame.origin.x + (gazePointer.radius + gazePointer.locationOffset), y: gazePointer.frame.origin.y + (gazePointer.radius - gazePointer.locationOffset) + offset)
        let zoomCenter = mapView.convert(gazePointOrigin, toCoordinateFrom: mapView)
        let currentZoom = mapView.region.span
        if(0.001 < currentZoom.latitudeDelta / 2){
            initMap(latitudeDelta: currentZoom.latitudeDelta/2, longitudeDelta: currentZoom.longitudeDelta/2, showsUserLocation: true, userTrackingMode: .follow)
        }
        updateCurrentPos(zoomCenter, mapInit: true)
    }
}


