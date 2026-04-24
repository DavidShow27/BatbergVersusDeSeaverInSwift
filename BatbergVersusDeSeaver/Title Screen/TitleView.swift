//
//  TitleView.swift
//  BatbergVersusDeSeaver
//
//  Created by DIEGO CHAVEZ on 4/21/26.
//

import SpriteKit
import SwiftUI

struct TitleView: View {
    @State var showGame = false
    var body: some View {
        
            ZStack {
                Color.orange.ignoresSafeArea()

                VStack {
                    Text("Batberg VS De Seaver")
                        .font(.custom("MortalKombat-Regular", size: 30))

                    Button {
                        showGame = true
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(width: 200, height: 50)
                                .foregroundColor(.black)

                            Text("START GAME")
                                .font(.custom("MortalKombat-Regular", size: 10))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showGame) {
                GameViewControllerRepresentable()
            }
        
    }
    init() {
        for familyName in UIFont.familyNames {
            print(familyName)
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print("--\(fontName)")
            }
        }
    }
}

#Preview {
    TitleView()
}
