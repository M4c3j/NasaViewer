//
//  MainMenuViewController.swift
//  NasaViewer
//
//  Created by Maciej Lipiec on 2023-04-03.
//

import UIKit
import SwiftUI

class APODMainMenuViewController: UIViewController {
    
    var contentView: UIHostingController<APODMainMenuSwiftUIView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView = UIHostingController(rootView: APODMainMenuSwiftUIView { buttonIndex, date  in
            switch buttonIndex {
            case 1:
                self.pushViewWithRandomArticles()
                break
            case 2:
                guard let date = date else {
                    self.pushViewFromSelectedDay(date: .now)
                    break
                }
                self.pushViewFromSelectedDay(date: date)
                // Handle button 2 tap
                break
            case 3:
                guard let date = date else {
                    self.pushViewFromSelectedDay(date: .now)
                    break
                }
                self.pushViewFromSelectedMonth(date: date)
                // Handle button 3 tap
                break
            default:
                break
            }
        })
        
        addChild(contentView)
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView.view)
        contentView.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            contentView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.view.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        self.checkforPermission()
    }
    
    private func pushViewWithRandomArticles() {
        self.navigationController?.pushViewController(APODTableViewController(randomArticles: 10), animated: true)
    }
    
    private func pushViewFromSelectedDay(date: Date) {
        self.navigationController?.pushViewController(APODTableViewController(articleFromDate: date), animated: true)
    }
    
    private func pushViewFromSelectedMonth(date: Date) {
        self.navigationController?.pushViewController(APODTableViewController(articlesFromSelectedMonth: date), animated: true)
    }
    
}










#if DEBUG
import SwiftUI
struct MainMenuViewController_Preview: PreviewProvider {
    static var previews: some View = Preview(for: APODMainMenuViewController())
}
#endif
