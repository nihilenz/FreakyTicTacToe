//
//  main.m
//  FreakyTicTacToeExample
//
//  Created by Enrico Angelini on 22/04/2020.
//  Copyright © 2020 Spirales di Enrico Angelini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
