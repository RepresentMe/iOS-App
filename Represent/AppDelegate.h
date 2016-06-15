//
//  AppDelegate.h
//  Represent
//
//  Created by Hassan on 8/8/15.
//  Copyright (c) 2015 Fahad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong) UINavigationController *nav;

@property (strong, nonatomic) NSMutableData *responseData;

@property (strong , nonatomic)WebViewController *main;
@end

