import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

final class AuthorizationViewModel: ObservableObject {
    
    func signUp(email: String, password: String, completion: @escaping (AlertError) -> Void) {
        
        guard checkValid(email: email) else {
            completion(.incorrectLogin)
            return
        }
        
        if password.count < 8 {
            completion(.incorrectPassword)
            return
        }
        
        isEmailUnique(email: email) { error in
            if error == .userNotFound {
                Auth.auth().createUser(withEmail: email, password: password) { _, error in
                    if error != nil {
                        print("Ошибка создания аккаунта: \(String(describing: error?.localizedDescription))")
                        completion(.accountNotCreated)
                        return
                    }
                    completion(AlertError.none)
                }
            } else {
                completion(error)
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (AlertError) -> Void) {
        isEmailUnique(email: email) { error in
            if error == .userAlreadyCreated {
                Auth.auth().signIn(withEmail: email, password: password) { _, error in
                    if let error {
                        print("Ошибка аутентификации: \(error.localizedDescription)")
                        completion(.authenticationNotCompleted)
                        return
                    }
                    completion(AlertError.none)
                }
            } else {
                completion(error)
            }
        }
    }

    func resetPassword(email: String) {
        guard !email.isEmpty else {
            print("Пожалуйста, введите email.")
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error {
               print(error.localizedDescription)
            } else {
                print("Письмо для сброса пароля отправлено на \(email).")
            }
        }
    }
    
    private func checkValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func isEmailUnique(email: String, completion: @escaping (AlertError) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
            if let error = error {
                completion(.emailCheckingNotCompleted)
                return
            }
            methods?.isEmpty ?? true ? completion (.userNotFound) : completion(.userAlreadyCreated)
        }
    }
    
    func signInWithGoogle() async -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
          fatalError("No client ID found in Firebase configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController else {
          return false
        }
        
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            let user = userAuthentication.user
            guard let idToken = user.idToken else { return false }
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)
            
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            return true
        }
        catch {
            print(error.localizedDescription)
            return false
        }
    }
}
