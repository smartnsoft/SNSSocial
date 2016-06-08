//
//  SNSFacebookInteractions.m
//  SNSSocial-Sample
//
//  Created by Guillaume Bonnin on 17/04/2015.
//  Copyright (c) 2015 Smart&Soft. All rights reserved.
//

#import "SNSFacebookInteractions.h"

#import <FBSDKCoreKit/FBSDKGraphRequest.h>

#import "SNSFacebookLogin.h"

@interface SNSFacebookInteractions ()

@property (copy, nonatomic) SNSFacebookCompletionBlock retainCompletionBlock;

@end

@implementation SNSFacebookInteractions

#pragma mark - Singleton -

static SNSFacebookInteractions *_sharedInstance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Sharing Status -

+ (void)postStatusWithMessage:(NSString *)message completion:(SNSFacebookCompletionBlock)completionBlock
{
    if (message != nil)
    {
        NSDictionary *params = @{@"message" : message};
        [SNSFacebookInteractions publishIntoGraphPath:@"me/feed"
                                           withParams:params
                                           completion:completionBlock];
    }
    else
    {
        [SNSFacebook callCompletionBlock:completionBlock
                               withError:[NSError errorWithDomain:@"Invalid attributes"
                                                             code:SNSFacebookErrorCodeInvalidAttribute
                                                         userInfo:nil]];
    }
}

+ (void)postStatusFromParentViewController:(UIViewController *)parentViewController
                                completion:(SNSFacebookCompletionBlock)completionBlock
{
    if (completionBlock != nil)
    {
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        
        SNSFacebookInteractions *self_ = [SNSFacebookInteractions sharedInstance];
        self_.retainCompletionBlock = completionBlock;
        [FBSDKShareDialog showFromViewController:parentViewController
                                     withContent:content
                                        delegate:self_];
    }
    else
    {
        [SNSFacebook callCompletionBlock:completionBlock
                               withError:[NSError errorWithDomain:@"Invalid attributes"
                                                             code:SNSFacebookErrorCodeInvalidAttribute
                                                         userInfo:nil]];
    }
}

#pragma mark - Sharing Link -

+ (void)postLink:(NSString *)link
       withTitle:(NSString *)title
     description:(NSString *)description
      pictureUrl:(NSString *)pictureUrl
      completion:(SNSFacebookCompletionBlock)completionBlock
{
    if (link != nil)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:link forKey:@"link"];
        if (title != nil) [params setObject:title forKey:@"name"];
        if (description != nil) [params setObject:description forKey:@"description"];
        if (pictureUrl != nil)  [params setObject:pictureUrl forKey:@"picture"];
        
        [SNSFacebookInteractions publishIntoGraphPath:@"me/feed"
                                           withParams:params
                                           completion:completionBlock];
    }
    else
    {
        [SNSFacebook callCompletionBlock:completionBlock
                               withError:[NSError errorWithDomain:@"Invalid attributes"
                                                             code:SNSFacebookErrorCodeInvalidAttribute
                                                         userInfo:nil]];
    }
}

+ (void)postLink:(NSString *)link
       withTitle:(NSString *)title
     description:(NSString *)description
      pictureUrl:(NSString *)pictureUrl
parentController:(UIViewController *)parentViewController
      completion:(SNSFacebookCompletionBlock)completionBlock
{
    if (link != nil && completionBlock != nil)
    {
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentURL = [NSURL URLWithString:link];
        content.contentTitle = title;
        content.contentDescription = description;
        if (pictureUrl != nil)
        {
            content.imageURL = [NSURL URLWithString:pictureUrl];
        }
        
        SNSFacebookInteractions *self_ = [SNSFacebookInteractions sharedInstance];
        self_.retainCompletionBlock = completionBlock;
        [FBSDKShareDialog showFromViewController:parentViewController
                                     withContent:content
                                        delegate:self_];
    }
    else
    {
        [SNSFacebook callCompletionBlock:completionBlock
                               withError:[NSError errorWithDomain:@"Invalid attributes"
                                                             code:SNSFacebookErrorCodeInvalidAttribute
                                                         userInfo:nil]];
    }
}

#pragma mark - Sharing Photo -

+ (void)postPhoto:(UIImage *)photo fromParentViewController:(UIViewController *)parentViewController completion:(SNSFacebookCompletionBlock)completionBlock
{
    if (photo != nil && completionBlock != nil)
    {
        [SNSFacebookInteractions postPhotos:@[photo]
                   fromParentViewController:parentViewController
                                 completion:completionBlock];
    }
    else
    {
        [SNSFacebook callCompletionBlock:completionBlock
                               withError:[NSError errorWithDomain:@"Invalid attributes"
                                                             code:SNSFacebookErrorCodeInvalidAttribute
                                                         userInfo:nil]];
    }
}

+ (void)postPhotos:(NSArray *)photos fromParentViewController:(UIViewController *)parentViewController completion:(SNSFacebookCompletionBlock)completionBlock
{
    if (photos != nil && photos.count > 0 && completionBlock != nil)
    {
        NSMutableArray *sharePhotos = [NSMutableArray array];
        for (UIImage *photo in photos)
        {
            FBSDKSharePhoto *sharePhoto = [[FBSDKSharePhoto alloc] init];
            sharePhoto.image = photo;
            sharePhoto.userGenerated = YES;
            [sharePhotos addObject:sharePhoto];
        }
        
        FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
        content.photos = sharePhotos;
        
        SNSFacebookInteractions *self_ = [SNSFacebookInteractions sharedInstance];
        self_.retainCompletionBlock = completionBlock;
        [FBSDKShareDialog showFromViewController:parentViewController
                                     withContent:content
                                        delegate:self_];
    }
    else
    {
        [SNSFacebook callCompletionBlock:completionBlock
                               withError:[NSError errorWithDomain:@"Invalid attributes"
                                                             code:SNSFacebookErrorCodeInvalidAttribute
                                                         userInfo:nil]];
    }
}

+ (void)postPhoto:(UIImage *)photo withCaption:(NSString *)caption completion:(SNSFacebookCompletionBlock)completionBlock
{
    if (photo != nil)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:UIImagePNGRepresentation(photo) forKey:@"picture"];
        if (caption != nil) [params setObject:caption forKey:@"caption"];
        
        [SNSFacebookInteractions publishIntoGraphPath:@"me/photos"
                                           withParams:params
                                           completion:completionBlock];
    }
    else
    {
        [SNSFacebook callCompletionBlock:completionBlock
                               withError:[NSError errorWithDomain:@"Invalid attributes"
                                                             code:SNSFacebookErrorCodeInvalidAttribute
                                                         userInfo:nil]];
    }
}

#pragma mark - Like -

+ (void)isObjectLiked:(NSString *)objectId completion:(SNSFacebookCompletionBlock)completionBlock
{
    [SNSFacebookInteractions searchObjectInLikes:objectId completion:^(id result, id error)
     {
         if (error != nil)
         {
             [SNSFacebook callCompletionBlock:completionBlock
                                    withError:error];
         }
         else
         {
             [SNSFacebook callCompletionBlock:completionBlock
                                   withResult:(result == nil || [[result objectForKey:@"data"] count] == 0) ? @(NO) : @(YES)];
         }
     }];
}

+ (void)likeWithObject:(NSString *)objectId completion:(SNSFacebookCompletionBlock)completionBlock
{
    [SNSFacebookLogin loginWithPublishPermissions:@[@"publish_actions"]
                               fromViewController:nil
                                       completion:^(id result, id error)
     {
         if (error != nil)
         {
             [SNSFacebook callCompletionBlock:completionBlock
                                    withError:error]; // Login failed
         }
         else
         {
             [SNSFacebookInteractions searchObjectInLikes:objectId
                                               completion:^(id result, id error)
              {
                  if (error != nil)
                  {
                      [SNSFacebook callCompletionBlock:completionBlock
                                             withError:error]; // Cannot determines if object is already liked
                  }
                  else
                  {
                      NSDictionary *objectLiked = nil;
                      if (result != nil) objectLiked = [[result objectForKey:@"data"] firstObject];
                      
                      // Prepares params : if the object is found in likes, we dislike it
                      NSString *graphPath = (objectLiked == nil) ? @"me/og.likes" : [objectLiked objectForKey:@"id"];
                      NSDictionary *params = (objectLiked == nil) ? @{@"object" : objectId} : nil;
                      NSString *action = (objectLiked == nil) ? @"POST" : @"DELETE";
                      
                      FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:graphPath
                                                                                     parameters:params
                                                                                     HTTPMethod:action];
                      
                      [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                       {
                           if (error != nil)
                           {
                               [SNSFacebook callCompletionBlock:completionBlock
                                                      withError:error]; // like/dislike failed
                           }
                           else
                           {
                               BOOL isNowLiked = (result != nil && [((NSDictionary *)result) objectForKey:@"id"] != nil);
                               [SNSFacebook callCompletionBlock:completionBlock
                                                     withResult:@(isNowLiked)];
                           }
                       }];
                  }
              }];
         }
     }];
}

#pragma mark - Sharing Delegate -

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    [SNSFacebook callCompletionBlock:_retainCompletionBlock
                           withError:[NSError errorWithDomain:@"share canceled"
                                                         code:SNSFacebookErrorCodeActionCanceled
                                                     userInfo:nil]];
    _retainCompletionBlock = nil;
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    [SNSFacebook callCompletionBlock:_retainCompletionBlock
                           withError:error];
    _retainCompletionBlock = nil;
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    if (results.count == 0)
    {
        [SNSFacebook callCompletionBlock:_retainCompletionBlock
                               withError:[NSError errorWithDomain:@"share canceled"
                                                             code:SNSFacebookErrorCodeActionCanceled
                                                         userInfo:nil]];
    }
    else
    {
        [SNSFacebook callCompletionBlock:_retainCompletionBlock
                              withResult:results];
    }
    _retainCompletionBlock = nil;
}

#pragma mark - Private -

/**
 *  Publish something on user's wall with graph path
 *
 *  @param params           params to publish
 *  @param completionBlock  calls the block after action
 */
+ (void)publishIntoGraphPath:(NSString *)graphPath withParams:(NSDictionary *)params completion:(SNSFacebookCompletionBlock)completionBlock
{
    [SNSFacebookLogin loginWithPublishPermissions:@[@"publish_actions"]
                               fromViewController:nil
                                       completion:^(id result, id error)
     {
         if (error != nil)
         {
             [SNSFacebook callCompletionBlock:completionBlock withError:error];
         }
         else
         {
             FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:graphPath
                                                                            parameters:params
                                                                            HTTPMethod:@"POST"];
             
             [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
              {
                  if (error != nil)
                  {
                      [SNSFacebook callCompletionBlock:completionBlock withError:error];
                  }
                  else
                  {
                      [SNSFacebook callCompletionBlock:completionBlock withResult:nil];
                  }
              }];
         }
     }];
}

/**
 *  Search an object in likes of the user
 *
 *  @param objectId         id of searched object
 *  @param completionBlock  calls the block after action (result contains object or nil if no object found)
 */
+ (void)searchObjectInLikes:(NSString *)objectId completion:(SNSFacebookCompletionBlock)completionBlock
{
    [SNSFacebookLogin loginWithReadPermissions:@[@"user_likes"]
                            fromViewController:nil
                                    completion:^(id result, id error)
     {
         if (error != nil)
         {
             [SNSFacebook callCompletionBlock:completionBlock withError:error];
         }
         else
         {
             FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/og.likes"
                                                                            parameters:@{@"object" : objectId}
                                                                            HTTPMethod:@"GET"];
             
             [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
              {
                  if (error != nil)
                  {
                      [SNSFacebook callCompletionBlock:completionBlock withError:error];
                  }
                  else
                  {
                      [SNSFacebook callCompletionBlock:completionBlock withResult:result];
                  }
              }];
         }
     }];
}

@end