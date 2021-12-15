//
//  AppDelegate.swift
//  Mindful
//
//  Created by Rafaela Peralva on 11/5/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

      self.managedObjectContext = managedObjectContext
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)

  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.

  }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "Mindful")
      container.loadPersistentStores {_, error in
        if let error = error as NSError? {
          fatalError("Could not load data store: \(error)")
        }
      }
      return container
    }()
    
    lazy var managedObjectContext = persistentContainer.viewContext
    
    // MARK: - Core Data Saving support
    func saveContext() {
      let context = persistentContainer.viewContext
      if context.hasChanges {
        do {
          try context.save()
        } catch {
          let nserror = error as NSError
          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
      }
    }
}


