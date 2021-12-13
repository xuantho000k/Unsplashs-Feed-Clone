//
//  AuthService.swift
//  unsplashFeedClone
//
//  Created by Nguyen Xuan Tho on 16/11/2021.
//

import Foundation
import AuthenticationServices

struct AuthRouter {
    static func getPath(sub: String) -> String {
        return "/oauth" + sub
    }
    
    struct Authorize: Readable {
        var path = getPath(sub: "/authorize")
    }
    
    struct Token: Creatable {
        var path = getPath(sub: "/token")
    }
}

class AuthService {
    
    var api: APIConnection
    var session: ASWebAuthenticationSession?
    
    init(_ api: APIConnection) {
        self.api = api
    }
    
    func authorize(_ provider: ASWebAuthenticationPresentationContextProviding,
                   completion: @escaping  Connection.Completion) {
        let p: Parameters = ["client_id": Constants.accessKey,
                             "redirect_uri": Constants.appUrl,
                             "response_type": "code",
                             "scope": "public+read_user+write_user+read_photos+write_photos+write_likes+write_followers+read_collections+write_collections"]
        
        let request = AuthRouter.Authorize().get(p).asURLRequest(api.baseURL)
        session = ASWebAuthenticationSession(url: request.url!, callbackURLScheme: "feedclone")
        { callbackURL, error in
            guard error == nil, let callbackURL = callbackURL else { return }
            
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            if let code = queryItems?.filter({ $0.name == "code" }).first?.value {
                debugPrint(code)
                
            }
        }
        session?.presentationContextProvider = provider
        session?.prefersEphemeralWebBrowserSession = true
        session?.start()
    }
    
    func getToken(completion: @escaping  Connection.Completion) {
        let p: Parameters = ["client_id": Constants.accessKey,
                             "client_secret": Constants.secretKey,
                             "redirect_uri": Constants.appUrl,
                             "grant_type": "authorization_code",
                             "code": ""]
        
        api.makeRequest(AuthRouter.Token().create(p), completion: completion)
    }
    
    deinit {
        debugPrint("deinit - AuthService")
    }
}
