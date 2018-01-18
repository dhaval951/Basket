//
//  AppDelegate.swift
//  MasterProject
//
//  Created by Sanjay Shah on 02/08/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit
import Fabric
import CoreData
import TwitterKit
import Crashlytics
import CoreLocation
import FBSDKLoginKit
import UserNotifications
import IQKeyboardManagerSwift
import SlideMenuControllerSwift
import SwiftyJSON

//GCM COnfigure
import Firebase

// AppDelegate Shared Instance
var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var QuntiltyArrayList : [[String: Any]] = [[String : Any]]()
    var SelectedArray : [JSON] = [JSON]()

    //MARK: - Variables
    var window: UIWindow?
    var menuSelectedIndex = 0
    var IsItfirstTime = 0
    var IsStatus : Bool = false
    var IsRegister : Bool = false

    var menuVC: MenuVC!
    var slideMenuController: SlideMenuController!

    // For push notification handel this is required
    var mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var detailStoryboard = UIStoryboard(name: "Detail", bundle: nil)
    var loginVC: UIViewController!
    var homeVC: UIViewController!
    var packgesVC: UIViewController!

    var conatctUsVC: UIViewController!
    var lastOrderVC: UIViewController!

    var myProfileVC: UIViewController!
    var changePasswordVC: UIViewController!
    var ISfromPushEditProfile : String = ""


    //1. declare variable
    var locationManager: CLLocationManager!
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"
    var latitude = 0.0
    var longitude = 0.0
    var country = ""

    var city = ""
    var deviceToken = "123456"
    
    //MARK: - AppDelegate Default Methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        print("SDK version \(FBSDKSettings .sdkVersion())")

        
        // custom status bar
//        UIApplication.shared.statusBarStyle = .lightContent //or .default
//        UIApplication.shared.isStatusBarHidden = false
//        UIApplication.shared.statusBarStyle = .lightContent
//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        statusBar.backgroundColor = UIColor.gray
        
        //Fabric Initialize
        Fabric.with([Crashlytics.self])
        
        //Path for the CoreData file
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print("DATABASE PATH : \(paths[0])")

        //IQKeyboard Manager
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().toolbarTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        // You can specify your custom font
        // IQKeyboardManager.sharedManager().placeholderFont = UIFont(name: "Raleway-Medium", size: 14)
        
        //2. call this in appFlinish Launching
        initLocationManager()

        // Set RootViewController as per User LoggedIn or Not
        var navigationController: UINavigationController!
        menuVC = mainStoryboard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        
//        if UserDefaults.standard.object(forKey: "token") != nil {
////            _theUser = user
//
//            appDelegate.IsItfirstTime = appDelegate.IsItfirstTime + 1
//
//            let loginVC = detailStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//            navigationController = UINavigationController(rootViewController: loginVC)
//            
////            let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
////            navigationController = UINavigationController(rootViewController: loginVC)
//            
//            // Display Home Screen
//        }else{
//            
//            
////            let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
////            navigationController = UINavigationController(rootViewController: loginVC)
////            
//            
//            let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//            navigationController = UINavigationController(rootViewController: loginVC)
////             Display Login Screen
//        }

        let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "SplaseVC") as! SplaseVC
        navigationController = UINavigationController(rootViewController: loginVC)

        slideMenuController = SlideMenuController(mainViewController: navigationController, leftMenuViewController: menuVC)
        
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()

        // Register For Push Notification
        registerForRemoteNotification()
        
        // Facebook Login Setup
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        print(FBSDKSettings.sdkVersion())
        
        // Twitter Login Setup
       // Twitter.sharedInstance().start(withConsumerKey:"PnBekXJIjGoKMfEuQbi6B9E2c", consumerSecret:"v2x5tqYKt8K560PNlZOaXFhvdJ0JeUk2EfzV2y27gmYUNESOcj")
        
        
//        let gai = GAI.sharedInstance()
//        gai?.tracker(withTrackingId: "UA-104399447-1")
//        // Optional: automatically report uncaught exceptions.
//        gai?.trackUncaughtExceptions = true

        GAI.sharedInstance().tracker(withTrackingId: "UA-104399447-1")
        GAI.sharedInstance().defaultTracker.allowIDFACollection = true
        GAI.sharedInstance().defaultTracker.send(GAIDictionaryBuilder.createEvent(withCategory: "ui_action", action: "app_launched",label:"launch",value:nil).build() as! [AnyHashable : Any]!)

        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().dispatchInterval = 20
        GAI.sharedInstance().logger.logLevel = GAILogLevel.verbose
        GAI.sharedInstance().tracker(withTrackingId: "UA-104399447-1")

        // Optional: set Logger to VERBOSE for debug information.
        // Remove before app release.
//        gai.logger.logLevel = .verbose;
        
        //GCM COnfigure
       FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()

        //Defulat value set here
//        UserDefaults.standard.set(false, forKey: "Subscribed")
//        UserDefaults.standard.set(false, forKey: "IsSocial")

        // Override point for customization after application launch.
        return true
    }
    //MARK: - Register Remote Notification Monitor token generation
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
     //   self.saveContext()
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: Facebook Login
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    //MARK: Twitter Login
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        return Twitter.sharedInstance().application(app, open: url, options: options)
//    }

    //MARK: - Register Remote Notification Methods // <= iOS 9.x
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    //MARK: - Remote Notification Methods // <= iOS 9.x
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        self.deviceToken = deviceTokenString
        Messaging.messaging().apnsToken = deviceToken

    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo["aps"] as! [String: Any])
        self.writeToFile(data: "didReceiveRemoteNotification :\(userInfo["aps"] as! [String: Any])")
    }
    
    // MARK: - UNUserNotificationCenter Delegate // >= iOS 10
    //Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("User Info = ",notification.request.content.userInfo)

        self.writeToFile(data: "UNUserNotificationCenter  willPresent:\(notification.request.content.userInfo)")

        completionHandler([.alert, .badge, .sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        self.writeToFile(data: "UNUserNotificationCenter  didReceive response.notification.request.content.userInfo is : \(response.notification.request.content.userInfo as! [String: Any])")

        self.writeToFile(data: "UNUserNotificationCenter  didReceive gcm.notification.action_code is : \(response.notification.request.content.userInfo["gcm.notification.action_code"] as! String)")

//        print("User Info = ",response.notification.request.content.userInfo["aps"] as! [String: Any])

//        let userinfo = response.notification.request.content.userInfo["aps"] as! [String: Any]
//        self.writeToFile(data: "UNUserNotificationCenter  didReceive: \(userinfo)")


        if (response.notification.request.content.userInfo["gcm.notification.action_code"] as! String).contains("HOME") {
            //goto home
            let homevc = detailStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.homeVC = UINavigationController(rootViewController: homevc)
            self.slideMenuController.changeMainViewController(self.homeVC, close: true)
            
//            let destController = detailStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//            let topMostController = self.window?.topMostController() as! SlideMenuController
//            let navigationController = topMostController.mainViewController as! UINavigationController
//            navigationController.pushViewController(destController, animated: true)

//            let delayInSeconds = 1
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delayInSeconds), execute: {
//            })
            
        }
        else if (response.notification.request.content.userInfo["gcm.notification.action_code"] as! String).contains("PACKAGES") {
            //goto Package
            let packagesvc = detailStoryboard.instantiateViewController(withIdentifier: "PackagesVC") as! PackagesVC
            self.packgesVC = UINavigationController(rootViewController: packagesvc)
            self.slideMenuController.changeMainViewController(self.packgesVC, close: true)
        }
        else if (response.notification.request.content.userInfo["gcm.notification.action_code"] as! String).contains("PROFILE") {
            //goto PROFILE
            let myprofileVC = detailStoryboard.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
            self.myProfileVC = UINavigationController(rootViewController: myprofileVC)
            self.slideMenuController.changeMainViewController(self.myProfileVC, close: true)
        }
        else if (response.notification.request.content.userInfo["gcm.notification.action_code"] as! String).contains("ORDERS") {
            //goto ORDERS
            let lastorderVC = detailStoryboard.instantiateViewController(withIdentifier: "LastOrderVC") as! LastOrderVC
            self.lastOrderVC = UINavigationController(rootViewController: lastorderVC)
            self.slideMenuController.changeMainViewController(self.lastOrderVC, close: true)
        }
        else if (response.notification.request.content.userInfo["gcm.notification.action_code"] as! String).contains("EDIT_PROFILE") {
            //goto EDIT_PROFILE
            let myprofileVC = detailStoryboard.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
            self.ISfromPushEditProfile = "YES"
            self.myProfileVC = UINavigationController(rootViewController: myprofileVC)
            self.slideMenuController.changeMainViewController(self.myProfileVC, close: true)
        }
        else if (response.notification.request.content.userInfo["gcm.notification.action_code"] as! String).contains("ORDER_DETAIL") {
            //goto ORDERS
            let lastorderVC = detailStoryboard.instantiateViewController(withIdentifier: "LastOrderVC") as! LastOrderVC
            self.lastOrderVC = UINavigationController(rootViewController: lastorderVC)
            self.slideMenuController.changeMainViewController(self.lastOrderVC, close: true)
        }
        else if (response.notification.request.content.userInfo["gcm.notification.action_code"] as! String).contains("PACK_ACTIVATED") {
            //goto home
            let homevc = detailStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.homeVC = UINavigationController(rootViewController: homevc)
            self.slideMenuController.changeMainViewController(self.homeVC, close: true)
        }
        
        //
    }

    // MARK: - Core Data stack
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // iOS 9 and below
    lazy var applicationDocumentsDirectory: URL = {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "CoreData", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        
        if #available(iOS 10.0, *) {
            
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                
            } else {
                // iOS 9.0 and below - however you were previously handling it
                if managedObjectContext.hasChanges {
                    do {
                        try managedObjectContext.save()
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        let nserror = error as NSError
                        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                        abort()
                    }
                }
            }
        }
    }
}

//1. import CoreLocation

//import CoreLocation

//2. declare variable

//var locationManager: CLLocationManager!
//var seenError : Bool = false
//var locationFixAchieved : Bool = false
//var locationStatus : NSString = "Not Started"
//var latitude = 0.0
//var longitude = 0.0
//var country = ""

//3. call this in appFlinish Launching

//initLocationManager()

//4. allow flag in info.plist

//Privacy - Location When In Use Usage Description

extension AppDelegate : CLLocationManagerDelegate {
    
    //MARK: - Location Manager helper stuff
    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // Location Manager Delegate stuff
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        if (seenError == false) {
            seenError = true
            print(error, terminator: "")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate
            
            latitude = coord.latitude
            longitude = coord.longitude
            
            print(latitude)
            print(longitude)
            
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: latitude, longitude:longitude)
            
            geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
                guard let addressDict = placemarks?[0].addressDictionary else {
                    return
                }
                
                // Print each key-value pair in a new row
                addressDict.forEach { print($0) }
                
                if let ctry = addressDict["Country"] as? String {
                    print(ctry)
                    self.country = ctry
                }
                if let citystr = addressDict["City"] as? String {
                    print(citystr)
                    self.city = citystr
                }
                //city
                /*
 if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
 print(formattedAddress.joined(separator: ", "))
 }

 // Access each element manually
 if let locationName = addressDict["Name"] as? String {
 print(locationName)
 }
 if let street = addressDict["Thoroughfare"] as? String {
 print(street)
 }
 if let city = addressDict["City"] as? String {
 print(city)
 self.StrCityName = city
 }
 if let zip = addressDict["ZIP"] as? String {
 print(zip)
 }
 if let country = addressDict["Country"] as? String {
 print(country)
 }
 */
            })
        }
    }

    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        var shouldIAllow = false

        switch status
        {
        case CLAuthorizationStatus.restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.notDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LabelHasbeenUpdated"), object: nil)
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            locationManager.startUpdatingLocation()
        } else {
            NSLog("Denied access: \(locationStatus)")
        }
    }


    func writeToFile(data: String)
    {
        let file = "\(NSDate().timeIntervalSince1970).txt" //this is the file. we will write to and read from it

        let text = " \(NSDate().timeIntervalSince1970) = \(data)" //just a text

        if let dir : NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first as NSString? {
            let path = dir.appendingPathComponent(file);

            //writing
            do {
                try text.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {/* error handling here */}

            //            //reading
            //            do {
            //                let text2 = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            //
            //            }
            //            catch {/* error handling here */}
        }
    }

}
