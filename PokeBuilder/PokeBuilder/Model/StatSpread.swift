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
}
