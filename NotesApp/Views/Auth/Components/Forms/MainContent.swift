import SwiftUI

struct MainContent: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmationCode: String
    @Binding var isPasswordVisible: Bool
    let showConfirmation: Bool
    let errorMessage: String
    let isLoading: Bool
    let isFormValid: Bool
    let onSignIn: () -> Void
    let onSignUp: () -> Void
    let onConfirm: () -> Void
    let onBack: () -> Void

    // Nuevo estado para animación de entrada
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 32) {
            // Card contenedor
            VStack(spacing: 28) {
                // Mensaje de error
                if !errorMessage.isEmpty {
                    ErrorMessage(message: errorMessage)
                        .transition(.scale.combined(with: .opacity))
                }

                // Campos del formulario
                FormFields(
                    email: $email,
                    password: $password,
                    confirmationCode: $confirmationCode,
                    isPasswordVisible: $isPasswordVisible,
                    showConfirmation: showConfirmation
                )
                .animation(.easeInOut(duration: 0.3), value: showConfirmation)

                // Botones de acción
                ActionButtonsSection(
                    showConfirmation: showConfirmation,
                    isLoading: isLoading,
                    isFormValid: isFormValid,
                    confirmationCode: confirmationCode,
                    onSignIn: onSignIn,
                    onSignUp: onSignUp,
                    onConfirm: onConfirm,
                    onBack: onBack
                )
                .animation(.easeInOut(duration: 0.3), value: showConfirmation)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.04), radius: 20, x: 0, y: 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.primary.opacity(0.05), lineWidth: 1)
                    )
            )
            // Animación de entrada
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 40)
            .animation(.easeOut(duration: 0.4), value: appeared)
            .onAppear {
                appeared = true
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 40) {
            Text("Vista Normal")
                .font(.headline)

            MainContent(
                email: .constant("usuario@email.com"),
                password: .constant("password123"),
                confirmationCode: .constant(""),
                isPasswordVisible: .constant(false),
                showConfirmation: false,
                errorMessage: "",
                isLoading: false,
                isFormValid: true,
                onSignIn: { print("Sign In") },
                onSignUp: { print("Sign Up") },
                onConfirm: { print("Confirm") },
                onBack: { print("Back") }
            )

            Text("Vista con Error")
                .font(.headline)

            MainContent(
                email: .constant(""),
                password: .constant(""),
                confirmationCode: .constant(""),
                isPasswordVisible: .constant(false),
                showConfirmation: false,
                errorMessage: "Correo electrónico o contraseña incorrectos",
                isLoading: false,
                isFormValid: false,
                onSignIn: { print("Sign In") },
                onSignUp: { print("Sign Up") },
                onConfirm: { print("Confirm") },
                onBack: { print("Back") }
            )

            Text("Vista de Confirmación")
                .font(.headline)

            MainContent(
                email: .constant(""),
                password: .constant(""),
                confirmationCode: .constant("123456"),
                isPasswordVisible: .constant(false),
                showConfirmation: true,
                errorMessage: "",
                isLoading: false,
                isFormValid: true,
                onSignIn: { print("Sign In") },
                onSignUp: { print("Sign Up") },
                onConfirm: { print("Confirm") },
                onBack: { print("Back") }
            )
        }
        .padding()
    }
}
