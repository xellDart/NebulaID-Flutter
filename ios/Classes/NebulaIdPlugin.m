#import "NebulaIdPlugin.h"
#import <nebula_id/nebula_id-Swift.h>

@implementation NebulaIdPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNebulaIdPlugin registerWithRegistrar:registrar];
}
@end
