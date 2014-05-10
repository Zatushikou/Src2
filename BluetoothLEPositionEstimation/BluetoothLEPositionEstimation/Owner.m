//
//  Owner.m
//  BluetoothLESample
//


#import "Owner.h"

@implementation Owner
@synthesize base_x,base_y;

- (void)move:(CFTimeInterval)timeSinceLastUpdate RSSI1:(int)rssi1 RSSI2:(int)rssi2 RSSI3:(int)rssi3{
    int valid_sensor_count = 0;
    int valid_rssi1,valid_rssi2,valid_rssi3; //white, red, black
    valid_rssi1 = valid_rssi2 = valid_rssi3 = 0;
    if(rssi1) {
        valid_sensor_count+=1;
        valid_rssi1 = -(rssi1+40)*3;
    }
    if(rssi2) {
        valid_sensor_count+=1;
        valid_rssi2 = -(rssi2+40)*3;
    }
    if(rssi3) {
        valid_sensor_count+=1;
        valid_rssi3 = -(rssi3+40)*3;
    }
    switch(valid_sensor_count){
        case 1:
            [self position_calc:timeSinceLastUpdate RSSI1:valid_rssi1];
            break;
        case 2:
            [self position_calc:timeSinceLastUpdate RSSI1:valid_rssi1 RSSI2:valid_rssi2 Type:2];
            break;
        case 3:
            [self position_calc:valid_rssi1 RSSI2:valid_rssi2 RSSI3:valid_rssi3];
            break;
        default:
            [self position_calc];
            break;
    }
    //NSLog(@"%d",valid_sensor_count);
}
- (void)movef:(CFTimeInterval)timeSinceLastUpdate RSSI1:(float)rssi1f RSSI2:(float)rssi2f RSSI3:(float)rssi3f{
    int valid_sensor_count = 0;
    float valid_rssi1,valid_rssi2,valid_rssi3; //white, red, black
    valid_rssi1 = valid_rssi2 = valid_rssi3 = 0;
    //NSLog(@"movef");
    //NSLog(@"rssi %f",rssi1f);
    if(rssi1f>0) {
        valid_sensor_count+=1;
        valid_rssi1 = rssi1f*50;
        //NSLog(@"valid rssi %f",valid_rssi1);
    }
    if(rssi2f>0) {
        valid_sensor_count+=1;
        valid_rssi2 = rssi2f*50;
    }
    if(rssi3f>0) {
        valid_sensor_count+=1;
        valid_rssi3 = rssi3f*50;
    }
    switch(valid_sensor_count){
        case 1:
            [self position_calcf:timeSinceLastUpdate RSSI1:valid_rssi1];
            break;
        case 2:
            [self position_calc:timeSinceLastUpdate RSSI1:valid_rssi1 RSSI2:valid_rssi2 Type:2];
            break;
        case 3:
            [self position_calcf:valid_rssi1 RSSI2:valid_rssi2 RSSI3:valid_rssi3];
            break;
        default:
            [self position_calc];
            break;
    }
    //NSLog(@"%d",valid_sensor_count);
}

- (void)position_calc{
    self.position = CGPointMake(-100,-100);
}
- (void)position_calc:(CFTimeInterval)timeSinceLastUpdate RSSI1:(int)rssi1{
    const float speed = 1.57f;
    //const float angularSpeed = 6.28f / 10.0f;
    // 回転させる
    float angularAmount = speed * timeSinceLastUpdate;
    static float theta = 1.57f;
    theta += angularAmount;
    float moveAmountX = cos(theta) * rssi1;
    float moveAmountY = sin(theta) * rssi1;
    //CGPoint positionBefore = self.position;
    
    self.position = CGPointMake(self.base_x+moveAmountX,self.base_y+moveAmountY);
}
- (void)position_calc:(CFTimeInterval)timeSinceLastUpdate RSSI1:(int)rssi1 RSSI2:(int)rssi2 Type:(int)type {
    
}
- (void)position_calc:(int)rssi1 RSSI2:(int)rssi2 RSSI3:(int)rssi3{
    float d = 0;
    float theta = 0;
    d = sqrt( (rssi1*rssi1 + rssi2*rssi2 + rssi3*rssi3)/3 - STANDS_RADIUS*STANDS_RADIUS );
    theta = atan2f( (rssi3*rssi3 - rssi2*rssi2)/sqrt(3),  rssi2*rssi2 + rssi3*rssi3 -2*d*d-2*STANDS_RADIUS*STANDS_RADIUS );
    
    float moveAmountX = cos(theta) * d;
    float moveAmountY = sin(theta) * d;
    //CGPoint positionBefore = self.position;
    if(!isnan(moveAmountX)&&!isnan(moveAmountY)){
        self.position = CGPointMake(self.base_x+moveAmountX,self.base_y+moveAmountY);
    }
    //NSLog(@"%f　%f %f", (rssi3*rssi3 - rssi2*rssi2)/sqrt(3),d*d+STANDS_RADIUS*STANDS_RADIUS-rssi1*rssi1,  rssi2*rssi2 + rssi3*rssi3 -2*d*d-2*STANDS_RADIUS*STANDS_RADIUS);
    //NSLog(@"%d　%d %d",rssi1,rssi2,rssi3);
    //NSLog(@"%f　%f",d,theta/3.14*180 );
    //NSLog(@"%f　%f",moveAmountX,moveAmountY);
}

- (void)position_calcf:(CFTimeInterval)timeSinceLastUpdate RSSI1:(float)rssi1f{
    const float speed = 1.57f;
    //const float angularSpeed = 6.28f / 10.0f;
    // 回転させる
    float angularAmount = speed * timeSinceLastUpdate;
    float d = rssi1f;
    //NSLog(@"rssif position calc %f",rssi1f);
    static float theta = 1.57f;
    theta += angularAmount;
    float moveAmountX = cos(theta) * d;
    float moveAmountY = sin(theta) * d;
    //CGPoint positionBefore = self.position;
    
    self.position = CGPointMake(self.base_x+moveAmountX,self.base_y+moveAmountY);
}
- (void)position_calcf:(CFTimeInterval)timeSinceLastUpdate RSSI1:(float)rssi1f RSSI2:(float)rssi2f Type:(int)type {
    
}
- (void)position_calcf:(float)rssi1f RSSI2:(float)rssi2f RSSI3:(float)rssi3f{
    float d = 0;
    float theta = 0;
    d = sqrt( (rssi1f*rssi1f + rssi2f*rssi2f + rssi3f*rssi3f)/3 - STANDS_RADIUSf*STANDS_RADIUSf );
    theta = atan2f( (rssi3f*rssi3f - rssi2f*rssi2f)/sqrt(3),  rssi2f*rssi2f + rssi3f*rssi3f -2*d*d-2*STANDS_RADIUSf*STANDS_RADIUSf ) + 3.14;
    
    float moveAmountX = cos(theta) * d;
    float moveAmountY = sin(theta) * d;
    //CGPoint positionBefore = self.position;
    if(!isnan(moveAmountX)&&!isnan(moveAmountY)){
        self.position = CGPointMake(self.base_x+moveAmountX,self.base_y+moveAmountY);
    }
    //NSLog(@"%f　%f %f", );
    //NSLog(@"%f　%f %f",rssi1f,rssi2f,rssi3f);
    NSLog(@"%f　%f",d,theta/3.14*180 );
    //NSLog(@"%f　%f",moveAmountX,moveAmountY);

}

@end
