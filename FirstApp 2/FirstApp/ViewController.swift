//
//  ViewController.swift
//  FirstApp
//
//  Created by Дмитрий Васильев on 31.10.2025.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var generalLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var clickButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    var counter: Int = 0
   
    let radius: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generalLabel.text = "Hello, world!"
        counterLabel.text = "0"
        counterLabel.textColor = .red
        clickButton.setTitle("Click me!", for: .normal)
        clickButton.layer.cornerRadius = radius
        counterLabel.accessibilityHint = "Всего кликов:\(counter)"
    }


    @IBAction func clickButton(_ sender: UIButton) {
        
        counter += 1
        counterLabel.text = "\(counter)"
        counterLabel.accessibilityHint = "Всего кликов:\(counter)"
        
        if counter >= 1{
                    clickButton.setTitle("Click", for: .normal)
                }
        
        if counter == 10{
            alert(title: "You win!", message: "Поздравляем, Вы достигли своей цели")
        }
    }

    @IBAction func stopButon(_ sender: UIButton) {
        counter = 0
        counterLabel.text = "0"
        clickButton.setTitle("Click me!", for: .normal)
        alert(title: "Stop", message: "Счетчик остановлен")
    }
    
    func alert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Окэу", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    
}

