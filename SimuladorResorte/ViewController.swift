//
//  ViewController.swift
//  SimuladorResorte
//
//  Created by Angel Figueroa Rivera on 10/10/19.
//  Copyright © 2019 Itesm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imgSpring: UIImageView!
    var timer : Timer!
    var elapsedTime : Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(0.01), target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func onTimerFires() {
        elapsedTime += 0.01
        UIView.animate(withDuration: 0.7) {
            let width = self.imgSpring.frame.size.width
            let x = self.imgSpring.frame.origin.x
            
            let newWidth = (cos(self.elapsedTime)+Float(width))
            let newX = (Float(x) - cos(self.elapsedTime) / 2)
            let newRect = CGRect(origin: CGPoint(x : CGFloat(newX), y : self.imgSpring.frame.origin.y), size: CGSize(width: CGFloat(newWidth), height: self.imgSpring.frame.size.height))
            
            self.imgSpring.frame = newRect
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "simulador" {
            let viewS = segue.destination as! ViewControllerSimulador
            viewS.modalPresentationStyle = .fullScreen
        } else if segue.identifier == "preguntas" {
            let viewQuest = segue.destination as! ViewControllerPreguntas
            viewQuest.modalPresentationStyle = .fullScreen
        } 
    }

    override var shouldAutorotate: Bool {
        return false
    }

}

