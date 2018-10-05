//
//  ViewController.swift
//  Watch Interface
//
//  Created by lucas fernández on 04/10/2018.
//  Copyright © 2018 lucas fernández. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        // Create a new Reference tracking dataset
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) else { return }
        
        // Set the image tracking and number of tracking images
        configuration.trackingImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 1
        configuration.isLightEstimationEnabled = true

        // Run the view's session with lightning estimation
        sceneView.session.run(configuration)
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }

}

extension ViewController: ARSCNViewDelegate {

    //      Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        // Check if the anchor is and image anchor
        guard anchor is ARImageAnchor else { return nil }
        // Create the plane
        let plane = SCNPlane(width: 0.1, height: 0.05)
        let interfaceScene = SKScene(fileNamed: "InterfaceScene")
        // Convert the material of the plane into the SpriteKit scene
        plane.firstMaterial?.diffuse.contents = interfaceScene
        plane.firstMaterial?.isDoubleSided = true
        // Transform the plane to display it horizontally
        plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2
        
        // Create the 3D scene kit's model
        var auraNode = SCNNode()
        let auraScene = SCNScene(named: "art.scnassets/AuraNew.scn")!
        // Add it in position
        auraNode = auraScene.rootNode.childNodes.first!
        auraNode.position = SCNVector3(0, -0.012, 0.01)
        // Add an scale
        let scale = 0.008
        auraNode.scale = SCNVector3(scale, scale, scale)
        
        node.addChildNode(planeNode)
        planeNode.addChildNode(auraNode)

        return node
    }

}
