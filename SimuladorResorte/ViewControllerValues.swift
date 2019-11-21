//
//  ViewControllerValues.swift
//  SimuladorResorte
//
//  Created by Angel Figueroa Rivera on 10/10/19.
//  Copyright © 2019 Itesm. All rights reserved.
//

import UIKit

class ViewControllerValues: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var btnMass: UIButton!
    @IBOutlet weak var btnConstantK: UIButton!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var sliderVal: UISlider!
    @IBOutlet weak var btnSimular: UIButton!
    @IBOutlet weak var lbUnities: UILabel!
    @IBOutlet weak var lbMinRange: UILabel!
    @IBOutlet weak var lbMaxRange: UILabel!

    @IBOutlet weak var lbVariable: UILabel!

    var btnSelected : UIButton!
    var mass : Int = 0
    var constantK : Int = 0
    var multiplier : Float = 0
    var calculado : Float = 0.95
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        tfValue.returnKeyType = .send
        self.tfValue.delegate = self
        tfValue.text = "\(mass)"
        multiplier = 1000.0
        sliderVal.setValue(Float(mass) /  multiplier, animated: true)
        btnSelected = btnMass
        btnConstantK.layer.cornerRadius = 5
        btnMass.layer.cornerRadius = 5
        btnSimular.layer.cornerRadius = 5
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        btnSimular.sendActions(for: .touchUpInside)
        return true
    }
    
    @IBAction func slider(_ sender: UISlider) {
    //UISlider
        //slider value is from 0 - 1
        let sliderValue = Int(Float(sender.value) * multiplier)
        tfValue.text = "\(sliderValue)"
        
        if btnSelected == btnMass {
            mass = sliderValue
        } else {
            constantK = sliderValue
        }
    }
    
    @IBAction func tfEdit(_ sender: Any) {
        if let val = Float(tfValue.text!) {
            sliderVal.setValue(val / multiplier, animated: true)
            if btnSelected == btnMass {
                mass = Int(val)
            } else {
                constantK = Int(val)
            }
        }
    }
    
    @IBAction func onConstantK(_ sender: UIButton) {
        onBtnTap(sender)
    }
    
    @IBAction func onMass(_ sender: UIButton) {
        onBtnTap(sender)
    }
    
    func onBtnTap(_ sender: UIButton) {
        resetBtn(btnSelected)
        
        sender.backgroundColor = UIColor.init(red: 1, green: 208/255, blue: 190/255, alpha: 1)
        
        if sender == btnMass {
            sender.setImage(UIImage(named: "weight-black"), for: .normal)
            lbVariable.text = "Masa"
            lbUnities.text = "Gr"
            lbMinRange.text = "0 Kg"
            lbMaxRange.text = "1 Kg"
            tfValue.text = "\(mass)"
            multiplier = 1000
        } else {
            sender.tintColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
            lbVariable.text = "Constante K"
            lbUnities.text = "N/m"
            lbMinRange.text = "0 N/m"
            lbMaxRange.text = "32 N/m"
            tfValue.text = "\(constantK)"
            multiplier = 32
        }
        
        if let val = Float(tfValue.text!) {
            sliderVal.setValue(val / multiplier, animated: true)
        }
        
        btnSelected = sender
    }
    
    func resetBtn(_ sender : UIButton) {
        sender.backgroundColor = UIColor.init(red: 215/255, green: 173/255, blue: 159/255, alpha: 1)
        if sender == btnMass {
            sender.setImage(UIImage(named: "weight-white"), for: .normal)
        } else {
            sender.tintColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewSim = segue.destination as! ViewControllerSimulador
        viewSim.mass = mass
        viewSim.constantK = constantK
        viewSim.ancho = CGFloat(((Double(constantK)/32.0)*1.1) + 0.4)
    }
}
