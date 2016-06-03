//
//  TaxRatesGlobals.h
//  KPMGTax
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

#ifndef KPMGTax_TaxRatesGlobals_h
#define KPMGTax_TaxRatesGlobals_h



#endif

typedef enum
{
    kFacebookSelected,
    kTwitterSelected,
    kNothingSelected
}CurrentlySelectedItem;

CurrentlySelectedItem currentlySelectedItem;

#define CONDITION_PICKER_FOR_CONDITION1_TAG 501
#define CONDITION_PICKER_FOR_CONDITION2_TAG 502


#define POPV_VIEW_CONTROLLER               @"POPVIEWCONTROLLER"
#define LOADING_MSG               @"Please Wait.."
#define NETWORK_CONNECTION_ERROR_MESSAGE               @"Please Check your network connection!!"
#define NETWORK_CONNECTION_TITLE               @"Network Error"

#define FONTSIZE_TITLE      16
#define FONTSIZE_NORMAL     16
#define FONTSIZE_SUB_TITLE  12

#define IPAD_FONTSIZE_TITLE      18
#define IPAD_FONTSIZE_NORMAL     18
#define IPAD_FONTSIZE_SUB_TITLE  14

//#define FONTSIZE_TITLE      20
//#define FONTSIZE_NORMAL     24
//#define FONTSIZE_SUB_TITLE  32


#define LIKE_LINKDEIN_LINK @"https://www.linkedin.com/company/4280?trk=tyah&trkInfo=tarId%3A1419679159174%2Ctas%3Asyntel%2Cidx%3A2-1-4"


#define LIKE_FACEBOOK_LINK @"http://www.facebook.com/plugins/likebox.php?href=http%3A%2F%2Fwww.facebook.com%2Fsyntel&width=292&height=290&show_faces=true&colorscheme=light&stream=false&show_border=true&header=true&appId=590504340982217"

#define LINKDEIN_COMPANY_UPDATES_URL @"https://api.linkedin.com/v1/companies/4280/updates"

#define SYNTEL_PAGE_ID               @"28153302"

#define NORMAL_FONT(s)                      [UIFont fontWithName:@"Helvetica" size:s]
//#define TITLE_FONT(s)                  [    UIFont fontWithName:@"Helvetica" size:s]
//#define SUB_TITLE_FONT(s)                   [UIFont fontWithName:@"Helvetica" size:s]

#define NORMAL_FONT_BOLD(s)                [UIFont fontWithName:@"Helvetica-Bold" size:s]
//#define TITLE_FONT_BOLD(s)                 [UIFont fontWithName:@"Helvetica-Bold" size:s]
//#define SUB_TITLE_FONT_BOLD(s)             [UIFont fontWithName:@"Helvetica-Bold" size:s]

