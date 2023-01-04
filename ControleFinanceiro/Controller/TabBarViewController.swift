//
//  TabBarViewController.swift
//  ControleFinanceiro
//
//  Created by Alan on 27/11/22.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    @IBOutlet weak var tabBarLista: UITabBar!
    
    override func viewDidLoad() {
        
        tabBarLista.unselectedItemTintColor = UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 1)

        tabBarLista.items![0].title = "Home"
        tabBarLista.items![0].image = UIImage(systemName: "house.circle.fill")

        tabBarLista.items![1].title = "Historico"
        tabBarLista.items![1].image = UIImage(systemName: "clock.arrow.circlepath")

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = 95
        tabBar.frame.origin.y = view.frame.height - 95
    }
     

}
