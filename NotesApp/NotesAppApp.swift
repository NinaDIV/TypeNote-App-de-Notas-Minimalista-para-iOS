import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import AWSAPIPlugin

@main
struct NotesAppApp: App {
    @StateObject private var initializer = AppInitializer()

    var body: some Scene {
        WindowGroup {
            if let error = initializer.configurationError {
                VStack {
                    Text("⚠️ Error configurando Amplify:")
                        .font(.headline)
                    Text(error)
                        .font(.subheadline)
                        .padding()
                    Button("Reintentar") {
                        initializer.objectWillChange.send()
                        initializer.isAmplifyConfigured = false
                        initializer.configurationError = nil
                        initializer.configureAmplify()
                    }
                }
            } else if initializer.isAmplifyConfigured {
                ContentView()
            } else {
                VStack {
                    ProgressView()
                    Text("Configurando Amplify...")
                        .padding(.top)
                }
            }
        }
    }
}
                 
