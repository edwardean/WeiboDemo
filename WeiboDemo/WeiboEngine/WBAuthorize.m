 //
//  WBAuthorize.m
//  SinaWeiBoSDK
//  Based on OAuth 2.0
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  Copyright 2011 Sina. All rights reserved.
//

#import "WBAuthorize.h"
#import "WBRequest.h"
#import "WBSDKGlobal.h"


#define kWBAuthorizeURL     @"https://api.weibo.com/oauth2/authorize"
#define kWBAccessTokenURL   @"https://api.weibo.com/oauth2/access_token"

@interface WBAuthorize (Private)

- (void)dismissModalViewController;
- (void)requestAccessTokenWithAuthorizeCode:(NSString *)code;
- (void)requestAccessTokenWithUserID:(NSString *)userID password:(NSString *)password;

@end

@implementation WBAuthorize

@synthesize appKey;
@synthesize appSecret;
@synthesize redirectURI;
@synthesize request;
@synthesize rootViewController;
@synthesize delegate;

#pragma mark - WBAuthorize Life Circle

- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret
{
    bug;
    if (self = [super init])
    {
        self.appKey = theAppKey;
        self.appSecret = theAppSecret;
    }
    
    return self;
}

- (void)dealloc
{
    [appKey release], appKey = nil;
    [appSecret release], appSecret = nil;
    
    [redirectURI release], redirectURI = nil;
    
    [request setDelegate:nil];
    [request disconnect];
    [request release], request = nil;
    
    rootViewController = nil;
    delegate = nil;
    
    [super dealloc];
}

#pragma mark - WBAuthorize Private Methods

- (void)dismissModalViewController
{
    bug;
    [rootViewController dismissModalViewControllerAnimated:YES];
}

- (void)requestAccessTokenWithAuthorizeCode:(NSString *)code
{
    bug;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:appKey, @"client_id",
                                                                      appSecret, @"client_secret",
                                                                      @"authorization_code", @"grant_type",
                                                                      redirectURI, @"redirect_uri",
                                                                      code, @"code", nil];
    [request disconnect];
    
    self.request = [WBRequest requestWithURL:kWBAccessTokenURL
                                   httpMethod:@"POST"
                                       params:params
                                 postDataType:kWBRequestPostDataTypeNormal
                             httpHeaderFields:nil 
                                     delegate:self];
    [request setCompleteBlock:^{
        BOOL success = NO;
        
        NSError* error = nil;
        id result = [request parseJSONData:request.responseData error:&error];
        
        
        if ([result isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = (NSDictionary *)result;
            
            NSString *token = [dict objectForKey:@"access_token"];
            NSString *userID = [dict objectForKey:@"uid"];
            NSInteger seconds = [[dict objectForKey:@"expires_in"] intValue];
            
            success = token && userID;
            
            if (success && [delegate respondsToSelector:@selector(authorize:didSucceedWithAccessToken:userID:expiresIn:)])
            {
                //[rootViewController dismissModalViewControllerAnimated:YES];
                [delegate authorize:self didSucceedWithAccessToken:token userID:userID expiresIn:seconds];
            }
        }
        
        // should not be possible
        if (!success && [delegate respondsToSelector:@selector(authorize:didFailWithError:)])
        {
            NSError *error = [NSError errorWithDomain:kWBSDKErrorDomain
                                                 code:kWBErrorCodeSDK
                                             userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", kWBSDKErrorCodeAuthorizeError]
                                                                                  forKey:kWBSDKErrorCodeKey]];
            [delegate authorize:self didFailWithError:error];
        }
    }];
    [request setFailedBlock:^{
        if ([delegate respondsToSelector:@selector(authorize:didFailWithError:)])
        {
            [delegate authorize:self didFailWithError:request.requestError];
        }
    }];
    
    [request connect];
}

- (void)requestAccessTokenWithUserID:(NSString *)userID password:(NSString *)password
{
    bug;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:appKey, @"client_id",
                                                                      appSecret, @"client_secret",
                                                                      @"password", @"grant_type",
                                                                      redirectURI, @"redirect_uri",
                                                                      userID, @"username",
                                                                      password, @"password", nil];
    NSLog(@"Dic_params:%@",params);
    [request disconnect];
    
    self.request = [WBRequest requestWithURL:kWBAccessTokenURL
                                   httpMethod:@"POST"
                                       params:params
                                 postDataType:kWBRequestPostDataTypeNormal
                             httpHeaderFields:nil 
                                     delegate:self];
    [request setCompleteBlock:^{
        BOOL success = NO;
        
        NSError* error = nil;
        id result = [request parseJSONData:request.responseData error:&error];
        
        
        if ([result isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = (NSDictionary *)result;
            
            NSString *token = [dict objectForKey:@"access_token"];
            NSString *userID = [dict objectForKey:@"uid"];
            NSInteger seconds = [[dict objectForKey:@"expires_in"] intValue];
            
            success = token && userID;
            
            if (success && [delegate respondsToSelector:@selector(authorize:didSucceedWithAccessToken:userID:expiresIn:)])
            {
                [delegate authorize:self didSucceedWithAccessToken:token userID:userID expiresIn:seconds];
            }
        }
        
        // should not be possible
        if (!success && [delegate respondsToSelector:@selector(authorize:didFailWithError:)])
        {
            NSError *error = [NSError errorWithDomain:kWBSDKErrorDomain
                                                 code:kWBErrorCodeSDK
                                             userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", kWBSDKErrorCodeAuthorizeError]
                                                                                  forKey:kWBSDKErrorCodeKey]];
            [delegate authorize:self didFailWithError:error];
        }
    }];
    [request setFailedBlock:^{
        if ([delegate respondsToSelector:@selector(authorize:didFailWithError:)])
        {
            [delegate authorize:self didFailWithError:request.requestError];
        }
    }];
    
    [request connect];
}

#pragma mark - WBAuthorize Public Methods

- (void)startAuthorize
{
    bug;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:appKey, @"client_id",
                                                                      @"code", @"response_type",
                                                                      redirectURI, @"redirect_uri", 
                                                                      @"mobile", @"display", nil];
    NSString *urlString = [WBRequest serializeURL:kWBAuthorizeURL
                                           params:params
                                       httpMethod:@"GET"];
    
    AuthViewController *auth = [[AuthViewController alloc] init] ;
    [auth setDelegate:self];
    auth.url = [NSURL URLWithString:urlString];
    [rootViewController presentModalViewController:auth animated:YES];
    [auth release];
}

- (void)startAuthorizeUsingUserID:(NSString *)userID password:(NSString *)password
{
    bug;
    NSLog(@"userID:%@  password:%@",userID,password);
    [self requestAccessTokenWithUserID:userID password:password];
}

#pragma mark - WBAuthorizeWebViewDelegate Methods

- (void)authorizeWebView:(WBAuthorizeWebView *)webView didReceiveAuthorizeCode:(NSString *)code
{
    bug;
    //[webView hide:YES];
    //[rootViewController dismissModalViewControllerAnimated:YES];
    // if not canceled
    if (![code isEqualToString:@"21330"])
    {
        [self requestAccessTokenWithAuthorizeCode:code];
    }
}

#pragma mark - WBRequestDelegate Methods

- (void)request:(WBRequest *)theRequest didFinishLoadingWithResult:(id)result
{
    bug;
    BOOL success = NO;
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)result;
        
        NSString *token = [dict objectForKey:@"access_token"];
        NSString *userID = [dict objectForKey:@"uid"];
        NSInteger seconds = [[dict objectForKey:@"expires_in"] intValue];
        
        success = token && userID;
        
        if (success && [delegate respondsToSelector:@selector(authorize:didSucceedWithAccessToken:userID:expiresIn:)])
        {
            
            [delegate authorize:self didSucceedWithAccessToken:token userID:userID expiresIn:seconds];
        }
    }
    
    // should not be possible
    if (!success && [delegate respondsToSelector:@selector(authorize:didFailWithError:)])
    {
        NSError *error = [NSError errorWithDomain:kWBSDKErrorDomain 
                                             code:kWBErrorCodeSDK 
                                         userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", kWBSDKErrorCodeAuthorizeError] 
                                                                              forKey:kWBSDKErrorCodeKey]];
        [delegate authorize:self didFailWithError:error];
    }
}

- (void)request:(WBRequest *)theReqest didFailWithError:(NSError *)error
{
    bug;
    if ([delegate respondsToSelector:@selector(authorize:didFailWithError:)])
    {
        [delegate authorize:self didFailWithError:error];
    }
}

@end
