//
//  ViewControllerSimulador.swift
//  SimuladorResorte
//
//  Created by Angel Figueroa Rivera on 10/10/19.
//  Copyright © 2019 Itesm. All rights reserved.
//

import UIKit

class ViewControllerSimulador: UIViewController {
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnValues: UIButton!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var imgMass: UIImageView!
    @IBOutlet weak var viewSimulation: UIView!
    
    var btnSelected : UIButton!
    var mass : Int = 500
    var constantK : Int = 16
    var timer : Timer!
    var counter : Int = 0
    var timeSpeed : Float = 0.01
    var timeRatio : Float = 1.0
    var elapsedTime : Float = 0.0
    
    var xi : Float = 80.0 // Punto inicial
    var o : Float = 0.0 // Pi si esta compactado, 0 si esta estirado
    var startingXCoord : CGFloat!
    
    let shapeLayer = CAShapeLayer()
    var separado = CGFloat(0.02)
    var ancho = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSelected = btnPause
        btnValues.layer.cornerRadius = 4
        btnPause.layer.cornerRadius = 4
        btnPlay.layer.cornerRadius = 4
        btnStop.layer.cornerRadius = 4
        btnReset.layer.cornerRadius = 4
        
        let figura = dibujarResorte(graphWidth: separado)
        
        shapeLayer.path = figura.cgPath
        shapeLayer.frame = CGRect(x: 55, y: 28, width: 150, height: 300)
        viewSimulation.layer.addSublayer(shapeLayer)

        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = CGFloat(ancho)
        
        startingXCoord = imgMass.frame.origin.x
        xi = Float(imgMass.frame.size.width)
    }
    
    func dibujarResorte(graphWidth : CGFloat) -> UIBezierPath{
        let width = CGFloat(150.0)
        let height = CGFloat(300.0)
        let amplitude: CGFloat = 0.2   // Amplitude of sine wave is 30% of view height
        let origin = CGPoint(x: 0, y: height * 0.50)

        let path = UIBezierPath()
        path.move(to: origin)

        for angle in stride(from: 0.0, through: 50 * 360.0, by: 5.0) {
            let x = origin.x + CGFloat(angle/360.0) * width * graphWidth
            let y = origin.y - CGFloat(sin(angle/180.0 * Double.pi)) * height * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        UIColor.black.setStroke()
        path.stroke()
        return path
    }
    
    @IBAction func onPause(_ sender: UIButton) {
        if timer != nil {
            onBtnTap(sender)
            timer.invalidate()
            timer = nil
        }
    }
    
    @IBAction func onPlay(_ sender: UIButton) {
        onBtnTap(sender)
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeSpeed), target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        }
    }
    
    @objc func onTimerFires() {
        let min = Int(counter / 6000)
        let sec = Int(counter / 100 % 60)
        let mil = counter % 100
        var minStr = "\(min)"
        var secStr = "\(sec)"
        var milStr = "\(mil)"
        
        if min < 10 {
            minStr = "0\(min)"
        }
        
        if sec < 10 {
            secStr = "0\(sec)"
        }
        
        if mil < 10 {
            milStr = "0\(mil)"
        }
        
        lbTime.text = "\(minStr):\(secStr):\(milStr)"
        counter += 1
        updatePosicion()
    }
    
    @IBAction func onStop(_ sender: UIButton) {
        if timer != nil {
            onBtnTap(sender)
            timer.invalidate()
            timer = nil
            counter = 0
        }
    }
    
    @IBAction func onReset(_ sender: UIButton) {
        onBtnTap(sender)
        counter = 0
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        lbTime.text = "00:00:00"
        mass = 500
        constantK = 16
        resetPos()
        print(mass)
        print(constantK)
    }
    
    func onBtnTap(_ sender: UIButton) {
        resetBtn(btnSelected)
        
        sender.backgroundColor = UIColor.init(red: 1, green: 59/255, blue: 66/255, alpha: 1)
        sender.tintColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        btnSelected = sender
        }
    
    func resetBtn(_ sender : UIButton) {
        sender.backgroundColor = UIColor.init(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)
        sender.tintColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func updatePosicion() {
        elapsedTime += timeSpeed / timeRatio
        let posActual = getPosActual(xi: xi, k: Float(constantK), m: Float(mass)/1000, o: o, t: elapsedTime)
        let movement = Float(startingXCoord) + posActual
        let newRect = CGRect(origin: CGPoint(x: CGFloat(movement + 200), y: CGFloat(imgMass.frame.origin.y)), size: imgMass.frame.size)
        
        
        shapeLayer.frame = CGRect(x: Int(movement), y: 28, width: 150, height: 300)
        //shapeLayer.frame = CGRect(origin: CGPoint(x: CGFloat(movement), y: CGFloat(imgMass.frame.origin.y - 300)), size: CGSize(width: 150, height: 300))
        
        imgMass.frame = newRect
        
        
//        shapeLayer.removeFromSuperlayer()
//        shapeLayer.position = CGPoint(x: CGFloat(movement), y: CGFloat(imgMass.frame.origin.y - 153))
//        viewSimulation.layer.addSublayer(shapeLayer)
        
    }
    
    func resetPos() {
        elapsedTime = 0.0
        
        let movement = Float(startingXCoord)
        let newRect = CGRect(origin: CGPoint(x: CGFloat(movement), y: CGFloat(imgMass.frame.origin.y)), size: imgMass.frame.size)
        shapeLayer.frame = CGRect(x: 55, y: 28, width: 150, height: 300)
        
        imgMass.frame = newRect
    }
    
    func getPosActual( xi: Float, k: Float, m: Float, o: Float, t: Float) -> Float{
        return abs(xi) * cos(sqrt(k/m) * t + o)
    }
    
    @IBAction func switchChange(_ sender: UISwitch) {
        if sender.isOn {
            timeSpeed = 0.1
            timeRatio = 10.0
        } else {
            timeSpeed = 0.01
            timeRatio = 1.0
        }
        
        updateTimer(x : timeSpeed)
    }
    
    func updateTimer(x : Float) {
        if timer != nil {
            timer.invalidate()
            timer = nil
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(x), target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewValues = segue.destination as! ViewControllerValues
        viewValues.mass = mass
        viewValues.constantK = constantK
    }
    
    //UNWIND
    @IBAction func unwindSetValues(unwindSegue: UIStoryboardSegue) {
        
    }

}
