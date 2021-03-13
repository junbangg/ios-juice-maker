//
//  JuiceMaker - JuiceMaker.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

// MARK: - JuiceMaker Type
class JuiceMaker {
  private var stock = Stock()
  
  func make(of orderedJuice: Juice) {
    do {
      let requiredFruitsForJuice = try requiredFruits(for: orderedJuice)
      let stockedFruitsForJuice = try stockedFruits(for: requiredFruitsForJuice)
      
      if hasEnoughIngredients(in: stockedFruitsForJuice) {
        comsumeStockedFruits(for: stockedFruitsForJuice)
        printOrderCompleted(for: orderedJuice)
      }
    } catch {
      handleErrorForMake(error)
    }
  }
  
  // MARK: - Component Methods for 'make(of:)'
  private func requiredFruits(for orderedJuice: Juice) throws -> [Fruit: Int] {
    var requiredFruits = [Fruit: Int]()
    let recipe = JuiceRecipe()
    
    for ingredient in try recipe.find(for: orderedJuice).ingredient {
      guard let fruit = ingredient.fruitName,
            let quantity = ingredient.quantity else {
        throw FruitError.invalidFruit
      }
      requiredFruits[fruit] = quantity
    }
    
    return requiredFruits
  }
  
  private func stockedFruits(for requiredFruits: [Fruit: Int]) throws -> [Fruit: Int] {
    var stockedFruits = [Fruit: Int]()
    
    for (fruit, requiredQuantity) in requiredFruits {
      let stockedQuantity = try stock.count(for: fruit)
      if stockedQuantity < requiredQuantity {
        print("\(fruit)의 재료가 \(requiredQuantity - stockedQuantity)개 부족합니다.")
        stockedFruits.removeAll()
        break
      } else {
        stockedFruits[fruit] = requiredQuantity
      }
    }
    
    return stockedFruits
  }
  
  private func hasEnoughIngredients(in stockedFruits: [Fruit: Int]) -> Bool {
    if stockedFruits.isEmpty {
      return false
    } else {
      return true
    }
  }
  
  private func comsumeStockedFruits(for requiredFruits: [Fruit: Int]) {
    for (fruit, quantity) in requiredFruits {
      stock.subtract(for: fruit, amount: quantity)
    }
  }
  
  private func printOrderCompleted(for orderedJuice: Juice) {
    print("\(orderedJuice.name)가 나왔습니다! 맛있게 드세요!")
  }
  
  private func handleErrorForMake(_ error: Error) {
    switch error {
    case FruitError.invalidFruit,
         JuiceError.invalidJuice,
         RecipeError.invalidRecipe:
      print(error)
    default:
      print("알 수 없는 에러입니다. \(error)")
    }
  }
}
