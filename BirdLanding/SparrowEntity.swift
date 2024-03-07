//
//  SparrowEntity.swift
//  SparrowFly
//
//  Created by Peter Rogers on 28/06/2023.
//


import Foundation
import Combine
import RealityKit

final class SparrowEntity: Entity {
    var model: Entity?
    
    static var loadAsync: AnyPublisher<SparrowEntity, Error> {
        return Entity.loadAsync(named: "sparrow_Base")
            .map { loadedSparrow -> SparrowEntity in
                let sparrow = SparrowEntity()
                loadedSparrow.name = "Sparrow"
                sparrow.model = loadedSparrow
                return sparrow
            }
            .eraseToAnyPublisher()
    }
}
