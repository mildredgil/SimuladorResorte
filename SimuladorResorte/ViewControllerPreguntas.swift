//
//  ViewControllerPreguntas.swift
//  SimuladorResorte
//
//  Created by Angel Figueroa Rivera on 11/3/19.
//  Copyright © 2019 Itesm. All rights reserved.
//

import UIKit

class ViewControllerPreguntas: UIViewController {
    @IBOutlet weak var lbPregunta: UILabel!
    @IBOutlet weak var tfRespuesta: UITextField!
    @IBOutlet weak var lbError: UILabel!
    
    var tipoPreguntas : [String] = ["Periodo", "Posicion"]
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
        lbError.isHidden = true;
        generePregunta()
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
    
    @IBAction func cambioTF(_ sender: UITextField) {
        lbError.isHidden = true;
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
            
            text = "Dada una masa de \(masa) gramos y una constante k de \(k) durante un tiempo de \(tiempo) segundos, calcula el periodo de un sistema armonico simple."
            respuestaCorrecta = calculaPeriodo(m: Float(masa),k: Float(k))
            
        }
        
        return text
    }
    
    func calculaPeriodo(m : Float, k: Float) -> Float {
        return 2 * Float.pi * sqrt(m/k)
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

        } else {
            lbError.isHidden = false;
        }
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
