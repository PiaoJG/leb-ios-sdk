#import "LiveEBDemoVideoCallView.h"

#import <AVFoundation/AVFoundation.h>

#import "UIImage+LiveEBUtilities.h"

static CGFloat const kButtonPadding = 16;
static CGFloat const kButtonSize = 48;
static CGFloat const kLocalVideoViewSize = 120;
static CGFloat const kLocalVideoViewPadding = 8;
static CGFloat const kStatusBarHeight = 20;

@interface LiveEBDemoVideoCallView () <LiveEBVideoViewDelegate>

@property(nonatomic, strong) LiveEBVideoView *remoteVideoView2;

@end

@implementation LiveEBDemoVideoCallView {
  UIButton *_routeChangeButton;
  UIButton *_cameraSwitchButton;
  UIButton *_hangupButton;
  CGSize _remoteVideoSize;
}

@synthesize statusLabel = _statusLabel;
@synthesize delegate = _delegate;

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {

      self.backgroundColor = [UIColor blackColor];
    _remoteVideoView2 = [LiveEBVideoView new];
      _remoteVideoView2.delegate = self;
      
      [self addSubview:_remoteVideoView2];
      _controlDelegate = _remoteVideoView2;
      UIImage *image;
      if (false) {
            _routeChangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _routeChangeButton.backgroundColor = [UIColor whiteColor];
            _routeChangeButton.layer.cornerRadius = kButtonSize / 2;
            _routeChangeButton.layer.masksToBounds = YES;
            UIImage *image = [UIImage imageNamed:@"ic_surround_sound_black_24dp.png"];
            [_routeChangeButton setImage:image forState:UIControlStateNormal];
            [_routeChangeButton addTarget:self
                                   action:@selector(onRouteChange:)
                         forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_routeChangeButton];
      }
      
     
      
      if (true) {
    _hangupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _hangupButton.backgroundColor = [UIColor redColor];
    _hangupButton.layer.cornerRadius = kButtonSize / 2;
    _hangupButton.layer.masksToBounds = YES;
    image = [UIImage imageForName:@"ic_call_end_black_24dp.png"
                            color:[UIColor whiteColor]];
    [_hangupButton setImage:image forState:UIControlStateNormal];
    [_hangupButton addTarget:self
                      action:@selector(onHangup:)
            forControlEvents:UIControlEventTouchUpInside];
          [self addSubview:_hangupButton];
          
      }

    _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _statusLabel.font = [UIFont fontWithName:@"Roboto" size:16];
    _statusLabel.textColor = [UIColor whiteColor];
    [self addSubview:_statusLabel];

    UITapGestureRecognizer *tapRecognizer =
        [[UITapGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(didTripleTap:)];
    tapRecognizer.numberOfTapsRequired = 3;
    [self addGestureRecognizer:tapRecognizer];
  }
  return self;
}

- (void)setLiveEBURL:(NSString *)liveEBURL {
    _remoteVideoView2.liveEBURL = liveEBURL;
}

- (void)layoutSubviews {
  CGRect bounds = self.bounds;
  if (_remoteVideoSize.width > 0 && _remoteVideoSize.height > 0) {
    // Aspect fill remote video into bounds.
    CGRect remoteVideoFrame =
        AVMakeRectWithAspectRatioInsideRect(_remoteVideoSize, bounds);
      
    _remoteVideoView2.frame = remoteVideoFrame;
    _remoteVideoView2.center =
        CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
  } else {
    _remoteVideoView2.frame = bounds;
  }

  NSLog(@"_remoteVideoView2222[ %f %f] x=%f y=%f width=%f height=%f _remoteVideoSize:%f %f ",
        _remoteVideoView2.center.x, _remoteVideoView2.center.y, _remoteVideoView2.frame.origin.x, _remoteVideoView2.frame.origin.y, _remoteVideoView2.frame.size.width, _remoteVideoView2.frame.size.height
        ,_remoteVideoSize.width, _remoteVideoSize.height);
    
  // Aspect fit local video view into a square box.
  CGRect localVideoFrame =
      CGRectMake(0, 0, kLocalVideoViewSize, kLocalVideoViewSize);
  // Place the view in the bottom right.
  localVideoFrame.origin.x = CGRectGetMaxX(bounds)
      - localVideoFrame.size.width - kLocalVideoViewPadding;
  localVideoFrame.origin.y = CGRectGetMaxY(bounds)
      - localVideoFrame.size.height - kLocalVideoViewPadding;


  // Place hangup button in the bottom left.
  _hangupButton.frame =
      CGRectMake(CGRectGetMinX(bounds) + kButtonPadding,
                 CGRectGetMaxY(bounds) - kButtonPadding -
                     kButtonSize,
                 kButtonSize,
                 kButtonSize);

  // Place button to the right of hangup button.
  CGRect cameraSwitchFrame = _hangupButton.frame;
  cameraSwitchFrame.origin.x =
      CGRectGetMaxX(cameraSwitchFrame) + kButtonPadding;
  _cameraSwitchButton.frame = cameraSwitchFrame;

  // Place route button to the right of camera button.
  CGRect routeChangeFrame = _cameraSwitchButton.frame;
  routeChangeFrame.origin.x =
      CGRectGetMaxX(routeChangeFrame) + kButtonPadding;
  _routeChangeButton.frame = routeChangeFrame;

  [_statusLabel sizeToFit];
  _statusLabel.center =
      CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
}

#pragma mark - RTCVideoViewDelegate

- (void)videoView:(LiveEBVideoView *)videoView didError:(NSError *)error {
    
}

- (void)showStats:(LiveEBVideoView *)videoView stat:(NSArray*)stat {
    
}

- (void)videoView:(LiveEBVideoView *)videoView didChangeVideoSize:(CGSize)size {
     if (videoView == _remoteVideoView2) {
        _remoteVideoSize = size;
      }
      [self setNeedsLayout];
}

#pragma mark - Private

- (void)onRouteChange:(id)sender {
  [_delegate videoCallViewDidChangeRoute:self];
}

- (void)onHangup:(id)sender {
  [_delegate videoCallViewDidHangup:self];
}

- (void)didTripleTap:(UITapGestureRecognizer *)recognizer {
  [_delegate videoCallViewDidEnableStats:self];
}

@end