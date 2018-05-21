//
//  HomePageViewController.swift
//  Park!
//
//  Created by Blaer on 21/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit
import ChameleonFramework
import SVProgressHUD
import FirebaseDatabase

class HomePageViewController: UIViewController {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourthView: UIView!
    
    @IBOutlet var  myScrollView: UIScrollView!
    @IBOutlet weak var spaceIdTextField: UITextField!
    
    @IBOutlet weak var presentInfoLabel: UILabel!
    @IBOutlet weak var countTimeLabel: UILabel!
    @IBOutlet weak var thridViewTopLayout: NSLayoutConstraint!
    
    @IBOutlet weak var firstMoreButton: RoundedButtonWithBorder!
    
    @IBOutlet weak var startOrderButton: RoundedButtonWithBorder!
    @IBOutlet weak var seeMoreButton: RoundedButtonWithBorder!
    
    @IBOutlet weak var stopOrderButton: RoundedButtonWithBorder!
    
    @IBOutlet var payView: UIView!
    
    @IBOutlet weak var paymentLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var topAnchorContraint: NSLayoutConstraint!
    let darkView = UIView.init()
    
    var currentUser: String!
    var currentOrder: String!
    var payment: String!
    
    var timer: Timer!
    var count: Int = 0
    
    var hour: Int = 0
    var minute: Int = 0
    var second: Int = 0
    
    var orders: [Order] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        self.setupNavBar()
        self.getRelatedRecord()
        self.myScrollView.contentInsetAdjustmentBehavior = .automatic
        self.myScrollView.delegate = self
        self.spaceIdTextField.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            currentUser = userInformation["phone"] as! String
        }
        
        //        Order.checkUnfinishedOrder(currentUser) { (free, orderId) in
        //            self.displayConvertWithStatus(free)
        //            self.currentOrder = orderId
        //        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Order.checkUnfinishedOrder(currentUser) { (free, orderId) in
            self.displayConvertWithStatus(free)
            self.currentOrder = orderId
        }
        
        if let orderId = self.currentOrder {
            if orderId != "" {
                Database.database().reference().child("orders").child(orderId).child("spaceId").observeSingleEvent(of: .value) { (snap) in
                    if snap.exists() {
                        let spaceId = snap.value! as! String
                        Database.database().reference().child("spaces").child(spaceId).child("isReady").observe(.value, with: { (shot) in
                            if shot.exists() {
                                let ready = shot.value! as! Bool
                                if ready {
                                    self.scheduleNotification(itemID: spaceId)
                                }
                            }
                        })
                    }}
            }
        }
    }
    
    // MARK: - setup
    func customization() {
        
        self.firstView.backgroundColor = FlatBlackDark()
        self.secondView.backgroundColor = FlatWhite()
        self.thirdView.backgroundColor = FlatWhite()
        self.fourthView.backgroundColor = FlatWhite()
        
        self.firstMoreButton.layer.borderColor = UIColor.white.cgColor
        self.startOrderButton.layer.borderColor = FlatMint().cgColor
        self.seeMoreButton.layer.borderColor = FlatMint().cgColor
        self.stopOrderButton.layer.borderColor = FlatMint().cgColor
        
        self.countTimeLabel.textColor = FlatSandDark()
        self.paymentLabel.textColor = FlatCoffee()
        
        // 由于效果需要暂时将子View加在最顶层Tabbar上，以便将darkView覆盖全屏
        //DarkView customization
        self.tabBarController?.view.addSubview(self.darkView)
        self.darkView.backgroundColor = UIColor.black
        self.darkView.alpha = 0
        self.darkView.translatesAutoresizingMaskIntoConstraints = false
        self.darkView.leadingAnchor.constraint(equalTo: (self.tabBarController?.view.leadingAnchor)!).isActive = true
        self.darkView.topAnchor.constraint(equalTo: (self.tabBarController?.view.topAnchor)!).isActive = true
        self.darkView.trailingAnchor.constraint(equalTo: (self.tabBarController?.view.trailingAnchor)!).isActive = true
        self.darkView.bottomAnchor.constraint(equalTo: (self.tabBarController?.view.bottomAnchor)!).isActive = true
        self.darkView.isHidden = true
        //ContainerView customization
        let extraViewsContainer = UIView.init()
        extraViewsContainer.translatesAutoresizingMaskIntoConstraints = false
        self.tabBarController?.view.addSubview(extraViewsContainer)
        self.topAnchorContraint = NSLayoutConstraint.init(item: extraViewsContainer, attribute: .top, relatedBy: .equal, toItem: self.tabBarController?.view, attribute: .top, multiplier: 1, constant: 1000)
        self.topAnchorContraint.isActive = true
        extraViewsContainer.leadingAnchor.constraint(equalTo: (self.tabBarController?.view.leadingAnchor)!).isActive = true
        extraViewsContainer.trailingAnchor.constraint(equalTo: (self.tabBarController?.view.trailingAnchor)!).isActive = true
        extraViewsContainer.heightAnchor.constraint(equalTo: (self.tabBarController?.view.heightAnchor)!, multiplier: 1).isActive = true
        extraViewsContainer.backgroundColor = UIColor.clear
        
        //ProfileView Customization
        extraViewsContainer.addSubview(self.payView)
        self.payView.translatesAutoresizingMaskIntoConstraints = false
        self.payView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        let payViewAspectRatio = NSLayoutConstraint.init(item: self.payView, attribute: .width, relatedBy: .equal, toItem: self.payView, attribute: .height, multiplier: 0.850, constant: 0)
        payViewAspectRatio.isActive = true
        self.payView.centerXAnchor.constraint(equalTo: extraViewsContainer.centerXAnchor).isActive = true
        self.payView.centerYAnchor.constraint(equalTo: extraViewsContainer.centerYAnchor).isActive = true
        self.payView.layer.cornerRadius = 5
        self.payView.clipsToBounds = true
        self.payView.isHidden = true
       
        self.view.layoutIfNeeded()
    }
    
    //Hide Extra views
    func dismissExtraViews() {
        self.topAnchorContraint.constant = 1000
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
            self.darkView.alpha = 0
            self.tabBarController?.view.transform = CGAffineTransform.identity
        }, completion:  { (true) in
            self.darkView.isHidden = true
            self.payView.isHidden = true
        })
    }
    
    //Show Pay view
    func showPayView()  {
        let transform = CGAffineTransform.init(scaleX: 0.96, y: 0.96)
        self.topAnchorContraint.constant = 0
        self.darkView.isHidden = false
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.darkView.alpha = 0.5
            
                self.tabBarController?.view.transform = transform
            
        })
        self.payView.isHidden = false
        
    }
    
    func setupNavBar() {
        self.navigationItem.title = "主页"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        //        self.navigationController?.navigationBar.barTintColor = FlatWhite()
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize.init(width: 5, height: 5)
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.2
        self.navigationController?.hidesNavigationBarHairline = true
    }
    
    // MARK: - methods
    
    func getRelatedRecord() {
        
//        SVProgressHUD.show(withStatus: "加载中")
        
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let phone = userInformation["phone"] as! String
            
            Order.getAllFinishedOrder(phone) { (orderArr) in
                self.orders = orderArr
                print("orders count\(orderArr.count)")
                DispatchQueue.main.async {
                    if orderArr.count == 0 {
//                        SVProgressHUD.showInfo(withStatus: "暂无消费记录")
                    }
                    else {
                        SVProgressHUD.dismiss()
                        self.collectionView.reloadData()
                    }
                }
                
                
            }
        }
        
    }
    
    func scheduleNotification(itemID:String){
        //如果已存在该通知消息，则先取消
        cancelNotification(itemID: itemID)
        
        //创建UILocalNotification来进行本地消息通知
        let localNotification = UILocalNotification()
        //推送时间（设置为30秒以后）
        localNotification.fireDate = Date(timeIntervalSinceNow: 0)
        //时区
        localNotification.timeZone = NSTimeZone.default
        //推送内容
        localNotification.alertBody = "当前使用的车位已被业主收回，请在两小时内结束停车"
        //声音
        localNotification.soundName = UILocalNotificationDefaultSoundName
        //额外信息
        localNotification.userInfo = ["ItemID":itemID]
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    //取消通知消息
    func cancelNotification(itemID:String){
        //通过itemID获取已有的消息推送，然后删除掉，以便重新判断
        let existingNotification = self.notificationForThisItem(itemID: itemID)
        if existingNotification != nil {
            //如果existingNotification不为nil，就取消消息推送
            UIApplication.shared.cancelLocalNotification(existingNotification!)
        }
    }
    
    //通过遍历所有消息推送，通过itemid的对比，返回UIlocalNotification
    func notificationForThisItem(itemID:String)-> UILocalNotification? {
        let allNotifications = UIApplication.shared.scheduledLocalNotifications
        for notification in allNotifications! {
            let info = notification.userInfo as! [String:String]
            let number = info["ItemID"]
            if number != nil && number == itemID {
                return notification as UILocalNotification
            }
        }
        return nil
    }
    
    func displayConvertWithStatus(_ status: Bool) {
        
        if status {
            self.presentInfoLabel.text = "当前停车时间为"
            
            Order.getTimeFromStart(currentUser, completion: { (time) in
                self.hour = Int(time/3600);
                self.minute = Int(time - self.hour * 3600) / 60
                self.second = Int(time - self.hour * 3600 - self.minute * 60)
                self.countTimeLabel.text = String.init(format: "%d:%02d:%02d", self.hour,self.minute,self.second)
                self.startTimer()
            })
            
            UIView.animate(withDuration: 0.8, animations: {
                self.spaceIdTextField.alpha = 0
                self.countTimeLabel.alpha = 1
                self.startOrderButton.alpha = 0
                self.stopOrderButton.alpha = 1
            }, completion: { (status) in
                self.spaceIdTextField.isHidden = true
                self.countTimeLabel.isHidden = false
                self.startOrderButton.isHidden = true
                self.stopOrderButton.isHidden = false
            })
        }
        else {
            self.presentInfoLabel.text = "使用共享车位服务"
            UIView.animate(withDuration: 0.8, animations: {
                self.spaceIdTextField.alpha = 1
                self.countTimeLabel.alpha = 0
                self.startOrderButton.alpha = 1
                self.stopOrderButton.alpha = 0
            }, completion: { (status) in
                self.spaceIdTextField.isHidden = false
                self.countTimeLabel.isHidden = true
                self.startOrderButton.isHidden = false
                self.stopOrderButton.isHidden = true
            })
        }
        
    }
    
    // MARK: - Action
    

    @IBAction func showScanAction(_ sender: Any) {
        
        if let currentOrder = self.currentOrder {
            if currentOrder != "" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ARVC")
                self.present(vc!, animated: true, completion: nil)
            }
            else {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "scanVC") as! ScanViewController
                vc.currentUser = self.currentUser
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func closeView(_ sender: Any) {
        self.dismissExtraViews()
        
    }
    
    @IBAction func startParkAction(_ sender: Any) {
        
        self.spaceIdTextField.resignFirstResponder()
        
        if self.spaceIdTextField.text! == "" {
            SVProgressHUD.showError(withStatus: "车位编号不能为空!")
            SVProgressHUD.dismiss(withDelay: 1.0)
            return
        }
        
        ParkingSpace.checkSpaceStatus(self.spaceIdTextField.text!) { (status) in
            if status == 0 {
                SVProgressHUD.showError(withStatus: "该车位已出租")
                SVProgressHUD.dismiss(withDelay: 1.0)
            } else if status == 1 {
                self.successStartPark()
            } else if status == 2 {
                SVProgressHUD.showError(withStatus: "该车位暂不开放")
                SVProgressHUD.dismiss(withDelay: 1.0)
            } else {
                SVProgressHUD.showError(withStatus: "车位编号不存在")
                SVProgressHUD.dismiss(withDelay: 1.0)
            }
        }
        
    }
    
    func successStartPark() {
        
        Order.checkUnfinishedOrder(currentUser, completion: { (status, orderId) in
            if status {
                // need to finish currentOrder
                
                SVProgressHUD.showError(withStatus: "暂不支持同时使用多车位")
                SVProgressHUD.dismiss(withDelay: 1.0)
            }
            else {
                SVProgressHUD.show()
                Order.createOrderWith(spaceId: self.spaceIdTextField.text!, user: self.currentUser, completion: { (status) in
                    if status {
                        print("车位解锁成功")
                        self.displayConvertWithStatus(true)
                        SVProgressHUD.dismiss()
                        SVProgressHUD.showSuccess(withStatus: "车位解锁成功")
                        SVProgressHUD.dismiss(withDelay: 1.0)
                    }
                    else {
                        print("失败，请重试")
                        SVProgressHUD.dismiss()
                        SVProgressHUD.showSuccess(withStatus: "请重试")
                        SVProgressHUD.dismiss(withDelay: 1.0)
                    }
                })
            }
        })
    }
    @IBAction func checkClubMore(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ClubNav") as! UINavigationController
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func checkInfoMore(_ sender: Any) {
        
        let storyBoard = "AppleHomePage"
        let vc = UIStoryboard(name: storyBoard, bundle: nil).instantiateInitialViewController()!
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    @IBAction func stopOrderAction(_ sender: Any) {
        
        SVProgressHUD.show(withStatus: "")
        Order.endUnfinishedOrder(currentUser) { (status, payment) in
            DispatchQueue.main.async {
                if status {
                    SVProgressHUD.dismiss()
                    // display payment view
                    self.showPayView()
                    self.payment = payment
                    self.paymentLabel.text = String.init(format: "%.1f元", Float(payment)!)
                    self.displayConvertWithStatus(false)
                }
                else {
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: "请重试")
                    SVProgressHUD.dismiss(withDelay: 1.0)
                }
            }
        }
    }
    
    
    @IBAction func wechatPayAction(_ sender: Any) {
        
        SVProgressHUD.show(withStatus: "支付中")
        NSLog("Wechat Pay Action")
        Order.didPayFee(self.currentUser, order: self.currentOrder, charged: self.payment) { (status) in
            if status {
                SVProgressHUD.dismiss()
                self.dismissExtraViews()
            }
            else {
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "支付失败,请重试")
            }
        }
        
    }
    
    @IBAction func aliPayAction(_ sender: Any) {
        SVProgressHUD.show(withStatus: "支付中")
        NSLog("Ali Pay Action")
        Order.didPayFee(self.currentUser, order: self.currentOrder, charged: self.payment) { (status) in
            if status {
                SVProgressHUD.dismiss()
                self.dismissExtraViews()
            }
            else {
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "支付失败,请重试")
            }
        }
    }

    
    // MARK: - Timer methods
    
    // 实例化方法
    func createTimer()
    {
        // init方法
        //        self.timer = NSTimer.init(timeInterval: 0.1, target: self, selector: #selector(ViewController.countdown), userInfo: nil, repeats: true);
        // scheduled方法
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.countdown()
        })
        
        RunLoop.current.add(self.timer, forMode: RunLoopMode.commonModes)
        self.stopTimer()
    }

    // 开始计数
    func startTimer()
    {
        if self.timer == nil
        {
            self.createTimer();
        }
        self.timer.fireDate = Date.distantPast
    }
    
    func stopTimer() {
        self.timer.fireDate = Date.distantFuture
    }
    
    func killTimer() {
        if (self.timer != nil)
        {
            if self.timer.isValid
            {
                self.timer.invalidate()
                self.timer = nil
            }
        }
        self.count = 0
    }
    
    // 计数方法
    func countdown()
    {
        self.second += 1
        
        if(self.second == 60){
            self.minute = self.minute + 1
            self.second = 0
        }
        if (self.minute == 60) {
            self.hour = self.hour + 1
            self.minute = 0
        }
        self.countTimeLabel.text = String.init(format: "%d:%02d:%02d", self.hour,self.minute,self.second)
    }
}

extension HomePageViewController: UIScrollViewDelegate,  UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.spaceIdTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.spaceIdTextField.resignFirstResponder()
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "recordItem", for: indexPath) as? RecordCollectionViewCell)!
        cell.order = self.orders[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "orderDetail") as! OrderDetailViewController
        vc.currentOrder = self.orders[indexPath.row]
        vc.whenPushed = false
        self.present(vc, animated: true, completion: nil)
    }
}
