#import "RootViewController.h"
#import <AppList/AppList.h>

//Determine device screen boundaries
#define kBounds [[UIScreen mainScreen] bounds]

@implementation RootViewController

//Application view’s initial load?
- (void)loadView {

	//Drawing tableView & it’s boundaries?
	tabView = [[UITableView alloc] initWithFrame:(CGRect) kBounds];
	tabView.delegate = self;
	tabView.dataSource = self;
    [tabView setAlwaysBounceVertical:YES];
	//Displaying the tableView?
	self.view = tabView;
	//Setting Navbar Title text
	self.title = @"Bundle IDs";

}

- (void)viewDidLoad {

	//hidden apps
	NSArray* excludedApps = [[NSArray alloc] initWithObjects:
		@"AACredentialRecoveryDialog",
		@"AccountAuthenticationDialog",
		@"AskPermissionUI",
		@"CompassCalibrationViewService",
		@"DDActionsService",
		@"DataActivation",
		@"DemoApp",
		@"FacebookAccountMigrationDialog",
		@"FieldTest",
		@"MailCompositionService",
		@"MessagesViewService",
		@"MusicUIService",
		@"Print Center",
		@"Setup",
		@"Siri",
		@"SocialUIService",
		@"AXUIViewService",
		@"Ad Platforms Diagnostics",
		@"CTCarrierSpaceAuth",
		@"CheckerBoard",
		@"Diagnostics",
		@"DiagnosticsService",
		@"Do Not Disturb While Driving",
		@"Family",
		@"FieldTestMenu",
		@"Game Center UI Service",
		@"HealthPrivacyService",
		@"HomeUIService",
		@"InCallService",
		//@"Magnifier",
		@"PhotosViewService",
		@"PreBoard",
		//@"Print Centre",
		@"SLGoogleAuth",
		@"SLYahooAuth",
		@"SafariViewService",
		@"ScreenSharingViewService",
		@"ScreenshotServicesService",
		@"Server Drive",
		@"SharedWebCredentialViewService",
		@"SharingViewService",
		@"SoftwareUpdateUIService",
		@"StoreDemoViewService",
		@"User Authentication",
		@"iCloud",
		@"SafeMode",
		@"VideoSubscriberAccountViewService",
		@"WLAccessService",
		@"Workbench Ad Tester",

	@"TencentWeiboAccountMigrationDialog",
		@"TrustMe",
		@"WebContentAnalysisUI",
		@"WebSheet",
		@"WebViewService",
		@"iAd",
		@"iAdOptOut",
		@"iOS Diagnostics",
		@"iTunes",
		@"quicklookd",
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

}

//Defining what happens when you tap on an app in the table view?
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSString* str = [theApps allKeysForObject:[appNames objectAtIndex:indexPath.row]][0];
	//copy bundle ID to clipboard 
	[UIPasteboard generalPasteboard].string = str;
	//show bundle ID pop up 
	[self showID:str];
}

//Defining the amount of rows in the tableView?
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [appNames count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString* CellIdentifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = [appNames objectAtIndex:indexPath.row];


	//Setting the app icon size, colour, shape, and image
UIImageView *imgAppIcon=[[UIImageView alloc] initWithFrame:CGRectMake(30, 5, 30, 30)];
imgAppIcon.backgroundColor=[UIColor clearColor];
[imgAppIcon.layer setCornerRadius:0.0f];
[imgAppIcon.layer setMasksToBounds:YES];
[imgAppIcon setImage:[[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeLarge forDisplayIdentifier:[theApps allKeysForObject:[appNames objectAtIndex:indexPath.row]][0]]];
[cell.contentView addSubview:imgAppIcon];

	//Show app icon on table
    cell.accessoryView = imgAppIcon;

    return cell;

}


//Deals with the Bundle ID pop-up window
- (void)showID:(NSString *)label {

	UIWindow* window = [[UIWindow alloc] initWithFrame:kBounds];
	window.windowLevel = UIWindowLevelStatusBar;

	//pop-up width
	int daWidth = 200;
	//pop-up height
	int daHeight = 90;
	CGRect frame = CGRectMake(0,0,0,0);
	frame.origin.x = (tabView.frame.size.width/2)-(daWidth/2);
	frame.origin.y = (tabView.frame.size.height/2)-(daHeight/2);
	frame.size.width = daWidth;
	frame.size.height = daHeight;

	CGRect tempFrame = kBounds;
	tempFrame.size.width -= 70;

	UILabel* drawLabel = [[UILabel alloc] initWithFrame:tempFrame];
	drawLabel.text = label;
	drawLabel.font = [UIFont systemFontOfSize:16.0];
	drawLabel.numberOfLines = 2;
	drawLabel.textColor = [UIColor whiteColor];
	drawLabel.textAlignment = NSTextAlignmentCenter;

	float newWidth = [label boundingRectWithSize:drawLabel.frame.size
		options:NSStringDrawingUsesLineFragmentOrigin
		attributes:@{ NSFontAttributeName: drawLabel.font }
		context:nil].size.width;

	newWidth += 20;

	if(newWidth < 100.0) {
		newWidth = 100.0;
	}

	frame.size.width = newWidth + 50;
	frame.origin.x = (tabView.frame.size.width/2)-(frame.size.width/2);

	CGRect newFrame = CGRectMake(0,0,0,0);
	newFrame.size.width = newWidth;
	newFrame.size.height = 120;
	newFrame.origin.x = (frame.size.width/2)-(newWidth/2);
	newFrame.origin.y = (frame.size.height/2)-60;

	[drawLabel setFrame:newFrame];

	UIView* preView = [[UIView alloc] initWithFrame:frame];
	preView.backgroundColor = [UIColor blackColor];
	preView.alpha = 0.0;
	preView.layer.cornerRadius = 20;
	preView.layer.masksToBounds = YES;

	//Popup dismiss label properties
	UILabel* dismissLabel = [[UILabel alloc] initWithFrame:(CGRectMake((frame.size.width / 2) - 40, frame.size.height - 40, 80, 40))];
	//The actual text of the Popup dismiss label
	dismissLabel.text = @"Bundle copied. Tap to Dismiss.";
	//Popup dismiss label font size auto adjust
	dismissLabel.adjustsFontSizeToFitWidth = YES;
	//Popup dismiss label line count
	dismissLabel.numberOfLines = 2;
	//Popup dismiss label text colour
	dismissLabel.textColor = [UIColor whiteColor];
	//Popup dismiss label text alignment
	dismissLabel.textAlignment = NSTextAlignmentCenter;

	[preView addSubview:drawLabel];
	[preView addSubview:dismissLabel];

	UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeWindowNow:)];
	tapGesture.numberOfTapsRequired = 1;
	tapGesture.numberOfTouchesRequired = 1;

	[preView addGestureRecognizer:tapGesture];
	[tapGesture release];

	[window addSubview:preView];

	[UIView animateWithDuration:0.35
        delay:0.0
        options: UIViewAnimationOptionCurveEaseInOut
        animations:^{preView.alpha = 0.85;}
        completion:^(BOOL finished){}];

	[window makeKeyAndVisible];

}

//How the Popup window disappears from the screen?
- (void)removeWindowNow:(UITapGestureRecognizer *)recognizer {
	UIView* view = recognizer.view;
	UIWindow* window = (UIWindow *)view.superview;
	[UIView animateWithDuration:0.35
        delay:0.0
        options: UIViewAnimationOptionCurveEaseInOut
        animations:^{view.alpha = 0.0;}
        completion:^(BOOL finished){
        	[window removeFromSuperview];
        	[window release];
        }];
}
 
@end
