//BundleIDs Originally created by @NoahSaso
//Updated in 2018 by @TD_Advocate
//Huge thanks to @TheTomMetzger and @Skittyblock for their massive amounts of help with updating and adding new features
//Shoutout to @xerusdesign for making the new icon and @EthanWhited for helping resolve an iOS 13 crash w/app icons in the table view

#import "RootViewController.h"
#import <AppList/AppList.h>

//Determine device screen boundaries
#define kBounds [[UIScreen mainScreen] bounds]

@implementation RootViewController

//Set showID alert to nil for auto dismiss
UIAlertController *showID = nil;

//Set copyAllAlert alert to nil for auto dismiss
UIAlertController *copyAllAlert = nil;

//Create array of bundleIDs to be used for copyAllButton
NSMutableArray *bundleIDs;

//Application view’s initial load?
- (void)loadView {
    
    //Drawing tableView and it’s boundaries
    tabView = [[UITableView alloc] initWithFrame:(CGRect) kBounds];
    tabView.delegate = self;
    tabView.dataSource = self;
    [tabView setAlwaysBounceVertical:YES];
    //Displaying the tableView
    self.view = tabView;
    //Setting Navbar Title text
    self.title = @"Bundle IDs";
    
    //Defining how the bundleIDs array works
    bundleIDs = [[NSMutableArray alloc] init];
    
    
}

//Auto dismiss for the showID alert
- (void) dismissIDAlert
{
    if (showID != nil)
    {
        [showID dismissViewControllerAnimated:true completion:nil];
    }
    else {
        NSLog(@"showID is nil");
    }
}

//Auto dismiss for the copyAllAlert alert
- (void) dismissAllAlert
{
    if (copyAllAlert != nil)
    {
        [copyAllAlert dismissViewControllerAnimated:true completion:nil];
    }
    else {
        NSLog(@"copyAllAlert is nil");
    }
}


- (void)viewDidLoad {
    
    //Create copyAllButton on right side of the navbar
    UIBarButtonItem *copyAllButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Copy All"
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(copyAllButton:)];
    self.navigationItem.rightBarButtonItem = copyAllButton;
    
    //Apps that are to be hidden from the view as they aren’t normally meant to be seen by the end user
    NSArray* excludedApps = [[NSArray alloc] initWithObjects:
                             @"AACredentialRecoveryDialog",
                             @"AccountAuthenticationDialog",
                             @"AskPermissionUI",
                             @"AppSSOUIService",
                             @"AuthKitUIService",
                             @"AXUIViewService",
                             @"Ad Platforms Diagnostics",
                             @"BusinessChatViewService",
                             @"CarPlaySplashScreen",
                             @"CheckerBoard",
                             @"CompassCalibrationViewService",
                             @"Continuity Camera",
                             @"CTCarrierSpaceAuth",
                             @"CTNotifyUIService",
                             @"DataActivation",
                             @"DDActionsService",
                             @"DemoApp",
                             @"Diagnostics",
                             @"DiagnosticsService",
                             @"Do Not Disturb While Driving",
                             @"FacebookAccountMigrationDialog",
                             @"Family",
                             @"FieldTest",
                             @"FieldTestMenu",
                             @"FontInstallViewService",
                             @"FTMInternal-4",
                             @"Game Center UI Service",
                             @"HealthPrivacyService",
                             @"HomeUIService",
                             @"iAd",
                             @"iAdOptOut",
                             @"iCloud",
                             @"iMessageAppsViewService",
                             @"InCallService",
                             @"iOS Diagnostics",
                             @"iTunes",
                             @"Magnifier",
                             @"MailCompositionService",
                             @"MessagesViewService",
                             @"MusicUIService",
                             @"PhotosViewService",
                             @"PreBoard",
                             @"Print Center",
                             @"Print Centre",
                             @"quicklookd",
                             @"RemoteiCloudQuotaUI",
                             @"SafariViewService",
                             @"SafeMode",
                             @"ScreenSharingViewService",
                             @"Screenshots",
                             @"ScreenshotServicesService",
                             @"ScreenTimeUnlock",
                             @"Server Drive",
                             @"Setup",
                             @"SharedWebCredentialViewService",
                             @"SharingViewService",
                             @"SIMSetupUIService",
                             @"Siri",
                             @"Siri Search",
                             @"SLGoogleAuth",
                             @"SLYahooAuth",
                             @"SocialUIService",
                             @"SoftwareUpdateUIService",
                             @"SPNFCURL",
                             @"StoreDemoViewService",
                             @"TencentWeiboAccountMigrationDialog",
                             @"TrustMe",
                             @"TVAccessViewService",
                             @"TVRemoteUIService",
                             @"User Authentication",
                             @"VideoSubscriberAccountViewService",
                             @"Web",
                             @"WebContentAnalysisUI",
                             @"WebSheet",
                             @"WebViewService",
                             @"Workbench Ad Tester",
                             @"WLAccessService",
                             nil];
    
    //Using applist to gather installed app information
    ALApplicationList* apps = [ALApplicationList sharedApplicationList];
    
    //Creating Dictionary to pull app list
    theApps = [[NSMutableDictionary alloc] init];
    for(int i = 0; i < [apps.applications allKeys].count; i++) {
        NSString* name = [[apps.applications allValues] objectAtIndex:i];
        if([excludedApps containsObject:name]) {
            continue;
        }
        theApps[[[apps.applications allKeys] objectAtIndex:i]] = name;
    }
    
    appNames = [[NSMutableArray alloc] init];
    
    for(NSString* i in [theApps allValues]) {
        [appNames addObject:i];
    }
    
    appNames = [[appNames sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    
    [tabView reloadData];
    
    
    //How the full list of installed bundle IDs is grabbed and placed into the bundleIDs array
    for (int i = 0; i < [theApps count]; i++)
    {
        NSString *bundleID = [theApps allKeysForObject:[appNames objectAtIndex:i]][0];
        bundleID = [NSString stringWithFormat:@"%@\n", bundleID];
        [bundleIDs addObject: bundleID];
    }
    
}

//Defining what happens when you tap on an app in the table view
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* str = [theApps allKeysForObject:[appNames objectAtIndex:indexPath.row]][0];
    //copy single selected application bundle ID to clipboard
    [UIPasteboard generalPasteboard].string = str;
    
    //show single bundle ID alert
    showID = [UIAlertController alertControllerWithTitle:str message:@"Copied to the clipboard" preferredStyle:UIAlertControllerStyleAlert];
    
    //Adding this code back in due to popular demand. Comment out just the UIAlertAction code and after the showID if you are adding back the auto-dismiss
    //The manual dismissal prompt for the UIAlertView
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^ (UIAlertAction *_Nonnull action) {
    NSLog(@"OK button is pressed");
    }];
    [showID addAction:actionOK];
    

    //Allowing the alert to actually be displayed
    [self presentViewController:showID animated:YES completion:nil];
    
    //Commenting out due to popular demand but leaving in case someone prefers it to auto-dismiss
    //Setting the timer for auto dismissing the alert
    /*[NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:NSSelectorFromString(@"dismissIDAlert")
                                   userInfo:nil
                                    repeats:NO];*/
                                    
}

//Defining the amount of rows in the tableView based on installed application count
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [appNames count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//Defining how the table cells work
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* CellIdentifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //Getting the name of the app for the table cell
    cell.textLabel.text = [appNames objectAtIndex:indexPath.row];
    
    
    //Setting the app icon size, colour, shape, and image
    UIImageView *imgAppIcon=[[UIImageView alloc] initWithFrame:CGRectMake(30, 5, 30, 30)];
    imgAppIcon.backgroundColor=[UIColor clearColor];
    [imgAppIcon.layer setCornerRadius:0.0f];
    [imgAppIcon.layer setMasksToBounds:YES];
    [imgAppIcon setImage:[[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeSmall forDisplayIdentifier:[theApps allKeysForObject:[appNames objectAtIndex:indexPath.row]][0]]];
    [cell.contentView addSubview:imgAppIcon];
    
    //Show app icon on table
    cell.accessoryView = imgAppIcon;
    
    return cell;
    
}

//How the Copy All button works
-(void)copyAllButton:(id)sender {
    
    //show copy all bundle IDs alert
    copyAllAlert = [UIAlertController alertControllerWithTitle:@"All Bundle IDs" message:@"Copied to the clipboard" preferredStyle:UIAlertControllerStyleAlert];
    
    //Commenting out due to crash caused by OK button dismissing the alert and dismissAlert trying to dismiss something that is no longer there
    /*
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^ (UIAlertAction *_Nonnull action) {
    NSLog(@"OK button is pressed");
    }];
    [copyAllAlert addAction:actionOK];
    */
    
    
    //Allowing the alert to actually be displayed
    [self presentViewController:copyAllAlert animated:YES completion:nil];
    //Setting the timer for auto dismissing the alert
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:NSSelectorFromString(@"dismissAllAlert")
                                   userInfo:nil
                                    repeats:NO];
    
    //All non-hidden bundle IDs to be copied
    NSString* copiedAllString = @"";
    for (int i=0; i < bundleIDs.count; i ++) {
        //Create the string of all application names
        NSString *allNames = [NSString stringWithFormat:@"%@\n", appNames[i]];
        //Add the string of application names to the copied all string
        copiedAllString = [copiedAllString stringByAppendingString:allNames];
        //Create the string of all application bundle IDs
        NSString *allBundles = [NSString stringWithFormat:@"%@\n", bundleIDs[i]];
        //Add the string of application bundle IDs to the copied all string
        copiedAllString = [copiedAllString stringByAppendingString:allBundles];
    }
    
    //copy all bundle IDs to clipboard
    [UIPasteboard generalPasteboard].string = copiedAllString;
    
}

@end
