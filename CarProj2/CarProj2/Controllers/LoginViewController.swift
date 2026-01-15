//
//  LoginViewController.swift
//  CarProj2
//
//  Created by vozzh on 14.01.2026.
//
import UIKit

// MARK: - Login View Controller
/// Контроллер экрана авторизации
class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var forgetLoginButton: UIButton!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!

    // MARK: - Properties

 
    private var savedUser: User? {
        User.load()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearTextFields()
    }

    // MARK: - Setup

    private func setupBackground() {
        view.backgroundColor = .white
        // Если нужно, можно добавить фоновую картинку
        // let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        // backgroundImage.image = UIImage(named: "back")
        // backgroundImage.contentMode = .scaleAspectFill
        // view.insertSubview(backgroundImage, at: 0)
    }

    private func clearTextFields() {
        loginTextField.text = ""
        passwordTextField.text = ""
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nameToShow = savedUser?.login ?? (loginTextField.text ?? "")

        if let navController = segue.destination as? UINavigationController,
           let carsVC = navController.topViewController as? CarsViewController {
            carsVC.userName = nameToShow
        } else if let carsVC = segue.destination as? CarsViewController {
            carsVC.userName = nameToShow
        }
    }

    /// Простая регистрация + вход
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let login = loginTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        // Проверяем, что поля не пустые
        guard !login.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(title: "Ошибка", message: "Введите логин и пароль")
            return false
        }

        // Если пользователь уже сохранён — проверяем логин/пароль
        if let user = savedUser {
            guard user.login == login, user.password == password else {
                showAlert(title: "Ошибка", message: "Неверный логин или пароль") {
                    self.passwordTextField.text = ""
                }
                return false
            }
            return true
        } else {
            // Если пользователя ещё нет — регистрируем нового
            let newUser = User(
                id: UUID().uuidString,
                login: login,
                password: password
            )
            newUser.save()
            return true
        }
    }

    // MARK: - Touch Handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    // MARK: - IBActions
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        let login = loginTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        guard !login.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(title: "Ошибка", message: "Введите логин и пароль для регистрации")
            return
        }

        let newUser = User(
            id: UUID().uuidString,
            login: login,
            password: password
        )
        newUser.save()

        showAlert(title: "Готово", message: "Регистрация успешно выполнена")
    }
    @IBAction func loginButtonForgetTapped() {
        guard let user = savedUser else {
            showAlert(title: "Подсказка", message: "Пользователь ещё не зарегистрирован")
            return
        }
        showAlert(title: "Ваш логин", message: "Логин: \(user.login)")
    }

    @IBAction func passwordForgetButtonTapped() {
        guard let user = savedUser else {
            showAlert(title: "Подсказка", message: "Пользователь ещё не зарегистрирован")
            return
        }
        showAlert(title: "Ваш пароль", message: "Пароль: \(user.password)")
    }

    // MARK: - Helper Methods

    private func showAlert(title: String,
                           message: String,
                           completion: (() -> Void)? = nil) {

        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "Ок", style: .default) { _ in
                completion?()
            }
        )
        present(alert, animated: true)
    }
}

