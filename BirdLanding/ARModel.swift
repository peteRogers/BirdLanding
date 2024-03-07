//
//  ARModel.swift
//  Tap To Place RealityKit Tutorial
//
//  Created by Cole Dennis on 11/21/22.
//

import Foundation
import RealityKit
import ARKit
import Combine

struct ARModel {
    var arView : DetectionView
    var anchors = [UUID: AnchorEntity]()
    var baseEntity:Entity!
    var subscribes: [Cancellable] = []
    
    init() {
        arView = DetectionView(frame: .zero)
        arView.setup()
       
        baseEntity = try? Entity.load(named: "sparrow_Base")
        
//        arView.automaticallyConfigureSession = false
//        let config = ARWorldTrackingConfiguration()
//        config.planeDetection = .horizontal
//        config.sceneReconstruction = .mesh
       // arView.session.run(config, options: [.removeExistingAnchors, .resetSceneReconstruction])
      //  arView.environment.sceneUnderstanding.options.insert([.collision, .physics, .receivesLighting])
        
    }
    
    mutating func raycastFunc(location: CGPoint) {
        guard let query = arView.makeRaycastQuery(from: location, allowing: .existingPlaneGeometry, alignment: .horizontal)
        else { return }
        
        guard let result = arView.session.raycast(query).first
                
        else { return }
        
        let sphereEntity = ModelEntity(mesh: .generateSphere(radius: 0.01), materials: [SimpleMaterial(color: .white, isMetallic: false)])
       // print(result.target)
        let raycastAnchor = AnchorEntity(world: result.worldTransform)
        
        raycastAnchor.addChild(sphereEntity)
        let hopper = baseEntity.clone(recursive: true)
        hopper.transform.translation.y += 2
       
        hopper.components.set(MotionComponent(futurePosition: SIMD3(x: 0, y: 0, z: 0), animationState: .instanced, onscreen: .appearing))
        raycastAnchor.addChild(hopper)
        
        arView.scene.anchors.append(raycastAnchor)
        
        
       
        
        
//        var origTransform = raycastAnchor.transform
//        print(raycastAnchor.transform.translation.debugDescription)
//        origTransform.translation.y += -0.5
//        var transformComponent = raycastAnchor.transform
//        transformComponent.translation.y += 0.5
//
//        raycastAnchor.transform = transformComponent
//        print(raycastAnchor.transform.translation.debugDescription)
//        print(sphereEntity.transform.translation.debugDescription)
//        raycastAnchor.move(to: origTransform, relativeTo: raycastAnchor, duration: 2, timingFunction: .easeIn)
        
        
    }
}
