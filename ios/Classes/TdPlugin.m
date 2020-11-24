#import "TdPlugin.h"
#if __has_include(<td/td-Swift.h>)
#import <td/td-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "td-Swift.h"
#endif

@implementation TdPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTdPlugin registerWithRegistrar:registrar];
}
@end
