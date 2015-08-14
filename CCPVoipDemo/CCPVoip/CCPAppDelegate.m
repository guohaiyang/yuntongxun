//
//  CCPAppDelegate.m
//  CCPVoipDemo
//
//  Created by Sea on 15/8/12.
//  Copyright (c) 2015年 hisun. All rights reserved.
//

#import "CCPAppDelegate.h"
#import "ModelEngineVoip.h"
#import "CallViewController.h"
#import "VoipCallController.h"
//SEA#import "VoipIncomingViewController.h"


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
    //用于设置消息返回的代理
    [self.modeEngineVoip setModalEngineDelegate:self];
    
    //[self redirectConsoleLogToDocumentFolder];//日志重定向，开启的话，会把nslog输出到文件
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addressbookChangeCallback:)
                                                 name:@"addressbookChanged"
                                               object:nil];
    NSString * serverip = @"sandboxapp.cloopen.com";
    NSString * serverport = @"8883";
    NSString * voipID = @"88537600000001";
    NSString * voipPwd = @"8s43ev4q";
    NSString * subID = @"8a48b5514ebe1674014ebea31ffb0111";
    NSString * subToken = @"ae8732fd5c934a2ab11146704f599f1b";
    
//    NSString * accountSID = @"8a48b5514ebe1674014ebe8b6eda00de";
//    NSString * authToken = @"TOKEN：c86d27a689564c85b22ea657c9ee30ba";
    
    [self.modeEngineVoip connectToCCP:serverip onPort:[serverport integerValue] withAccount:voipID withPsw:voipPwd withAccountSid:subID withAuthToken:subToken];
    
    return YES;
}


-(void)goCallView
{
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    UINavigationController *navigationBar = (UINavigationController *)window.rootViewController;
    //[navigationBar setNavigationBarHidden:YES animated:NO];
//        UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:[CommonTools navigationBackItemBtnInitWithTarget:self action:@selector(popToPreView)]];
//        self.navigationItem.leftBarButtonItem = leftBarItem;
//        [leftBarItem release];
        CallViewController *view = [[CallViewController alloc] init];
        [navigationBar pushViewController:view animated:YES];
        [view release];
}

#pragma mark - 由setModalEngineDelegate设置返回的登录消息
- (void)responseVoipRegister:(ERegisterResult)event data:(NSString *)data
{
    if (event == ERegisterSuccess)
    {
        //[self.modelEngineVoip setVoipName:btn.titleLabel.text];
        //[self.modelEngineVoip setVoipPhone:str];
        
        [self voipBackCall];
        
        NSString* strVersion = [self.modeEngineVoip getLIBVersion];
        NSLog(@"%@",strVersion);
    }
    if (event == ERegistering)
    {
    }
    else if (event == ERegisterFail)
    {
        //[self dismissProgressingView];
        //[self  popPromptViewWithMsg:@"登录失败，请稍后重试！" AndFrame:CGRectMake(0, 160, 320, 30)];
    }
    else if (event == ERegisterNot)
    {
        //[self dismissProgressingView];
    }
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
    NSString *type = [notification.userInfo objectForKey:KEY_TYPE];
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
            /*NSString *callID = [notification.userInfo objectForKey:KEY_CALLID];
             NSString *call = [notification.userInfo objectForKey:KEY_CALL_TYPE];
             NSString *caller = [notification.userInfo objectForKey:KEY_CALLNUMBER];
             NSInteger calltype = call.integerValue;
             [self.modeEngineVoip.UIDelegate incomingCallID:callID caller:caller phone:[notification.userInfo objectForKey:KEY_CALLERPHONE] name:[notification.userInfo objectForKey:KEY_CALLERNAME] callStatus:IncomingCallStatus_accepting callType:calltype];*///SEA
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


-(void)voipBackCall
{
    [self.modeEngineVoip setVoipPhone:@"13656020084"];
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    UINavigationController *navigationBar = (UINavigationController *)window.rootViewController;
    //电话回拨
    VoipCallController *myVoipCallController = [[VoipCallController alloc]
                                                initWithCallerName:@""
                                                andCallerNo:@"18950122992"
                                                andVoipNo:@""
                                                andCallType:2];
    [navigationBar presentModalViewController:myVoipCallController animated:YES];
    [myVoipCallController release];
}


@end
