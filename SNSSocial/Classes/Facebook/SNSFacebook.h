//
//  SNSFacebook.h
//  SNSSocial-Sample
//
//  Created by Guillaume Bonnin on 15/04/2015.
//  Copyright (c) 2015 Smart&Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^SNSFacebookCompletionBlock)(id _Nullable result, NSError * _Nullable error);

typedef NS_ENUM(NSInteger, SNSFacebookErrorCode) {
    SNSFacebookErrorCodeActionCanceled,
    SNSFacebookErrorCodeInvalidAttribute,
    SNSFacebookErrorCodeInvalidPermissions
};

/**
 *  Core of the SNSFacebook (manages relation between Facebook and application)
 */
@interface SNSFacebook : NSObject

/**
 *  Activates Facebook SDK and enables application to receive Facebook delegate events (must be called in the "applicationDidBecomeActive" method of your AppDelegate)
 */
+ (void)activateApplication;

/**
 * Finishes launching of facebook (must be called in the associated method of the AppDelegate)
 *
 *  @return true if no error occured
 */
+ (BOOL)application:(nonnull UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions;

/**
 *  Open the url from a facebook query (must be called in the "openURL" method of the AppDelegate)
 *
 *  @return true if no error occured
 */
+ (BOOL)application:(nonnull UIApplication *)application
            openURL:(nonnull NSURL *)url
  sourceApplication:(nullable NSString *)sourceApplication
         annotation:(nullable id)annotation;

+ (void)callCompletionBlock:(nullable SNSFacebookCompletionBlock)completionBlock
                 withResult:(nullable id)result;

+ (void)callCompletionBlock:(nullable SNSFacebookCompletionBlock)completionBlock
                  withError:(nullable NSError *)error;

@end
