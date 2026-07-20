import SwiftUI

struct SettingsView: View {
    
    @AppStorage("appearance")
    var appearance: Appearance = .automatic
    
    @AppStorage("learningEnabled")
    var learningEnabled: Bool = true
    
    @AppStorage("cardBackgroundColor")
    var cardBackgroundColorInt: Int = 0xFF0000FF
    
    //@State var numberOfQuestions = 6
    @EnvironmentObject
    var challengesViewModel: ChallengesViewModel
    
    @State var cardBackgroundColor: Color = .red
    @State var dailyReminderTime = Date(timeIntervalSince1970: 0)
    
    @AppStorage("dailyReminderTime")
    var dailyReminderTimeShadow: Double = 0
    
    @AppStorage("dailyReminderEnabled")
    var dailyReminderEnabled = false
    
    var body: some View {
        List {
            Text("Settings")
                .font(.largeTitle)
                .padding(.bottom, 8)
            Section(header: Text("Appearance")){
                VStack(alignment: .leading) {
                    Picker("Pick", selection: $appearance) {
                        ForEach(Appearance.allCases) { appearance in
                            Text(appearance.name).tag(appearance)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    ColorPicker("Card Background Color", selection: $cardBackgroundColor)
                }
            }
            Section(header: Text("Game")){
                VStack(alignment: .leading) {
                    Stepper(
                        "Number of Questions: \(challengesViewModel.numberOfQuestions)",
                        value: $challengesViewModel.numberOfQuestions,
                        in: 3...20
                    )
                    Text("Any change will affect the next game")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                Toggle("Learning Enabled", isOn: $learningEnabled)
            }
            Section(header: Text("Notifications")){
                HStack {
                    Toggle("Daily Reminder", isOn: $dailyReminderEnabled)
                    DatePicker("", selection: $dailyReminderTime, displayedComponents: .hourAndMinute)
                        .disabled(dailyReminderEnabled == false)
                }
                .onChange(of: dailyReminderEnabled, perform: { _ in configureNotification() })
                .onChange(
                    of: dailyReminderTime,
                    perform: { newValue in
                        dailyReminderTimeShadow = newValue.timeIntervalSince1970
                        configureNotification()
                })
                .onChange(of: cardBackgroundColor, perform: { newValue in
                    cardBackgroundColorInt = newValue.asRgba
                })
                .onAppear {
                    dailyReminderTime = Date(timeIntervalSince1970: dailyReminderTimeShadow)
                    cardBackgroundColor = Color(rgba: cardBackgroundColorInt)
                }
            }
        }
    }
    
    func configureNotification() {
        if dailyReminderEnabled {
            LocalNotifications.shared.createReminder(time: dailyReminderTime)
        } else {
            LocalNotifications.shared.deleteReminder()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ChallengesViewModel())
}
