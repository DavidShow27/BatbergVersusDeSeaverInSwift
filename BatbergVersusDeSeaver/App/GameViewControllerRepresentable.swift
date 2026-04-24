//
//  GameViewControllerRepresentable.swift
//  BatbergVersusDeSeaver
//
//  Created by DIEGO CHAVEZ on 4/23/26.
//

import SwiftUI
import UIKit

struct GameViewControllerRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> GameViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        return storyboard.instantiateViewController(
            withIdentifier: "GameViewController"
        ) as! GameViewController
    }
    
    func updateUIViewController(
        _ uiViewController: GameViewController,
        context: Context
    ) {
    }
}
