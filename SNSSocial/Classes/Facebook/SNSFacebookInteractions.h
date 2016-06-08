//
//  SNSFacebookInteractions.h
//  SNSSocial-Sample
//
//  Created by Guillaume Bonnin on 17/04/2015.
//  Copyright (c) 2015 Smart&Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FBSDKShareKit/FBSDKShareKit.h>

#import "SNSFacebook.h"

/**
 *  Manages facebook interactions (share, like etc.)
 *
 *  Notes: Each methods tries to login user and and asks missing permissions if needed
 */
@interface SNSFacebookInteractions : NSObject <FBSDKSharingDelegate>

#pragma mark - Share -

/**
 *  Posts a status on the wall's user without using dialog
 *
 *  @param message                  message at posted, required
 *  @param completionBlock          calls the block after action (returns an error if share failed)
 */
+ (void)postStatusWithMessage:(nonnull NSString *)message completion:(nullable SNSFacebookCompletionBlock)completionBlock;

/**
 *  Opens dialog to post a status
 *
 *  @param message                  message at posted, required
 *  @param parentViewController     a view controller which will display the dialog (use for sharing with social framework)
 *  @param completionBlock          calls the block after action (returns an error if share failed)
 */
+ (void)postStatusFromParentViewController:(nullable UIViewController *)parentViewController
                                completion:(nullable SNSFacebookCompletionBlock)completionBlock;

/**
 *  Posts a link on the wall's user without using dialog
 *
 *  @param url              a url's link to share (ex : htpp://www.google.fr), the parameter is required
 *  @param title            a title, the parameter is optional
 *  @param description      a description, the parameter is optional
 *  @param pictureUrl       a url's picture, the parameter is optional
 *  @param completionBlock  calls the block after action (returns an error if share failed)
 */
+ (void)postLink:(nonnull NSString *)link
       withTitle:(nullable NSString*)title
     description:(nullable NSString*)description
      pictureUrl:(nullable NSString*)pictureUrl
      completion:(nullable SNSFacebookCompletionBlock)completionBlock;

/**
 *  Posts a link on the wall's user using a dialog
 *
 *  @param url                      a url's link to share (ex : htpp://www.google.fr), the parameter is required
 *  @param title                    a title, the parameter is optional
 *  @param description              a description, the parameter is optional
 *  @param url                      a url's link to share (ex : htpp://www.google.fr), the parameter is required
 *  @param pictureUrl               a url's picture, the parameter is optional
 *  @param parentViewController     a view controller which will display the dialog (use for sharing with social framework)
 *  @param completionBlock          calls the block after action (returns an error if share failed)
 */
+ (void)postLink:(nonnull NSString *)link
       withTitle:(nullable NSString*)title
     description:(nullable NSString*)description
      pictureUrl:(nullable NSString*)pictureUrl
parentController:(nullable UIViewController *)parentViewController
      completion:(nullable SNSFacebookCompletionBlock)completionBlock;

/**
 *  Posts a photo with caption on the wall's user without using a dialog
 *
 *  @param photos                   a photo to share
 *  @param caption                  description of the photo
 *  @param completionBlock          calls the block after action (returns an error if share failed)
 */
+ (void)postPhoto:(nonnull UIImage *)photo
      withCaption:(nullable NSString *)caption
       completion:(nullable SNSFacebookCompletionBlock)completionBlock;

/**
 *  Posts a photo on the wall's user using a dialog
 *  (Doesn't work if the native Facebook application is not installed on the device)
 *
 *  @param photo                    a photo to share
 *  @param parentViewController     a view controller which will display the dialog (use for sharing with social framework)
 *  @param completionBlock          calls the block after action (returns an error if share failed)
 */
+ (void)postPhoto:(nonnull UIImage *)photo fromParentViewController:(nullable UIViewController *)parentViewController completion:(nullable SNSFacebookCompletionBlock)completionBlock
__attribute__ ((deprecated("doesn't work without native facebook application, prefer use postPhoto:withCaption:andCompletionBlock: instead")));

/**
 *  Posts many photos on the wall's user using a dialog
 *  (Doesn't work if the native Facebook application is not installed on the device)
 *
 *  @param photos                   an array of photo to share
 *  @param parentViewController     a view controller which will display the dialog (use for sharing with social framework)
 *  @param completionBlock          calls the block after action (returns an error if share failed)
 */
+ (void)postPhotos:(nonnull NSArray *)photos fromParentViewController:(nullable UIViewController *)parentViewController completion:(nullable SNSFacebookCompletionBlock)completionBlock
__attribute__ ((deprecated("doesn't work without native facebook application, prefer use postPhoto:withCaption:andCompletionBlock: instead")));

#pragma mark - Like -

/**
 *  Checks if an object is liked by the user (of the current FB session)
 *
 *  @param objectId         id of the object
 *  @param completionBlock  calls the block after action (returns @(true)/@(false) or an error if method failed)
 */
+ (void)isObjectLiked:(nonnull NSString *)objectId completion:(nullable SNSFacebookCompletionBlock)completionBlock;

/**
 *  Likes (or dislikes) a facebook object (status, link etc.)
 *
 *  @param objectId         id of the object
 *  @param completionBlock  calls the block after action (returns @(true) if object is now liked or @(false) or an error if like failed)
 */
+ (void)likeWithObject:(nonnull NSString *)objectId completion:(nullable SNSFacebookCompletionBlock)completionBlock;

@end
