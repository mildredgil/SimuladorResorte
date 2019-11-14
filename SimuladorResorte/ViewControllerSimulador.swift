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
    @IBOutlet weak var viewRule: UIView!
    @IBOutlet weak var viewSpring: UIView!
    
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
    var ancho : CGFloat = 0.95
    
    var lbNumbers : [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIPanGestureRecognizer(target: imgMass, action: #selector(onDragMass(_:)))
        //btn styles
        btnSelected = btnPause
        btnValues.layer.cornerRadius = 4
        btnPause.layer.cornerRadius = 4
        btnPlay.layer.cornerRadius = 4
        btnStop.layer.cornerRadius = 4
        btnReset.layer.cornerRadius = 4
        
        //set de spring figure
        let figura = dibujarResorte(graphWidth: separado,width: CGFloat(150))
        let springColor = UIColor.init(red: 1, green: 132.0 / 255, blue: 150.0 / 255, alpha: 1)
        
        shapeLayer.path = figura.cgPath
        shapeLayer.frame = CGRect(x: 1, y: 0, width: 150, height: 50)
        shapeLayer.strokeColor = springColor.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = CGFloat(ancho)
        
        viewSpring.layer.addSublayer(shapeLayer)
        
        //set mass position
        let whiteSpaceMass = Float(5.0)
        xi = Float(imgMass.frame.size.width)
        
        startingXCoord = imgMass.frame.origin.x - CGFloat(xi + whiteSpaceMass)
        updatePosicion()
        setRuleLines()
        print(xi)
    }
    
    func moverResorte(width : CGFloat) {
        let figura = dibujarResorte(graphWidth: separado,width: width)
        shapeLayer.path = figura.cgPath
        
        let springColor = UIColor.init(red: 1, green: 56.0 / 255, blue: 59.0 / 255, alpha: 1)
        shapeLayer.strokeColor = springColor.cgColor
        shapeLayer.setNeedsDisplay()
    }
    
    func dibujarResorte(graphWidth : CGFloat,width : CGFloat) -> UIBezierPath{
        let height = CGFloat(70.0)
        let amplitude: CGFloat = 0.2   // Amplitude of sine wave is 30% of view height
        let origin = CGPoint(x: 0, y: height * 0.50)

        let path = UIBezierPath()
        path.move(to: origin)

        for angle in stride(from: 0.0, through: 50 * 360.0, by: 5.0) {
            let x = origin.x + CGFloat(angle/360.0) * width * graphWidth
            let y = origin.y - CGFloat(sin(angle/180.0 * Double.pi)) * height * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
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

        moverResorte(width: CGFloat(movement))
        
        let newRect = CGRect(origin: CGPoint(x: CGFloat(movement), y: CGFloat(imgMass.frame.origin.y)), size: imgMass.frame.size)
        imgMass.frame = newRect
    }
    
    func resetPos() {
        elapsedTime = 0.0
        
        let newRect = CGRect(origin: CGPoint(x: CGFloat(startingXCoord), y: CGFloat(imgMass.frame.origin.y)), size: imgMass.frame.size)
        
        let figura = dibujarResorte(graphWidth: 0.02,width: CGFloat(150))
        
        imgMass.frame = newRect
        shapeLayer.path = figura.cgPath
        shapeLayer.lineWidth = CGFloat(0.95)
        
        updatePosicion()
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
        //change spring
        shapeLayer.lineWidth = CGFloat(ancho)
    }
    
    func setRuleLines() {
        let ruleWidth = UIScreen.main.bounds.width
        let lineHeight = CGFloat(20.0)
        let center = Int(ruleWidth / 2)
        let path = UIBezierPath()
        let y = CGFloat(0.0)
        
        //start drawing in the center to the right and left
        for pos in stride(from: 0, to: center, by: 5) {
            var lineH = lineHeight
            let xRight = CGFloat(center + pos)
            let xLeft = CGFloat(center - pos)
            
            if Int(pos) % 50 == 0 {
                lineH = 1.8 * lineHeight
                
                addRuleNumber(num : "\(pos / 10)", x : xRight, y : y + lineH)
                if(pos != 0) {
                    addRuleNumber(num : "-\(pos / 10)", x : xLeft, y : y + lineH)
                }
                
            } else if Int(pos) % 25 == 0 {
                lineH = 1.5 * lineHeight
            }
            
            path.move(to: CGPoint(x: xRight, y: y))
            path.addLine(to: CGPoint(x: xRight, y: y + lineH))
            
            path.move(to: CGPoint(x: xLeft, y: y))
            path.addLine(to: CGPoint(x: xLeft, y: y + lineH))
        }
        
        //draw layer
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.path = path.cgPath
        shapeLayer2.frame = CGRect(x: 1, y: 0, width: ruleWidth
            , height: 20)
        shapeLayer2.strokeColor = UIColor.black.cgColor
        shapeLayer2.fillColor = UIColor.white.cgColor
        shapeLayer2.lineWidth = CGFloat(ancho)
        viewRule.layer.addSublayer(shapeLayer2)
    }
    
    func addRuleNumber(num : String, x : CGFloat, y : CGFloat) {
        let lbl = UILabel(frame: CGRect(x: x, y: y, width: 23, height: 20))
        lbl.textAlignment = .center //For center alignment
        lbl.text = num
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.numberOfLines = 1
        
        lbl.sizeToFit()//If required
        
        //adjust position
        lbl.frame.origin.x = lbl.frame.origin.x - lbl.frame.size.width / 2
        
        viewRule.addSubview(lbl)
        lbNumbers.append(lbl)
    }
    @IBAction func onDragMass(_ sender: UIPanGestureRecognizer) {
        let translate : CGPoint = sender.translation(in: self.view)
        imgMass.center.x += translate.x
         
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
}
