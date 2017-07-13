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
