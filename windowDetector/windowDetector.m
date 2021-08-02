//
//  windowDetector.m
//  windowDetector
//
//  Created by Jon Lara Trigo on 28/04/2020.
//  Copyright © 2020 Jon Lara Trigo. All rights reserved.
//

#import "windowDetector.h"
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#define NSLog(FORMAT, ...) fprintf(stderr, "%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@implementation windowDetector

- (id) init
    {
    self = [super init];
           if (!self)
               return self;
    [[[NSWorkspace sharedWorkspace] notificationCenter]
     addObserver:self
     selector:@selector(getInfo:)
     name:NSWorkspaceDidActivateApplicationNotification
     object:nil];
        
    [[[NSWorkspace sharedWorkspace] notificationCenter]
     addObserver:self
     selector:@selector(getInfo:)
     name:NSWorkspaceDidTerminateApplicationNotification object:nil];

    return self;
    }

- (void) getInfo:(NSNotification *)d
    {
        NSRunningApplication *app = d.userInfo[NSWorkspaceApplicationKey];
        getInfoFromApp:app;
    }

- (void) getInfoFromApp:(NSRunningApplication*) app
    {
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [outputFormatter stringFromDate:now];

    NSLog(@"{\"name\": \"%@\", \"time\": \"%@\", \"bundleIdentifier\": \"%@\",\"launchDate\": \"%@\",\"PID\": \"%d\", \"isTerminated\": %hhd}", [app localizedName], dateString, [app bundleIdentifier], [app launchDate],[app processIdentifier], [app isTerminated]);
    }

int main(int argc, const char * argv[]) {
    @autoreleasepool
       {
           NSRunningApplication *app = [[NSWorkspace sharedWorkspace] frontmostApplication];
           [[windowDetector alloc] getInfoFromApp:app];
       };
       return 0;

}
@end
