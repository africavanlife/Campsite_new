#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AuthStorage.h"
#import "SFSafariAuthenticator.h"
#import "SimpleAuthFlutterPlugin.h"
#import "Simple_Auth_Fluttter-Bridging-Header.h"
#import "WebAuthenticator.h"
#import "WebAuthenticatorViewController.h"
#import "WebAuthenticatorWindow.h"

FOUNDATION_EXPORT double simple_auth_flutterVersionNumber;
FOUNDATION_EXPORT const unsigned char simple_auth_flutterVersionString[];

