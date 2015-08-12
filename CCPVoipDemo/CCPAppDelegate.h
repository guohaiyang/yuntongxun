//
//  CCPAppDelegate.h
//  CCPVoipDemo
//
//  Created by Sea on 15/8/12.
//  Copyright (c) 2015年 hisun. All rights reserved.
//

#define kKeyboardBtnpng             @"dial_icon.png"
#define kKeyboardBtnOnpng           @"dial_icon_on.png"
#define kHandsfreeBtnpng            @"handsfree_icon.png"
#define kHandsfreeBtnOnpng          @"handsfree_icon_on.png"
#define kMuteBtnpng                 @"mute_icon.png"
#define kMuteBtnOnpng               @"mute_icon_on.png"
#define kTransferCallBtnpng         @"call_transfer_icon.png"
#define kTransferCallBtnOnpng       @"call_transfer_icon_on.png"

#import <Foundation/Foundation.h>

NSInteger globalcontactsChanged;
NSInteger globalContactID;
NSInteger contactOptState;

@class ModelEngineVoip;

@interface CCPAppDelegate : NSObject
{
    
}

+ (instancetype)sharedInstance;

@property (retain, nonatomic) ModelEngineVoip *modeEngineVoip;
//用于输出日志
-(void)printLog:(NSString*)log;
-(void)logout;

- (BOOL)applicationDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)applicationDidEnterBackground;
- (void)applicationWillResignActive;
- (void)applicationWillEnterForeground;
- (void)applicationDidBecomeActive;
- (void)applicationWillTerminate;
- (void)applicationDidReceiveLocalNotification:(UILocalNotification *)notification;

@end
