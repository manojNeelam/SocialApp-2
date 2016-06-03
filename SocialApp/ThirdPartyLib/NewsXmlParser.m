//
//  NewsXmlParser.m
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

#import "NewsXmlParser.h"
#import "NewsData.h"
#import "NewsCD.h"
#import "NewsCoreService.h"

@interface NewsXmlParser()
{
    NewsCoreService *newsCoreSerice;
}
@property(nonatomic, retain) NSMutableString *currentElementValue;
@property(nonatomic, retain) NSMutableArray *objectArray;
@property(nonatomic, retain) NSMutableDictionary *newsObjectDict;

@end

@implementation NewsXmlParser
@synthesize objectArray;
@synthesize newsObjectDict;

- (void)startXmlParsingWithDelegate:(id)aDelegate
{
    self.delegate =aDelegate;
    
    newsCoreSerice = [NewsCoreService defaultInstance];
    
    //give local xml url here
    //NSString * filePath = [[NSBundle mainBundle] pathForResource:@"Tax_Rates" ofType:@"xml"];
    //NSURL * fileURL = [NSURL fileURLWithPath:filePath];
    //NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:fileURL];
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://apps.shareholder.com/rss/rss.aspx?channels=6323&companyid=SYNT&sh_auth=742451001%2E0%2E0%2E61558bc0f81d3e8be057e8061e18fb4c"];
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
        newsObjectDict = [[NSMutableDictionary alloc] init];
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
        NewsData *newsData = [[NewsData alloc] initwithDictionary:self.newsObjectDict];
        [self.objectArray addObject:newsData];
        newsObjectDict = nil;
    }
    else if([elementName isEqualToString:@"title"])
    {
        [self.newsObjectDict setObject:self.currentElementValue forKey:@"title"];
    }
    else if([elementName isEqualToString:@"link"])
    {
        [self.newsObjectDict setObject:self.currentElementValue forKey:@"link"];
    }
    else if([elementName isEqualToString:@"guid"])
    {
        [self.newsObjectDict setObject:self.currentElementValue forKey:@"guid"];
    }
    else if([elementName isEqualToString:@"pubDate"])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
        NSDate *date = [dateFormatter dateFromString:self.currentElementValue];
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"dd MMM YYYY"];
        NSString *dateString = [dateFormatter1 stringFromDate:date];
        [self.newsObjectDict setObject:dateString forKey:@"pubDate"];
    }
    else if([elementName isEqualToString:@"description"])
    {
        [self.newsObjectDict setObject:self.currentElementValue forKey:@"description"];
    }

    
    self.currentElementValue = nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [self.delegate newsXmlParseringFailWithError:parseError];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [newsCoreSerice saveNewsListFromJson:self.objectArray];
    
    
    [self.delegate newsXmlParseringWithResponse:self.objectArray];
}


@end
