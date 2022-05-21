//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Adi on 21.05.22.
//  Copyright © 2022. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet var playerName: UILabel!
    @IBOutlet var playerScore: UILabel!
    @IBOutlet var computerScore: UILabel!
    @IBOutlet var box1: UIImageView!
    @IBOutlet var box2: UIImageView!
    @IBOutlet var box3: UIImageView!
    @IBOutlet var box4: UIImageView!
    @IBOutlet var box5: UIImageView!
    @IBOutlet var box6: UIImageView!
    @IBOutlet var box7: UIImageView!
    @IBOutlet var box8: UIImageView!
    @IBOutlet var box9: UIImageView!
    var player: String!
    var lastValue = "o"
    var playerChoices: [Box] = []
    var computerChoices: [Box] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playerName.text = player+":"
        createTap(on: box1, type: .one)
        createTap(on: box2, type: .two)
        createTap(on: box3, type: .three)
        createTap(on: box4, type: .four)
        createTap(on: box5, type: .five)
        createTap(on: box6, type: .six)
        createTap(on: box7, type: .seven)
        createTap(on: box8, type: .eight)
        createTap(on: box9, type: .nine)
    }
    
    
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func createTap(on imageView: UIImageView, type box: Box){
        let tap = UITapGestureRecognizer(target: self, action: #selector(boxClicked(_:)))
        tap.name = box.rawValue
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    @objc func boxClicked(_ sender: UITapGestureRecognizer){
        let selectedBox = getBox(from: sender.name ?? "")
        makeChoice(selectedBox)
        playerChoices.append(Box(rawValue: sender.name!)!)
        didWin()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.computerMove()
        })
    }
    
    func computerMove(){
        var availableBoxes = [UIImageView]()
        var available = [Box]()
        for name in Box.allCases{
            let box = getBox(from: name.rawValue)
            if box.image == nil{
                availableBoxes.append(box)
                available.append(name)
            }
        }
        
        guard availableBoxes.count > 0 else {return}
        
        let randomIndex = Int.random(in: 0 ..< availableBoxes.count)
        makeChoice(availableBoxes[randomIndex])
        computerChoices.append(available[randomIndex])
        didWin()
    }
    
    func makeChoice(_ selectedBox:UIImageView){
        guard selectedBox.image == nil else{return}
        
        if lastValue == "x"{
            selectedBox.image = #imageLiteral(resourceName: "oh")
            lastValue = "o"
        }else{
            selectedBox.image = #imageLiteral(resourceName: "ex")
            lastValue = "x"
        }
        
        // Need to check if its the winning move
        
        // Need to check if there are any options left
    }
    
    func didWin(){
        var winnable = [[Box]]()
        let topRow: [Box] = [.one, .two, .three]
        let midRow: [Box] = [.four, .five, .six]
        let botRow: [Box] = [.seven, .eight, .nine]
        
        let leftCol: [Box] = [.one, .four, .seven]
        let midCol: [Box] = [.two, .five, .eight]
        let rightCol: [Box] = [.three, .six, .nine]
        
        let diagonal1: [Box] = [.one, .five, .nine]
        let diagonal2: [Box] = [.three, .five, .seven]
        
        winnable.append(topRow)
        winnable.append(midRow)
        winnable.append(botRow)
        winnable.append(leftCol)
        winnable.append(midCol)
        winnable.append(rightCol)
        winnable.append(diagonal1)
        winnable.append(diagonal2)
        
        for winner in winnable{
            let userWon = playerChoices.filter {winner.contains($0)}.count
            let computerWon = computerChoices.filter {winner.contains($0)}.count
            
            if userWon == winner.count{
                // user won
                playerScore.text = String((Int(playerScore.text ?? "0") ?? 0) + 1)
                resetGame()
                break
            } else if computerWon == winner.count{
                // comp won
                computerScore.text = String((Int(computerScore.text ?? "0") ?? 0) + 1)
                playerScore.text = String((Int(playerScore.text ?? "0") ?? 0) + 1)
                break
            } else if computerChoices.count + playerChoices.count == 9{
                // draw
                resetGame()
                break
            }
        }
    }
    
    func resetGame(){
        for name in Box.allCases{
            let box = getBox(from: name.rawValue)
            box.image = nil
        }
        
        lastValue = "o"
        playerChoices = []
        computerChoices = []
    }
    
    func getBox(from name: String)->UIImageView{
        let box = Box(rawValue: name) ?? .one
        switch box{
        case .one:
            return box1
        case .two:
            return box2
        case .three:
            return box3
        case .four:
            return box4
        case .five:
            return box5
        case .six:
            return box6
        case .seven:
            return box7
        case .eight:
            return box8
        case .nine:
            return box9
        }
    }
}


enum Box: String, CaseIterable{
    case one, two, three, four, five, six, seven, eight, nine
}
