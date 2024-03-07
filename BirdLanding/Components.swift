//
//  Components.swift
//  BirdLanding
//
//  Created by Peter Rogers on 05/07/2023.
//

import Foundation

import RealityKit

struct MotionComponent: RealityKit.Component {

   
    private(set) var futurePosition: SIMD3<Float>
    private(set) var animationState: animationStates
    private(set) var onscreen: entityVisibility
    mutating func setAnimationState(state:animationStates){
        self.animationState = state
    }
    
    mutating func setScreenState(state:entityVisibility){
        self.onscreen = state
    }
   // var forces = [Force]()

    
}



enum animationStates{
    
    case flying
    case landing
    case hopping
    case takingOff
    case instanced
}

enum entityVisibility{
    
    case onscreen
    case offscreen
    case appearing
    case leaving
}
