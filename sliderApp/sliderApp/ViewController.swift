

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var informLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var startButton: UIButton!
    private var round: Int = 0
    private var score: Int = 0
    private var attempts: Int = 0
    private let maxAttempts = 5
    private var trueNumber: Int = 0
    private var gameStarted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupUI()
    }
    
    private func setupUI() {
        slider.minimumValue = 1
        slider.maximumValue = 100
        slider.value = 50
        informLabel.text = "Угадай число от 1 до 100"
        startButton.setTitle("Start", for: .normal)
    }
    @IBAction func startButtonTapped(_ sender: UIButton) {
        startNewGame()
    }
    private func startNewGame() {
        trueNumber = Int.random(in: 1...100)
        attempts = 0
        score = 0
        slider.value = 50
        gameStarted = true
        informLabel.text = "Угадай число от 1 до 100! Попытка: \(attempts + 1) из \(maxAttempts)"
        startButton.setTitle( "Next round", for: .normal)
    }
    
    @IBAction func sliderAction() {
        if !gameStarted {
            return
        }
        let userNumber = Int(slider.value)
        let countscore = abs(userNumber - trueNumber)
        if countscore <= 10 {
            score += 5
        } else if countscore <= 20 {
            score += 3
        } else {
            score += 1
        }
        attempts += 1
        
        if attempts < maxAttempts {
        informLabel.text = "Угадай число! Попытка: \(attempts) из \(maxAttempts)"
        }
        else {
            
            showAlert(title: "Game over", message: "Вы заработали \(score) очков\nЗагаданное число: \(trueNumber)")
        }
    }
        func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                self.gameStarted = false  // Сбрасываем статус игры
                self.informLabel.text = "Нажмите Start, чтобы начать игру"
                self.slider.value = 50
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
