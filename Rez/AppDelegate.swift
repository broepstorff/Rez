//
//  AppDelegate.swift
//  Rez
//
//  Created by Bradley Roepstorff on 10/17/16.
//  Copyright © 2016 Bradley Roepstorff. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named: "screen")
            //Icon by: http://www.flaticon.com/authors/situ-herrera
            //Direct link: http://www.flaticon.com/free-icon/screen_23283
            //TODO: add credit in the help/about page of the app
            //button.action = #selector(self.printQuote(sender:))
        }
        
        updateMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func updateMenu()
    {
        //good basic example: https://www.snip2code.com/Snippet/1361281/Change-your-Mac-s-screen-resolution-from
        //also decent and with sub-menus, but in ObjC: https://github.com/robbertkl/ResolutionMenu/blob/master/Resolution%20Menu/AppDelegate.m
        //the mystery deepens: http://lists.apple.com/archives/cocoa-dev/2014/May/msg00262.html and http://stackoverflow.com/questions/30859718/cgdisplaycopyalldisplaymodes-leaves-out-one-valid-mode
        
        
        var displayCount: UInt32 = 0;
        var result = CGGetActiveDisplayList(0, nil, &displayCount)
        if (result != CGError.success) {
            print("error: \(result)")
            return
        }
        let allocated = Int(displayCount)
        let activeDisplays = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: allocated)
        result = CGGetActiveDisplayList(displayCount, activeDisplays, &displayCount)
        if (result != CGError.success) {
            print("error: \(result)")
            return
        }
        print("\(displayCount) displays:")
        for i in 0..<displayCount {
            print("[\(i)] - \(activeDisplays[Int(i)])")
           
            let options: CFDictionary = [kCGDisplayShowDuplicateLowResolutionModes as String : kCFBooleanTrue] as CFDictionary
            
            guard let displayModes = CGDisplayCopyAllDisplayModes(activeDisplays[Int(i)], options) as [AnyObject]? else {
                print("ERROR: CGDisplayCopyAllDisplayModes returned nil")
                exit(2)
            }
            let numModes = displayModes.count //CFArrayGetCount(displayModes)
            for m in 0..<numModes {
                let mode = displayModes[m] as! CGDisplayMode
                if mode.isUsableForDesktopGUI() {
                    print("  width: \(mode.width), height: \(mode.height)")
                }
                
            }
        }
        activeDisplays.deallocate(capacity: allocated)
        
        
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Print Quote", action: #selector(self.printQuote(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Refresh List", action: #selector(updateMenu), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Rez", action: #selector(quit), keyEquivalent: ""))
        
        statusItem.menu = menu
        
        print("updateMenu()")
    }
    
    func printDisplays() {
        
    }

    func printQuote(sender: AnyObject) {
        let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
        let quoteAuthor = "Mark Twain"
        
        print("\(quoteText) - \(quoteAuthor)")
    
    }
    
    func quit() {
        NSApp.terminate(self)
    }

}

