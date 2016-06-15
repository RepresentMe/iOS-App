//
//  WebViewController.m
//  NewApp
//
//  Created by Fahad Naeem on 6/4/15.
//  Copyright (c) 2015 Fahad Naeem. All rights reserved.
//

#import "WebViewController.h"
#import "AFNetworking.h"
#import "Utils.h"


@interface WebViewController ()

@end

@implementation WebViewController
@synthesize url,responseData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.splahView.hidden = NO;
    [self SendGetRequest];
    
    // create thread
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(SendPost) userInfo:nil repeats:YES];
    
}


-(void)SendPost
{
    int threadCount = [[Utils sharedObject] readCount];
    
    NSString *jsString = @"localStorage.getItem('auth_token');";
    NSString *someKeyValue = [self.webView stringByEvaluatingJavaScriptFromString:jsString];
    curAuthToken = someKeyValue;
    
    if ([someKeyValue isEqualToString:@""]) {
        
        if(threadCount != 0){
            NSString * old_authToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
            if([curAuthToken isEqualToString:old_authToken]){
            }else{
                // call remove token
                [self removeToken];
                // update thread_count
                threadCount ++;
                [[Utils sharedObject] updateCount:threadCount];
            }
            
        }else{
            // first token
        }
        
    }else{
        if(threadCount != 0){
            // compair new token
            NSString * old_authToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
            if([curAuthToken isEqualToString:old_authToken]){
            }else{
                [self registerToken];
            }
        }else{
            // first token
            [self registerToken];
        }
        
        // update thread_count
        threadCount ++;
        [[Utils sharedObject] updateCount:threadCount];
        
    }

}

- (void) registerToken
{
    [[NSUserDefaults standardUserDefaults] setObject:curAuthToken forKey:@"auth_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    oldAuthToken = curAuthToken;
    [self SendingToken];
}

-(void)SendingToken
{
    callType = @"regDevice";
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstSuccessReg"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString * device_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"DevToken"];
    NSLog(@"%@", device_token);
    
    // NSString * URL = [NSString stringWithFormat:@"https://represent.me/api-push/device/apns/"];
    NSString * URL = [NSString stringWithFormat:@"https://represent.me/api-push/device/apns/"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]];
    
    NSString * name = [NSString stringWithFormat:@"%@%@%@", @"ios", @"_", device_token];
    NSString * auth_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
    NSString * authorization = [NSString stringWithFormat:@"%@%@%@", @"Token", @" ", auth_token];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"1", @"active",
                                 device_token, @"registration_id",
                                 name, @"name",
                                 nil];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:&error];
    
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];

}
-(void)removeToken
{
    callType = @"removeToken";
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"auth_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    NSString * device_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"DevToken"];
    NSLog(@"%@", device_token);
    
    NSString * URL = [NSString stringWithFormat:@"%@%@%@", @"https://represent.me/api-push/device/apns/", device_token, @"/"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]];
    
    NSString * authorization = [NSString stringWithFormat:@"%@%@%@", @"Token", @" ", oldAuthToken];
    NSDictionary *requestData = [[NSDictionary alloc] init];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:&error];
    
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"DELETE"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
}

-(void) stopTimer
{
    [timer invalidate];
    timer = nil;
}

-(void)SendGetRequest
{
    callType = @"SendingGetReq";
    NSString *enquiryurl = @"";
    enquiryurl = [NSString stringWithFormat:@"https://represent.me"];
    [self LoadWebsite:enquiryurl];
}



-(void)LoadWebsite :(NSString *)str
{
    
    self.webView.delegate=self;
    
    NSURL *nsurl=[NSURL URLWithString:str];
    
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    
    [self.webView loadRequest:nsrequest];
}



- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"loading website");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self HideVIew];
    
    

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

-(void)HideVIew
{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        self.splahView.alpha = 0.0;
    }
                     completion:^(BOOL finished)
     {
         self.splahView.hidden = YES;
     }
     ];

}


#pragma mark - URL connection delegate

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    responseData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if([callType isEqualToString:@"regDevice"])
    {
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@"Unable To Register Device"
                                message:nil
                                delegate:self
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil,nil];
        [myAlert show];
    }
    if([callType isEqualToString:@"removeToken"])
    {
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@"Unable To remove Device"
                                message:nil
                                delegate:self
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil,nil];
        [myAlert show];
    }
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if([callType isEqualToString:@"regDevice"])
    {
        NSError * error;
        
        NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        NSLog(@"%@",jsonDic);
        
        [[NSUserDefaults standardUserDefaults]setObject:[jsonDic objectForKey:@"registration_id"] forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    if([callType isEqualToString:@"removeToken"])
    {
        NSError * error;
        
        NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        NSLog(@"%@",jsonDic);
        
        
    }

}


@end
