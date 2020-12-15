//
//  ViewController.swift
//  Poke3D
//
//  Created by Александр Воробьев on 06.11.2020.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 2
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
        
        let node = SCNNode()
        
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2
        node.addChildNode(planeNode)
        
        if let pokeName = imageAnchor.referenceImage.name {
            if let pokeScene = SCNScene(named: "art.scnassets/\(pokeName).scn") {
                if let pokeNode = pokeScene.rootNode.childNodes.first {
                    pokeNode.eulerAngles.x = .pi / 2
                    pokeNode.eulerAngles.z = .pi
                    planeNode.addChildNode(pokeNode)
                }
            }
        }
        
        return node
    }
}
