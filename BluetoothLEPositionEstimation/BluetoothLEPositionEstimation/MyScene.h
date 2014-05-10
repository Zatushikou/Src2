//
//  MyScene.h
//  BluetoothLESample
//

#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIKit.h>
#import "SerchCircle.h"
#import "Owner.h"

@interface MyScene : SKScene{
    dispatch_once_t lastUpdatedAtInitToken;
    CFTimeInterval lastUpdatedAt;
    SerchCircle* serch_circle;
    Owner* owner;
    
}
@property int rssi1,rssi2,rssi3;
@property float rssi1f,rssi2f,rssi3f;

@end
