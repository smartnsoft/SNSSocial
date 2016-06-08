//
//  SNSTwitter.m
//  SNSSocial-Sample
//
//  Created by Guillaume Bonnin on 15/04/2015.
//  Copyright (c) 2015 Smart&Soft. All rights reserved.
//

#import "SNSTwitter.h"

#import <Social/Social.h>
#import <STTwitter/STTwitter.h>

static NSString * const kAccessToken       = @"SNSTwitteAccessToken";
static NSString * const kAccessTokenSecret = @"SNSTwitterAccessTokenSecret";
static NSString * const kIsLogged          = @"SNSTwitterIsLogged";

#define kConsumerKey            [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TwitterAPIKey"]
#define kConsumerSecret         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TwitterAPISecret"]
#define kTwitterCallBackScheme  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TwitterCallBackScheme"]

@interface SNSTwitter () <STTwitterAPIOSProtocol>

@property (nonatomic, strong) STTwitterAPI *twitterAPI;

@property (nonatomic, copy) SNSTwitterCompletionBlock retainLoginCompletionBlock;

@end

@implementation SNSTwitter

#pragma mark - /// Publics methods -

#pragma mark - Singleton -

static SNSTwitter *_sharedInstance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Twitter Core -

+ (void)openURL:(NSURL *)url
{
    SNSTwitter *self_ = [SNSTwitter sharedInstance];
    
    NSDictionary *dic = [self_ parametersDictionaryFromQueryString:[url query]];
    
    NSString *token = dic[@"oauth_token"];
    NSString *verifier = dic[@"oauth_verifier"];
    
    [self_ setOAuthToken:token andOAuthVerifier:verifier];
}

#pragma mark - User Connection -

+ (void)tryRestoreConnectionWithCompletionBlock:(SNSTwitterCompletionBlock)completionBlock
{
    SNSTwitter *self_ = [SNSTwitter sharedInstance];
    if ([SNSTwitter isLogged] == YES)
    {
        [self_ callCompletionBlock:completionBlock
                        withResult:self_.twitterAPI.userID];
        return;
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogged])
    {
        NSString *keyAccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken];
        NSString *keyAccessSecret = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessTokenSecret];
        
        if ((keyAccessToken != nil) && (keyAccessSecret != nil))
        {
            self_.twitterAPI = [STTwitterAPI twitterAPIWithOAuthConsumerKey:kConsumerKey
                                                             consumerSecret:kConsumerSecret
                                                                 oauthToken:keyAccessToken
                                                           oauthTokenSecret:keyAccessSecret];
        }
        else
        {
            self_.twitterAPI = [STTwitterAPI twitterAPIOSWithFirstAccountAndDelegate:self_];
        }
        [self_.twitterAPI verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID)
         {
             [self_ callCompletionBlock:completionBlock withResult:username];
         }
                                                     errorBlock:^(NSError *error)
         {
             [SNSTwitter logout];
             [self_ callCompletionBlock:completionBlock
                              withError:[NSError errorWithDomain:@"Cannot restore previous connection because session has expired"
                                                            code:SNSTwitterErrorCodeConnectionExpired
                                                        userInfo:nil]];
         }];
    }
    else
    {
        [self_ callCompletionBlock:completionBlock
                         withError:[NSError errorWithDomain:@"Cannot restore connection because user was not logged at previous launch"
                                                       code:SNSTwitterErrorCodeMissingConnection
                                                   userInfo:nil]];
    }
}

+ (void)loginWithCompletionBlock:(SNSTwitterCompletionBlock)completionBlock
{
    SNSTwitter *self_ = [SNSTwitter sharedInstance];
    
    [SNSTwitter tryRestoreConnectionWithCompletionBlock:^(id  _Nullable result, NSError * _Nullable error) {
        if (error == nil)
        {
            [self_ callCompletionBlock:completionBlock withResult:result];
        }
        else // there is no previous connection to restore, try native login
        {
            self_.twitterAPI = [STTwitterAPI twitterAPIOSWithFirstAccountAndDelegate:self_];
            [self_.twitterAPI verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID)
             {
                 [self_ callCompletionBlock:completionBlock withResult:username];
             }
                                                         errorBlock:^(NSError *error)
             {
                 // native connection failed, try safari connection
                 [self_ askTwitterConnectionWithCompletionBlock:^(id  _Nullable result, NSError * _Nullable error)
                  {
                      if (error == nil)
                      {
                          [self_ callCompletionBlock:completionBlock
                                          withResult:result];
                      }
                      else
                      {
                          // login failed
                          [SNSTwitter logout];
                          [self_ callCompletionBlock:completionBlock
                                           withError:[NSError errorWithDomain:@"Cannot restore previous connection because session has expired"
                                                                         code:SNSTwitterErrorCodeConnectionExpired
                                                                     userInfo:nil]];
                      }
                  }];
             }];
        }
    }];
}

+ (void)logout
{
    SNSTwitter *self_ = [SNSTwitter sharedInstance];
    
    self_.twitterAPI = nil;
    [[NSUserDefaults standardUserDefaults] setObject:nil
                                              forKey:kAccessToken];
    [[NSUserDefaults standardUserDefaults] setObject:nil
                                              forKey:kAccessTokenSecret];
    [[NSUserDefaults standardUserDefaults] setBool:NO
                                            forKey:kIsLogged];
}

+ (BOOL)isLogged
{
    SNSTwitter *self_ = [SNSTwitter sharedInstance];
    
    return (self_.twitterAPI != nil && self_.twitterAPI.userID != nil);
}

#pragma mark - User Informations -

+ (NSString *)getCurrentUserName
{
    if ([SNSTwitter isLogged] == YES)
    {
        SNSTwitter *self_ = [SNSTwitter sharedInstance];
        return self_.twitterAPI.userName;
    }
    
    return nil;
}

+ (void)retrieveUserNameWithCompletionBlock:(SNSTwitterCompletionBlock)completionBlock
{
    SNSTwitter *self_ = [SNSTwitter sharedInstance];
    
    [SNSTwitter loginWithCompletionBlock:^(id result, NSError *error)
     {
         if (error == nil) // login succeed
         {
             [self_ callCompletionBlock:completionBlock
                             withResult:self_.twitterAPI.userName];
         }
         else // login failed => cannot retrieve user name
         {
             [self_ callCompletionBlock:completionBlock
                              withError:[NSError errorWithDomain:@"Cannot retrieve username because user is not logged"
                                                            code:SNSTwitterErrorCodeMissingConnection
                                                        userInfo:nil]];
         }
     }];
}

+ (void)retrieveUserProfilePictureWithCompletionBlock:(SNSTwitterCompletionBlock)completionBlock
{
    SNSTwitter *self_ = [SNSTwitter sharedInstance];
    
    [SNSTwitter loginWithCompletionBlock:^(id result, NSError *error)
     {
         if (error == nil) // login succeed
         {
             [self_.twitterAPI profileImageFor:self_.twitterAPI.userName successBlock:^(id image)
              {
                  [self_ callCompletionBlock:completionBlock withResult:image];
              }
                                    errorBlock:^(NSError *error)
              {
                  [self_ callCompletionBlock:completionBlock withError:error];
              }];
         }
         else // login failed => cannot retrieve profile picture
         {
             [self_ callCompletionBlock:completionBlock
                              withError:[NSError errorWithDomain:@"Cannot retrieve profile picture because user is not logged"
                                                            code:SNSTwitterErrorCodeMissingConnection
                                                        userInfo:nil]];
         }
     }];
}

#pragma mark - Send a tweet -

+ (void)postTweetWithMessage:(NSString *)message
    fromParentViewController:(UIViewController *)parentViewController
                  completion:(SNSTwitterCompletionBlock)completionBlock
{
    SNSTwitter *self_ = [SNSTwitter sharedInstance];
    
    [self_ tryPostTweetWithMessage:message
          fromParentViewController:parentViewController
                          latitude:nil
                         longitude:nil
                           picture:nil
                        completion:completionBlock];
}

+ (void)postTweetWithMessage:(NSString *)message
                    latitude:(NSString *)latitude
                   longitude:(NSString *)longitude
                  completion:(SNSTwitterCompletionBlock)completionBlock
{
    SNSTwitter *self_ = [SNSTwitter sharedInstance];
    
    [self_ tryPostTweetWithMessage:message
          fromParentViewController:nil
                          latitude:latitude
                         longitude:longitude
                           picture:nil
                        completion:completionBlock];
}

+ (void)postTweetWithMessage:(NSString *)message picture:(UIImage *)picture completion:(SNSTwitterCompletionBlock)completionBlock
{
    SNSTwitter *self_ = [SNSTwitter sharedInstance];
    
    [self_ tryPostTweetWithMessage:message
          fromParentViewController:nil
                          latitude:nil
                         longitude:nil
                           picture:picture
                        completion:completionBlock];
}

+ (void)postTweetWithMessage:(NSString *)message
                     picture:(UIImage *)picture
                    latitude:(NSString *)latitude
                   longitude:(NSString *)longitude
                  completion:(SNSTwitterCompletionBlock)completionBlock
{
    SNSTwitter *self_ = [SNSTwitter sharedInstance];
    
    [self_ tryPostTweetWithMessage:message
          fromParentViewController:nil
                          latitude:nil
                         longitude:nil
                           picture:picture
                        completion:completionBlock];
}

#pragma mark - /// Privates methods

#pragma mark - User Connection -

/**
 *  Ask the twitter connection with safari
 *  The method opens Safari and returns to application via the method "openUrl" Appdelegate
 */
- (void)askTwitterConnectionWithCompletionBlock:(SNSTwitterCompletionBlock)completionBlock
{
    self.twitterAPI = [STTwitterAPI twitterAPIWithOAuthConsumerKey:kConsumerKey
                                                    consumerSecret:kConsumerSecret];
    _retainLoginCompletionBlock = completionBlock;
    
    [_twitterAPI postTokenRequest:^(NSURL *url, NSString *oauthToken)
     {
         [[UIApplication sharedApplication] openURL:url];
     }
   authenticateInsteadOfAuthorize:NO
                       forceLogin:@(YES)
                       screenName:nil
                    oauthCallback:kTwitterCallBackScheme
                       errorBlock:^(NSError *error)
     {
         [SNSTwitter logout];
         // The response connection is managed by the method "setOAuthToken"
         [self callCompletionBlock:completionBlock withError:error];
         _retainLoginCompletionBlock = nil;
     }];
}

/**
 *  Sets oauth elements to finalize safari authentication (it is called after "openURL" in the AppDelegate)
 */
- (void)setOAuthToken:(NSString *)token andOAuthVerifier:(NSString *)verifier
{
    [_twitterAPI postAccessTokenRequestWithPIN:verifier
                                  successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName)
     {
         [_twitterAPI verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
             [[NSUserDefaults standardUserDefaults] setObject:_twitterAPI.oauthAccessToken
                                                       forKey:kAccessToken];
             
             [[NSUserDefaults standardUserDefaults] setObject:_twitterAPI.oauthAccessTokenSecret
                                                       forKey:kAccessTokenSecret];
             
             [[NSUserDefaults standardUserDefaults] setBool:YES
                                                     forKey:kIsLogged];
             
             SNSTwitterCompletionBlock completionBlock = _retainLoginCompletionBlock;
             _retainLoginCompletionBlock = nil;
             [self callCompletionBlock:completionBlock withResult:userID];
             
         } errorBlock:^(NSError *error) {
             SNSTwitterCompletionBlock completionBlock = _retainLoginCompletionBlock;
             [SNSTwitter logout];
             _retainLoginCompletionBlock = nil;
             [self callCompletionBlock:completionBlock withError:error];
         }];
         
     }errorBlock:^(NSError *error)
     {
         SNSTwitterCompletionBlock completionBlock = _retainLoginCompletionBlock;
         [SNSTwitter logout];
         _retainLoginCompletionBlock = nil;
         [self callCompletionBlock:completionBlock withError:error];
     }];
}

#pragma mark - Sending Tweet -

/**
 *  Checks login and posts a tweet
 */
- (void)tryPostTweetWithMessage:(NSString *)message
       fromParentViewController:(UIViewController *)parentViewController
                       latitude:(NSString *)latitude
                      longitude:(NSString *)longitude
                        picture:(UIImage *)picture
                     completion:(SNSTwitterCompletionBlock)completionBlock
{
    [SNSTwitter loginWithCompletionBlock:^(id result, NSError *error)
     {
         if (error == nil) // login succeed
         {
             [self postTweetWithMessage:message
               fromParentViewController:parentViewController
                               latitude:latitude
                              longitude:longitude
                                picture:picture
                             completion:completionBlock];
         }
         else // login failed => cannot post tweet
         {
             [self callCompletionBlock:completionBlock
                             withError:[NSError errorWithDomain:@"Cannot send Tweet because user is not logged"
                                                           code:SNSTwitterErrorCodeMissingConnection
                                                       userInfo:nil]];
         }
     }];
}

/**
 *  Sends the tweet to Twitter services
 */
- (void)postTweetWithMessage:(NSString *)message
    fromParentViewController:(UIViewController *)parentViewController
                    latitude:(NSString *)latitude
                   longitude:(NSString *)longitude
                     picture:(UIImage *)picture
                  completion:(SNSTwitterCompletionBlock)completionBlock
{
    BOOL isDisplayCoordinates = (latitude == nil && longitude == nil) ? NO : YES;
    BOOL isAttachPicture = (picture == nil) ? NO : YES;
    
    // If we can use the native social framework
    if (isDisplayCoordinates == NO
        && isAttachPicture == NO
        && parentViewController != nil
        && [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *twitterComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [twitterComposeViewController setInitialText:message];
        twitterComposeViewController.completionHandler = ^(SLComposeViewControllerResult result)
        {
            [parentViewController dismissViewControllerAnimated:YES completion:nil];
            if (result == SLComposeViewControllerResultCancelled)
            {
                [self callCompletionBlock:completionBlock
                                withError:[NSError errorWithDomain:@"Tweet cancelled"
                                                              code:SNSTwitterErrorCodeTweetFailed
                                                          userInfo:nil]];
            }
            else
            {
                [self callCompletionBlock:completionBlock
                               withResult:nil];
            }
        };
        
        [parentViewController presentViewController:twitterComposeViewController
                                           animated:YES
                                         completion:nil];
    }
    else // Else we use STTwitter to post status update
    {
        if (isAttachPicture == YES)
        {
            [self uploadPicture:picture completion:^(id result, NSError *error)
             {
                 if (error == nil && result != nil)
                 {
                     [_twitterAPI postStatusUpdate:message
                                 inReplyToStatusID:nil
                                          mediaIDs:@[result]
                                          latitude:latitude
                                         longitude:longitude
                                           placeID:nil
                                displayCoordinates:@(isDisplayCoordinates)
                                          trimUser:nil
                                      successBlock:^(NSDictionary *status)
                      {
                          [self callCompletionBlock:completionBlock withResult:nil];
                      }
                                        errorBlock:^(NSError *error)
                      {
                          [self callCompletionBlock:completionBlock withError:error];
                      }];
                 }
                 else
                 {
                     [self callCompletionBlock:completionBlock
                                     withError:[NSError errorWithDomain:@"Fails to upload picture"
                                                                   code:SNSTwitterErrorCodeUploadDataFailed
                                                               userInfo:nil]];
                 }
             }];
        }
        else
        {
            [_twitterAPI postStatusUpdate:message
                        inReplyToStatusID:nil
                                 latitude:latitude
                                longitude:longitude
                                  placeID:nil
                       displayCoordinates:@(isDisplayCoordinates)
                                 trimUser:nil
                             successBlock:^(NSDictionary *status)
             {
                 [self callCompletionBlock:completionBlock withResult:nil];
             }
                               errorBlock:^(NSError *error)
             {
                 [self callCompletionBlock:completionBlock withError:error];
             }];
        }
    }
}

#pragma mark - Upload a media -

- (void)uploadPicture:(UIImage *)picture completion:(SNSTwitterCompletionBlock)completionBlock
{
    [self uploadData:UIImagePNGRepresentation(picture) completion:completionBlock];
}

- (void)uploadData:(NSData *)data completion:(SNSTwitterCompletionBlock)completionBlock
{
    if (data != nil)
    {
        [SNSTwitter loginWithCompletionBlock:^(id result, NSError *error)
         {
             if (error == nil)
             {
                 [_twitterAPI postMediaUploadData:data
                                         fileName:nil
                              uploadProgressBlock:nil
                                     successBlock:^(NSDictionary *imageDictionary, NSString *mediaID, NSInteger size)
                  {
                      [self callCompletionBlock:completionBlock
                                     withResult:mediaID];
                  }
                                       errorBlock:^(NSError *error)
                  {
                      [self callCompletionBlock:completionBlock
                                     withResult:error];
                  }];
             }
             else
             {
                 [self callCompletionBlock:completionBlock
                                 withError:[NSError errorWithDomain:@"Cannot upload data because user is not logged"
                                                               code:SNSTwitterErrorCodeMissingConnection
                                                           userInfo:nil]];
             }
         }];
    }
}

#pragma mark - Utils -

/**
 *  Parses parameters of the query string called after oauth
 */
- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;
        
        NSString *key = pair[0];
        NSString *value = pair[1];
        
        md[key] = value;
    }
    
    return md;
}

#pragma mark - Twitter Completion -

- (void)callCompletionBlock:(SNSTwitterCompletionBlock)completionBlock withResult:(id)result
{
    if (completionBlock != nil)
    {
        completionBlock(result, nil);
    }
}

- (void)callCompletionBlock:(SNSTwitterCompletionBlock)completionBlock withError:(NSError *)error
{
    if (completionBlock != nil)
    {
        completionBlock(nil, error);
    }
}

#pragma mark - STTwitter Delegate -

- (void)twitterAPI:(STTwitterAPI *)twitterAPI accountWasInvalidated:(ACAccount *)invalidatedAccount
{
    //[SNSTwitter logout];
}

@end
