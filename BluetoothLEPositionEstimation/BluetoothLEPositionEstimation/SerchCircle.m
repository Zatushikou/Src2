//
//  SerchCircle.m
//  BluetoothLESample
//


#import "SerchCircle.h"

@implementation SerchCircle
@synthesize ScaleSpeed = _ScaleSpeed;
- (void)serch:(CFTimeInterval)timeSinceLastUpdate {
    //const float speed = 30.0f;
    //const float angularSpeed = 6.28f / 10.0f;
    // 回転させる
    //float angularAmount = self.angularSpeed * timeSinceLastUpdate;
   // self.zRotation = self.zRotation + angularAmount;
    // 向いている方向に移動させる
    self.xScale += self.ScaleSpeed * timeSinceLastUpdate;
    self.yScale += self.ScaleSpeed * timeSinceLastUpdate;
    if(self.xScale > 5){
        self.xScale = 0.2;
        self.yScale = 0.2;
    }
}

@end
