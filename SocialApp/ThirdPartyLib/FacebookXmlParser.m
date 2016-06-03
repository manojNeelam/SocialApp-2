
#import "FacebookXmlParser.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface FacebookXmlParser()

@property(nonatomic, retain) NSMutableString *currentElementValue;
@property(nonatomic, retain) NSMutableArray *objectArray;
@property(nonatomic, retain) NSMutableDictionary *facebookObjectDict;

@end

@implementation FacebookXmlParser
@synthesize objectArray;
@synthesize facebookObjectDict;

- (void)startXmlParsingWithDelegate:(id)aDelegate
{
    self.delegate =aDelegate;
    
    //https://fbcdn-sphotos-a-a.akamaihd.net/hphotos-ak-xap1/v/t1.0-9/9495_757958374251811_770412172407149245_n.jpg?oh=8075ebfb7a43fe4d1492d06c119fb951&oe=552E7ADC&__gda__=1429805553_7d7c51dee66657c85323b2057818216a
    //://www.facebook.com/feeds/page.php?id=250918001622520https&format=json
    //give local xml url here
    //NSString * filePath = [[NSBundle mainBundle] pathForResource:@"Tax_Rates" ofType:@"xml"];
    //NSURL * fileURL = [NSURL fileURLWithPath:filePath];
    //NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:fileURL];
    
    //NSString *urlStr = @"https://graph.facebook.com/Syntel/feed?access_token=758722117536358|d47d53ff89aa0c06d44cf921769c874f";
    
    //NSURL *webURL = [[NSURL alloc] initWithString:[webStr stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];

    
    //NSURL *url = [[NSURL alloc] initWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
                  //@"http://graph.facebook.com/Google/feed?access_token=758722117536358|d47d53ff89aa0c06d44cf921769c874f"];//@"http://www.facebook.com/feeds/page.php?format=atom10&id=250918001622520"];//250918001622520"];
   // NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
   // [xmlParser setDelegate:self];
   // [xmlParser parse];
    
    [self callFacebookLoginAPI:nil];
}


-(void)callFacebookLoginAPI:(NSDictionary *)params
{
    
   /* NSError *error;

    NSString *urlStr = @"https://graph.facebook.com/MuzikGarage/posts?access_token=758722117536358%7Cd47d53ff89aa0c06d44cf921769c874f";
    //@"https://graph.facebook.com/Syntel/feed?access_token=758722117536358|d47d53ff89aa0c06d44cf921769c874f";

    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSURL *Url=[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]; //@"http://babyappdev.azurewebsites.net/apiv1/service/facebook_login/"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
        if (!error) {
            
            
            NSError* errorJason;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"facebook_login response : %@",json);
            if (!errorJason) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([[json objectForKey:@"status"] boolValue])
                    {
                        // [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"userData"];
                        //[self performSegueWithIdentifier:@"HomeViewControllerSegue" sender:self];
                        
                       
                        
                    }
                });
            }else
            {
                NSLog(@"facebook_login error : %@",[errorJason localizedDescription]);
                
            }
            
            
        }
        else{
            NSLog(@"facebook_login error : %@",[error localizedDescription]);
        }
        
    }];
    
    [postDataTask resume];*/
    
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/250918001622520/feed"
                                  parameters:params
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        

        
        // Handle the result
    }];
    
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    objectArray = [[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"entry"])
    {
        facebookObjectDict = [[NSMutableDictionary alloc] init];
    }
    else if([elementName isEqualToString:@"link"])
    {
        [self.facebookObjectDict setObject:[attributeDict valueForKey:@"href"] forKey:@"link"];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(!self.currentElementValue)
        self.currentElementValue = [[NSMutableString alloc] initWithString:string];
    else
        [self.currentElementValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"entry"])
    {
        NSString *title = [self.facebookObjectDict valueForKey:@"title"];
        if(![title isEqualToString:@""])
        {
            [self.objectArray addObject:self.facebookObjectDict];
        }
        facebookObjectDict = nil;
    }
    else if([elementName isEqualToString:@"title"])
    {
        NSString *subString = [self.currentElementValue stringByReplacingOccurrencesOfString:@"&#x2019;" withString:@"'"];
        subString = [subString stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
        subString = [subString stringByReplacingOccurrencesOfString:@"&#x2018;" withString:@"'"];
        subString = [subString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        subString = [subString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        
        //Amar update on may 2014
        subString = [subString stringByReplacingOccurrencesOfString:@"&#x2013;" withString:@""];
        subString = [subString stringByReplacingOccurrencesOfString:@"&#x2122;" withString:@""];
        
        [self.facebookObjectDict setObject:subString forKey:@"title"];
    }
    else if([elementName isEqualToString:@"content"])
    {
        NSString *subString = [self.currentElementValue stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSRange range = [subString rangeOfString:@"<imgclass=\"img\"src=\""];
        if (range.location != NSNotFound)
        {
            subString =  [subString substringFromIndex:range.location + range.length];
            range = [subString rangeOfString:@"\""];
            if (range.location != NSNotFound)
            {
                subString = [subString substringToIndex:range.location];
            }
        }
        else
        {
            subString = @"";
        }
        range = [subString rangeOfString:@"s130x130"];
        if (range.location != NSNotFound)
        {
            subString = [subString stringByReplacingOccurrencesOfString:@"s130x130"
                                                             withString:@""];
        }
        else
        {
            subString = [subString stringByReplacingOccurrencesOfString:@"s130x130"
                                                             withString:@""];
        }
        
        range = [subString rangeOfString:@".php"];
        if (range.location != NSNotFound)
        {
            subString = @"";
        }
        
        //link
        
        [self.facebookObjectDict setObject:subString forKey:@"image"];
    }
    
    //https://fbcdn-sphotos-a-a.akamaihd.net/hphotos-ak-xap1/v/t1.0-9/9495_757958374251811_770412172407149245_n.jpg?oh=8075ebfb7a43fe4d1492d06c119fb951&oe=552E7ADC&__gda__=1429805553_7d7c51dee66657c85323b2057818216a
    
    else if([elementName isEqualToString:@"published"])
    {
        NSRange range = [self.currentElementValue rangeOfString:@"T"];
        if (range.location != NSNotFound)
        {
            NSString *subString =  [self.currentElementValue substringToIndex:range.location];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSDate *date = [dateFormatter dateFromString:subString];
            [dateFormatter setDateFormat:@"dd MMM YYYY"];
            NSString *dateString = [dateFormatter stringFromDate:date];

            [self.facebookObjectDict setObject:[NSString stringWithFormat:@"%@",dateString] forKey:@"pubDate"];

        }
        else
        {
            [self.facebookObjectDict setObject:[NSString stringWithFormat:@"%@",@""] forKey:@"pubDate"];
        }
    }
    
    self.currentElementValue = nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [self.delegate FacebookXmlParsingFailWithError:parseError];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.delegate FacebookXmlParsingWithResponse:self.objectArray];
    
}


@end
