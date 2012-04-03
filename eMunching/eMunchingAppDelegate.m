//
//  eMunchingAppDelegate.m
//  eMunching
//
//  Created by Andrew Green on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "eMunchingAppDelegate.h"
#import "ApplicationManager.h"
#import "MyOrderViewController.h"
#import "GANTracker.h"

@implementation eMunchingAppDelegate

@synthesize window=_window;

@synthesize tabBarController=_tabBarController;

@synthesize savedOrderGroup = m_savedOrderGroup;
@synthesize savedOrderGroupItems = m_savedOrderGroupItems;

// Dispatch period in seconds
static const NSInteger kGANDispatchPeriodSec = 10;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [ApplicationManager instance].appDelegate = self;
    [[ApplicationManager instance].fontManager loadFont:REGULARFONT];
    [[ApplicationManager instance].fontManager loadFont:BOLDFONT];
    
    // Add the tab bar controller's current view as a subview of the window    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    
    [[GANTracker sharedTracker] startTrackerWithAccountID:GOOGLEACCOUNTID dispatchPeriod:kGANDispatchPeriodSec delegate:nil];
    
    // Read Login data from saved Plist
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];   
    
    // get the path to our Data/plist file
    NSString *plistPath = [docsDir stringByAppendingPathComponent:@"Login.plist"];
    
    
    NSMutableArray *loginArray = [[NSMutableArray arrayWithContentsOfFile:plistPath] retain];
    
    
    NSMutableDictionary *loginHistory =[loginArray objectAtIndex:0];
    
    [[ApplicationManager instance].dataCacheManager setEmailId:[loginHistory objectForKey:@"emailId"]];
    
    [[ApplicationManager instance].dataCacheManager setPassword:[loginHistory objectForKey:@"password"]];
    
    [[ApplicationManager instance].dataCacheManager setRegisterStatus:[[loginHistory objectForKey:@"registerSatus"]boolValue]];
    [[ApplicationManager instance].dataCacheManager setLoginStatus:[[loginHistory objectForKey:@"loginStatus"]boolValue]];
    [[ApplicationManager instance].dataCacheManager setAuthenticationStatus:[[loginHistory objectForKey:@"authenticationStatus"]boolValue]];
    
    [[ApplicationManager instance].dataCacheManager setFirstName:[loginHistory objectForKey:@"firstName"]];
    [[ApplicationManager instance].dataCacheManager setLastName:[loginHistory objectForKey:@"lastName"]];
    [[ApplicationManager instance].dataCacheManager setPhoneNumber:[loginHistory objectForKey:@"phoneNumber"]];
    
    [[ApplicationManager instance].dataCacheManager setPrefLocationId:[loginHistory objectForKey:@"locationId"]];
    
    NSLog(@"%@",[[ApplicationManager instance].dataCacheManager emailId]);
    NSLog(@"%@",[[ApplicationManager instance].dataCacheManager password]);
    NSLog(@"%@",[[ApplicationManager instance].dataCacheManager firstName]);
    NSLog(@"%@",[[ApplicationManager instance].dataCacheManager lastName]);
    NSLog(@"%@",[[ApplicationManager instance].dataCacheManager phoneNumber]); 
    NSLog(@"%@",[[ApplicationManager instance].dataCacheManager  preferredLocation]); 
    
    [loginArray release];
    
    
    // Read SavedOrderGroup from saved PList
    
    NSData *data;
    NSKeyedUnarchiver *unarchiver;
    
    NSString *plistPath1 = [docsDir stringByAppendingPathComponent:@"SavedOrderGroup.plist"];
    
    data = [NSData dataWithContentsOfFile:plistPath1];
    unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    m_savedOrderGroup = [[[NSMutableArray alloc] init] autorelease];
    m_savedOrderGroup = [unarchiver decodeObjectForKey:@"savedOrderGroup"];
    
    if (m_savedOrderGroup != nil)
    {
        [[ApplicationManager instance].dataCacheManager setSavedOrderGroup:m_savedOrderGroup];
    }
    
    [unarchiver finishDecoding];
    [unarchiver release];
    
    
    // Read SavedOrderGroupItems from saved PList
    
    NSData *data1;
    NSKeyedUnarchiver *unarchiver1;
    
    NSString *plistPath2 = [docsDir stringByAppendingPathComponent:@"SavedOrderGroupItems.plist"];
    
    data1 = [NSData dataWithContentsOfFile:plistPath2];
    unarchiver1 = [[NSKeyedUnarchiver alloc] initForReadingWithData:data1];
    
    m_savedOrderGroupItems = [[[NSMutableArray alloc] init] autorelease];
    m_savedOrderGroupItems = [unarchiver1 decodeObjectForKey:@"savedOrderGroupItems"];
    
    if (m_savedOrderGroupItems != nil)
    {
        [[ApplicationManager instance].dataCacheManager setSavedOrderGroupItems:m_savedOrderGroupItems];
    }
    
    [unarchiver1 finishDecoding];
    [unarchiver1 release];

    
    return YES; 
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
    // Save Login data to Plist
    
    NSMutableArray *loginArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *loginDict =[[NSMutableDictionary alloc]init];
    
    [loginDict  setValue: [[ApplicationManager instance].dataCacheManager emailId] forKey:@"emailId"];
    [loginDict  setValue: [[ApplicationManager instance].dataCacheManager password] forKey:@"password"];
    
    NSNumber * registerStatusNumber = [NSNumber numberWithBool:[[ApplicationManager instance].dataCacheManager registerStatus]];
    [loginDict  setValue: registerStatusNumber forKey:@"registerStatus"];
    
    NSNumber * loginStatusNumber = [NSNumber numberWithBool:[[ApplicationManager instance].dataCacheManager loginStatus]];
    [loginDict  setValue: loginStatusNumber   forKey:@"loginStatus"];
    
    NSNumber * authenticationStatusNumber = [NSNumber numberWithBool:[[ApplicationManager instance].dataCacheManager authenticationStatus]];
    [loginDict  setValue: authenticationStatusNumber forKey:@"authenticationStatus"];
    
    [loginDict  setValue: [[ApplicationManager instance].dataCacheManager firstName] forKey:@"firstName"];
    [loginDict  setValue: [[ApplicationManager instance].dataCacheManager lastName] forKey:@"lastName"];
    [loginDict  setValue: [[ApplicationManager instance].dataCacheManager phoneNumber] forKey:@"phoneNumber"];
    
    [loginDict  setValue: [[ApplicationManager instance].dataCacheManager preferredLocation].locationId forKey:@"locationId"];
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];    
    
    // get the path to our Data/plist file
    NSString *plistPath = [docsDir stringByAppendingPathComponent:@"Login.plist"];
    
    
    [loginArray insertObject:loginDict atIndex:0];
    
    // This writes the array to a plist file. If this file does not already exist, it creates a new one.
    [loginArray writeToFile:plistPath atomically:TRUE]; 
    [loginArray release];
    [loginDict release];
    
    // Save SavedOrderGroup data to Plist
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:  [[ApplicationManager instance].dataCacheManager savedOrderGroup] forKey:@"savedOrderGroup"];
    [archiver finishEncoding];
    
    // get the path to our Data/plist file
    NSString *plistPath1 = [docsDir stringByAppendingPathComponent:@"SavedOrderGroup.plist"];
    
    [data writeToFile:plistPath1 atomically:YES];
        
    [data release];
    [archiver release];
    
    // Save SavedOrderGroupItems data to Plist
    
    NSMutableData *data1 = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver1 = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data1];
    
    [archiver1 encodeObject:  [[ApplicationManager instance].dataCacheManager savedOrderGroupItems]  forKey:@"savedOrderGroupItems"];
    [archiver1 finishEncoding];
    
    // get the path to our Data/plist file
    NSString *plistPath2 = [docsDir stringByAppendingPathComponent:@"SavedOrderGroupItems.plist"];
    
    [data1 writeToFile:plistPath2 atomically:YES];
    
    [data1 release];
    [archiver1 release];  
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
    return [[[ApplicationManager instance].dataCacheManager facebookInstance] handleOpenURL:url];
}

// Optional UITabBarControllerDelegate method.
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    if (viewController == [self.tabBarController.viewControllers objectAtIndex:3])
//    {
//        [[[[ApplicationManager instance].uiManager orderController] orderTable] reloadData];
//        self.tabBarController.selectedViewController = [[ApplicationManager instance].uiManager orderController];
//        [self.tabBarController.selectedViewController viewWillAppear:YES];
//    }
//}


/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
