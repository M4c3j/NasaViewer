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
    var alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
    
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
        self.addCancelToButton()
    }
    
    private func pushViewWithRandomArticles() {
        do {
            self.navigationController?.pushViewController(try APODTableViewController(randomArticles: 10), animated: true)
        } catch {
            self.showError(String(describing: error))
        }
    }
    
    private func pushViewFromSelectedDay(date: Date) {
        do {
            self.navigationController?.pushViewController(try APODTableViewController(articleFromDate: date), animated: true)
        } catch {
            self.showError(String(describing: error))
        }

    }
    
    private func pushViewFromSelectedMonth(date: Date) {
        do {
            self.navigationController?.pushViewController(try APODTableViewController(articlesFromSelectedMonth: date), animated: true)
        } catch {
            self.showError(String(describing: error))
        }
    }
    
    private func addCancelToButton() {
        self.alert.addAction(UIAlertAction(title: "OK", style: .cancel))
    }
    
}

extension APODMainMenuViewController {
    
    private func showError(_ message: String) {
        self.alert.title = "Ups.."
        self.alert.message = message

        present(alert, animated: true)
    }
    
}








#if DEBUG
import SwiftUI
struct MainMenuViewController_Preview: PreviewProvider {
    static var previews: some View = Preview(for: APODMainMenuViewController())
}
#endif
