/********* VolumeManager.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#ifdef DEBUG
    #define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define DLog(...)
#endif

@interface VolumeManager : CDVPlugin {
  // Member variables go here.
}

- (void)setVolume:(CDVInvokedUrlCommand*)command;
- (void)getVolume:(CDVInvokedUrlCommand*)command;
@end

@implementation VolumeManager

- (UISlider *)currentSystemVolumeSlider {
    static UISlider * volumeViewSlider = nil;
    if(volumeViewSlider == nil) {
        MPVolumeView * volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(10, 50, 200, 4)];
        [volumeView setHidden:YES];
        for(UIView *newView in volumeView.subviews) {
            if([newView.class.description isEqualToString:@"MPVolumeSlider"]) {
                volumeViewSlider = (UISlider *)newView;
                break;
            }
        }
    }
    return volumeViewSlider;
}


- (void)setVolume:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    float volume = [[command argumentAtIndex:0] floatValue];
    [self currentSystemVolumeSlider].value = volume;

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getVolume:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    DLog(@"getVolume");

    float volume = [[self currentSystemVolumeSlider] value];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:(double)volume];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
