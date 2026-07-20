import SwiftUI

@main
struct KuchiApp: App {
  let userManager = UserManager()
  let challengesViewModel = ChallengesViewModel()
    
    @AppStorage("appearance")
    var appearance: Appearance = .automatic
  
  init() {
    userManager.load()
  }
  
  var body: some Scene {
    WindowGroup {
      StarterView()
        .environmentObject(userManager)
        .environmentObject(challengesViewModel)
        .preferredColorScheme(appearance.getColorScheme())
    }
  }
}

struct KuchiApp_Previews: PreviewProvider {
  static let userManager = UserManager(name: "Ray")
  static var previews: some View {
    StarterView()
      .environmentObject(userManager)
  }
}
