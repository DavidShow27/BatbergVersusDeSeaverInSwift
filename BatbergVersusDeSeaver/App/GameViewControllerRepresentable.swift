//
//  GameViewControllerRepresentable.swift
//  BatbergVersusDeSeaver
//
//  Created by DIEGO CHAVEZ on 4/23/26.
//

import SwiftUI

struct GameViewControllerRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> GameViewController {
        return GameViewController()
    }
    
    func updateUIViewController(_ uiViewController: GameViewController, context: Context) {}
}
