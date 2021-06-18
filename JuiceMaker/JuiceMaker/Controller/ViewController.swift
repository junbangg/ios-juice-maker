//
//  JuiceMaker - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var strawberryStockLabel: UILabel!
    @IBOutlet weak var bananaStockLabel: UILabel!
    @IBOutlet weak var pineappleStockLabel: UILabel!
    @IBOutlet weak var kiwiStockLabel: UILabel!
    @IBOutlet weak var mangoStockLabel: UILabel!
    
    let juiceMaker = JuiceMaker.shared
    var successOrderAlert: UIAlertController?
    var outOfStockErrorAlert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStockLabels()
        successOrderAlert = createSuccessOrderAlert()
        outOfStockErrorAlert = createOutOfStockErrorAlert()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("hi")
        guard let vc = segue.destination.children.first as? ChangeStockViewController else {
            return
        }
        vc.delegate = self
    }
    
    func updateStockLabels() {
        do {
            strawberryStockLabel.text = try juiceMaker.returnStockString(of: .strawberry)
            bananaStockLabel.text = try juiceMaker.returnStockString(of: .banana)
            pineappleStockLabel.text = try juiceMaker.returnStockString(of: .pineapple)
            kiwiStockLabel.text = try juiceMaker.returnStockString(of: .kiwi)
            mangoStockLabel.text = try juiceMaker.returnStockString(of: .mango)
        } catch {
            return
        }
    }
    
    @IBAction func touchUpOrderButton(_ sender: UIButton) {
        guard let juiceName = sender.titleLabel?.text?.components(separatedBy: " ").first,
              let juice = Juice(rawValue: juiceName) else {
            return
        }
        do {
            try juiceMaker.orderJuice(name: juice)
            updateStockLabels()
            showSuccessOrderAlert(for: juiceName)
        } catch FruitStoreError.outOfStock {
            showOutOfStockErrorAlert()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension ViewController {
    func createSuccessOrderAlert() -> UIAlertController {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        let checkAction = UIAlertAction(title: "확인", style: .default, handler : nil )
        alert.addAction(checkAction)
        return alert
    }
    
    func createOutOfStockErrorAlert() -> UIAlertController {
        let alert = UIAlertController(title: "재료가 모자라요. 재고를 수정할까요?", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "예", style: .default, handler : { (action) in
            guard let controller = self.storyboard?.instantiateViewController(identifier: "controller") else { return }
            guard let view = controller.children.first as? ChangeStockViewController else { return }
            view.delegate = self
            self.present(controller, animated: true, completion: nil)
        })
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler : nil)
        alert.addAction(noAction)
        alert.addAction(yesAction)
        return alert
    }
    
    func showSuccessOrderAlert(for juiceName: String) {
        guard let alert = successOrderAlert else { return }
        alert.title = "\(juiceName) 쥬스 나왔습니다! 맛있게 드세요!"
        present(alert, animated: true, completion: nil)
    }
    
    func showOutOfStockErrorAlert() {
        guard let alert = outOfStockErrorAlert else { return }
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: StockDelegate {
    func stockDidChange(_ vc: UIViewController) {
        updateStockLabels()
    }
}
