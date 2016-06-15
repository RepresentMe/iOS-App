//
//  Utils.m
//  Represent
//
//  Created by sergei on 5/12/16.
//  Copyright © 2016 Fahad. All rights reserved.
//

#import "Utils.h"

@implementation Utils

-(id) init
{
    if((self = [super init]))
    {
        thread_count = 0;
    }
    
    return self;
}

+ (Utils *)sharedObject
{
    static Utils *objUtility = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objUtility = [[Utils alloc] init];
    });
    return objUtility;
}

- (int) readCount{
    return thread_count;
}
- (void) updateCount:(int) updateCount
{
    thread_count = updateCount;
}

@end
