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

#import "SNSFacebookLogin.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation SNSFacebookLogin

#pragma mark - Login -

+ (void)loginFromViewController:(UIViewController *)viewController completion:(SNSFacebookCompletionBlock)completionBlock
{
    [SNSFacebookLogin loginWithReadPermissions:nil
                            fromViewController:viewController
                                    completion:completionBlock];
}

+ (void)loginWithReadPermissions:(NSArray *)permissions
              fromViewController:(UIViewController *)viewController
                      completion:(SNSFacebookCompletionBlock)completionBlock
{
    if ([SNSFacebookLogin isLogged] && [SNSFacebookLogin hasPermissions:permissions])
    {
        [SNSFacebook callCompletionBlock:completionBlock withResult:@"User already logged"];
        return;
    }
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logInWithReadPermissions:permissions
                        fromViewController:viewController
                                   handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
         if (error != nil)
         {
             [SNSFacebook callCompletionBlock:completionBlock
                                    withError:error];
         }
         else if (result.isCancelled)
         {
             [SNSFacebook callCompletionBlock:completionBlock
                                    withError:[NSError errorWithDomain:@"Login canceled"
                                                                  code:SNSFacebookErrorCodeActionCanceled
                                                              userInfo:nil]];
         }
         else if ([SNSFacebookLogin hasPermissions:permissions] == NO)
         {
             [SNSFacebook callCompletionBlock:completionBlock
                                    withError:[NSError errorWithDomain:@"Fail to authorize asked permissions"
                                                                  code:SNSFacebookErrorCodeInvalidPermissions
                                                              userInfo:nil]];
         }
         else
         {
             [SNSFacebook callCompletionBlock:completionBlock withResult:nil];
         }
     }];
}

+ (void)loginWithPublishPermissions:(NSArray *)permissions
                 fromViewController:(UIViewController *)viewController
                         completion:(SNSFacebookCompletionBlock)completionBlock
{
    if ([SNSFacebookLogin isLogged] && [SNSFacebookLogin hasPermissions:permissions])
    {
        [SNSFacebook callCompletionBlock:completionBlock withResult:@"User already logged"];
        return;
    }
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logInWithPublishPermissions:permissions
                           fromViewController:viewController
                                      handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
         if (error != nil)
         {
             [SNSFacebook callCompletionBlock:completionBlock
                                    withError:error];
         }
         else if (result.isCancelled)
         {
             [SNSFacebook callCompletionBlock:completionBlock
                                    withError:[NSError errorWithDomain:@"Login canceled"
                                                                  code:SNSFacebookErrorCodeActionCanceled
                                                              userInfo:nil]];
         }
         else if ([SNSFacebookLogin hasPermissions:permissions] == NO)
         {
             [SNSFacebook callCompletionBlock:completionBlock
                                    withError:[NSError errorWithDomain:@"Fail to authorize asked permissions"
                                                                  code:SNSFacebookErrorCodeInvalidPermissions
                                                              userInfo:nil]];
         }
         else
         {
             [SNSFacebook callCompletionBlock:completionBlock
                                   withResult:nil];
         }
     }];
}

+ (BOOL)isLogged
{
    return ([FBSDKAccessToken currentAccessToken] != nil);
}

+ (void)logout
{
    if ([SNSFacebookLogin isLogged])
    {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
    }
}

#pragma mark - Permissions -

+ (BOOL)hasPermission:(NSString *)permission
{
    return ([SNSFacebookLogin isLogged] == YES && [[FBSDKAccessToken currentAccessToken] hasGranted:permission]);
}

+ (BOOL)hasPermissions:(NSArray *)permissions
{
    for (NSString *permission in permissions)
    {
        if ([SNSFacebookLogin hasPermission:permission] == NO) return NO;
    }
    return YES;
}

+ (NSArray *)requiredPermissionForUserInformations:(NSArray *)userInformations
{
    NSMutableArray *permissions = [NSMutableArray array];
    [permissions addObject:@"public_profile"];
    
    if ([userInformations indexOfObjectIdenticalTo:SNSFacebookUserInfoEmail] != NSNotFound)
    {
        [permissions addObject:@"email"];
    }
    if ([userInformations indexOfObjectIdenticalTo:SNSFacebookUserInfoAbout] != NSNotFound
        || [userInformations indexOfObjectIdenticalTo:SNSFacebookUserInfoBio] != NSNotFound)
    {
        [permissions addObject:@"user_about_me"];
    }
    if ([userInformations indexOfObjectIdenticalTo:SNSFacebookUserInfoWebsite] != NSNotFound)
    {
        
        [permissions addObject:@"user_website"];
    }
    if ([userInformations indexOfObjectIdenticalTo:SNSFacebookUserInfoBirthday] != NSNotFound)
    {
        
        [permissions addObject:@"user_birthday"];
    }
    if ([userInformations indexOfObjectIdenticalTo:SNSFacebookUserInfoRelationshipStatus] != NSNotFound)
    {
        
        [permissions addObject:@"user_relationships"];
    }
    if ([userInformations indexOfObjectIdenticalTo:SNSFacebookUserInfoHometown] != NSNotFound)
    {
        
        [permissions addObject:@"user_hometown"];
    }
    
    return permissions;
}

#pragma mark - Informations -

NSString * const SNSFacebookUserInfoId                 = @"id";
NSString * const SNSFacebookUserInfoName               = @"name";
NSString * const SNSFacebookUserInfoFirstName          = @"first_name";
NSString * const SNSFacebookUserInfoMiddleName         = @"middle_name";
NSString * const SNSFacebookUserInfoLastName           = @"last_name";
NSString * const SNSFacebookUserInfoEmail              = @"email";
NSString * const SNSFacebookUserInfoWebsite            = @"website";
NSString * const SNSFacebookUserInfoAgeRange           = @"age_range";
NSString * const SNSFacebookUserInfoBirthday           = @"birthday";
NSString * const SNSFacebookUserInfoGender             = @"gender";
NSString * const SNSFacebookUserInfoAbout              = @"about";
NSString * const SNSFacebookUserInfoBio                = @"bio";
NSString * const SNSFacebookUserInfoRelationshipStatus = @"relationship_status";
NSString * const SNSFacebookUserInfoHometown           = @"hometown";

NSString * const SNSFacebookUserInfoPicture       = @"picture.type(normal)";
NSString * const SNSFacebookUserInfoPictureSmall  = @"picture.type(smalls)";
NSString * const SNSFacebookUserInfoPictureAlbum  = @"picture.type(album)";
NSString * const SNSFacebookUserInfoPictureLarge  = @"picture.type(large)";
NSString * const SNSFacebookUserInfoPictureSquare = @"picture.type(square)";

+ (void)logToRetrieveUserInformations:(NSArray *)userInformations
                   fromViewController:(UIViewController *)viewController
                           completion:(SNSFacebookCompletionBlock)completionBlock
{
    [SNSFacebookLogin loginWithReadPermissions:[SNSFacebookLogin requiredPermissionForUserInformations:userInformations]
                            fromViewController:viewController
                                    completion:^(id result, id error)
     {
         if (error != nil)
         {
             [SNSFacebook callCompletionBlock:completionBlock
                                    withError:error];
         }
         else
         {
             [SNSFacebookLogin retrieveUserInformations:userInformations
                                             completion:completionBlock];
         }
     }];
}

+ (void)retrieveCurrentUserInformations:(NSArray *)userInformations completion:(SNSFacebookCompletionBlock)completionBlock
{
    if ([SNSFacebookLogin hasPermissions:[SNSFacebookLogin requiredPermissionForUserInformations:userInformations]] == NO)
    {
        [SNSFacebook callCompletionBlock:completionBlock
                               withError:[NSError errorWithDomain:@"Missing permissions"
                                                             code:2
                                                         userInfo:nil]];
    }
    else
    {
        [SNSFacebookLogin retrieveUserInformations:userInformations
                                        completion:completionBlock];
    }
}

+ (void)retrieveUserInformations:(NSArray *)userInformations completion:(SNSFacebookCompletionBlock)completionBlock
{
    NSMutableString *fields = [[NSMutableString alloc] init];
    for (NSString *userInfo in userInformations)
    {
        if (fields.length > 0)
        {
            [fields appendString:@", "];
        }
        [fields appendString:userInfo];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:fields forKey:@"fields"];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                                                   parameters:params
                                                                   HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         if (error != nil)
         {
             [SNSFacebook callCompletionBlock:completionBlock withError:error];
         }
         else
         {
             NSMutableDictionary *dic = [NSMutableDictionary dictionary];
             for (NSString *userInfo in userInformations)
             {
                 NSString *paramName = userInfo;
                 NSRange rangeParamArgs = [paramName rangeOfString:@"."];
                 if (rangeParamArgs.location != NSNotFound)
                 {
                     paramName = [paramName substringToIndex:rangeParamArgs.location];
                 }
                 
                 NSObject *value = [result objectForKey:paramName];
                 if (value != nil)
                 {
                     if ([userInfo isEqualToString:SNSFacebookUserInfoPicture]
                         || [userInfo isEqualToString:SNSFacebookUserInfoPictureSmall]
                         || [userInfo isEqualToString:SNSFacebookUserInfoPictureAlbum]
                         || [userInfo isEqualToString:SNSFacebookUserInfoPictureLarge]
                         || [userInfo isEqualToString:SNSFacebookUserInfoPictureSquare])
                     {
                         NSDictionary *data = [(NSDictionary *)value objectForKey:@"data"];
                         if (data != nil)
                         {
                             NSString *url = [data objectForKey:@"url"];
                             if (url != nil)
                             {
                                 [dic setObject:url forKey:userInfo];
                             }
                         }
                     }
                     else
                     {
                         [dic setObject:value forKey:userInfo];
                     }
                 }
             }
             [SNSFacebook callCompletionBlock:completionBlock withResult:dic];
         }
     }];
}

@end
