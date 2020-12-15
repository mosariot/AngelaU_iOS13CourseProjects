//
//  ViewController.swift
//  MagicPaper
//
//  Created by Александр Воробьев on 07.11.2020.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "AR_Image", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 1
        }

        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
        
        let videoNode = SKVideoNode(fileNamed: "harry_potter.mp4")
        videoNode.play()
        
        let videoScene = SKScene(size: CGSize(width: 1280, height: 720))
        videoNode.position = CGPoint(x: videoScene.size.width/2, y: videoScene.size.height/2)
        videoNode.yScale = -1.0
        videoScene.addChild(videoNode)
        
        let node = SCNNode()
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        plane.firstMaterial?.diffuse.contents = videoScene
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2
        node.addChildNode(planeNode)
        
        return node
    }
}
