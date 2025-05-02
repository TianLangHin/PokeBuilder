//
//  ItemCacheViewModel.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 1/5/2025.
//

import SwiftUI

// Serves as a ViewModel that loads all item descriptions once,
// allowing any view to conduct a search on all items without needing
// excessive API calls.
class ItemCacheViewModel: ObservableObject, Observable {
    @Published var itemList: [ItemApiData]

    let jsonDecoder = JSONDecoder()

    init() {
        self.itemList = []
        Task {
            do {
                let pagingUrl = URL(string: "https://pokeapi.co/api/v2/item/")!
                let pagingResponse = try? await URLSession.shared.data(from: pagingUrl)
                guard let (pagingData, _) = pagingResponse else {
                    return
                }
                guard let itemCount = try? jsonDecoder.decode(ItemCount.self, from: pagingData) else {
                    return
                }
                for itemIndex in 1...itemCount.count {
                    let itemUrl = URL(string: "https://pokeapi.co/api/v2/item/\(itemIndex)")!
                    let itemResponse = try? await URLSession.shared.data(from: itemUrl)
                    guard let (data, _) = itemResponse else {
                        continue
                    }
                    if let itemData = try? jsonDecoder.decode(ItemApiData.self, from: data) {
                        self.itemList.append(itemData)
                    }
                }
            }
        }
    }
}

private struct ItemCount: Codable {
    let count: Int
}
