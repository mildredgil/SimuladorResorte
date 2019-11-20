//
//  ViewControllerPreguntas.swift
//  SimuladorResorte
//
//  Created by Angel Figueroa Rivera on 11/3/19.
//  Copyright © 2019 Itesm. All rights reserved.
//

import UIKit

class ViewControllerPreguntas: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var lbPregunta: UILabel!
    @IBOutlet weak var tfRespuesta: UITextField!
    
    var tipoPreguntas : [String] = ["Periodo", "Posicion", "Frecuencia"]
    var respuestaCorrecta : Float!
    var isAnswCorrect : Bool!
    /*
    //Para preguntas del periodo:
    var per_masa : Float!
    var per_k : Float!
    var per_text : String = ""
    //Para preguntas de posicion:
    */
    //
    var tipoActual : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfRespuesta.returnKeyType = .send
        self.tfRespuesta.delegate = self
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        generePregunta()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        btnConfirmar(true)
        return true
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
    
    func generePregunta () -> Void {
        tfRespuesta.text = ""
        let indexTipo = genereTipo()
        let texto = genereTexto(tipo : tipoPreguntas[indexTipo])
        lbPregunta.text = texto
    }
    
    func genereTipo() -> Int {
        return Int.random(in: 0..<tipoPreguntas.count)
    }
    
    func genereTexto(tipo : String) -> String {
        var text = ""
        if(tipo == "Periodo") {
            let masa = Int.random(in: 1..<1001)
            let k = Int.random(in: 1..<33)
            
            text = "Dada una masa de \(masa) gramos y una constante k de \(k), calcula el periodo de un sistema armonico simple."
            respuestaCorrecta = calculaPeriodo(m: Float(masa),k: Float(k))
            
        } else if(tipo == "Posicion") {
            let masa = Int.random(in: 1..<1001)
            let k = Int.random(in: 1..<33)
            let tiempo = Int.random(in: 1..<21)
            
            text = "Dada una masa de \(masa) gramos y una constante k de \(k) durante un tiempo de \(tiempo) segundos, ¿Cuántos periodos habrán pasado después de ese tiempo?"
            respuestaCorrecta = Float(tiempo) / calculaPeriodo(m: Float(masa),k: Float(k))
            
        } else if(tipo == "Frecuencia") {
            let masa = Int.random(in: 1..<1001)
            let k = Int.random(in: 1..<33)
            
            text = "Dada una masa de \(masa) gramos y una constante k de \(k), calcula la frecuencia de un sistema armonico simple."
            respuestaCorrecta = 1.0 / calculaPeriodo(m: Float(masa),k: Float(k))
        }
        
        return text
    }
    
    func calculaPeriodo(m : Float, k: Float) -> Float {
        return 2 * Float.pi * sqrt((m/1000)/k)
    }
    
    @IBAction func btnConfirmar(_ sender: Any) {
        if let respuestaUsuario = Float(tfRespuesta.text!) {
            let min = respuestaCorrecta - respuestaCorrecta * 0.05
            let max = respuestaCorrecta + respuestaCorrecta * 0.05
            
            isAnswCorrect = min <= respuestaUsuario && max >= respuestaUsuario
            var message = "Incorrecta"
            if isAnswCorrect {
                message = "Correcta"
            }
            //agregar titulo y mensaje
            let alerta = UIAlertController(title: "RESPUESTA", message: message, preferredStyle: .alert)

            //agregar btn y action de cierre
            alerta.addAction(UIAlertAction(title:"OK", style: .cancel, handler: nil))
            
            alerta.addAction(UIAlertAction(title: "Nueva Pregunta", style: .default, handler: { (UIAlertAction) in
                self.generePregunta()
            }))
            
            //Desplegar la alerta
            present(alerta, animated: true,completion: nil)

        }
    }
    
    @IBAction func goHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
