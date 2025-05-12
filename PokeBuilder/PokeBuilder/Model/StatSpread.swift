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

    // Programmatic method of retrieving a certain stat without more code duplication.
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

    // Programmatic method of modifying a certain stat without more code duplication.
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

    // For calculating the new stat total if a particular stat were to be changed
    // to the new value `increment`.
    func newTotal(change: Stat, increment: Int) -> Int {
        return currentTotal() - getStat(stat: change) + increment
    }
}

// This enum is to enable the programmatic editing of stats,
// alleviating any potential code duplication when
// having multiple View elements that each edit one stat.
enum Stat: Int {
    case hp = 0
    case atk = 1
    case def = 2
    case spa = 3
    case spd = 4
    case spe = 5
}
