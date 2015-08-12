//
//  CCPAppDelegate.m
//  CCPVoipDemo
//
//  Created by Sea on 15/8/12.
//  Copyright (c) 2015年 hisun. All rights reserved.
//

#import "CCPAppDelegate.h"
#import "ModelEngineVoip.h"
#import "VoipIncomingViewController.h"


@implementation CCPAppDelegate

@synthesize modeEngineVoip;


+ (instancetype)sharedInstance;
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}


- (void)dealloc
{
    self.modeEngineVoip = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addressbookChanged" object:nil];
    [super dealloc];
}


- (BOOL)applicationDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
{
    //初始化Voip SDK接口，分配资源
    self.modeEngineVoip = [ModelEngineVoip getInstance];
    
    //[self redirectConsoleLogToDocumentFolder];//日志重定向，开启的话，会把nslog输出到文件
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addressbookChangeCallback:)
                                                 name:@"addressbookChanged"
                                               object:nil];
    
    return YES;
}


- (void)applicationDidEnterBackground;
{
    contactOptState = -1;//通讯录如果改变则重新建立拼音索引
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}




- (void)applicationWillResignActive;
{
    [self.modeEngineVoip stopUdpTest];
    [self.modeEngineVoip stopCurRecording];
    self.modeEngineVoip.appIsActive = NO;
    // Sent when the application is about to move ·from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationWillEnterForeground;
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive;
{
    self.modeEngineVoip.appIsActive = YES;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate;
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveLocalNotification:(UILocalNotification *)notification;
{
    NSString *callID = [notification.userInfo objectForKey:KEY_CALLID];
    NSString *type = [notification.userInfo objectForKey:KEY_TYPE];
    NSString *call = [notification.userInfo objectForKey:KEY_CALL_TYPE];
    NSString *caller = [notification.userInfo objectForKey:KEY_CALLNUMBER];
    NSInteger calltype = call.integerValue;
    if ([type isEqualToString:@"comingCall"])
    {
        UIApplication *uiapp = [UIApplication sharedApplication];
        NSArray *localNotiArray = [uiapp scheduledLocalNotifications];
        for (UILocalNotification *notification in localNotiArray)
        {
            NSDictionary *dic = [notification userInfo];
            NSString *value = [dic objectForKey:KEY_TYPE];
            if ([value isEqualToString:@"comingCall"] || [value isEqualToString:@"releaseCall"])
            {
                [uiapp cancelLocalNotification:notification];
            }
        }
        if (self.modeEngineVoip.UIDelegate && [self.modeEngineVoip.UIDelegate respondsToSelector:@selector(incomingCallID:caller:phone:name:callStatus:callType:)])
        {
            [self.modeEngineVoip.UIDelegate incomingCallID:callID caller:caller phone:[notification.userInfo objectForKey:KEY_CALLERPHONE] name:[notification.userInfo objectForKey:KEY_CALLERNAME] callStatus:IncomingCallStatus_accepting callType:calltype];
        }
    }
}



//-(void) redirectConsoleLogToDocumentFolder
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"console_log.txt"];
//    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
//}


-(void)logout
{
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    UINavigationController *navigationBar = (UINavigationController *)window.rootViewController;
    [navigationBar setNavigationBarHidden:YES animated:NO];
    [navigationBar popToRootViewControllerAnimated:YES];
    [navigationBar setNavigationBarHidden:YES animated:NO];
}


- (void)addressbookChangeCallback:(NSNotification *)_notification
{
    globalcontactsChanged = 1;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"contactsChanged" object:nil userInfo:nil];
}


-(void)printLog:(NSString*)log
{
    NSLog(@"%@",log); //用于xcode日志输出
}


@end
