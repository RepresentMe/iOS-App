//
//  WebViewController.h
//  NewApp
//
//  Created by Fahad Naeem on 6/4/15.
//  Copyright (c) 2015 Fahad Naeem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>
{
    NSString * callType;
    NSTimer * timer;
    NSString * curAuthToken;
    NSString * oldAuthToken;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) NSString * url;

@property (weak, nonatomic) IBOutlet UIView *splahView;

@property (strong, nonatomic) NSMutableData *responseData;


-(void)SendPost;
-(void)LoadWebsite :(NSString *)str;

@end
