//
//  LVBT-BRU01Peripheral.h
//  BluetoothLESample
//
//  Created by 岡本 悠 on 2014/03/01.
//  Copyright (c) 2014年 Classmethod Inc. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface LVBT_BRU01Peripheral : CBPeripheral
@property (nonatomic, retain) CBPeripheral* targetPeripheral;

@end
