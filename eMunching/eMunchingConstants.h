//
//  eMunchingConstants.h
//  eMunching
//
//  Created by Andrew Green on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// Button handler constants
//_____________________________________________________________________________________________________

#define CHEFSPECIALS 0
#define DAILYDEALS   1

#define SEARCH  0
#define MYORDER 1

#define MENU_LIKEIT      0
#define MENU_ADDTOORDER  1
#define MENU_UIPICKER    2
#define MENU_DESCRIPTION 3

#define BUTTON_CHEFSPECIAL  0
#define BUTTON_FEATUREDDEAL 1
#define BUTTON_HOTDEALS     2

#define BUTTON_CONTACTUS    0
#define BUTTON_MAILUS       1
#define BUTTON_FINDUS       2
#define BUTTON_REACHUS      3
#define BUTTON_FOLLOWUS     4
#define BUTTON_WEBSITE      5


#define BUTTON_ABOUTUSVIEW   0
#define BUTTON_CONTACTVIEW   1
#define BUTTON_MYPROFILEVIEW 2

// Currency
//_____________________________________________________________________________________________________

#define CURRENCY @"$"


// Steps to create new versions of the app
//_____________________________________________________________________________________________________

// 1. Create a copy of the workspace and open in xCode
// 2. Change the product name under "Build settings"
// 3. Change the constants below as instructed
// 4. Replace the required image assets in the folder - eMunching\eMunching\Images
//    The replaced images should have the SAME name, dimension and type



// Custom fonts
//_____________________________________________________________________________________________________

// To change the custom font, add new otf format files to the project and change the names here

// Bold font format
#define BOLDFONT    @"TrajanPro-Bold"

// Regular font format
#define REGULARFONT @"TrajanPro-Regular"



// Background and text colors
//_____________________________________________________________________________________________________

// Replace numerators with RGB of selected color

// To change background of all UI elements
#define BACKGROUNDCOLOR  [UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1]

// To change the tint of the navigation bar
#define TINTCOLOR        [UIColor colorWithRed:138.0/255.0 green:120.0/255.0 blue:97.0/255.0 alpha:1]


// Text color 1 (Black)
#define TEXTCOLOR1       [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1]

// Text color 2 (Shade of brown)
#define TEXTCOLOR2       [UIColor colorWithRed:159.0/255.0 green:137.0/255.0 blue:117.0/255.0 alpha:1]

// Text color 3 (White)
#define TEXTCOLOR3       [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]

// Text color 4 (Light gray)
#define TEXTCOLOR4       [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1]

// Text color 5 (Dark gray)
#define TEXTCOLOR5       [UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1]

// Text color 6 (Red)
#define TEXTCOLOR6       [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1]


//Test colors

//// To change background of all UI elements
//#define BACKGROUNDCOLOR  [UIColor colorWithRed:25.0/255.0 green:65.0/255.0 blue:131.0/255.0 alpha:1]
//
//// To change the tint of the navigation bar
//#define TINTCOLOR        [UIColor colorWithRed:200.0/255.0 green:120.0/255.0 blue:97.0/255.0 alpha:1]
//
//
//// Text color 1 (Black)
//#define TEXTCOLOR1       [UIColor colorWithRed:2.0/255.0 green:120.0/255.0 blue:97.0/255.0 alpha:1]
//
//// Text color 2 (Shade of brown)
//#define TEXTCOLOR2       [UIColor colorWithRed:2.0/255.0 green:120.0/255.0 blue:97.0/255.0 alpha:1]
//
//// Text color 3 (White)
//#define TEXTCOLOR3       [UIColor colorWithRed:2.0/255.0 green:120.0/255.0 blue:97.0/255.0 alpha:1]
//
//// Text color 4 (Light gray)
//#define TEXTCOLOR4       [UIColor colorWithRed:2.0/255.0 green:120.0/255.0 blue:97.0/255.0 alpha:1]
//
//// Text color 5 (Dark gray)
//#define TEXTCOLOR5       [UIColor colorWithRed:2.0/255.0 green:120.0/255.0 blue:97.0/255.0 alpha:1]
//
//// Text color 6 (Red)
//#define TEXTCOLOR6       [UIColor colorWithRed:2.0/255.0 green:120.0/255.0 blue:97.0/255.0 alpha:1]



// Restaurant ID and synch interval
//_____________________________________________________________________________________________________

#define RESTAURANT_ID  5
#define SYNCH_INTERVAL 10



// Menu constants
//_____________________________________________________________________________________________________

// The following values are mapped to the server values and NOT to be changed

#define MEALTYPE_ALL          0
#define MEALTYPE_BREAKFAST    1
#define MEALTYPE_BRUNCH       2
#define MEALTYPE_MORNINGTEA   3
#define MEALTYPE_LUNCH        4
#define MEALTYPE_DINNER       5
#define MEALTYPE_AFTERNOONTEA 6
#define MEALTYPE_SUPPER       7

// The following values are to be changed based on which two meal types are selected by the restaurants
// while entering menu items on the sever. The values are to be changed to one of the 7 meal typed defined
// above

#define MEALTYPE1 MEALTYPE_LUNCH
#define MEALTYPE2 MEALTYPE_DINNER



// Google analytics account ID
//_____________________________________________________________________________________________________

// Create a google analytics account and mention the ID here. To maintain the analytics in a single 
// account, mention the same ID in all versions of the app. To maintain separate analytics for each app
// create a separate profiles and change this ID accordingly

#define GOOGLEACCOUNTID @"UA-26249029-1"



// Facebook ID and like message
//_____________________________________________________________________________________________________

// 1. Create a Facebook app under developer.facebook.com. Update the app ID below
// 1. Go to project -> info -> URL Types -> URL Schemes -> Enter the new app ID in the following 
//    format: fb[facebookAppId]
// 2. Update the app bundle ID (com.indavest.[application name]) in the app settings on facebook

#define FACEBOOKAPID @"240127832701061"

#define FACEBOOKSHARELINK @"http://www.emunching.com/"

#define FACEBOOKSHARENAME @"I just tried this dish at Besito and it is delicious!"

// While we set @message, Facebook's revised policy does not allow setting this and hence the
// "Say something about this... " textbox will remain empty
#define FACEBOOKSHAREMESSAGE @"This is absolutely fabulous!"



// Contact Us constants
//_____________________________________________________________________________________________________

#define CALLUSTEXT @"Call Besito?"


// Branding and version strings
//_____________________________________________________________________________________________________

#define RESTAURANTBRANDING @"Besito"

#define EMUNCHINGBRANDING @"powered by eMunching"

#define APPVERSION @"version 1.0"







// General instructions
//_____________________________________________________________________________________________________

// When uploading data to the server, the following will yield the best results in the app

// 1. The images must be of type PNG
// 2. The images must not have transparent areas
// 3. File names of images(For 'menu categories' and 'menu items') should not have a space. This is 
//    essential for the images to appear correctly in Facebook 'likes'
// 4. The recommended size of images for each menu category is 37 x 37
// 5. The recommended sizes for images for each menu item - Image1:120x83, Image2:320x183, Image3:320x183
// 6. Phone numbers of restaurants should be mentioned with the country codes to dial directly from the app
// 7. Website, Facebook and Twitter links of the restaurant must start with 'http://'





