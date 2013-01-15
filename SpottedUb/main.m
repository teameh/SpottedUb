//
//  main.m
//  SpottedUb
//
//  Created by Tieme van Veen on 1/9/13.
//  Copyright (c) 2013 Tieme van Veen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"nl", nil] forKey:@"AppleLanguages"];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
