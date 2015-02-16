//
//  GameOverController.swift
//  MichiganHackersOneTap
//
//  Created by Spruce Bondera on 2/16/15.
//  Copyright (c) 2015 Spruce Bondera. All rights reserved.
//

import UIKit

class GameOverController: UIViewController {
    var scene: GameScene?
    var new_game: GameViewController?
    @IBOutlet var scoreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.new_game?.scene_init()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        scoreLabel.text = scoreLabel.text! + String(scene!.score)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
