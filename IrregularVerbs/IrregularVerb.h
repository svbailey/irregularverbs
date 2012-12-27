//
//  IrregularVerb.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 20/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IrregularVerb : NSObject

@property (nonatomic) BOOL randomOrder;
@property (nonatomic) int level;
@property (nonatomic, readonly) NSString *simple;
@property (nonatomic, readonly) NSString *translation;
@property (nonatomic, readonly) NSString *past;
@property (nonatomic, readonly) NSString *participle;

- (void)change;

+ (void)resetVerbsList;

@end
