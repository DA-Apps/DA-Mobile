/*
 
 Copyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 Early code inspired on a similar class by Philip Kluz (Philip.Kluz@zuui.org)
 
 */

#import "AppDelegate.h"
#import "TFHpple.h"
#import "ViewController.h"
#import "EAIntroView.h"
#import <FirebaseCore/FirebaseCore.h>
#import <FirebaseMessaging/FirebaseMessaging.h>
#import <FirebaseInstanceID/FirebaseInstanceID.h>

static NSString * const kUserHasOnboardedKey = @"user_has_onboarded";

@import UserNotifications;

@interface AppDelegate() <UNUserNotificationCenterDelegate, FIRMessagingDelegate>
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FIRApp configure];
    
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!granted) {
            NSLog(@"%@", error);
        }
    }];

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!granted) {
                NSLog(@"we have issues %@", error);
            }
        }];
        [FIRMessaging messaging].remoteMessageDelegate = self;
    }
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    BOOL userHasOnboarded = [[NSUserDefaults standardUserDefaults] boolForKey:kUserHasOnboardedKey];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setupNormalRootViewController];
    if (!userHasOnboarded)
        [self showIntroView];
    [self.window makeKeyAndVisible];
    //--------------------------------------------------------------------------------
    return YES;
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *dotw = [dateFormatter stringFromDate: [NSDate date]];
    if (![dotw isEqualToString:@"Wednesday"] && ![dotw isEqualToString:@"Saturday"] && ![dotw isEqualToString:@"Sunday"]) {
        [self triggerNotification:nil];
        [NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(triggerNotification:) userInfo:nil repeats:YES];
    }
}

#pragma mark - Private

- (void)setupNormalRootViewController {
    // create whatever your root view controller is going to be, in this case just a simple view controller
    // wrapped in a navigation controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"initialView"];
    
    self.window.rootViewController = viewController;
}

- (void)handleOnboardingCompletion {
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserHasOnboardedKey];
    [self setupNormalRootViewController];
}

- (void)showIntroView {
    
    // basic
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"DA Bulletin, now on your iPhone";
    page1.desc = @"";
    page1.bgImage = [UIImage imageNamed:@"bg1@2x"];
    // custom
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"Pull to refresh to see the latest posts";
    page2.titlePositionY = 220;
    page2.desc = @"";
    page2.descPositionY = 200;
    page2.bgImage = [UIImage imageNamed:@"bg3@2x"];
    // custom view from nib
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"Bookmark your favorite posts";
    page3.desc = @"";
    page3.bgImage = [UIImage imageNamed:@"bg1@2x"];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"Receive notifications for upcoming meals";
    page4.desc = @"";
    page4.bgImage = [UIImage imageNamed:@"bg3@2x"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.window.rootViewController.view.bounds andPages:@[page1,page2,page3, page4]];
    [intro showInView:self.window.rootViewController.view animateDuration:0.0];
    
}


-(void)triggerNotification:(NSTimer *)timer{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH"];
    NSDate *myDate = [NSDate date];
    NSString *hour = [df stringFromDate:myDate];
    if ([hour isEqualToString:@"11"]) {
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        content.title = @"What's for lunch today?";
        content.body = [self getMenuData];
        content.sound = [UNNotificationSound defaultSound];
        
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
        
        NSString *identifier = @"UYLocalNotification";
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
        
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Something went wrong: %@",error);
            }
        }];
        
        if (timer) {
            [timer invalidate];
        }
    }
}

-(NSString *)getMenuData{

    NSURL *tutorialsUrl = [NSURL URLWithString:@"https://deerfield.edu/bulletin"];
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    TFHpple *parser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
    
    NSString *tutorialsXpathQueryString = @"//ul[@class='dh-meal-container active-dh-meal-container']/li";
    NSArray *tutorialsNodes = [parser searchWithXPathQuery:tutorialsXpathQueryString];
    
    NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in tutorialsNodes) {
        [objects addObject:[[element firstChild] content]];
    }
    return [objects componentsJoinedByString:@", "];
}

#pragma mark - Notification

-(void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage{
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    completionHandler(UIBackgroundFetchResultNewData);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    completionHandler(UNNotificationPresentationOptionAlert + UNNotificationPresentationOptionSound);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
}

- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
}

- (void)connectToFcm {
    // Won't connect since there is no token
    if (![[FIRInstanceID instanceID] token]) {
        return;
    }
    
    // Disconnect previous FCM connection if it exists.
    [[FIRMessaging messaging] disconnect];
    
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Unable to register for remote notifications: %@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"APNs token retrieved: %@", deviceToken);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self connectToFcm];
}

@end
