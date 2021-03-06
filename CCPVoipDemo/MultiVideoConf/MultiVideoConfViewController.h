/*
 *  Copyright (c) 2013 The CCP project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a Beijing Speedtong Information Technology Co.,Ltd license
 *  that can be found in the LICENSE file in the root of the web site.
 *
 *                    http://www.yuntongxun.com
 *
 *  An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "UIBaseViewController.h"
#import "VideoView.h"
@interface MultiVideoConfViewController : UIBaseViewController<UITextFieldDelegate,UIAlertViewDelegate,VideoViewDelegate,UIActionSheetDelegate>
{
    NSInteger curCameraIndex;
    BOOL willClose;
}
@property (nonatomic, assign) UIViewController *backView;
@property (nonatomic, retain) NSString* curVideoConfId;
@property (nonatomic, retain) NSString* Confname;
@property (nonatomic, retain) NSString* curMain;
@property (nonatomic, retain) NSString* curMember;
@property (nonatomic, assign) BOOL isCreator;
@property (nonatomic, assign) BOOL isCreatorExit;
@property (nonatomic, retain) NSArray *cameraInfoArr;
@property (nonatomic, retain) UIView* bgView; //适配ios7使用

@property (nonatomic, retain) MultiVideoView* mainView;
@property (nonatomic, retain) MultiVideoView* view1;
@property (nonatomic, retain) MultiVideoView* view2;
@property (nonatomic, retain) MultiVideoView* view3;
@property (nonatomic, retain) MultiVideoView* view4;
@property (nonatomic, retain) MultiVideoView* view5;
@property (nonatomic, retain) UIImageView *pointImg;
@property (nonatomic, retain) id myAlertView;
-(void)createMultiVideoWithAutoClose:(BOOL) isAutoClose andIsPresenter:(BOOL) isPresenter andiVoiceMod:(NSInteger)voiceMod andAutoDelete:(BOOL)autoDelete andIsAutoJoin:(BOOL) isAutoJoin;
-(void)joinInVideoConf;
@end
