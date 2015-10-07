#import <UIKit/UIKit.h>

static NSString * _Nonnull const ADBLOCKTESTER_UPDATE_NOTIFICATION = @"LiberateAdBlockTesterUpdateNotification";
static NSString * _Nonnull const ADBLOCKTESTER_NOTIFICATIONKEY_ADSBLOCKED = @"AdsBlocked";

typedef void (^LiberateAdBlockerTesterCompletionHandler)(BOOL adsBlocked);

@interface LiberateAdBlockTester : NSObject
{
@private
    NSNumber *_previousAdsBlockedStatus;
    NSTimer *_updateTimer;
    
@protected
}

#pragma mark - Properties

@property (nonatomic) BOOL automaticUpdatesEnabled;
@property (nonatomic, readonly) BOOL adsBlocked;
@property (nonatomic) NSArray * _Nullable urlsToTest;

#pragma mark - Public Class Methods

+ (LiberateAdBlockTester * _Nonnull)sharedInstance;

#pragma mark - Public Instance Methods

- (void)updateStatusWithCompletionHandler:(nullable LiberateAdBlockerTesterCompletionHandler)completionHandler;

- (void)setAutomaticUpdatesEnabled:(BOOL)automaticUpdatesEnabled interval:(NSTimeInterval)interval;

@end
