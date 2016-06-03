//Like. Follow. Interact. Stay Engaged with Syntel

/**
 Detect iphone 5 and iphone 4
 */
//#define IS_IPHONE ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )
//#define IS_IPOD   ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)

//#define IS_IPHONE_05 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0f)


/**
 If defined this constant enables logging output for DebugLog Macro
 */
#define PRINT_LOGS
/**
 Used to print debugging output
 */
#ifdef PRINT_LOGS
#   define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DebugLog(...)
#endif


//#if DEBUG_LOG 
//#define NSLog(s, ...) NSLog(s, ##__VA_ARGS__)
//#else
//#define NSLog(s, ...)
//#endif


/*#define LocalizedString(key) \
[[NSDictionary dictionaryWithContentsOfFile:[AppContext getLangaugeBundle]] valueForKey:key]


#define KYLocalizedString(key, comment) \
[[[NSBundle mainBundle] localizedStringForKey:(key) value:nil table:nil] isEqualToString:(key)] ? \
[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:@"KYLocalizable"] : \
[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

#define LocalizedString(key) \
[[[NSDictionary dictionaryWithContentsOfFile:[AppContext getLangaugeBundle]] valueForKey:key] length] > 0 ? \
[[NSDictionary dictionaryWithContentsOfFile:[AppContext getLangaugeBundle]] valueForKey:key] : \
key

*/

/**
 Used to print normal logging output which you want always to be present while execution. This should be used very rarely.
 */
#define NormalLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#pragma mark - Convenience Constants

/**
 Easily access the Projects AppDelegate object from anywhere
 */
#define APP_DELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#define iOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#define UI_DEVICE [UIDevice currentDevice]


//Amar changes

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)





#pragma mark - Color Utils

/**
 Create UIColor Objects from RGB values where max value of each color compoenent  is 255.
 */
#define ColorWithRGB(r,g,b)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

/**
 Create UIColor Objects from RGBA values where max value of each color compoenent is 255.
 */
#define ColorWithRGBA(r,g,b,a)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f]


#define ColorFromHEX(hexString) [UIColor colorWithHexString:hexString]

#define ClearColor [UIColor clearColor]

#pragma mark - Floating Point Comparision

/**
 Error tolerance for folating point comparision  
 */
#define EPSILON 1.0e-7


/**
 Compare two floating point numbers for equality.
 */
#define FltEquals(a, b) (fabs((a)-(b)) < EPSILON)


#define IOS_OLDER_THAN_6 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] < 6.0 )
#define IOS_NEWER_OR_EQUAL_TO_6 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= 6.0 )

#pragma mark - Runtime iOS Version Checking

/**
 Check for if current iOS system version to equal to a particular version, can be used for conditional coding by detecting system version at the the runtime.
 */
#define SystemVersionEqualTo(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

/**
 Check for if current iOS system version to greater than a particular version, can be used for conditional coding by detecting system version at the the runtime.
 */
#define SystemVersionGreaterThen(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

/**
 Check for if current iOS system version to greater than or equal to a particular version, can be used for conditional coding by detecting system version at the the runtime.
 */
#define SystemVersionGreaterThanOrEqualTo(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

/**
 Check for if current iOS system version to less than a particular version, can be used for conditional coding by detecting system version at the the runtime.
 */
#define SystemVersionLessThan(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

/**
 Check for if current iOS system version to less than or equal to a particular version, can be used for conditional coding by detecting system version at the the runtime.
 */
#define SystemVersionLessThanOrEqualTo(v)   ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//predicates string
// AND, OR, IN, NOT, ALL, ANY, SOME, NONE, LIKE, CASEINSENSITIVE, CI, MATCHES, CONTAINS, BEGINSWITH, ENDSWITH, BETWEEN, NULL, NIL, SELF, TRUE, YES, FALSE, NO, FIRST, LAST, SIZE, ANYKEY, SUBQUERY, CAST, TRUEPREDICATE, FALSEPREDICATE

