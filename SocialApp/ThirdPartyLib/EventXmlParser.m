//
//  EventXmlParser.m
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

#import "EventXmlParser.h"
#import "EventsCD.h"
#import "EventCoreService.h"
#import "EventData.h"

@interface EventXmlParser()
{
    EventCoreService *eventCoreService;
    
}
@property(nonatomic, retain) NSMutableString *currentElementValue;
@property(nonatomic, retain) NSMutableArray *objectArray;
@property(nonatomic, retain) NSMutableDictionary *eventObjectDict;

@end

@implementation EventXmlParser
@synthesize objectArray;
@synthesize eventObjectDict;

- (void)startXmlParsingWithDelegate:(id)aDelegate
{
    self.delegate =aDelegate;
    
    eventCoreService = [EventCoreService defaultInstance];
    
    //give local xml url here
    //NSString * filePath = [[NSBundle mainBundle] pathForResource:@"Tax_Rates" ofType:@"xml"];
    //NSURL * fileURL = [NSURL fileURLWithPath:filePath];
    //NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:fileURL];
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://www.syntelinc.com/xml/events.xml"];
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
        EventData *eventdata =[[EventData alloc] initwithDictionary:self.eventObjectDict];
        [self.objectArray addObject:eventdata];
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
    else if([elementName isEqualToString:@"guid"])
    {
        [self.eventObjectDict setObject:self.currentElementValue forKey:@"guid"];
    }
    else if([elementName isEqualToString:@"pubDate"])
    {
        [self.eventObjectDict setObject:self.currentElementValue forKey:@"pubDate"];
    }
    else if([elementName isEqualToString:@"image"])
    {
        [self.eventObjectDict setObject:self.currentElementValue forKey:@"image"];
    }

    
    
    self.currentElementValue = nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [self.delegate eventXmlParseringFailWithError:parseError];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
    [eventCoreService saveEventsListFromJson:self.objectArray];
    
    [self.delegate eventXmlParseringWithResponse:self.objectArray];
    
}


@end
