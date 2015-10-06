# AdBlockTesterForIOS

Class to test if ad providers are blocked by a VPN.

Recently Apple has allowed VPN's in the store that block in app advertisements. This class can help you to detect if ads are blocked by a VPN.

# How

This class will check if calls to certain URLs result in a specific error. If this is the case it is assumed that a VPN is blocking the call.

It will assume ads are blocked only when none of the URLs were available.

# Usage

To simply test if ads are blocked you can do a single call:

```
[[AdBlockTester sharedInstance] updateStatusWithCompletionHandler:^(BOOL adsBlocked) {
 
  NSLog(@"Ads are blocked: %@", @(adsBlocked));
}];
```

This method will also send a notification (ADBLOCKTESTER_UPDATE_NOTIFICATION) the first time you call this method or any other time if the status has changed.

## Automatic Updates

To periodically test the status you can enable the timer:

```
[[AdBlockTester sharedInstance] setAatomaticUpdatesEnabled:YES];
```

By default it will be updated every 3 minutes but you can also provide a custom interval:

```
[[AdBlockTester sharedInstance] setAatomaticUpdatesEnabled:YES interval:180.0];
```

## Tested URL's

By default only two URL's are tested. You can set your own with the "urlsToTest" property:

```
[[AdBlockTester sharedInstance] setUrlsToTest:@[ "sourceurlforads.com" ];
```

Only when none of the URL's can be reached it will be assumed that the ads are blocked.
