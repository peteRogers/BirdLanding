//
//  File.swift
//  SparrowFly
//
//  Created by Peter Rogers on 28/06/2023.
//

import Foundation
import RealityKit

final class Animator{
    
    var animations:[Animation] = []
    
    func loadAnimations(){
        guard let fly = try? Entity.load(named: "sparrowFly")else{
            fatalError("no fly")
        }
        animations.append(Animation(skel: fly.availableAnimations.first!.repeat(), name: "fly"))
        
        guard let land = try? Entity.load(named: "sparrowLand")else{
            fatalError("no land")
        }
        animations.append(Animation(skel: land.availableAnimations.first!, name: "land"))
       
        guard let land = try? Entity.load(named: "sparrowTakeOff")else{
            fatalError("no takeoff")
        }
        animations.append(Animation(skel: land.availableAnimations.first!, name: "takeoff"))
        
        guard let land = try? Entity.load(named: "sparrowIdleLookAround")else{
            fatalError("no IdleLookAround")
        }
        animations.append(Animation(skel: land.availableAnimations.first!.repeat(), name: "idleLookAround"))
        
    }
    
    func getAnimationByName(name:String)->AnimationResource{
        let anim = animations.filter{$0.name == name}
        return anim[0].skel
    }
}

struct Animation{
    let skel:AnimationResource
    let name:String
    
}

struct AnimationController{
    
    
}
