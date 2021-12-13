//
//  LoginViewController.swift
//  unsplashFeedClone
//
//  Created by Nguyen Xuan Tho on 22/11/2021.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tappedAtLoginButton(_ sender: Any) {
//        let api = APIConnection(baseURL: "https://unsplash.com")
//        let service = AuthService(api)
//        service.authorize(self) { data, error in
//
//        }
        if let vc = storyboard?.instantiateViewController(withIdentifier: GalleryViewController.storyboardId) as? GalleryViewController {
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true, completion: nil)
        }
    }
    
}

extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}
