//
//  ViewController.swift
//  ARDicee
//
//  Created by Александр Воробьев on 03.11.2020.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    var diceArray: [SCNNode] = []
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        //        let cube = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0.02)
        
        //        let sphere = SCNSphere(radius: 0.2)
        //
        //        let material = SCNMaterial()
        //        material.diffuse.contents = UIImage(named: "art.scnassets/moon.jpg")
        //        sphere.materials = [material]
        //
        //        let node = SCNNode()
        //        node.position = SCNVector3(0, 0.2, -0.5)
        //        node.geometry = sphere
        //
        //        sceneView.scene.rootNode.addChildNode(node)
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //MARK: - Dice Rendering Methods
    
    @IBAction func rollAgainPressed(_ sender: UIBarButtonItem) {
        rollAll()
    }
    
    @IBAction func removeAllPressed(_ sender: UIBarButtonItem) {
        if !diceArray.isEmpty {
            for dice in diceArray {
                dice.removeFromParentNode()
            }
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, options: [SCNHitTestOption.searchMode : 1])
            for result in results.filter({$0.node.name != nil}) {
                if result.node.name == "planeNode" {
                    addDice(atLocation: result)
                }
            }
        }
    }
    
    func addDice(atLocation location: SCNHitTestResult) {
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        guard let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) else { return }
        diceArray.append(diceNode)
        
        diceNode.position = SCNVector3(
            location.worldCoordinates.x,
            location.worldCoordinates.y + diceNode.boundingSphere.radius/2,
            location.worldCoordinates.z)
        sceneView.scene.rootNode.addChildNode(diceNode)
        
        roll(dice: diceNode)
    }
    
    func rollAll() {
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice: dice)
            }
        }
    }
    
    func roll(dice: SCNNode) {
        let randomX = Float(Int.random(in: 1...4)) * (Float.pi/2)
        let randomZ = Float(Int.random(in: 1...4)) * (Float.pi/2)
        
        dice.runAction(
            SCNAction.rotateBy(
                x: CGFloat(randomX * 2),
                y: 0,
                z: CGFloat(randomZ * 2),
                duration: 0.5)
        )
    }
    
    //MARK: - ARSCNView Delegate Methods
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let planeNode = createPlane(withPlaneAnchor: planeAnchor)
        node.addChildNode(planeNode)
    }
    
    //MARK: - Plane Rendering Methods
    
    func createPlane(withPlaneAnchor planeAnchor: ARPlaneAnchor) -> SCNNode {
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let planeNode = SCNNode()
        planeNode.name = "planeNode"
        planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        plane.materials = [gridMaterial]
        planeNode.geometry = plane
        return planeNode
    }
}
