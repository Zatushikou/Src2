//
//  Owner.h
//  BluetoothLESample
//


#import <SpriteKit/SpriteKit.h>
#define STANDS_RADIUS 30
#define STANDS_RADIUSf (0.2*50)

@interface Owner : SKSpriteNode
@property int base_x,base_y;
- (void)move:(CFTimeInterval)timeSinceLastUpdate RSSI1:(int)rssi1 RSSI2:(int)rssi2 RSSI3:(int)rssi3; // 追加
- (void)movef:(CFTimeInterval)timeSinceLastUpdate RSSI1:(float)rssi1f RSSI2:(float)rssi2f RSSI3:(float)rssi3f; // 追加- (void)position_calc;
- (void)position_calc:(CFTimeInterval)timeSinceLastUpdate RSSI1:(int)rssi1;
- (void)position_calc:(CFTimeInterval)timeSinceLastUpdate RSSI1:(int)rssi1 RSSI2:(int)rssi2 Type:(int)type;
- (void)position_calc:(int)rssi1 RSSI2:(int)rssi2 RSSI3:(int)rssi3;

- (void)position_calcf:(CFTimeInterval)timeSinceLastUpdate RSSI1:(float)rssi1f;
- (void)position_calcf:(CFTimeInterval)timeSinceLastUpdate RSSI1:(float)rssi1f RSSI2:(float)rssi2f Type:(int)type;
- (void)position_calcf:(float)rssi1f RSSI2:(float)rssi2f RSSI3:(float)rssi3f;
@end
