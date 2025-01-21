//
//  iosUnitConverterApp.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 7/1/2025.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseCrashlytics

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Firebase - init
        FirebaseApp.configure()
        // Firebase - Crashlytics
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        // Firebase - Remote config
        RC.shared.initialize { result in
            print("RemoteConfig init succeed=\(result)")
        }
        // Admob
        AdmobManager.shared.initialize()
        return true
    }
}


@main
struct iosUnitConverterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modifier(VersionControlModifier())
        }
        .modelContainer(sharedModelContainer)
    }
}
