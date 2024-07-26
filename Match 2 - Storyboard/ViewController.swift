//
//  ViewController.swift
//  Match 2 - Storyboard
//
//  Created by Ruslan Yelguldinov on 09.07.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesArray.shuffle()
        
    }
    
    @IBOutlet weak var stepsLabel: UILabel!
    
    var imagesArray: [UIImage] = [ UIImage._1, UIImage._2, UIImage._3, UIImage._4, UIImage._5, UIImage._6, UIImage._7, UIImage._8, UIImage._1, UIImage._2, UIImage._3, UIImage._4, UIImage._5, UIImage._6, UIImage._7, UIImage._8 ]
    
    @IBOutlet var buttonsCollection: [UIButton]!
    var openedButtons: [UIButton] = []
    
    var timer = Timer()
    var steps = 0
    
    func stepsCounter() {
        steps += 1
        stepsLabel.text = "Steps: " + String(steps)
    }
    @objc func closeCards() {
        for button in openedButtons {
            button.setImage(nil, for: .normal)
        }
        openedButtons.removeAll()
        stepsCounter()
    }
    
    func checkSameCards() -> Bool {
        let tagA: Int = openedButtons[0].tag
        let tagB: Int = openedButtons[1].tag
        let imageA: UIImage = imagesArray[tagA - 1]
        let imageB: UIImage = imagesArray[tagB - 1]
        
        print("tagA:\(tagA) with Image:\(imageA) AND tagB:\(tagB) with Image:\(imageB)")
        
        if imageA == imageB {
            return true
        }
        return false
    }
    func checkGameCompletion() {
        let allButtonsDisabled = buttonsCollection.allSatisfy { button in
            button.isEnabled == false
        }
        
        if allButtonsDisabled {
            print("Игра завершена, все карточки открыты!")
            let alert = UIAlertController(title: "Game over", message: "You win! \n\nTotal steps - \(steps)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Play again", style: .default, handler: { UIAlertAction in
                print("Shuffle cards")
                self.restartTheGame()
            }))
            present(alert, animated: true)
        }
    }
    func restartTheGame() {
        imagesArray.shuffle()
        for button in buttonsCollection {
            button.isEnabled = true
            button.setImage(nil, for: .normal)
            button.backgroundColor = .lightGray
        }
        steps = -1
        stepsCounter()
    }
    @IBAction func btnTapped(_ sender: UIButton) {
        if openedButtons.contains(sender) || openedButtons.count == 2 {
            return
        }
        
        sender.setImage(imagesArray[sender.tag - 1], for: .normal)
        openedButtons.append(sender)
        
        if openedButtons.count == 2 {
            if checkSameCards() {
                print("MATCH TWO!")
                
                let sameBtn1 = openedButtons[0]
                let sameBtn2 = openedButtons[1]
                sameBtn1.isEnabled = false
                sameBtn2.isEnabled = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    sameBtn1.backgroundColor = .darkGray
                    sameBtn2.backgroundColor = .darkGray
                    self.openedButtons.removeAll()
                    self.stepsCounter()
                    self.checkGameCompletion()
                }
                return
            } else {
                print("Not matched")
            }
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(closeCards), userInfo: nil, repeats: false)
        }
        
    }
    
    
    
} // End of class

