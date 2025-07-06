import SwiftUI

@main
struct Wayfarer: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    var shader = ShaderLibrary.pixellate(.float(3))
                    try? await shader.compile(as: .layerEffect)
                    
                    shader = ShaderLibrary.crtEffect(
                        .float(Date.now.timeIntervalSinceNow),
                        .float2(CGSize.zero)
                    )
                    try? await shader.compile(as: .layerEffect)
                    
                    shader = ShaderLibrary.noise(.float(Date.now.timeIntervalSinceNow))
                    try? await shader.compile(as: .colorEffect)
                }
        }
    }
}
