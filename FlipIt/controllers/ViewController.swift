//
//  ViewController.swift
//  FlipIt
//
//  Created by theapache64 on 07/04/18.
//  Copyright © 2018 theapache64. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var vCardsHolder: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //Looping through cards
        for case let card as UIButton in vCardsHolder.subviews {
            card.addTarget(self,action: #selector(onCardClicked),for: .touchUpInside)
        }
    }
    
    @objc func onCardClicked(card: UIButton!){
        card.backgroundColor = .red
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

