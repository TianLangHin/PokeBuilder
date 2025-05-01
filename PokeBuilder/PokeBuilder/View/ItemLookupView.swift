//
//  ItemLookupView.swift
//  PokeBuilder
//
//  Created by Tian Lang Hin on 1/5/2025.
//

import SwiftUI

struct ItemLookupView: View {

    @ObservedObject var itemData: ItemCacheViewModel

    var body: some View {
        VStack {
            HStack {
                List(itemData.itemList) { item in
                    HStack {
                        AsyncImage(url: item.sprite)
                        Text("\(item.name)")
                        Spacer()
                        Text("\(item.effect)")
                    }
                }
            }
        }
    }
}

#Preview {
    ItemLookupView(
        itemData: ItemCacheViewModel()
    )
}
