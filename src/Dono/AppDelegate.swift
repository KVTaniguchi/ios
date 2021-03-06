// Dono iOS - Password Derivation Tool
// Copyright (C) 2016  Dono - Password Derivation Tool
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

import IQKeyboardManagerSwift
import PasscodeLock
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    lazy var passcodeLockPresenter: PasscodeLockPresenter = {
        self.initializePasscodeLockPresenter()
    }()
    
    func initializePasscodeLockPresenter() -> PasscodeLockPresenter
    {
        let configuration = PasscodeLockConfiguration()
        let presenter = PasscodeLockPresenter(mainWindow: self.window, configuration: configuration)
        
        return presenter
    }
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool
    {
        self.colorStatusBar(application)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(passcodeFail(_:)), name: PasscodeLockIncorrectPasscodeNotification, object: nil)
        
        return true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        self.passcodeLockPresenter.presentPasscodeLock()
      
        IQKeyboardManager.sharedManager().enable = true

        return true
    }
    
    func colorStatusBar(application: UIApplication)
    {
        self.setStatusBarBackgroundColor(DonoViewController.DarkPrimaryColor)
    }
    
    func applicationWillResignActive(application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        passcodeLockPresenter.presentPasscodeLock()
        
        self.window?.endEditing(true)
    }
    
    func applicationWillEnterForeground(application: UIApplication)
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.        
    }
    
    func applicationWillTerminate(application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func passcodeFail(notification: NSNotification)
    {
        self.destroySensitiveData()
        
        self.passcodeLockPresenter.dismissPasscodeLock()
        
        ((self.window?.rootViewController)! as UIViewController).showError("Passcode was entered wrong 3 times. Your Key and your Passcode Pin were deleted")
        
        self.passcodeLockPresenter = self.initializePasscodeLockPresenter()
    }
    
    private func setStatusBarBackgroundColor(color: UIColor)
    {
        guard  let statusBar = UIApplication.sharedApplication().valueForKey("statusBarWindow")?.valueForKey("statusBar") as? UIView else {
            return
        }
        
        statusBar.backgroundColor = color
    }

    private func destroySensitiveData()
    {
        PersistableKey().delete()
        PasscodeLockConfiguration().repository.deletePasscode()
    }
}

