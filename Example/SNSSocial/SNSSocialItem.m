//
//  SNSSocialItem.m
//  SNSSocial
//
//  Created by Jean-Charles SORIN on 26/05/2016.
//  Copyright © 2016 Jean-Charles SORIN. All rights reserved.
//

#import "SNSSocialItem.h"

@implementation SNSSocialItem

+(instancetype)socialTestItemNamed:(NSString *)name completion:(void (^)(void))completion
{
    SNSSocialItem *item = [[SNSSocialItem alloc] init];
    item.name = name;
    item.completion = completion;
    return item;
}

@end
