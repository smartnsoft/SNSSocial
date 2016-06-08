//
//  SNSFacebook.m
//  SNSSocial-Sample
//
//  Created by Guillaume Bonnin on 15/04/2015.
//  Copyright (c) 2015 Smart&Soft. All rights reserved.
//

#import "SNSFacebook.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation SNSFacebook

#pragma mark - Application -

+ (void)activateApplication
{
    [FBSDKAppEvents activateApp];
}

+ (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

#pragma mark - Facebook Completion -

+ (void)callCompletionBlock:(SNSFacebookCompletionBlock)completionBlock withResult:(id)result
{
    if (completionBlock != nil)
    {
        completionBlock(result, nil);
    }
}

+ (void)callCompletionBlock:(SNSFacebookCompletionBlock)completionBlock withError:(NSError *)error
{
    if (completionBlock != nil)
    {
        completionBlock(nil, error);
    }
}

@end
