/*
 AppleDelegate.m
 Created by Neil Nie (c) 2016-2018
 Contact: contact@neilnie.com
 */

#import "AppDelegate.h"
#import "TFHpple.h"
#import "BulletinViewController.h"
#import <EAIntroView/EAIntroView.h>
#import <FirebaseCore/FirebaseCore.h>
#import <FirebaseMessaging/FirebaseMessaging.h>
#import <FirebaseInstanceID/FirebaseInstanceID.h>

static NSString * const kUserHasOnboardedKey = @"user_has_onboarded";

@import UserNotifications;

@interface AppDelegate() <UNUserNotificationCenterDelegate, FIRMessagingDelegate, EAIntroDelegate>
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
    
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!granted) {
            NSLog(@"we have issues %@", error);
        }
    }];
    [FIRMessaging messaging].remoteMessageDelegate = self;
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    BOOL userHasOnboarded = [[NSUserDefaults standardUserDefaults] boolForKey:kUserHasOnboardedKey];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setupNormalRootViewController];
    if (!userHasOnboarded){
        [self showIntroView];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notificationON"];
    }
    [self.window makeKeyAndVisible];
    
    //Realm migration
    // Inside your [AppDelegate didFinishLaunchingWithOptions:]
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    // Set the new schema version. This must be greater than the previously used
    // version (if you've never set a schema version before, the version is 0).
    config.schemaVersion = 1;
    
    // Set the block which will be called automatically when opening a Realm with a
    // schema version lower than the one set above
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // We haven’t migrated anything yet, so oldSchemaVersion == 0
        if (oldSchemaVersion < 1) {
            // Nothing to do!
            // Realm will automatically detect new properties and removed properties
            // And will update the schema on disk automatically
        }
    };
    // Tell Realm to use this new configuration object for the default Realm
    [RLMRealmConfiguration setDefaultConfiguration:config];
    // Now that we've told Realm how to handle the schema change, opening the file
    // will automatically perform the migration
    [RLMRealm defaultRealm];
    
    return YES;
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"notificationON"] == YES) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE"];
        NSString *dotw = [dateFormatter stringFromDate: [NSDate date]];
        if (![dotw isEqualToString:@"Saturday"]) {
            [self triggerNotification:nil];
            [NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(triggerNotification:) userInfo:nil repeats:YES];
        }
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

-(void)introWillFinish:(EAIntroView *)introView wasSkipped:(BOOL)wasSkipped{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserHasOnboardedKey];
}

- (void)showIntroView {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notificationON"];
    
    // basic
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Convenience at your figure tips";
    page1.titleFont = [UIFont systemFontOfSize:35];
    page1.titlePositionY = 300;
    page1.desc = @"";
    page1.bgImage = [UIImage imageNamed:@"intro-1"];
    // custom
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"intro-2"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"intro-3"];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.bgImage = [UIImage imageNamed:@"intro-4"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.window.rootViewController.view.bounds andPages:@[page1,page2,page3, page4]];
    [intro setDelegate:self];
    [intro showInView:self.window.rootViewController.view animateDuration:0.0];
}


-(void)triggerNotification:(NSTimer *)timer{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH"];
    NSDate *now = [NSDate date];
    NSString *hour = [df stringFromDate:now];
    NSDate *notifiedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"notified_date"];
    NSTimeInterval interval = [now timeIntervalSinceDate:notifiedDate];
    if (!notifiedDate)
        interval = 22*60*61;
    if ([hour isEqualToString:@"11"] && interval > 22*60*60) {
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        content.title = @"What's for lunch today?";
        content.body = [self getMenuData];
        content.sound = [UNNotificationSound defaultSound];
        
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
        
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            [[NSUserDefaults standardUserDefaults] setObject:now forKey:@"notified_date"];
        }];
        
        if (timer)
            [timer invalidate];
    }else
        NSLog(@"not the right time or already notified");
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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    completionHandler(UIBackgroundFetchResultNewData);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    completionHandler(UNNotificationPresentationOptionAlert + UNNotificationPresentationOptionSound);
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
