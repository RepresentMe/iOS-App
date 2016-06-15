//
//  Utils.h
//  Represent
//
//  Created by sergei on 5/12/16.
//  Copyright © 2016 Fahad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
{
    int thread_count;
}

-(id) init;
+ (Utils *)sharedObject;

- (int) readCount;
- (void) updateCount:(int) updateCount;
@end
