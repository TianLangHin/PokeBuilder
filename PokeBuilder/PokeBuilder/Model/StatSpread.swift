//
//  StatSpread.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 5/5/2025.
//

// A separate `StatSpread` struct makes the declaration of EVs
// in each Pokemon as succinct in the code as possible.
struct StatSpread {
    
    // Domain-specific logic: Each Pokémon can be allocated maximum 510 EVs.
    static let maximumAllocation = 510
    
    var hitPoints: Int = 0
    var attack: Int = 0
    var defense: Int = 0
    var specialAttack: Int = 0
    var specialDefense: Int = 0
    var speed: Int = 0
    
    func currentTotal() -> Int {
        let firstThree = self.hitPoints + self.attack + self.defense
        let lastThree = self.specialAttack + self.specialDefense + self.speed
        return firstThree + lastThree
    }
    
    func newTotal(change: Stat, increment: Int) -> Int {
        let total = currentTotal()
        switch change {
        case .hp:
            return total - self.hitPoints + increment
        case .atk:
            return total - self.attack + increment
        case .def:
            return total - self.defense + increment
        case .spa:
            return total - self.specialAttack + increment
        case .spd:
            return total - self.specialDefense + increment
        case .spe:
            return total - self.speed + increment
        }
    }
    
    func getStat(stat: Stat) -> Int {
        switch stat {
        case .hp:
            return self.hitPoints
        case .atk:
            return self.attack
        case .def:
            return self.defense
        case .spa:
            return self.specialAttack
        case .spd:
            return self.specialDefense
        case .spe:
            return self.speed
        }
    }
    
    mutating func setStat(stat: Stat, value: Int) {
        switch stat {
        case .hp:
            self.hitPoints = value
        case .atk:
            self.attack = value
        case .def:
            self.defense = value
        case .spa:
            self.specialAttack = value
        case .spd:
            self.specialDefense = value
        case .spe:
            self.speed = value
        }
    }   
}

enum Stat {
    case hp
    case atk
    case def
    case spa
    case spd
    case spe
}
