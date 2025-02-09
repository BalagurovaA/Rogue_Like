//
//  GameViewController.swift
//  RogueLike
//
//  Created by Starfighter Dollie on 1/22/25.
//

import UIKit
import SpriteKit
import GameplayKit

extension SKNode {
    class func unarchiveFromFile(_ file: NSString) -> SKNode? {

        guard let path = Bundle.main.path(forResource: file as String, ofType: "sks") else {
            print("Failed to find the file.")
            return nil
        }

        do {
            let sceneData = try Data(contentsOf: URL(fileURLWithPath: path))
            print("Data loaded successfully")
            
            let archiver = try NSKeyedUnarchiver(forReadingFrom: sceneData)
            archiver.setClass(GameScene.self, forClassName: "SKScene")
            
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                scene.scaleMode = .aspectFill

                return scene
//                view.presentScene(scene)
            } else {
                print("Failed to decode scene")
                return nil
            }
            
        
        } catch {
            print("Error unarchiving the file: \(error)")
            return nil
        }
    }
}


class GameViewController: UIViewController {

    override func viewDidLoad() {
            super.viewDidLoad()
        
        
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene
      {
          let skView = self.view as! SKView
          skView.showsFPS = true
          skView.showsNodeCount = true
          skView.ignoresSiblingOrder = true
          scene.scaleMode = .aspectFill
          skView.presentScene(scene)
        
        } else{
        print("НЕ ПОЛУЧИЛОСЬ СОЗДАТЬ СЦЕНУ")
        }
        
        
        var newDungeon = Dungeon()
        generateDungeon(&newDungeon)
        
    }
    
    




    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    


}



