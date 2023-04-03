//
//  MainMenuViewController.swift
//  NasaViewer
//
//  Created by Maciej Lipiec on 2023-04-03.
//

import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let button1 = UIButton()
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.setTitle("Button 1", for: .normal)
        button1.backgroundColor = .red
        view.addSubview(button1)
        
        let button2 = UIButton()
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.setTitle("Button 2", for: .normal)
        button2.backgroundColor = .blue
        view.addSubview(button2)
        
        let button3 = UIButton()
        button3.translatesAutoresizingMaskIntoConstraints = false
        button3.setTitle("Button 3", for: .normal)
        button3.backgroundColor = .green
        view.addSubview(button3)
        
        NSLayoutConstraint.activate([
            button1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button1.widthAnchor.constraint(equalTo: button2.widthAnchor),
            button2.widthAnchor.constraint(equalTo: button3.widthAnchor),
            button1.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            button2.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button3.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 60)
        ])
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

#if DEBUG
import SwiftUI
struct MainMenuViewController_Preview: PreviewProvider {
    static var previews: some View = Preview(for: MainMenuViewController())
}
#endif
