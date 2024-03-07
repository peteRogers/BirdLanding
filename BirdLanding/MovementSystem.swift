//
//  MovementSystem.swift
//  Tap To Place RealityKit Tutorial
//
//  Created by Peter Rogers on 29/06/2023.
//

import Foundation
import RealityKit
import UIKit
import Combine

class MovementSystem: System {
    var subscriptions = Set<AnyCancellable>()
    static let query = EntityQuery(where:
            .has(ModelComponent.self))
    static let birdQuery = EntityQuery(where: .has(MotionComponent.self))
    let animator = Animator()
    
    
    
    required init(scene: Scene) {
        print("movement system started")
        
        animator.loadAnimations()
        
    }
    
    func update(context: SceneUpdateContext) {
        context.scene.performQuery(Self.birdQuery).forEach { entity in
            var mc:MotionComponent = entity.components[MotionComponent.self] as! MotionComponent
            if(mc.animationState == .instanced){
                let anim = entity.playAnimation(animator.getAnimationByName(name: "fly"), transitionDuration: 1, blendLayerOffset: 0, separateAnimatedValue: false, startsPaused: false)
                anim.speed = 3
                mc.setAnimationState(state: .flying)
            }
            if(mc.onscreen == .appearing || mc.onscreen == .onscreen){
                if(entity.transform.translation.y > 0.2){
                    entity.transform.translation.y -= 0.01
                }
                if(entity.transform.translation.y <= 0.2 && entity.transform.translation.y > 0){
                    entity.transform.translation.y -= 0.005
                }
                if(entity.transform.translation.y < 0.2 && mc.animationState == .flying){
                    mc.setAnimationState(state: .landing)
                    mc.setScreenState(state: .onscreen)
                    let anim = entity.playAnimation(self.animator.getAnimationByName(name: "land"), transitionDuration: 0, blendLayerOffset: 0, separateAnimatedValue: false, startsPaused: false)
                    context.scene.subscribe(to: AnimationEvents.PlaybackCompleted.self, on: entity) { [weak self] event in
                        if event.playbackController == anim {
                            let a = anim.entity!.playAnimation(self!.animator.getAnimationByName(name: "idleLookAround"), transitionDuration: 0, blendLayerOffset: 0, separateAnimatedValue: false, startsPaused: false)
                            a.speed = Float.random(in: 0.5 ... 1.5)
                        }
                    }.store(in: &subscriptions)
                   
                }
            }
            if(mc.onscreen == .offscreen){
                mc.setScreenState(state: .leaving)
                mc.setAnimationState(state: .takingOff)
                let anim = entity.playAnimation(self.animator.getAnimationByName(name: "takeoff"), transitionDuration: 0, blendLayerOffset: 0, separateAnimatedValue: false, startsPaused: false)
                context.scene.subscribe(to: AnimationEvents.PlaybackCompleted.self, on: entity) { [weak self] event in
                    if event.playbackController == anim {
                        let a = anim.entity!.playAnimation(self!.animator.getAnimationByName(name: "fly"), transitionDuration: 0, blendLayerOffset: 0, separateAnimatedValue: false, startsPaused: false)
                        a.speed = 3
                    }
                }.store(in: &subscriptions)
            }
            
            if(mc.onscreen == .leaving){
                entity.transform.translation.y += 0.01
            }
            
            entity.components[MotionComponent.self] = mc
        }
    }
}
