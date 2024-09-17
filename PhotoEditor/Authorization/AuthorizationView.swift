import SwiftUI
import GoogleSignInSwift

struct AuthorizationView: View {
    
    @State private var loginText: String = ""
    @State private var passwordText: String = ""
    @State private var errorType: AlertError = .none
    @State private var isLoading: Bool = false
    @State private var isAlertPresented: Bool = false
    @State private var isRecoveryPasswordPresented: Bool = false
    @State private var isContentPresented: Bool = false
    @StateObject var viewModel: AuthorizationViewModel = AuthorizationViewModel()
    
    var body: some View {
        
        VStack {
            Text("Авторизация")
                .font(.system(size: 20))
                .bold()
            
            TextField("Логин", text: $loginText)
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)
            
            SecureField("Пароль", text: $passwordText)
                .textFieldStyle(.roundedBorder)
            
            HStack {
                Button {
                    isLoading = true
                    viewModel.signUp(email: loginText,
                                     password: passwordText) { error in
                        isLoading = false
                        if error == AlertError.none {
                            isContentPresented = true
                            return }
                        errorType = error
                        isAlertPresented = true
                    }
                } label: {
                    Text("Зарегистрироваться")
                }.customButtonModifier()
                
                Button {
                    isLoading = true
                    viewModel.signIn(email: loginText,
                                     password: passwordText) { error in
                        isLoading = false
                        if error == AlertError.none {
                            isContentPresented = true
                            return }
                        errorType = error
                        isAlertPresented = true
                    }
                } label: {
                    Text("Войти")
                }.customButtonModifier()
            }
            
            Button(action: {
                isRecoveryPasswordPresented = true
            }, label: {
                Text("Восстановить пароль")
            })
            
            GoogleSignInButton {
                Task {
                    let result = await viewModel.signInWithGoogle()
                    if result {
                        isContentPresented = true
                    }
                }
            }
            
            .overlay {
                if isLoading {
                    ProgressView().offset(CGSize(width: 0, height: -250.0))
                }
            }
            
        }
        .padding()
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text("Ошибка"),
                  message: Text(errorType.rawValue),
                  dismissButton: .default(Text("ОК")))
        }
        .sheet(isPresented: $isRecoveryPasswordPresented, content: {
            VStack {
                Text("Введите электронную почту для восстановления пароля")
                    .multilineTextAlignment(.center)
                
                TextField("Логин", text: $loginText)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(.roundedBorder)
                
                Button(action: {
                    viewModel.resetPassword(email: loginText)
                    isRecoveryPasswordPresented = false
                }, label: {
                    Text("Продолжить")
                        .customButtonModifier()
                })
            }
            .padding()
            
        })
        .fullScreenCover(isPresented: $isContentPresented, content: {
            EditorView()
                .environmentObject(ImageEditingViewModel())
        })
    }
    
}

#Preview {
    AuthorizationView()
}
