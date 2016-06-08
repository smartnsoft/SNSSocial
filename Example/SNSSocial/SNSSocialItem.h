//
//  SNSSocialItem.h
//  SNSSocial
//
//  Created by Jean-Charles SORIN on 26/05/2016.
//  Copyright © 2016 Jean-Charles SORIN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNSSocialItem : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, copy) void (^completion)(void);

+(instancetype)socialTestItemNamed:(NSString*)named completion:(void(^)(void))completion;

@end
