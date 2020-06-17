//
//  HomeController.swift
//  LoginPage
//
//  Created by Wesley on 6/14/20.
//  Copyright © 2020 Wesley. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController{
    //Mark - Properties
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.alpha = 0
        return label
    }()
    
    //MARK-INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUserAndConfigureView()
    }
    
    //MARK-SELECTORS
    @objc func handleSignOut(){
        let alertController = UIAlertController(title:nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: {(_) in self.signOut() }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK-HELPER
    
    func configureViewComponents(){
        view.backgroundColor = UIColor.mainBlue()
        navigationItem.title = "FireBase Login"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cloud"), style: .plain, target: self, action: #selector(handleSignOut))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        navigationController?.navigationBar.barTintColor = UIColor.mainBlue()
        
        view.addSubview(welcomeLabel)
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    //MARK-API
    func loadUserData(){
        print("1.1")
        guard let uid = Auth.auth().currentUser?.uid else {
            print("fail")
            return
        }
        print("\(uid)")
        Database.database().reference().child("user").child(uid).child("username").observeSingleEvent(of: .value)
            {(snapshot) in
            guard let username = snapshot.value as? String else {return}
            self.welcomeLabel.text = "Welcome ,\(username)"

            UIView.animate(withDuration: 0.5, animations: {
                self.welcomeLabel.alpha = 1
            })
        }
    }
    
    func signOut(){
        do {
            try
            Auth.auth().signOut()
            let navController = UINavigationController(rootViewController: LoginController())
            navController.navigationBar.barStyle = .black
            self.present(navController, animated:true, completion:nil)
        }
        catch let error {
            print("Failed to sign out with error:", error)
        }
    }
    
    
    func authenticateUserAndConfigureView(){
        if Auth.auth().currentUser == nil{
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: LoginController())
                navController.navigationBar.barStyle = .black
                self.present(navController, animated:true, completion:nil)
            }
        }
        else {
            print("1")
            configureViewComponents()
            print("2")
            loadUserData()
            print("3")
        }
    }
}
