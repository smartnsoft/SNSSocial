//
//  SNSFacebookLogin.h
//  SNSSocial-Sample
//
//  Created by Guillaume Bonnin on 16/04/2015.
//  Copyright (c) 2015 Smart&Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SNSFacebook.h"

extern NSString * _Nonnull const SNSFacebookUserInfoId;
extern NSString * _Nonnull const SNSFacebookUserInfoName;
extern NSString * _Nonnull const SNSFacebookUserInfoFirstName;
extern NSString * _Nonnull const SNSFacebookUserInfoMiddleName;
extern NSString * _Nonnull const SNSFacebookUserInfoLastName;
extern NSString * _Nonnull const SNSFacebookUserInfoEmail;
extern NSString * _Nonnull const SNSFacebookUserInfoWebsite;
extern NSString * _Nonnull const SNSFacebookUserInfoAgeRange;
extern NSString * _Nonnull const SNSFacebookUserInfoBirthday;
extern NSString * _Nonnull const SNSFacebookUserInfoGender;
extern NSString * _Nonnull const SNSFacebookUserInfoAbout;
extern NSString * _Nonnull const SNSFacebookUserInfoBio;
extern NSString * _Nonnull const SNSFacebookUserInfoRelationshipStatus;
extern NSString * _Nonnull const SNSFacebookUserInfoHometown;

extern NSString * _Nonnull const SNSFacebookUserInfoPicture;
extern NSString * _Nonnull const SNSFacebookUserInfoPictureSmall;
extern NSString * _Nonnull const SNSFacebookUserInfoPictureAlbum;
extern NSString * _Nonnull const SNSFacebookUserInfoPictureLarge;
extern NSString * _Nonnull const SNSFacebookUserInfoPictureSquare;

/**
 *  Manages user connection to facebook
 *
 *  The connection can uses three modes
 *      - Connection with native facebook iOS
 *      - Connection with the Facebook application, if it's installed
 *      - Connection with Safari
 */
@interface SNSFacebookLogin : NSObject

#pragma mark - Login -

/**
 *  Connects the user to Facebook (without specific permissions)
 *
 *  @param viewController   view controller which calls facebook logger (can be nil)
 *  @param completionBlock  calls the block after login (returns an error if login failed)
 */
+ (void)loginFromViewController:(nullable UIViewController *)viewController
                     completion:(nullable SNSFacebookCompletionBlock)completionBlock;

/**
 *  Connects the user to Facebook with read permissions
 *
 *  @param permissions      an array of required read permissions (NSString *)
 *  @param viewController   view controller which calls facebook logger (can be nil)
 *  @param completionBlock  calls the block after login (returns an error if login failed)
 */
+ (void)loginWithReadPermissions:(nullable NSArray *)permissions
              fromViewController:(nullable UIViewController *)viewController
                      completion:(nullable SNSFacebookCompletionBlock)completionBlock;

/**
 *  Connects the user to Facebook with read permissions
 *
 *  @param permissions      an array of required publish permissions (NSString *)
 *  @param viewController   view controller which calls facebook logger (can be nil)
 *  @param completionBlock  calls the block after login (returns an error if login failed)
 */
+ (void)loginWithPublishPermissions:(nullable NSArray *)permissions
                 fromViewController:(nullable UIViewController *)viewController
                         completion:(nullable SNSFacebookCompletionBlock)completionBlock;

/**
 *  Checks if the user is connected
 *
 *  @return true if the user is connected
 */
+ (BOOL)isLogged;

/**
 *  Disconnects the user
 */
+ (void)logout;

#pragma mark - Permissions -

/**
 *  Checks if the user logged has a specific permission
 *
 *  @param permission   permission to test
 *  @return             true if permission granted
 */
+ (BOOL)hasPermission:(nullable NSString *)permission;

/**
 *  Checks if the user logged has specific permissions
 *
 *  @param permissions  an array of permissions to test
 *  @return             true if all permissions granted
 */
+ (BOOL)hasPermissions:(nullable NSArray *)permissions;

#pragma mark - User informations -

/**
 *  Gets informations about the current user connected (calls errorBlock if there is no connected user or missing permissions)
 *  Note: You can use logToRetrieveUserInformations:fromViewController:andCompletionBlock: instead to let SNSFacebook ensures login and permissions
 *
 *  @param userInformations     array with required user informations
 *  @param completionBlock      calls the block with result or error
 *  @return                     dictionary with requested user informations (returns an error if request failed)
 */
+ (void)retrieveCurrentUserInformations:(nullable NSArray *)userInformations
                             completion:(nullable SNSFacebookCompletionBlock)completionBlock;

/**
 *  Retrieves user's informations (tries to log a new user and asks the missing permissions if needed)
 *
 *  @param userInformations     array with required user informations
 *  @param viewController       view controller which calls facebook getInformations (can be nil)
 *  @param completionBlock      calls the block with result or error
 *  @return                     dictionary with requested user informations (returns an error if request failed)
 */
+ (void)logToRetrieveUserInformations:(nullable NSArray *)userInformations
                   fromViewController:(nullable UIViewController *)viewController
                           completion:(nullable SNSFacebookCompletionBlock)completionBlock;

@end
