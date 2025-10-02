Thursday, 2 October 2025

## 1. Характеристики

Тип Float в Swift представляет собой соответствующее стандарту для одинарной точности. Он является одним из двух основных типов для работы с дробными числами в Swift — второй тип, Double, обеспечивает двойную точность (64 бита)
Важные константы и свойства 

- Float.pi — математическая константа π.
- Float.infinity — положительная бесконечность.
- Float.nan — «не число» (quiet NaN).
- Float.signalingNaN — сигнализирующий NaN.
- Float.greatestFiniteMagnitude — наибольшее конечное значение.
- Float.leastNormalMagnitude и Float.leastNonzeroMagnitude — наименьшие положительные нормальное и ненулевое значения соответственно.
- Float.ulpOfOne — единица в последнем разряде для 1.0 (аналог FLT_EPSILON в C).
## 2. Преобразования
Float поддерживает множество способов преобразования: 

Из целых чисел (Int, BinaryInteger) — с округлением или строгой проверкой точности (init(exactly:)).

Из других типов с плавающей точкой (Double, Float16) — с потерей точности или без неё.

Из строк (String, Substring) — поддерживает десятичный, шестнадцатеричный форматы, а также специальные строки "inf", "nan" и др.

По битовому шаблону (init(bitPattern:)) или по компонентам (sign, exponent, significand).
## 3. Специальные свойства
- magnitude — абсолютное значение.
- ulp — единица в последнем разряде текущего значения.
- nextUp / nextDown — соседние представимые значения.
- sFinite, isNaN, isInfinite, isZero, isNormal, isSubnormal — проверки классификации.
- rounded(), round(_:) — округление по разным правилам.
- isTotallyOrdered(belowOrEqualTo:) — полное упорядочение, включая NaN и ±0.

## 4. Протокол

Float реализует множество протоколов, включая: 

- BinaryFloatingPoint — основной протокол для чисел с плавающей точкой.
- Codable, Hashable, CustomStringConvertible, LosslessStringConvertible, Strideable, SIMDScalar.
