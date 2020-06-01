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

NS_ASSUME_NONNULL_BEGIN

@class LiveEBVideoView;

@protocol LiveEBVideoViewControllerDelegate <NSObject>
@required
    -(void)start;
    -(void)stop;

    -(void)restart;
    -(void)setStatState:(BOOL)stat;
@end

@protocol LiveEBVideoViewDelegate <NSObject>

@required

- (void)videoView:(LiveEBVideoView *)videoView didError:(NSError *)error;
- (void)showStats:(LiveEBVideoView *)videoView stat:(NSArray*)stat;
- (void)showStats:(LiveEBVideoView *)videoView strStat:(NSString*)strStat;
- (void)videoView:(LiveEBVideoView *)videoView didChangeVideoSize:(CGSize)size;

@end


@interface LiveEBVideoView : UIView <LiveEBVideoViewControllerDelegate>

@property (nonatomic, copy) NSString *rtcHost;
@property (nonatomic, copy) NSString *liveEBURL; //播放流地址 webrtc://
@property (nonatomic, copy) NSString *sessionid; //业务生成的唯一key，标识本次播放会话

@property(nonatomic, weak) id<LiveEBVideoViewDelegate> delegate;
@property(nonatomic, readonly) __kindof UIView<RTCVideoRenderer> *remoteVideoView;
@end

NS_ASSUME_NONNULL_END
