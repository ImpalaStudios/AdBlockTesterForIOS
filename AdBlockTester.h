#import <UIKit/UIKit.h>

static NSString * _Nonnull const ADBLOCKTESTER_UPDATE_NOTIFICATION = @"AdBlockTesterUpdateNotification";
static NSString * _Nonnull const ADBLOCKTESTER_NOTIFICATIONKEY_ADSBLOCKED = @"AdsBlocked";

typedef void (^AdBlockerTesterCompletionHandler)(BOOL adsBlocked);

@interface AdBlockTester : NSObject
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

+ (AdBlockTester * _Nonnull)sharedInstance;

#pragma mark - Public Instance Methods

- (void)updateStatusWithCompletionHandler:(nullable AdBlockerTesterCompletionHandler)completionHandler;

- (void)setAutomaticUpdatesEnabled:(BOOL)automaticUpdatesEnabled interval:(NSTimeInterval)interval;

@end
