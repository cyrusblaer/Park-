//
//  ARViewController.swift
//  Park!
//
//  Created by Blaer on 2018/5/2.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController,ARSCNViewDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
  
    @IBOutlet weak var endOrderButton: RoundedButtonWithBorder!
    
    @IBOutlet var payView: UIView!
    
    let defaults = UserDefaults.standard
    
    let session = ARSession()
    
    var textNode:SCNNode?
    var textSize:CGFloat = 5
    var textDistance:Float = 15
    
    var currentUser = "13802973828"
    var currentOrder: String!
    var payment: String!
    var timer: Timer!
    var count: Int = 0
    
    var hour: Int = 0
    var minute: Int = 0
    var second: Int = 0
    
    var countToShow = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Order.getTimeFromStart(currentUser, completion: { (time) in
            self.hour = Int(time/3600);
            self.minute = Int(time - self.hour * 3600) / 60
            self.second = Int(time - self.hour * 3600 - self.minute * 60)
            self.startTimer()

        })
        
        Order.getUnfinishedOrderStartTime(currentUser) { (payment) in
            self.payment = payment
        }
        
        //setup sceneView
        
        setupScene()
        /**
         SettingsViewController.registerDefaults()
         
         // Do any additional setup after loading the view, typically from a nib.
         
         NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
         
         NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
         
         self.growingTextView.layer.cornerRadius = 4
         self.growingTextView.backgroundColor = UIColor(white: 0.9, alpha: 1)
         self.growingTextView.textView.textContainerInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
         self.growingTextView.placeholderAttributedText = NSAttributedString(string: "Placeholder text",
         attributes: [NSAttributedStringKey.font: self.growingTextView.textView.font!,
         NSAttributedStringKey.foregroundColor: UIColor.gray
         ]
         )
         */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical
        
        // Run the view's session
        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupScene() {
        // set up sceneView
        sceneView.delegate = self
        sceneView.session = session
        sceneView.antialiasingMode = .multisampling4X
        sceneView.automaticallyUpdatesLighting = false
        
        sceneView.preferredFramesPerSecond = 60
        sceneView.contentScaleFactor = 1.3
        //sceneView.showsStatistics = true
        
        //        enableEnvironmentMapWithIntensity(25.0)
        
        DispatchQueue.main.async {
            //self.screenCenter = self.sceneView.bounds.mid
        }
        
        if let camera = sceneView.pointOfView?.camera {
            camera.wantsHDR = true
            //camera.wantsExposureAdaptation = true
            //camera.exposureOffset = -1
            //camera.minimumExposure = -1
        }
        
        sceneView.showsStatistics = true
//        self.startTimer()
        //        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    @IBAction func endOrderAction(_ sender: Any) {
        
        SVProgressHUD.show(withStatus: "")
        Order.endUnfinishedOrder(currentUser) { (status, payment) in
            DispatchQueue.main.async {
                if status {
                    SVProgressHUD.dismiss()
                    // display payment view
                    self.showPayView()
                    self.payment = payment
                   
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
                
            }
            else {
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "支付失败,请重试")
            }
        }
    }
 
    func showPayView()  {
        
        self.view.addSubview(self.payView)
        self.view.bringSubview(toFront: self.payView)
        
    }
    
    func showText(text:String) -> Void{
        /*
         if (defaults.object(forKey: "textDistance") != nil){
         print("distance is:", defaults.object(forKey: "textDistance") ?? "nothing")
         }else{
         print("no distance: ", defaults.object(forKey: "textDistance") ?? "nothing")
         
         }
         
         
         let textScn = ARText(text: text, font: UIFont.systemFont(ofSize: 200), color:defaults.colorForKey(key: "textColor")!, depth: 40)
         let textNode = TextNode(distance: defaults.float(forKey: "textDistance"), scntext: textScn, sceneView: self.sceneView, scale: 1/100.0)
         self.sceneView.scene.rootNode.addChildNode(textNode)
         */
        
        
        /*
         let textScn = ARText(text: text, font: UIFont.systemFont(ofSize: 25), color: UIColor .white, depth: 5)
         let textNode = TextNode(distance: 1, scntext: textScn, sceneView: self.sceneView, scale: 1/100.0)
         self.sceneView.scene.rootNode.addChildNode(textNode)
         */
        
        let fontSize = CGFloat(defaults.float(forKey: "textFont"))
        let textDistance = defaults.float(forKey: "textDistance")
        
        let textScn = ARText(text: text, font: UIFont .systemFont(ofSize: fontSize), color: UIColor.yellow, depth: fontSize/10)
        let textNode = TextNode(distance: textDistance/10, scntext: textScn, sceneView: self.sceneView, scale: 1/100.0, offset: 1.0)
        self.sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    
    
    @IBAction func restartButton(_ sender: UIButton) {
        
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) -> Void in
            node.removeFromParentNode()
        }
        
    }
    
    func enableEnvironmentMapWithIntensity(_ intensity: CGFloat) {
        if sceneView.scene.lightingEnvironment.contents == nil {
            if let environmentMap = UIImage(named: "Models.scnassets/sharedImages/environment_blur.exr") {
                sceneView.scene.lightingEnvironment.contents = environmentMap
            }
        }
        sceneView.scene.lightingEnvironment.intensity = intensity
    }
    
    
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    // MARK: - ARSCNViewDelegate
    
    /// - Tag: PlaceARContent
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Place content only for anchors found by plane detection.
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // Create a SceneKit plane to visualize the plane anchor using its position and extent.
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let planeNode = SCNNode(geometry: plane)
        planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
        
        // `SCNPlane` is vertically oriented in its local coordinate space, so
        // rotate the plane to match the horizontal orientation of `ARPlaneAnchor`.
        planeNode.eulerAngles.x = -.pi / 2
        
        // Make the plane visualization semitransparent to clearly show real-world placement.
        planeNode.opacity = 0
        
        // Add the plane visualization to the ARKit-managed node so that it tracks
        // changes in the plane anchor as plane estimation continues.
        node.addChildNode(planeNode)
        
        let fontSize = CGFloat.init(18.0)
        let textDistance = 10.0
        
        let textScn1 = ARText(text: "          当前停车费用", font: UIFont .systemFont(ofSize: fontSize), color: UIColor.yellow, depth: fontSize/10)
        let textNode1 = TextNode(distance: Float(textDistance/10), scntext: textScn1, sceneView: self.sceneView, scale: 1/100.0, offset: 0.0 )
        self.sceneView.scene.rootNode.addChildNode(textNode1)
        let textScn2 = ARText(text: "         \((self.payment)!)元", font: UIFont .systemFont(ofSize: fontSize), color: UIColor.yellow, depth: fontSize/10)
        let textNode2 = TextNode(distance: Float(textDistance/10), scntext: textScn2, sceneView: self.sceneView, scale: 1/100.0, offset: -0.3 )
        self.sceneView.scene.rootNode.addChildNode(textNode2)
        let textScn3 = ARText(text: self.countToShow, font: UIFont .systemFont(ofSize: fontSize), color: UIColor.yellow, depth: fontSize/10)
        let textNode3 = TextNode(distance: Float(textDistance/10), scntext: textScn3, sceneView: self.sceneView, scale: 1/100.0, offset: -0.6 )
        self.sceneView.scene.rootNode.addChildNode(textNode3)
        
    }
    
    /// - Tag: UpdateARContent
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // Update content only for plane anchors and nodes matching the setup created in `renderer(_:didAdd:for:)`.
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }
        
        // Plane estimation may shift the center of a plane relative to its anchor's transform.
        planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
        
        // Plane estimation may also extend planes, or remove one plane to merge its extent into another.
        plane.width = CGFloat(planeAnchor.extent.x)
        plane.height = CGFloat(planeAnchor.extent.z)
        
        print("node.childNodes.count:\(self.sceneView.scene.rootNode.childNodes.count)")

        guard let textNode = self.sceneView.scene.rootNode.childNodes.last as? TextNode else {
            return
        }
        
        let fontSize = CGFloat.init(22.0)
//        let textDistance = 10.0
        
//        let textScn = ARText(text: "test\(self.count)", font: UIFont .systemFont(ofSize: fontSize), color: UIColor.yellow, depth: fontSize/10)
//        textNode.scnText = textScn
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
    }

    // MARK: - ARSessionDelegate
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard let frame = session.currentFrame else { return }
        //updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        guard let frame = session.currentFrame else { return }
        //updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        //updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
    }
    
    // MARK: - ARSessionObserver
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay.
        //sessionInfoLabel.text = "Session was interrupted"
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required.
        //sessionInfoLabel.text = "Session interruption ended"
        resetTracking()
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user.
        //sessionInfoLabel.text = "Session failed: \(error.localizedDescription)"
        resetTracking()
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    private func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
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
        
        let node1 = self.sceneView.scene.rootNode.childNodes.last as? TextNode
        
//        node1?.removeFromParentNode()
        
        let fontSize = CGFloat.init(22.0)
        let textDistance = 10.0

        let textScn1 = ARText(text: String.init(format: "%02d:%02d:%02d", self.hour,self.minute,self.second), font: UIFont .systemFont(ofSize: fontSize), color: UIColor.yellow, depth: fontSize/10)
        let textNode1 = TextNode(distance: Float(textDistance/10), scntext: textScn1, sceneView: self.sceneView, scale: 1/100.0, offset: 0.0 )
        node1?.geometry = textNode1.geometry
        print(String.init(format: "%02d:%02d:%02d", self.hour,self.minute,self.second))
//        self.sceneView.scene.rootNode.addChildNode(textNode1)
//        self.countToShow = String.init(format: "%d:%02d:%02d", self.hour,self.minute,self.second)
    }
    
}
