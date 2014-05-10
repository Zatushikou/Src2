//
//  PeripheralManager.h
//  BluetoothLETest
//


#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


@class PeripheralManager;

@protocol PeripheralManagerDelegate <NSObject>
@optional
// 外部デバイスへの接続完了時に呼ばれる
- (void)peripheralManagerDidConnectPeripheral:(PeripheralManager *)manager Type:(NSString *)type;
// 外部デバイスとの接続の切断時に呼ばれる
- (void)peripheralManagerDidDisconnectPeripheral:(PeripheralManager *)manager Type:(NSString *)type;;
// 外部デバイスの鳴動指示が利用可能になった時に呼ばれる
- (void)peripheralManagerNotifyAlertReady:(PeripheralManager *)manager Type:(NSString *)type;;
// 外部デバイスのバッテリー情報取得が利用可能になった時に呼ばれる
- (void)peripheralManagerCheckBatteryReady:(PeripheralManager *)manager Type:(NSString *)type;;
// 外部でバイスのバッテリー情報取得完了時に呼ばれる
- (void)peripheralManager:(PeripheralManager *)manager
          didCheckBattery:(ushort)value Type:(NSString *)type;;
// 外部デバイスへの探索終了時に呼ばれる
- (void)peripheralManagerFinishSerchPeripheral:(PeripheralManager *)manager;
@end
enum SEARCH_MODE{
    MULTIPLE,
    RED,
    BLACK,
    WHITE
};
@interface PeripheralManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>{
    NSTimer *_timer;
    //BOOL isScanning;
    int timer_count;
}

@property (nonatomic, strong) id<PeripheralManagerDelegate> delegate;
@property (nonatomic, readonly) NSString *deviceName;
@property (nonatomic, readonly) BOOL isScanning;
/*
@property (nonatomic, readonly) BOOL isConnect_red;
@property (nonatomic, readonly) BOOL isConnect_black;
@property (nonatomic, readonly) BOOL isConnect_white;;
 */
@property (nonatomic, readonly) BOOL isAlerting_red;
@property (nonatomic, readonly) BOOL isAlerting_black;
@property (nonatomic, readonly) BOOL isAlerting_white;

@property (nonatomic, retain) CBPeripheral* targetPeripheral_red;
@property (nonatomic, retain) CBPeripheral* targetPeripheral_black;
@property (nonatomic, retain) CBPeripheral* targetPeripheral_white;
@property (nonatomic) enum SEARCH_MODE search_mode;
- (void)scanForPeripheralsAndConnect;
- (void)scanForPeripheralsAndConnectSingle;
- (void)notifyAlertofType:(NSString *)type;
- (void)stopAlertofType:(NSString *)type;
- (void)checkBatteryofType:(NSString *)type;
- (void)endscan:(NSTimer *)timer;
- (void)endscanSingle:(NSTimer *)timer;
- (void)disconnectofType:(NSString *)type;
- (void)readRSSIofType:(NSString *)type;

@end
