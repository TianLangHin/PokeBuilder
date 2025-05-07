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

    func newTotal(change: StatChange) -> Int {
        let total = currentTotal()
        switch change {
        case let .hp(increment):
            return total - self.hitPoints + increment
        case let .atk(increment):
            return total - self.attack + increment
        case let .def(increment):
            return total - self.defense + increment
        case let .spa(increment):
            return total - self.specialAttack + increment
        case let .spd(increment):
            return total - self.specialDefense + increment
        case let .spe(increment):
            return total - self.speed + increment
        }
    }
}

enum StatChange {
    case hp(Int)
    case atk(Int)
    case def(Int)
    case spa(Int)
    case spd(Int)
    case spe(Int)
}
