#import "ChampVideoPlugin.h"
#if __has_include(<champ_video/champ_video-Swift.h>)
#import <champ_video/champ_video-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "champ_video-Swift.h"
#endif

@implementation ChampVideoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftChampVideoPlugin registerWithRegistrar:registrar];
}
@end
