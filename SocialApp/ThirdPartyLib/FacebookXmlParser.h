//
//  FacebookXmlParser.h
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//


@protocol FacebookXmlParserDelegate <NSObject>

- (void)FacebookXmlParsingFailWithError:(NSError *)error;
- (void)FacebookXmlParsingWithResponse:(NSMutableArray *)array;

@end

@interface FacebookXmlParser : NSObject<NSXMLParserDelegate>

@property(nonatomic, retain) id<FacebookXmlParserDelegate> delegate;

- (void)startXmlParsingWithDelegate:(id)aDelegate;

@end
