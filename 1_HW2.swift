import UIKit

let myAge: Int = 24
let myAgeInTenYears: Int = myAge + 10
let daysInYear: Float = 365.25
let daysPassed: Float = Float(myAgeInTenYears) * daysInYear
print("Мой возраст " + String(myAge) + " лет. Через 10 лет, мне будет " + String(myAgeInTenYears) + " лет, с момента моего рождения пройдет " + String(daysPassed) + " дней.")
print("Мой возраст \(myAge) лет. Через 10 лет, мне будет \(myAgeInTenYears) лет, с момента моего рождения пройдет \(daysPassed) дней.")
