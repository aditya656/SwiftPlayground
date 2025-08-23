//
//  ForYouPageGeometryReader.swift
//  Playground
//
//  Created by Aditya Patole on 19/08/25.
//



import SwiftUI

struct CardItem: Identifiable {
    let id: UUID
    let color: Color
}

struct ForYouPageGeometryReader: View {
    let cardsArray: [CardItem] = [
        CardItem(id: UUID(), color: Color(red: 0.95, green: 0.26, blue: 0.21)),
        CardItem(id: UUID(), color: Color(red: 0.96, green: 0.55, blue: 0.25)),
        CardItem(id: UUID(), color: Color(red: 0.98, green: 0.78, blue: 0.14)),
        CardItem(id: UUID(), color: Color(red: 0.79, green: 0.93, blue: 0.24)),
        CardItem(id: UUID(), color: Color(red: 0.43, green: 0.80, blue: 0.25)),
        CardItem(id: UUID(), color: Color(red: 0.22, green: 0.60, blue: 0.19)),
        CardItem(id: UUID(), color: Color(red: 0.20, green: 0.65, blue: 0.76)),
        CardItem(id: UUID(), color: Color(red: 0.13, green: 0.58, blue: 0.95)),
        CardItem(id: UUID(), color: Color(red: 0.33, green: 0.33, blue: 0.33)),
        CardItem(id: UUID(), color: Color(red: 0.50, green: 0.50, blue: 0.50)),
        CardItem(id: UUID(), color: Color(red: 0.70, green: 0.70, blue: 0.70)),
        CardItem(id: UUID(), color: Color(red: 0.90, green: 0.90, blue: 0.90)),
        CardItem(id: UUID(), color: Color(red: 0.93, green: 0.51, blue: 0.93)),
        CardItem(id: UUID(), color: Color(red: 0.85, green: 0.33, blue: 0.84)),
        CardItem(id: UUID(), color: Color(red: 0.58, green: 0.00, blue: 0.83)),
        CardItem(id: UUID(), color: Color(red: 0.32, green: 0.00, blue: 0.69)),
        CardItem(id: UUID(), color: Color(red: 0.93, green: 0.60, blue: 0.78)),
        CardItem(id: UUID(), color: Color(red: 0.99, green: 0.75, blue: 0.80)),
        CardItem(id: UUID(), color: Color(red: 0.99, green: 0.84, blue: 0.69)),
        CardItem(id: UUID(), color: Color(red: 0.93, green: 0.93, blue: 0.93)),
        CardItem(id: UUID(), color: Color(red: 0.80, green: 0.80, blue: 0.80)),
        CardItem(id: UUID(), color: Color(red: 0.69, green: 0.19, blue: 0.38)),
        CardItem(id: UUID(), color: Color(red: 0.47, green: 0.27, blue: 0.56)),
        CardItem(id: UUID(), color: Color(red: 0.22, green: 0.35, blue: 0.63)),
        CardItem(id: UUID(), color: Color(red: 0.07, green: 0.20, blue: 0.42)),
        CardItem(id: UUID(), color: Color(red: 0.34, green: 0.68, blue: 0.90)),
        CardItem(id: UUID(), color: Color(red: 0.20, green: 0.60, blue: 0.60)),
        CardItem(id: UUID(), color: Color(red: 0.00, green: 0.50, blue: 0.50)),
        CardItem(id: UUID(), color: Color(red: 0.56, green: 0.93, blue: 0.56)),
        CardItem(id: UUID(), color: Color(red: 0.00, green: 0.39, blue: 0.00)),
        CardItem(id: UUID(), color: Color(red: 0.93, green: 0.93, blue: 0.93)),
        CardItem(id: UUID(), color: Color(red: 0.98, green: 0.90, blue: 0.75)),
        CardItem(id: UUID(), color: Color(red: 0.80, green: 0.52, blue: 0.25)),
        CardItem(id: UUID(), color: Color(red: 0.61, green: 0.32, blue: 0.18)),
        CardItem(id: UUID(), color: Color(red: 0.65, green: 0.16, blue: 0.16)),
        CardItem(id: UUID(), color: Color(red: 0.71, green: 0.40, blue: 0.71)),
        CardItem(id: UUID(), color: Color(red: 0.60, green: 0.80, blue: 0.196)),
        CardItem(id: UUID(), color: Color(red: 0.40, green: 0.60, blue: 0.40)),
        CardItem(id: UUID(), color: Color(red: 0.40, green: 0.40, blue: 0.60)),
        CardItem(id: UUID(), color: Color(red: 0.50, green: 0.40, blue: 0.60)),
        CardItem(id: UUID(), color: Color(red: 0.60, green: 0.80, blue: 0.80)),
        CardItem(id: UUID(), color: Color(red: 0.30, green: 0.40, blue: 0.70)),
        CardItem(id: UUID(), color: Color(red: 0.70, green: 0.40, blue: 0.70)),
        CardItem(id: UUID(), color: Color(red: 0.80, green: 0.60, blue: 0.80)),
        CardItem(id: UUID(), color: Color(red: 0.90, green: 0.70, blue: 0.70)),
        CardItem(id: UUID(), color: Color(red: 0.75, green: 0.75, blue: 0.75)),
        CardItem(id: UUID(), color: Color(red: 0.50, green: 0.70, blue: 0.40)),
        CardItem(id: UUID(), color: Color(red: 0.40, green: 0.80, blue: 0.40)),
        CardItem(id: UUID(), color: Color(red: 0.20, green: 0.40, blue: 0.60)),
        CardItem(id: UUID(), color: Color(red: 0.60, green: 0.60, blue: 0.80)),
        CardItem(id: UUID(), color: Color(red: 0.50, green: 0.50, blue: 0.50)),
        CardItem(id: UUID(), color: Color(red: 0.25, green: 0.25, blue: 0.25)),
        CardItem(id: UUID(), color: Color(red: 0.35, green: 0.65, blue: 0.35)),
        CardItem(id: UUID(), color: Color(red: 0.45, green: 0.55, blue: 0.75)),
        CardItem(id: UUID(), color: Color(red: 0.55, green: 0.45, blue: 0.65)),
        CardItem(id: UUID(), color: Color(red: 0.65, green: 0.35, blue: 0.55)),
        CardItem(id: UUID(), color: Color(red: 0.75, green: 0.25, blue: 0.45)),
        CardItem(id: UUID(), color: Color(red: 0.85, green: 0.15, blue: 0.35)),
        CardItem(id: UUID(), color: Color(red: 0.95, green: 0.05, blue: 0.25)),
        CardItem(id: UUID(), color: Color(red: 0.05, green: 0.95, blue: 0.35)),
        CardItem(id: UUID(), color: Color(red: 0.15, green: 0.85, blue: 0.45)),
        CardItem(id: UUID(), color: Color(red: 0.25, green: 0.75, blue: 0.55)),
        CardItem(id: UUID(), color: Color(red: 0.35, green: 0.65, blue: 0.65)),
        CardItem(id: UUID(), color: Color(red: 0.45, green: 0.55, blue: 0.75)),
        CardItem(id: UUID(), color: Color(red: 0.55, green: 0.45, blue: 0.85)),
        CardItem(id: UUID(), color: Color(red: 0.65, green: 0.35, blue: 0.95)),
        CardItem(id: UUID(), color: Color(red: 0.75, green: 0.25, blue: 0.85))
    ]
    
    let columns: [GridItem] = [
        GridItem(spacing: 1),
        GridItem(spacing: 1),
        GridItem(spacing: 1)
    ]
    @Namespace private var profileAnimation
    
    @State var isCardScaledFullScreen: Bool = false
    @State var selectedCardIndex: Int?
    @State var selectedCard: CardItem = CardItem(id: UUID(), color: Color(red: 0.95, green: 0.26, blue: 0.21))
    @State var selectedCardID = UUID()
    @StateObject private var debouncer = Debouncer(delay: 0.3)
    @State var offset: CGSize = .zero
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 1) {
                    ForEach(Array(cardsArray.enumerated()), id: \.element.id) { index, cardItem in
                        GeometryReader { proxy in
                            Rectangle()
                                .fill(cardItem.color)
                                .frame(height: 250)
                                .matchedGeometryEffect(id: cardItem.id, in: profileAnimation)
                                .onTapGesture {
                                    debouncer.run {
                                        withAnimation(.spring) {
                                            isCardScaledFullScreen = true
                                            selectedCardID = cardItem.id
                                            selectedCard = cardItem
                                        }
                                    }
                                }
                        }
                        .frame(height: 250)
                    }
                }
            }
            .scrollDisabled(isCardScaledFullScreen)
            
            if isCardScaledFullScreen {
                ExpandedView(animationID: $selectedCardID, selectedCard: $selectedCard, profileAnimation: profileAnimation, isCardScaledFullScreen: $isCardScaledFullScreen, offset: $offset)
                    .offset(offset)
            }
        }
    }
}

struct ExpandedView: View {
    @Binding var animationID: UUID
    @Binding var selectedCard: CardItem
    var profileAnimation: Namespace.ID
    @Binding var isCardScaledFullScreen: Bool
    @Binding var offset: CGSize
    
    var body: some View {
        Rectangle()
            .fill(selectedCard.color)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        offset = value.translation
                    })
            )
            .matchedGeometryEffect(id: animationID, in: profileAnimation)
            .transition(.offset(y: 1))
            
            .onTapGesture {
//                withAnimation(.spring) {
                    isCardScaledFullScreen = false
//                }
            }
    }
}

#Preview {
    ForYouPageGeometryReader()
}
