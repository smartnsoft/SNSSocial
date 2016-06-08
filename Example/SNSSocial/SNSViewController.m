//
//  SNSViewController.m
//  SNSSocial
//
//  Created by Jean-Charles SORIN on 05/26/2016.
//  Copyright (c) 2016 Smart&Soft. All rights reserved.
//

#import "SNSViewController.h"

#import "SNSTwitter.h"
#import "SNSFacebookLogin.h"
#import "SNSFacebookInteractions.h"

#import "SNSSocialItem.h"


@interface SNSViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *ibLabelCurrentUserTwitter;
@property (weak, nonatomic) IBOutlet UILabel *ibLabelCurrentUserFacebook;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation SNSViewController

#pragma mark - View Lifecycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"SNSSocial";
    [self.ibTableView registerClass:[UITableViewCell class]
             forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.ibTableView.tableHeaderView = [UIView new];
    self.ibTableView.tableFooterView = [UIView new];
    [self prepareDataSource];
    
    //
    [SNSTwitter tryRestoreConnectionWithCompletionBlock:^(id _Nullable result, NSError * _Nullable error) {
        if (error == nil)
        {
            self.ibLabelCurrentUserTwitter.text = [NSString stringWithFormat: @"Welcome, %@", [SNSTwitter getCurrentUserName]];
        }
    }];
    
    if ([SNSFacebookLogin isLogged] == true)
    {
        [SNSFacebookLogin retrieveCurrentUserInformations:@[SNSFacebookUserInfoName]
                                               completion:^(id result, NSError * _Nullable error)
         {
             if (error == nil && result != nil)
             {
                 NSString *username = [result objectForKey:SNSFacebookUserInfoName];
                 self.ibLabelCurrentUserFacebook.text = [NSString stringWithFormat: @"Welcome, %@", username];
             }
         }];
    }
}

#pragma mark - Prepare Testing Datasource

-(void)prepareDataSource
{
#pragma mark - Twitter Connect
    SNSSocialItem* connectTwitter = [SNSSocialItem socialTestItemNamed:@"Twitter User Connect" completion:^{
        [SNSTwitter retrieveUserNameWithCompletionBlock:^(id _Nullable result, NSError * _Nullable error) {
            if (result != nil)
            {
                self.ibLabelCurrentUserTwitter.text = [NSString stringWithFormat: @"Welcome, %@", result];
                [self showMessage:@"Twitter login succeed" withTitle:@"Success"];
            }
            else
            {
                [self showMessage:@"Twitter login failed" withTitle:@"Error"];
            }
        }];
    }];
    
#pragma mark - Twitter Logout
    SNSSocialItem* logoutTwitter = [SNSSocialItem socialTestItemNamed:@"Logout Twitter" completion:^{
        if ([SNSTwitter isLogged])
        {
            [SNSTwitter logout];
            _ibLabelCurrentUserTwitter.text = @"Twitter User Name";
            [self showMessage:@"Twitter logout succeed" withTitle:@"Success"];
        }
        else
        {
            [self showMessage:@"User is already not connected." withTitle:@"Info"];
        }
    }];
    
#pragma mark - Twitter Sharing
    SNSSocialItem* shareTwitter = [SNSSocialItem socialTestItemNamed:@"Sahre with Twitter" completion:^{
        [SNSTwitter postTweetWithMessage:@"Sample tweet with SNSSocial #iosdev"
                fromParentViewController:self
                              completion:^(id result, NSError * _Nullable error)
         {
             if (error == nil)
             {
                 [self showMessage:@"Post tweet succeed" withTitle:@"Success"];
             }
             else
             {
                 [self showMessage:@"Post tweet failed" withTitle:@"Error"];
             }
         }];
    }];
    
    SNSSocialItem* uploadImageOnTwitter = [SNSSocialItem socialTestItemNamed:@"Upload Image on Twitter" completion:^{
        UIImage *image = [UIImage imageNamed:@"avatar"];
        [SNSTwitter postTweetWithMessage:@"Sample tweet with SNSSocial #iosdev"
                                 picture:image
                              completion:^(id result, NSError * _Nullable error)
         {
             if (error == nil)
             {
                 [self showMessage:@"Post tweet with picture succeed" withTitle:@"Success"];
             }
             else
             {
                 [self showMessage:@"Post tweet with picture failed" withTitle:@"Error"];
             }
         }];
    }];
    
#pragma mark - Facebook Connect
    SNSSocialItem* facebookConnect = [SNSSocialItem socialTestItemNamed:@"Facebook User Connect" completion:^{
        [SNSFacebookLogin logToRetrieveUserInformations:@[SNSFacebookUserInfoName]
                                     fromViewController:self
                                             completion:^(id result, NSError * _Nullable error)
         {
             if (error == nil && result != nil)
             {
                 NSString *username = [result objectForKey:SNSFacebookUserInfoName];
                 self.ibLabelCurrentUserFacebook.text = [NSString stringWithFormat: @"Welcome, %@", username];
             }
         }];
    }];
    
#pragma mark - Facebook Logout
    SNSSocialItem* facebookLogout = [SNSSocialItem socialTestItemNamed:@"Facebook Logout" completion:^{
        if ([SNSFacebookLogin isLogged])
        {
            [SNSFacebookLogin logout];
            _ibLabelCurrentUserFacebook.text = @"Facebook User Name";
            [self showMessage:@"Facebook logout succeed" withTitle:@"Success"];
        }
        else
        {
            [self showMessage:@"User is already not connected." withTitle:@"Info"];
        }
    }];
    
#pragma mark - Facebook Sharing
    SNSSocialItem* facebookShare = [SNSSocialItem socialTestItemNamed:@"Facebook Share" completion:^{
        [SNSFacebookInteractions postLink:@"http://smartnsoft.com/"
                                withTitle:@"SNSSocial"
                              description:@"I shared this link with SNSSocial, an iOS library to interact easily with social networks in your app."
                               pictureUrl:nil
                         parentController:self
                               completion:^(id result, NSError * _Nullable error)
         {
             if (error == nil)
             {
                 [self showMessage:@"Facebook share succeed" withTitle:@"Success"];
             }
             else
             {
                 [self showMessage:@"Facebook Share failed" withTitle:@"Error"];
             }
         }];
    }];
    
    SNSSocialItem* facebookImageUpload = [SNSSocialItem socialTestItemNamed:@"Facebook Image Upload" completion:^{
        UIImage *image = [UIImage imageNamed:@"avatar"];
        [SNSFacebookInteractions postPhoto:image
                               withCaption:@"Sample image uploaded with SNSSocial"
                                completion:^(id  _Nullable result, NSError * _Nullable error)
         {
             if (error == nil)
             {
                 [self showMessage:@"Facebook share succeed" withTitle:@"Success"];
             }
             else
             {
                 [self showMessage:@"Facebook Share failed" withTitle:@"Error"];
             }
         }];
    }];
    
#pragma mark - Facebook Like
    SNSSocialItem* facebookLike = [SNSSocialItem socialTestItemNamed:@"Facebook Like" completion:^{
        [SNSFacebookInteractions likeWithObject:@"http://smartnsoft.com/"
                                     completion:^(id _Nullable result, NSError * _Nullable error)
         {
             if (error == nil)
             {
                 if ([result boolValue])
                 {
                     [self showMessage:@"The link has been liked" withTitle:@"Success"];
                 }
                 else
                 {
                     [self showMessage:@"The link has been disliked" withTitle:@"Success"];
                 }
             }
             else
             {
                 [self showMessage:@"Facebook Like failed" withTitle:@"Error"];
             }
         }];
    }];
    
    
    self.dataSource = @[
                        @[connectTwitter, logoutTwitter, shareTwitter, uploadImageOnTwitter],
                        @[facebookConnect, facebookLogout, facebookShare, facebookImageUpload, facebookLike]
                        ];
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray*)self.dataSource[section]).count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Twitter";
    }
    else{
        return @"Facebook";
    }
}

#pragma mark - UITableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])
                                                            forIndexPath:indexPath];
    
    SNSSocialItem* item = ((NSArray*)self.dataSource[indexPath.section])[indexPath.row];
    cell.textLabel.text = item.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SNSSocialItem* item = ((NSArray*)self.dataSource[indexPath.section])[indexPath.row];
    item.completion();
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Utils -

- (void)showMessage:(NSString *)message withTitle:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
