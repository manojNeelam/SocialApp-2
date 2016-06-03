//
//  TaxRatesXmlParser.m
//  XMLParse
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

#import "YoutubeXmlParser.h"

@interface YoutubeXmlParser()

@property(nonatomic, retain) NSMutableString *currentElementValue;
@property(nonatomic, retain) NSMutableArray *objectArray;
@property(nonatomic, retain) NSMutableDictionary *youTubeObjectDict;

@end

@implementation YoutubeXmlParser
@synthesize objectArray;
@synthesize youTubeObjectDict;

- (void)startXmlParsingWithDelegate:(id)aDelegate
{
    self.delegate =aDelegate;
    
    //give local xml url here
    //NSString * filePath = [[NSBundle mainBundle] pathForResource:@"Tax_Rates" ofType:@"xml"];
    //NSURL * fileURL = [NSURL fileURLWithPath:filePath];
    //NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:fileURL];
    
    //NSURL *url = [[NSURL alloc] initWithString:@"http://www.syntelinc.com/xml/youtube.xml"];
    //NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    //[xmlParser setDelegate:self];
    //[xmlParser parse];
    objectArray = [[NSMutableArray alloc] init];
    
//UCGZnmQhq2Y3nJcHG3O8XGQg
    
    //https://www.googleapis.com/youtube/v3/channels?id=UC&key=AIzaSyAetJQGAkFnVsxbNxkYztNRls_niYaxCi0&part=snippet
    
    //https://www.googleapis.com/youtube/v3/channels?part=contentDetails,snippet&forUsername=Apple&key=AIzaSyAetJQGAkFnVsxbNxkYztNRls_niYaxCi0
    
    
    NSURL *baseURL=[NSURL URLWithString:@"https://gdata.youtube.com/feeds/mobile/users/syntel/uploads?v=2&alt=jsonc&start-index=1&max-results=50&orderby=published"];
    
    NSLog(@" login url = %@",baseURL);
    NSError *error = nil;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];
    NSURLResponse *resposnse = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&resposnse
                                                     error:&error];
    if(error)
    {
        [self.delegate youtubeXmlParseringFailWithError:error];
        return ;
    }
    
    NSMutableDictionary *responseDict;
    if(data)
    {
        responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    }
    
    NSArray *array = [[responseDict valueForKey:@"data"]valueForKey:@"items"];
    
    for (NSDictionary *tempDict in array)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        [dict setObject:[tempDict valueForKey:@"title"] forKey:@"title"];
        [dict setObject:[[tempDict valueForKey:@"player"] valueForKey:@"mobile"] forKey:@"link"];
        [dict setObject:[[tempDict valueForKey:@"thumbnail"] valueForKey:@"sqDefault"] forKey:@"image"];
        
        
        NSRange range = [[tempDict valueForKey:@"updated"] rangeOfString:@"T"];
        if (range.location != NSNotFound)
        {
            NSString *subString =  [[tempDict valueForKey:@"updated"] substringToIndex:range.location];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSDate *date = [dateFormatter dateFromString:subString];
            [dateFormatter setDateFormat:@"dd MMM YYYY"];
            NSString *dateString = [dateFormatter stringFromDate:date];
            [dict setObject:[NSString stringWithFormat:@"%@",dateString] forKey:@"pubDate"];

            
        }
        else
        {
            [dict setObject:[NSString stringWithFormat:@"%@",@""] forKey:@"pubDate"];
        }

        [self.objectArray addObject:dict];
    }
    
    [self.delegate youtubeXmlParseringWithResponse:self.objectArray];

}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"item"])
    {
        youTubeObjectDict = [[NSMutableDictionary alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if(!self.currentElementValue)
        self.currentElementValue = [[NSMutableString alloc] initWithString:string];
    else
        [self.currentElementValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"item"])
    {
        [self.objectArray addObject:self.youTubeObjectDict];
        youTubeObjectDict = nil;
    }
    else if([elementName isEqualToString:@"title"])
    {
        [self.youTubeObjectDict setObject:self.currentElementValue forKey:@"title"];
    }
    else if([elementName isEqualToString:@"link"])
    {
        [self.youTubeObjectDict setObject:self.currentElementValue forKey:@"link"];
    }
    else if([elementName isEqualToString:@"image"])
    {
        [self.youTubeObjectDict setObject:self.currentElementValue forKey:@"image"];
    }
    else if([elementName isEqualToString:@"pubDate"])
    {
        [self.youTubeObjectDict setObject:self.currentElementValue forKey:@"pubDate"];
    }
    
    self.currentElementValue = nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [self.delegate youtubeXmlParseringFailWithError:parseError];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.delegate youtubeXmlParseringWithResponse:self.objectArray];
    
}




@end
