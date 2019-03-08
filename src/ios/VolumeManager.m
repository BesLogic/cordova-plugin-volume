/********* VolumeManager.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

@interface VolumeManager : CDVPlugin {
  // Member variables go here.
}

- (UISlider *)currentSystemVolumeSlider:(CDVInvokedUrlCommand*)command;
- (void)getVolume:(CDVInvokedUrlCommand*)command;
- (void)setVolume:(CDVInvokedUrlCommand*)command;
@end

@implementation VolumeManager

+ (UISlider *)currentSystemVolumeSlider {
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

+ (void)getVolume {
    CGFloat *volume = [[self currentSystemVolumeSlider] value];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:volume];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

+ (void)setVolume:(double)volume {
    [self currentSystemVolumeSlider].value = volume;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
