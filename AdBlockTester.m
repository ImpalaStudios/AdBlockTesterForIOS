#import "AdBlockTester.h"

@implementation AdBlockTester

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    
    _adsBlocked = NO;
    _urlsToTest = @[
        @"https://googleads.g.doubleclick.net/",
        @"https://admob.com"
    ];
    
    return self;
}

#pragma mark - Public Class Methods

+ (AdBlockTester *)sharedInstance
{
    static AdBlockTester *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^ {
        sharedInstance = [[AdBlockTester alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Public Instance Methods

- (void)updateStatusWithCompletionHandler:(nullable AdBlockerTesterCompletionHandler)completionHandler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        
        NSArray *urlsToTest = [_urlsToTest copy];
        
        __block NSInteger testsCompleted = 0;
        __block NSInteger testsFailed = 0;

        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        [sessionConfig setURLCache:nil];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];

        for (NSString *urlToTest in urlsToTest)
        {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlToTest] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
            
            [request setHTTPMethod:@"HEAD"];
            
            NSURLSessionDataTask *sessionTask = [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
                
                BOOL adsBlocked = [error code] == -1200;
                
                if (adsBlocked)
                {
                    testsFailed++;
                }
                
                testsCompleted++;
                
                if (testsCompleted == [_urlsToTest count])
                {
                    _adsBlocked = testsCompleted == testsFailed;
                    
                    BOOL statusChanged = !_previousAdsBlockedStatus || [_previousAdsBlockedStatus boolValue] != _adsBlocked;
                    
                    _previousAdsBlockedStatus = [NSNumber numberWithBool:_adsBlocked];
                    
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        
                        if (completionHandler)
                        {
                            completionHandler(_adsBlocked);
                        }
                        
                        if (statusChanged)
                        {
                            NSNotification *notification = [NSNotification notificationWithName:ADBLOCKTESTER_UPDATE_NOTIFICATION object:self userInfo:@{ ADBLOCKTESTER_NOTIFICATIONKEY_ADSBLOCKED : @(_adsBlocked) }];
                            
                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                        }
                    });
                }
            }];
            
            [sessionTask resume];
        }
    });
}

- (void)setAutomaticUpdatesEnabled:(BOOL)automaticUpdatesEnabled
{
    [self setAutomaticUpdatesEnabled:automaticUpdatesEnabled interval:180.0];
}

- (void)setAutomaticUpdatesEnabled:(BOOL)automaticUpdatesEnabled interval:(NSTimeInterval)interval
{
    if (automaticUpdatesEnabled && !_updateTimer)
    {
        _updateTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(updateTimerFired) userInfo:nil repeats:YES];
    }
    else if (!automaticUpdatesEnabled && _updateTimer)
    {
        [_updateTimer invalidate];
        
        _updateTimer = nil;
    }
}

- (BOOL)automaticUpdatesEnabled
{
    return _updateTimer != nil;
}

- (void)updateTimerFired
{
    [self updateStatusWithCompletionHandler:nil];
}

@end
