//
//  LiveEBVideoView.h
//  LiveEB_IOS
//
//  Created by ts on 4/10/20.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

#import <WebRTC/RTCEAGLVideoView.h>
#if defined(RTC_SUPPORTS_METAL)
#import <WebRTC/RTCMTLVideoView.h>
#endif

#import "LEBStatReport.h"

NS_ASSUME_NONNULL_BEGIN

@class LiveEBVideoView;

@interface LiveEBAudioSessionConfiguration : NSObject

@property(nonatomic, strong) NSString *category;
@property(nonatomic, assign) AVAudioSessionCategoryOptions categoryOptions;
@property(nonatomic, strong) NSString *mode;

@end


@protocol LiveEBVideoViewControllerDelegate <NSObject>
@required
    -(void)start;
    -(void)stop;
    -(void)pause;
    -(void)resume;
    
    -(BOOL)isPlaying;

    /* 0 ~ 1 返回上次的设置值*/
    -(CGFloat)setVolume:(CGFloat)volume;

    -(void)setAudioMute:(BOOL)mute;
    
    - (void)restart;

    /*开启调试信息*/
    -(void)setStatState:(BOOL)stat;

    -(void)setWebRTCConfiguration:(LiveEBAudioSessionConfiguration *)configuration;
    
    ///【字段含义】播放器遭遇网络连接断开时 SDK 默认重试的次数 和网络重连的时间间隔
    -(void)setConnectRetryCount:(int)retryCount retryInterval:(int)retryInterval;

@end

@protocol LiveEBVideoViewDelegate <NSObject>

@required

- (void)videoView:(LiveEBVideoView *)videoView didError:(NSError *)error;

- (void)videoView:(LiveEBVideoView *)videoView didChangeVideoSize:(CGSize)size;


@optional

- (void)onPrepared:(LiveEBVideoView*)videoView;

/*播放结束 包括主动结束和被动结束(断流等)*/
- (void)onCompletion:(LiveEBVideoView*)videoView;

- (void)onFirstFrameRender:(LiveEBVideoView*)videoView;


- (void)showStats:(LiveEBVideoView *)videoView statReport:(LEBStatReport*)statReport;

/*调试信息回调 deprecated*/
- (void)showStats:(LiveEBVideoView *)videoView stat:(NSArray*)stat;

- (void)showStats:(LiveEBVideoView *)videoView strStat:(NSString*)strStat;


@end


@interface LiveEBVideoView : UIView <LiveEBVideoViewControllerDelegate>

@property (nonatomic, copy) NSString *rtcHost;
@property (nonatomic, copy) NSString *liveEBURL; //播放流地址 webrtc://
@property (nonatomic, copy) NSString *sessionid; //业务生成的唯一key，标识本次播放会话

@property(nonatomic, weak) id<LiveEBVideoViewDelegate> delegate;
@property(nonatomic, readonly) __kindof UIView<RTCVideoRenderer> *remoteVideoView;
@end

NS_ASSUME_NONNULL_END
