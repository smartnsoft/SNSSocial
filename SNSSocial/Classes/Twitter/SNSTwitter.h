//
//  SNSTwitter.h
//  SNSSocial-Sample
//
//  Created by Guillaume Bonnin on 15/04/2015.
//  Copyright (c) 2015 Smart&Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^SNSTwitterCompletionBlock)(id _Nullable result,  NSError * _Nullable error);

typedef NS_ENUM(NSInteger, SNSTwitterErrorCode) {
    SNSTwitterErrorCodeMissingConnection,
    SNSTwitterErrorCodeTweetFailed,
    SNSTwitterErrorCodeUploadDataFailed,
    SNSTwitterErrorCodeConnectionExpired
};

/**
 *  Core of the SNSTwitter (manages relation between Twitter and application)
 */
@interface SNSTwitter : NSObject

#pragma mark - Twitter Core -

/**
 *  Opens the URL from a twitter query (must be called in the "openURL" method of the AppDelegate)
 *
 *  @param completion block called after login (returns the userID of the client or an error)
 */
+ (void)openURL:(nonnull NSURL *)url;

#pragma mark - User Connection -

/**
 *  Tries to restore previous connection if exists and not expired (should be called after relaunch application)
 *
 *  @param completion block called after login (returns the userID of the client or an error)
 */
+ (void)tryRestoreConnectionWithCompletionBlock:(nullable SNSTwitterCompletionBlock)completionBlock;

/**
 *  Connects the user to its Twitter account
 *
 *  @param completion block called after login (returns the userID of the client or an error)
 */
+ (void)loginWithCompletionBlock:(nullable SNSTwitterCompletionBlock)completionBlock;

/**
 *  Disconnects the user
 */
+ (void)logout;

/**
 *  Checks if the user is connected
 *
 *  @return true if the user is connected
 */
+ (BOOL)isLogged;

#pragma mark - User Informations -

/**
 *  Gets the username of the current User (returns nil if there is no logged user)
 */
+ (nullable NSString *)getCurrentUserName;

/**
 *  Retrieves username (tries to log a new user if needed)
 *
 *  @param completion block called after login (returns the username of the client or an error)
 */
+ (void)retrieveUserNameWithCompletionBlock:(nullable SNSTwitterCompletionBlock)completionBlock;

/**
 *  Retrieves user profile picture (tries to log a new user if needed)
 *
 *  @param completion block called after login (returns the profile picture of the client or an error)
 */
+ (void)retrieveUserProfilePictureWithCompletionBlock:(nullable SNSTwitterCompletionBlock)completionBlock;

#pragma mark - Send a tweet -

/**
 *  Posts a tweet
 *  (Confirm share dialog appears if native sharing is available)
 *
 *  @param message                  the message to send
 *  @param parentViewController     a view controller which will display the dialog, nil for no dialog
 *  @param completionBlock          completion block called after login
 */
+ (void)postTweetWithMessage:(nullable NSString*)message
    fromParentViewController:(nullable UIViewController *)parentViewController
                  completion:(nullable SNSTwitterCompletionBlock)completionBlock;

/**
 *  Posts a tweet with coordinates
 *  (Confirm share dialog is not displayed)
 *
 *  @param message                  the message to send
 *  @param latitude                 the latitude of the tweet
 *  @param longitude                the longitude  of the tweet
 *  @param completionBlock          completion block called after login
 */
+ (void)postTweetWithMessage:(nullable NSString*)message
                    latitude:(nullable NSString*)latitude
                   longitude:(nullable NSString*)longitude
                  completion:(nullable SNSTwitterCompletionBlock)completionBlock;

/**
 *  Posts a tweet with a picture
 *  (Confirm share dialog is not displayed)
 *
 *  @param message                  the message to send
 *  @param picture                  attached picture
 *  @param completionBlock          completion block called after login
 */
+ (void)postTweetWithMessage:(nullable NSString *)message
                     picture:(nullable UIImage *)picture
                  completion:(nullable SNSTwitterCompletionBlock)completionBlock;

/**
 *  Posts a tweet with a picture and coordinates
 *  (Confirm share dialog is not displayed)
 *
 *  @param message                  the message to send
 *  @param picture                  attached picture
 *  @param latitude                 the latitude of the tweet
 *  @param longitude                the longitude  of the tweet
 *  @param completionBlock          completion block called after login
 */
+ (void)postTweetWithMessage:(nullable NSString *)message
                     picture:(nullable UIImage *)picture
                    latitude:(nullable NSString*)latitude
                   longitude:(nullable NSString*)longitude
                  completion:(nullable SNSTwitterCompletionBlock)completionBlock;

@end
