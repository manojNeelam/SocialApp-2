//
//  jobXmlParser.m
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

#import "JobXmlParser.h"
#import "JobData.h"
#import "JobsCD.h"
#import "JobCoreSerice.h"

@interface JobXmlParser()
{
    JobCoreSerice *jobcoreService;
    
}
@property(nonatomic, retain) NSMutableString *currentElementValue;
@property(nonatomic, retain) NSMutableArray *objectArray;
@property(nonatomic, retain) NSMutableDictionary *eventObjectDict;

@end

@implementation JobXmlParser
@synthesize objectArray;
@synthesize eventObjectDict;

- (void)startXmlParsingWithDelegate:(id)aDelegate
{
    self.delegate =aDelegate;
    
    jobcoreService = [JobCoreSerice defaultInstance];
    
    //give local xml url here
    //NSString * filePath = [[NSBundle mainBundle] pathForResource:@"Tax_Rates" ofType:@"xml"];
    //NSURL * fileURL = [NSURL fileURLWithPath:filePath];
    //NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:fileURL];
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://www.syntelinc.com/xml/jobs.xml"];
    NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [xmlParser setDelegate:self];
    [xmlParser parse];
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
    if([elementName isEqualToString:@"item"])
    {
        eventObjectDict = [[NSMutableDictionary alloc] init];
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
        JobData *jobData = [[JobData alloc] initwithDictionary:self.eventObjectDict];
        
        [self.objectArray addObject:jobData];
        eventObjectDict = nil;
    }
    else if([elementName isEqualToString:@"title"])
    {
        [self.eventObjectDict setObject:self.currentElementValue forKey:@"title"];
    }
    else if([elementName isEqualToString:@"link"])
    {
        [self.eventObjectDict setObject:self.currentElementValue forKey:@"link"];
    }
    else if([elementName isEqualToString:@"image"])
    {
        [self.eventObjectDict setObject:self.currentElementValue forKey:@"image"];
    }
    else if([elementName isEqualToString:@"pubDate"])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:self.currentElementValue];
        if(date==nil)
        {
            [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
            date = [dateFormatter dateFromString:self.currentElementValue];
        }
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"dd MMM YYYY"];
        NSString *dateString = [dateFormatter1 stringFromDate:date];
        [self.eventObjectDict setObject:[NSString stringWithFormat:@"%@",dateString] forKey:@"pubDate"];
    }
    
    
    
    self.currentElementValue = nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [self.delegate jobXmlParseringFailWithError:parseError];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [jobcoreService saveJobListFromJson:self.objectArray];
    
    [self.delegate jobXmlParseringWithResponse:self.objectArray];
    
}


@end
