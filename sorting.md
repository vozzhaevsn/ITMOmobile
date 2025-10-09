# Алгоритмы сортировки

Алгоритм — пошаговая инструкция.

## Quick Sort (быстрая сортировка)
Выбираем некоторый опорный элемент (например, средний). После этого разбиваем исходный массив на три части: элементы эквивалентные опорному, меньше, больше опорного.
Рекурсивно вызовемся от большей и меньшей частей. В итоге получим отсортированный массив, так как каждый элемент меньше опорного стоял раньше каждого большего опорного. 

import Foundation

```
func quickSort<T:Comparable>(_ list: [T]) -> [T] {
    // если в нашем массиве больше, чем один элемент, то имеет смысл его сортировать
    if list.count > 1 {
        
        //определяем опорный элемент - середина массива
        let pivot = list[0+(list.count - 0)/2]
        
        //создаём массив элементов меньших, чем опорный
        var less:[T] = []
        //создаём массив элементов эквивалентных опорному
        var equal:[T] = []
        //создаём массив элементов больших, чем опроный
        var greater:[T] = []
        
        //проходим по массиву и сортируем элементы по группам
        for element in list {
            if element < pivot {
                less.append(element)
            } else if element == pivot {
                equal.append(element)
            } else if element > pivot {
                greater.append(element)
            }
        }
        return quickSort(less) + equal + quickSort(greater)
    } else {
        return list
    }
}
```
## Сортировка вставками (Insertion Sort) в Swift

## Описание алгоритма

**Сортировка вставками** — это простой алгоритм сортировки, который строит отсортированный массив по одному элементу за раз. Он эффективен для небольших наборов данных и почти отсортированных массивов.

### Основная идея
Алгоритм делит массив на две части: отсортированную (слева) и неотсортированную (справа). На каждой итерации он берет первый элемент из неотсортированной части и вставляет его в правильную позицию в отсортированной части.

```
import UIKit

let array = [7, -5, 0, 1, 14, 98, -21, 11, 10]

func sort(items: [Int]) -> [Int] {
    guard items.count != 1 else { return array }
    
    var sortedArray = items
    
    for index in 1..<sortedArray.count {
        let number = sortedArray[index]
        
        var i = index
        
        while i > 0 && sortedArray[i - 1] > number {
            sortedArray[i] = sortedArray[i - 1]
            sortedArray[i - 1] = number
            
            i -= 1
        }
        
    }
    return sortedArray
}

let newArray = sort(items: array)
```
