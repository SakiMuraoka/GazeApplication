//
//  MapView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/07/20.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit
import MapKit

class MapView:UIView, UIGestureRecognizerDelegate, UITextFieldDelegate, MKMapViewDelegate {
    let mapView: MKMapView!
    var mapRegion: MKCoordinateRegion!
    
    let trackingButton: MKUserTrackingButton!
    
    let scale: MKScaleView!
    let compass: MKCompassButton!
    
    let mapViewTypeButton: UIButton!
    
    let searchField: UITextField!
    var searchPin: MKPointAnnotation!
    var anoPin: MKPointAnnotation!
    
    let gazePointer: GazePointer!
    
    var tapGesture: UITapGestureRecognizer!
    var doubleTapGesture: UITapGestureRecognizer!
    let maxScale: CGFloat = 10
    
    var operationType = "none"
    var operationPosition = CGPoint()
    
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
        mapViewTypeButton.addTarget(self, action: #selector(self.mapViewTypeButtonThouchDown), for: .touchDown)
//        compass.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(Compass(gesture:))))
        searchField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(forcusSearch(gesture:))))

        //ダブルタップジェスチャの作成と初期化
        doubleTapGesture = UITapGestureRecognizer(target: self, action:#selector(self.doubleTapAction(gesture:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGesture)
        tapGesture = UITapGestureRecognizer(target: self, action:#selector(self.tapAction(gesture:)))
        self.addGestureRecognizer(tapGesture)
        //ピンチイン・アウト
        let pinchGetsture = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction))
        pinchGetsture.delegate = self
        self.addGestureRecognizer(pinchGetsture)
        //ロングタップ
        let longTapGetsture = UILongPressGestureRecognizer(target: self, action: #selector(longTapAction))
        longTapGetsture.delegate = self
        self.addGestureRecognizer(longTapGetsture)
        
        mapView.delegate = self
        searchField.delegate = self
        tapGesture.delegate = self
        doubleTapGesture.delegate = self
        
//        //キーボードが現れるときに通知するメソッドを登録する。
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc func Compass(gesture: UITapGestureRecognizer) {
        self.operationType = "Compass"
        self.operationPosition = gesture.location(in: self)
        compass.becomeFirstResponder()
    }
    
    @objc func forcusSearch(gesture: UITapGestureRecognizer){
        self.operationType = "touchTextField"
        self.operationPosition = gesture.location(in: self)
        searchField.becomeFirstResponder()
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
    
//    マップの初期化（今回は現在地表示のため）
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
    
    //MARK: - ボタン
    //マップの表示タイプ切り替えボタンの処理
    @objc func mapViewTypeButtonThouchDown(_ sender: UIButton, event: UIEvent) {
        self.operationType = "typeButton"
        if let location = event.touches(for: sender)?.first?.location(in: self) {
            self.operationPosition = location
        }
        switch mapView.mapType {
        case .standard:         // 標準の地図
            mapView.mapType = .satellite
            break
        case .satellite:        // 航空写真
            mapView.mapType = .hybrid
            break
        case .hybrid:           // 標準の地図＋航空写真
            mapView.mapType = .standard
            break
//        case .satelliteFlyover: // 3D航空写真
//            mapView.mapType = .hybridFlyover
//            break
//        case .hybridFlyover:    // 3D標準の地図＋航空写真
//            mapView.mapType = .mutedStandard
//            break
//        case .mutedStandard:    // 地図よりもデータを強調
//            mapView.mapType = .standard
//            break
        default:
            break
        }
    }
    //MARK: - テキストフィールド
    //テキストフィールドが改行された時（doneが押された時）の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.operationType = "returnTextField"
        self.operationPosition = CGPoint(x: 375, y: 755)
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
//                            print(targetCoordinate)
                            //ピンを作成し，マップの中心にする
                            self.createSearchPin(coordinate: targetCoordinate, title: searchKey)
                        }
                    }
                }
                })
        }
        return true
    }

    // クリアボタンが押された時の処理
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.operationType = "clearTextField"
        //FIXME: クリアボタンの座標にする
        let clearButtonrect = textField.clearButtonRect(forBounds: self.searchField.frame)
        self.operationPosition = clearButtonrect.center
        return true
    }

    // テキストフィールドがフォーカスされた時の処理
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        self.operationType = "touchTextField"
//        self.operationPosition = textField.center
        return true
    }

    // テキストフィールドでの編集が終了する直前での処理
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    //キーボードが開くときの呼び出しメソッド
    var keyboardRect = CGRect()
    @objc func keyboardWillBeShown(notification:NSNotification) {
        //キーボードのフレームを取得する。
        if let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            keyboardRect = keyboardFrame
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        operationType = "editTextFild「" + string + "」"
        return true
    }

    //MARK: - ピン
    var exsistPin = false
    //ピンを作成し，マップの中心にする
    func createSearchPin(coordinate:CLLocationCoordinate2D, title: String) {
//        self.operationType = "createPin"
        //すでにピンがある場合は，削除
        if(exsistPin) {
            self.mapView.removeAnnotation(searchPin)
        }
        self.searchPin = MKPointAnnotation()
        self.searchPin.coordinate = coordinate
        self.searchPin.title = title
        self.mapView.addAnnotation(self.searchPin)
        self.mapView.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
        exsistPin = true
    }
    
    func createPin(coordinate:CLLocationCoordinate2D) {
//        self.operationType = "createPin"
        anoPin = MKPointAnnotation()
        anoPin.coordinate = coordinate
        anoPin.title = "ピン"
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
//            guard let placemark = placemarks?.first, error == nil else { return }
//            self.anoPin.title = placemark.administrativeArea! + placemark.subAdministrativeArea! ?? "" + placemark.locality! ?? ""
//        }
        self.mapView.addAnnotation(anoPin)
    }
    
    //MARK: - MKmapViewDelegate

    //annotationが表示される時
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //現在地は除外
        if annotation is MKUserLocation {
            return nil
        }
        let markerAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        print("viewFor")
        markerAnnotationView.markerTintColor = UIColor.orange
        markerAnnotationView.canShowCallout = true
        markerAnnotationView.isDraggable = true
        let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
        button.setTitleColor(UIColor.black, for:.normal)
//        let label = UILabel()
//        label.text = annotation.title as! String
//        markerAnnotationView.detailCalloutAccessoryView = label
        markerAnnotationView.rightCalloutAccessoryView = button
        return markerAnnotationView
    }
    
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        print("didChangef")
        if newState == .starting {
        }
    }

    var selectPin: MKAnnotationView!
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        print("didSelect")
        selectPin = view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        mapView.removeAnnotations([selectPin.annotation!])
    }

    //MARK: - ドラッグ
    //GazePointerをドラッグで移動
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let view = touch.view else { return }
        self.operationType = "drug"
        self.operationPosition = touch.location(in: self)
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
    //MARK: - タップ
    var tapCount = 0
    @objc func tapAction(gesture: UITapGestureRecognizer) {
        self.operationType = "Tap"
        self.operationPosition = gesture.location(in: self)
        print(operationPosition)
        if(exsistPin) {
            self.mapView.removeAnnotation(searchPin)
        }
//        print("tap" + tapCount.description)
//        tapCount += 1
    }
    //ダブルタップで，gazePointerの位置でズーム
    var gazePointInit = true
    @objc func doubleTapAction(gesture: UITapGestureRecognizer) {
        self.operationType = "doubleTap"
        self.operationPosition = gesture.location(in: self)
//        let offset: CGFloat!
//        offset = 4.8

//        let gazePointOrigin = CGPoint(x: gazePointer.frame.origin.x + (gazePointer.radius + gazePointer.locationOffset), y: gazePointer.frame.origin.y + (gazePointer.radius - gazePointer.locationOffset) + offset)
//        let zoomCenter = mapView.convert(gazePointOrigin, toCoordinateFrom: mapView)
//        let currentZoom = mapView.region.span
//        if(0.001 < currentZoom.latitudeDelta / 2){
//            initMap(latitudeDelta: currentZoom.latitudeDelta/2, longitudeDelta: currentZoom.longitudeDelta/2, showsUserLocation: true, userTrackingMode: .follow)
//        }
//        updateCurrentPos(zoomCenter, mapInit: true)
    }
    @objc func longTapAction(_ sender: UILongPressGestureRecognizer) {
        print("longtap")
        // ロングタップ開始
        if sender.state == .began {
        }
        // ロングタップ終了（手を離した）
        else if sender.state == .ended {
            // タップした位置（CGPoint）を指定してMkMapView上の緯度経度を取得する
            let tapPoint = sender.location(in: self)
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            let lonStr = center.longitude.description
            let latStr = center.latitude.description

//            // 現在位置とタッウプした位置の距離(m)を算出する
//            let distance = calcDistance(mapView.userLocation.coordinate, center)
//            print("distance : " + distance.description)

//            // ロングタップを検出した位置にピンを立てる
//            anoPin.coordinate = center
//            mapView.addAnnotation(anoPin)
            createPin(coordinate: center)
        }
    }
    
    //MARK:- ピンチイン・アウト
    @objc func pinchAction(gesture: UIPinchGestureRecognizer) {
        self.operationType = "pinch"
        self.operationPosition = gesture.location(in:self)
    }
}

extension CGRect
{
    /** Creates a rectangle with the given center and dimensions
    - parameter center: The center of the new rectangle
    - parameter size: The dimensions of the new rectangle
     */
    init(center: CGPoint, size: CGSize)
    {
        self.init(x: center.x - size.width / 2, y: center.y - size.height / 2, width: size.width, height: size.height)
    }
    
    /** the coordinates of this rectangles center */
    var center: CGPoint
        {
        get { return CGPoint(x: centerX, y: centerY) }
        set { centerX = newValue.x; centerY = newValue.y }
    }
    
    /** the x-coordinate of this rectangles center
    - note: Acts as a settable midX
    - returns: The x-coordinate of the center
     */
    var centerX: CGFloat
        {
        get { return midX }
        set { origin.x = newValue - width * 0.5 }
    }
    
    /** the y-coordinate of this rectangles center
     - note: Acts as a settable midY
     - returns: The y-coordinate of the center
     */
    var centerY: CGFloat
        {
        get { return midY }
        set { origin.y = newValue - height * 0.5 }
    }
    
    // MARK: - "with" convenience functions
    
    /** Same-sized rectangle with a new center
    - parameter center: The new center, ignored if nil
    - returns: A new rectangle with the same size and a new center
     */
    func with(center: CGPoint?) -> CGRect
    {
        return CGRect(center: center ?? self.center, size: size)
    }
    
    /** Same-sized rectangle with a new center-x
    - parameter centerX: The new center-x, ignored if nil
    - returns: A new rectangle with the same size and a new center
     */
    func with(centerX: CGFloat?) -> CGRect
    {
        return CGRect(center: CGPoint(x: centerX ?? self.centerX, y: centerY), size: size)
    }

    /** Same-sized rectangle with a new center-y
    - parameter centerY: The new center-y, ignored if nil
    - returns: A new rectangle with the same size and a new center
     */
    func with(centerY: CGFloat?) -> CGRect
    {
        return CGRect(center: CGPoint(x: centerX, y: centerY ?? self.centerY), size: size)
    }
    
    /** Same-sized rectangle with a new center-x and center-y
    - parameter centerX: The new center-x, ignored if nil
    - parameter centerY: The new center-y, ignored if nil
    - returns: A new rectangle with the same size and a new center
     */
    func with(centerX: CGFloat?, centerY: CGFloat?) -> CGRect
    {
        return CGRect(center: CGPoint(x: centerX ?? self.centerX, y: centerY ?? self.centerY), size: size)
    }
}

