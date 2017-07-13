// The MIT License (MIT)
//
// Copyright (c) 2015-2017 Smart&Soft
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
