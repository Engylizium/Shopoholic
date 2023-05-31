//
//  ContentView.swift
//  Shopoholic
//
//  Created by Соболев Пересвет on 5/24/23.
//

import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.leading)
            
            Text("Please sign in to continue.")
                .foregroundColor(.gray)
                .padding(.leading)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                RectangleTextFieldView(imageName: "envelope", placeholder: "Email", text: $email)
                RectangleTextFieldView(imageName: "lock.fill", placeholder: "Password", text: $password)
            }
            .padding()
            
            Button(action: {
                // Perform login logic here
            }) {
                HStack {
                    Spacer()
                    
                    Text("LOGIN")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.trailing, 40)
                        .padding(.leading, 20)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(30)
                        .padding(.horizontal)
                        .overlay(
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                                .offset(x: 40)
                        )
                }
            }
            
            Spacer()
            
            HStack {
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                
                Button(action: {
                    // Sign up button action
                }) {
                    Text("Sign up")
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            .frame(maxWidth: .infinity) // Align to center
        }
        .padding(.vertical, 20)
    }
}

struct RectangleTextFieldView: View {
    let imageName: String
    let placeholder: String
    @Binding var text: String
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(.white)
                        .modifier(FocusedShadowModifier(isFocused: isFocused))
 
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                            .padding(.top, 49)
                            .opacity(0.3)
                            .animation(.easeInOut(duration: 0.3), value: isFocused)
            
            HStack {
                Image(systemName: imageName)
                    .foregroundColor(.gray)
                    .padding(.leading)
                
                if imageName == "lock.fill" {
                    SecureField(placeholder, text: $text)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($isFocused)
                } else if imageName == "key.fill" {
                    SecureField(placeholder, text: $text)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($isFocused)
                }
                else {
                    TextField(placeholder, text: $text)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($isFocused)
                }
                
                if imageName == "lock.fill" {
                    Button(action: {
                        // Perform action for "Forgot" button
                    }) {
                        Text("FORGOT")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            .font(.footnote)
                            .padding(.trailing, 30)
                            .padding(.leading, 20)
                    }
                }
            }
        }
        .frame(height: 50)
        .onTapGesture {
            isFocused = true // Enable focus when tapped
        }
    }
}

struct FocusedShadowModifier: AnimatableModifier {
    var isFocused: Bool
    var shadowOpacity: Double // New property for controlling shadow opacity
    
    var animatableData: Double {
        get { isFocused ? 1 : 0 }
        set { isFocused = newValue > 0.5 }
    }
    
    init(isFocused: Bool) {
        self.isFocused = isFocused
        self.shadowOpacity = isFocused ? 1.0 : 0.0
    }
    
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.gray.opacity(shadowOpacity), radius: isFocused ? 5 : 0, x: 6, y: 6)
            .animation(.easeInOut(duration: 0.3), value: isFocused)
    }
}

struct SignUpFormView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    var showPasswordsDoNotMatch: Bool {
        return (password != confirmPassword || password.isEmpty && confirmPassword.isEmpty) && password.count == confirmPassword.count && !password.isEmpty && !confirmPassword.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.leading)
                .padding(.bottom, 20)
            
            RectangleTextFieldView(imageName: "person.fill", placeholder: "Full Name", text: $fullName)
            RectangleTextFieldView(imageName: "envelope", placeholder: "Email", text: $email)
            RectangleTextFieldView(imageName: "key.fill", placeholder: "Password", text: $password)
            RectangleTextFieldView(imageName: "key.fill", placeholder: "Confirm Password", text: $confirmPassword)
            
            if showPasswordsDoNotMatch {
                            Text("Passwords do not match")
                                .foregroundColor(.red)
                                .padding(.leading)
                        }
        }
        .padding()
        
        Button(action: {
                    // Perform sign-up logic here
                    if !showPasswordsDoNotMatch {
                        // Passwords match, proceed with sign-up
                    } else {
                        // Passwords do not match, display error or take appropriate action
                    }
                }) {
            HStack {
                Spacer()
                
                Text("SIGN UP")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .padding(.trailing, 40)
                    .padding(.leading, 20)
                    .background(
                                            Group {
                                                if !showPasswordsDoNotMatch {
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                    .eraseToAnyView()
                                                } else {
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color.gray.opacity(0.7), Color.gray]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                        .eraseToAnyView()
                                                }
                                            }
                                        )
                    .cornerRadius(30)
                    .padding(.horizontal)
                    .overlay(
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                            .offset(x: 40)
                    )
            }
        }
                .disabled(showPasswordsDoNotMatch)
        
        Spacer()
        
        HStack {
            Text("Already have an account?")
                .foregroundColor(.gray)
            
            Button(action: {
                // Sign up button action
            }) {
                Text("Sign in")
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
        .frame(maxWidth: .infinity)
    }
}

extension View {
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
}

struct SignUpView: View {
    var body: some View {
        VStack {
            SignUpFormView()
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
