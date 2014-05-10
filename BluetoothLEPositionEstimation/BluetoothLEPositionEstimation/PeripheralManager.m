//
//  PeripheralManager.m
//  BluetoothLETest
//


#import "PeripheralManager.h"

// サービスUUID:Immediate Alert
NSString *kUUIDServiceImmediateAlert = @"1802";
// サービスUUID:Battery Service
NSString *kUUIDServiceBatteryService = @"180F";
// キャラクタリスティックUUID:Alert Level
NSString *kUUIDCharacteristicsAlertLevel = @"2A06";
// キャラクタリスティックUUID:Battery Level
NSString *kUUIDCharacteristicsBatteryLevel = @"2A19";

#define red_vru01_uuid @"A63DF42C-EA53-060D-E280-A95FD0F4956F"
#define black_vru01_uuid @"DEC160FE-AE49-D7D8-335B-C2406F800514"
#define white_vru01_uuid @"F3CC6655-C6D7-5652-73A2-A9461A2ED5B2"

@interface PeripheralManager () {
    CBCentralManager *centralManager;
    //CBPeripheral *target_peripheral_red;
    CBCharacteristic *alertLevelCharacteristic_red;
    CBCharacteristic *batteryLevelCharacteristic_red;
    CBCharacteristic *alertLevelCharacteristic_black;
    CBCharacteristic *batteryLevelCharacteristic_black;
    CBCharacteristic *alertLevelCharacteristic_white;
    CBCharacteristic *batteryLevelCharacteristic_white;
}
@end

@implementation PeripheralManager
/*
@synthesize targetPeripheral_red = _targetPeripheral_red;
@synthesize targetPeripheral_black = _targetPeripheral_black;
@synthesize targetPeripheral_white = _targetPeripheral_white;
@synthesize delegate = _delegate;
@synthesize isScanning = _isScanning;
@synthesize isConnect_red = _isConnect_red;
@synthesize isConnect_black = _isConnect_black;
@synthesize isConnect_white = _isConnect_white;
@synthesize isAlerting_red = _isAlerting_red;
@synthesize isAlerting_black = _isAlerting_black;
@synthesize isAlerting_white = _isAlerting_white;
*/
#pragma mark - Properties

- (NSString *)deviceNameofType:(NSString *)type
{
    //NSString * return_name;
    /*
    if( _targetPeripheral_red!=nil && [type isEqualToString:@"red"]){
        return_name = _targetPeripheral_red.name;
    }else if(_targetPeripheral_black!=nil && [type isEqualToString:@"black"]){
        return_name = _targetPeripheral_black.name;
    }else if(_targetPeripheral_white!=nil && [type isEqualToString:@"white"]){
        return_name = _targetPeripheral_white.name;
    }
    else{
        ;
    }
     return return_name;
     */

    if (!_targetPeripheral_red)
    {
        return nil;
    }
    
    return _targetPeripheral_red.name;
}

#pragma mark - View lifecycle methods

- (id)init
{
    self = [super init];
    if (self)
    {
        // Bluetoothの接続マネージャーを生成
        centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _isScanning = false;
        /*
        _isConnect_red = false;
        _isConnect_white = false;
        _isConnect_black = false;
         */
        _search_mode = MULTIPLE;

    }
    return self;
}

#pragma mark - Public methods

- (void)scanForPeripheralsAndConnect
{
    // 探索対象のデバイスが持つサービスを指定
    NSArray *services = [NSArray arrayWithObjects:[CBUUID UUIDWithString:kUUIDServiceImmediateAlert], 
                         [CBUUID UUIDWithString:kUUIDServiceBatteryService], nil];
    // 単一デバイスの発見イベントを重複して発行させない
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] 
                                                        forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    
    // デバイスの探索を開始
    [centralManager scanForPeripheralsWithServices:services options:options];
    
    //タイマースタート、発見できなかったときにscanをやめるため。
    _timer = [NSTimer
             scheduledTimerWithTimeInterval:0.3
             target:self selector:@selector(endscan:) userInfo:nil repeats:YES];
    timer_count = 0;
    _isScanning = true;
    
}
-(void)endscan:(NSTimer *)timer
{
    // 探索対象のデバイスが持つサービスを指定
    NSArray *services = [NSArray arrayWithObjects:[CBUUID UUIDWithString:kUUIDServiceImmediateAlert],
                         [CBUUID UUIDWithString:kUUIDServiceBatteryService], nil];
    // 単一デバイスの発見イベントを重複して発行させない
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                        forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    //NSLog(@"test");
    if(timer_count++>3){
        [timer invalidate];
        timer = nil;
        _isScanning = false;
        [centralManager stopScan];
        [self.delegate peripheralManagerFinishSerchPeripheral:self];
    }else{
        [centralManager stopScan];
        [centralManager scanForPeripheralsWithServices:services options:options];
    }
    if(_targetPeripheral_red.state ==  CBPeripheralStateDisconnected&&_targetPeripheral_black.state ==  CBPeripheralStateDisconnected&&_targetPeripheral_white.state ==  CBPeripheralStateDisconnected){
        //[_delegate peripheralManagerDidDisconnectPeripheral:self Type:@"red"];
        //[_delegate peripheralManagerDidDisconnectPeripheral:self Type:@"black"];
        //[_delegate peripheralManagerDidDisconnectPeripheral:self Type:@"white"];

        NSLog(@"can't fiind peripheral");
    }
}
- (void)scanForPeripheralsAndConnectSingle
{
    // 探索対象のデバイスが持つサービスを指定
    NSArray *services = [NSArray arrayWithObjects:[CBUUID UUIDWithString:kUUIDServiceImmediateAlert],
                         [CBUUID UUIDWithString:kUUIDServiceBatteryService], nil];
    // 単一デバイスの発見イベントを重複して発行させない
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                        forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    
    // デバイスの探索を開始
    [centralManager scanForPeripheralsWithServices:services options:options];
    
    //タイマースタート、発見できなかったときにscanをやめるため。
    _timer = [NSTimer
              scheduledTimerWithTimeInterval:0.3
              target:self selector:@selector(endscanSingle:) userInfo:nil repeats:NO];
    _isScanning = true;
    
}
-(void)endscanSingle:(NSTimer *)timer
{
   
    [centralManager stopScan];
    [timer invalidate];
    timer = nil;
    _isScanning = false;
    NSLog(@"endscanSingle");
    [self.delegate peripheralManagerFinishSerchPeripheral:self];
}
- (void)notifyAlertofType:(NSString *)type
{
    // HighAlertを指定
    ushort value = 2;
    NSMutableData *data = [NSMutableData dataWithBytes:&value length:8];
    // alertLevelの値を書き込んで、接続デバイスに通知
    if( _targetPeripheral_red!=nil && [type isEqualToString:@"red"]){
        [_targetPeripheral_red writeValue:data
                        forCharacteristic:alertLevelCharacteristic_red
                                     type:CBCharacteristicWriteWithoutResponse];
        _isAlerting_red = true;

    }else if(_targetPeripheral_black!=nil && [type isEqualToString:@"black"]){
        [_targetPeripheral_black writeValue:data
                        forCharacteristic:alertLevelCharacteristic_black
                                     type:CBCharacteristicWriteWithoutResponse];
        _isAlerting_black = true;

    }else if(_targetPeripheral_white!=nil && [type isEqualToString:@"white"]){
        [_targetPeripheral_white writeValue:data
                        forCharacteristic:alertLevelCharacteristic_white
                                     type:CBCharacteristicWriteWithoutResponse];
        _isAlerting_white = true;
    }
    else{
        ;
    }

    
}

- (void)stopAlertofType:(NSString *)type
{
    // HighAlertを指定
    ushort value = 0;
    NSMutableData *data = [NSMutableData dataWithBytes:&value length:8];
    // alertLevelの値を書き込んで、接続デバイスに通知
    if( _targetPeripheral_red!=nil && [type isEqualToString:@"red"]){
        [_targetPeripheral_red writeValue:data
                        forCharacteristic:alertLevelCharacteristic_red
                                     type:CBCharacteristicWriteWithoutResponse];
        _isAlerting_red = false;
        
    }else if(_targetPeripheral_black!=nil && [type isEqualToString:@"black"]){
        [_targetPeripheral_black writeValue:data
                          forCharacteristic:alertLevelCharacteristic_black
                                       type:CBCharacteristicWriteWithoutResponse];
        _isAlerting_black = false;
        
    }else if(_targetPeripheral_white!=nil && [type isEqualToString:@"white"]){
        [_targetPeripheral_white writeValue:data
                          forCharacteristic:alertLevelCharacteristic_white
                                       type:CBCharacteristicWriteWithoutResponse];
        _isAlerting_white = false;
    }
    else{
        ;
    }

}
- (void)checkBatteryofType:(NSString *)type
{
    // 接続デバイスのバッテリー情報取得
    if( _targetPeripheral_red!=nil && [type isEqualToString:@"red"]){
        [_targetPeripheral_red readValueForCharacteristic:batteryLevelCharacteristic_red];
        
    }else if(_targetPeripheral_black!=nil && [type isEqualToString:@"black"]){
        [_targetPeripheral_black readValueForCharacteristic:batteryLevelCharacteristic_black];
        
    }else if(_targetPeripheral_white!=nil && [type isEqualToString:@"white"]){
        [_targetPeripheral_white readValueForCharacteristic:batteryLevelCharacteristic_white];
    }
    else{
        ;
    }
}

#pragma mark - CBCentralManagerDelegate methods

- (void)centralManager:(CBCentralManager *)central 
 didDiscoverPeripheral:(CBPeripheral *)peripheral 
     advertisementData:(NSDictionary *)advertisementData 
                  RSSI:(NSNumber *)RSSI
{
    
    NSLog(@"didDiscoverPeripheral UUID:%@ advertisementData:%@", peripheral.identifier, [advertisementData description]);
    
    //_targetPeripheral_red = peripheral;
    peripheral.delegate = self;

    // 発見されたデバイスに接続
    //NSLog(@"identifier %@",(peripheral.identifier.UUIDString));
    //NSLog(@"%@",red_vru01_uuid);
    //NSLog(@"%hhd",[peripheral.identifier.UUIDString isEqualToString:red_vru01_uuid]);
    //NSLog(@"%hhd",[(__bridge_transfer NSString *)(peripheral.UUID)  isEqual: red_vru01_uuid]);
    //NSLog(@"%hhd",[[NSString stringWithFormat:@"%@",(peripheral.UUID)] isEqualToString: red_vru01_uuid]);
    /*
    CBUUID *targetUUID_red = [CBUUID UUIDWithString:red_vru01_uuid];
    CBUUID *targetUUID_black = [CBUUID UUIDWithString:black_vru01_uuid];
    CBUUID *targetUUID_white = [CBUUID UUIDWithString:white_vru01_uuid];
    if (!peripheral.isConnected && [[CBUUID UUIDWithCFUUID:peripheral.UUID].data isEqualToData:targetUUID_red.data] && (_search_mode == MULTIPLE || _search_mode == RED ))
     */
    //NSLog(@"peripheralstate %d",peripheral.state);
    if(peripheral.state == CBPeripheralStateDisconnected && [peripheral.identifier.UUIDString isEqualToString:red_vru01_uuid] && (_search_mode == MULTIPLE || _search_mode == RED ))
    {
        _targetPeripheral_red = peripheral;
        [centralManager connectPeripheral:_targetPeripheral_red options:nil];
        //_isConnect_red = true;
        //[self addObserver:target_peripheral_red forKeyPath:@"RSSI" options:0 context:<#(void *)#>];
    }else if (peripheral.state == CBPeripheralStateDisconnected && [peripheral.identifier.UUIDString isEqualToString:black_vru01_uuid] && (_search_mode == MULTIPLE || _search_mode == BLACK ))
    {
        _targetPeripheral_black = peripheral;
        [centralManager connectPeripheral:peripheral options:nil];
        //_isConnect_black = true;
        //[self addObserver:target_peripheral_red forKeyPath:@"RSSI" options:0 context:<#(void *)#>];
    }else if (peripheral.state == CBPeripheralStateDisconnected && [peripheral.identifier.UUIDString isEqualToString:white_vru01_uuid] && (_search_mode == MULTIPLE || _search_mode == WHITE ))
    {
        _targetPeripheral_white = peripheral;
        [centralManager connectPeripheral:peripheral options:nil];
        //_isConnect_white = true;
        //[self addObserver:target_peripheral_red forKeyPath:@"RSSI" options:0 context:<#(void *)#>];
    }
    
}
-(void)disconnectofType:(NSString *)type
{
    NSLog(@"disconnectofType %@",type);
    if( _targetPeripheral_red!=nil && [type isEqualToString:@"red"]){
        //NSLog(@"disconnect %@",_targetPeripheral_red);
        [centralManager cancelPeripheralConnection:_targetPeripheral_red];
        _targetPeripheral_red = false;
        //_isConnect_red = false;
        [self.delegate peripheralManagerDidDisconnectPeripheral:self Type:@"red"];
        
    }else if(_targetPeripheral_black!=nil && [type isEqualToString:@"black"]){
        [centralManager cancelPeripheralConnection:_targetPeripheral_black];
        _targetPeripheral_black = false;
        //_isConnect_black = false;
        [self.delegate peripheralManagerDidDisconnectPeripheral:self Type:@"black"];
        
    }else if(_targetPeripheral_white!=nil && [type isEqualToString:@"white"]){
        [centralManager cancelPeripheralConnection:_targetPeripheral_white];
        _targetPeripheral_white = false;
        //_isConnect_white = false;
        [self.delegate peripheralManagerDidDisconnectPeripheral:self Type:@"white"];
    }
    //peripheral = nil;
    //_isConnect = false;
}
-(void)readRSSIofType:(NSString *)type
{
       if( _targetPeripheral_red!=nil && [type isEqualToString:@"red"]){
            [_targetPeripheral_red readRSSI];
        }else if(_targetPeripheral_black!=nil && [type isEqualToString:@"black"]){
            [_targetPeripheral_black readRSSI];
        }else if(_targetPeripheral_white!=nil && [type isEqualToString:@"white"]){
            [_targetPeripheral_white readRSSI];
        }
        else{
            ;
        }
}
- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"didConnectPeripheral");
    //NSLog(@"%@",[NSString stringWithFormat:@"%@",(peripheral.UUID)]);
    // 外部デバイスとの接続完了を通知
    
    if ([peripheral.identifier.UUIDString isEqualToString:red_vru01_uuid])
    {
        [self.delegate peripheralManagerDidConnectPeripheral:self Type:@"red"];
    }else if ([peripheral.identifier.UUIDString isEqualToString:black_vru01_uuid])
    {
        [self.delegate peripheralManagerDidConnectPeripheral:self Type:@"black"];
    }else if ([peripheral.identifier.UUIDString isEqualToString:white_vru01_uuid])
    {
       [self.delegate peripheralManagerDidConnectPeripheral:self Type:@"white"];
    }
    

    // 探索するサービスを指定
    NSArray *services = [NSArray arrayWithObjects:[CBUUID UUIDWithString:kUUIDServiceImmediateAlert], 
                         [CBUUID UUIDWithString:kUUIDServiceBatteryService], nil];
    // サービスの探索を開始
    [peripheral discoverServices:services];
}

- (void)centralManager:(CBCentralManager *)central
didFailToConnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error
{
    NSLog(@"didFailToConnectPeripheral %@", [error localizedDescription]);
}

- (void)centralManager:(CBCentralManager *)central
didDisconnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error
{
    NSLog(@"didDisconnectPeripheral %@", [error localizedDescription]);
    
    if ([peripheral.identifier.UUIDString isEqualToString:red_vru01_uuid])
    {
        //_isConnect_red = false;
        [self.delegate peripheralManagerDidDisconnectPeripheral:self Type:@"red"];
    
    }else if ([peripheral.identifier.UUIDString isEqualToString:black_vru01_uuid])
    {
        //_isConnect_black = false;
        [self.delegate peripheralManagerDidDisconnectPeripheral:self Type:@"black"];
    }else if ([peripheral.identifier.UUIDString isEqualToString:white_vru01_uuid])
    {
        //_isConnect_white = false;
        [self.delegate peripheralManagerDidDisconnectPeripheral:self Type:@"white"];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            NSLog(@"centralManagerDidUpdateState poweredOn");
            break;
            
        case CBCentralManagerStatePoweredOff:
            NSLog(@"centralManagerDidUpdateState poweredOff");
            break;
            
        case CBCentralManagerStateResetting:
            NSLog(@"centralManagerDidUpdateState resetting");
            break;
            
        case CBCentralManagerStateUnauthorized:
            NSLog(@"centralManagerDidUpdateState unauthorized");
            break;
            
        case CBCentralManagerStateUnsupported:
            NSLog(@"centralManagerDidUpdateState unsupported");
            break;
            
        case CBCentralManagerStateUnknown:
            NSLog(@"centralManagerDidUpdateState unknown");
            break;
            
        default:
            break;
    }
}

#pragma mark - CBPeripheralDelegate methods

- (void)peripheral:(CBPeripheral *)peripheral 
didDiscoverServices:(NSError *)error
{
    if (error)
    {
        NSLog(@"didDiscoverServices error: %@", error.localizedDescription);
        return;
    }
    
    if (peripheral.services.count == 0)
    {
        NSLog(@"didDiscoverServices no services");
        return;
    }
    
    NSLog(@"didDiscoverServices services:%@", [peripheral.services description]);
    
    for (CBService *service in peripheral.services)
    {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:kUUIDServiceImmediateAlert]])
        {
            // Immediate Alertサービスを発見した場合、Alert Levelキャラクタリスティックの探索を開始
            [peripheral discoverCharacteristics:[NSArray arrayWithObjects:[CBUUID UUIDWithString:kUUIDCharacteristicsAlertLevel], nil] forService:service];
        }
        else if ([service.UUID isEqual:[CBUUID UUIDWithString:kUUIDServiceBatteryService]])
        {
            // Battery Serviceサービスを発見した場合、Battery Levelキャラクタリスティックの探索を開始
            [peripheral discoverCharacteristics:[NSArray arrayWithObjects:[CBUUID UUIDWithString:kUUIDCharacteristicsBatteryLevel], nil] forService:service];
        } 
    }
}

- (void)peripheral:(CBPeripheral *)peripheral 
didDiscoverCharacteristicsForService:(CBService *)service 
             error:(NSError *)error
{
    if (error)
    {
        NSLog(@"didDiscoverCharacteristics error: %@", error.localizedDescription);
        return;
    }
    
    if (service.characteristics.count == 0)
    {
        NSLog(@"didDiscoverCharacteristics no characteristics");
        return;
    }
    
    NSLog(@"didDiscoverCharacteristics %@", [service.characteristics description]);
    //NSLog(@"%@",[NSString stringWithFormat:@"%@",(peripheral.UUID)]);
    
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kUUIDCharacteristicsAlertLevel]])
        {
            
            // Alert Levelキャラクタリスティックオブジェクトへの参照を保管
            
            // 外部デバイス鳴動指示準備完了を通知
            if ([peripheral.identifier.UUIDString isEqualToString:red_vru01_uuid])
            {
                alertLevelCharacteristic_red = characteristic;
                [self.delegate peripheralManagerNotifyAlertReady:self Type:@"red"];
            }else if ([peripheral.identifier.UUIDString isEqualToString:black_vru01_uuid])
            {
                alertLevelCharacteristic_black = characteristic;
                [self.delegate peripheralManagerNotifyAlertReady:self Type:@"black"];
            }else if ([peripheral.identifier.UUIDString isEqualToString:white_vru01_uuid])
            {
                alertLevelCharacteristic_white = characteristic;
                [self.delegate peripheralManagerNotifyAlertReady:self Type:@"white"];
            }
            
        }
        else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kUUIDCharacteristicsBatteryLevel]])
        {
            // Battery Levelキャラクタリスティックオブジェクトへの参照を保管
            // 外部デバイスバッテリー情報取得準備完了を通知
            if ([peripheral.identifier.UUIDString isEqualToString:red_vru01_uuid])
            {
                batteryLevelCharacteristic_red = characteristic;
                [self.delegate peripheralManagerCheckBatteryReady:self Type:@"red"];
            }else if ([peripheral.identifier.UUIDString isEqualToString:black_vru01_uuid])
            {
                batteryLevelCharacteristic_black = characteristic;
                [self.delegate peripheralManagerCheckBatteryReady:self Type:@"black"];
            }else if ([peripheral.identifier.UUIDString isEqualToString:white_vru01_uuid])
            {
                batteryLevelCharacteristic_white = characteristic;
                [self.delegate peripheralManagerCheckBatteryReady:self Type:@"white"];
            }
            
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral 
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic 
             error:(NSError *)error
{
    if (error)
    {
        NSLog(@"didUpdateValueForCharacteristic error: %@", error.localizedDescription);
        return;
    }
    
    NSLog(@"didUpdateValueForCharacteristic");
    
    if ([characteristic isEqual:batteryLevelCharacteristic_red])
    {
        // バッテリー情報の値を取得
        ushort value;
        NSMutableData *data = [NSMutableData dataWithData:characteristic.value];
        [data increaseLengthBy:8];
        [data getBytes:&value length:sizeof(value)];
        // バッテリー情報取得完了を通知
        [self.delegate peripheralManager:self didCheckBattery:value Type:@"red"];
    }else if ([characteristic isEqual:batteryLevelCharacteristic_black])
    {
        // バッテリー情報の値を取得
        ushort value;
        NSMutableData *data = [NSMutableData dataWithData:characteristic.value];
        [data increaseLengthBy:8];
        [data getBytes:&value length:sizeof(value)];
        // バッテリー情報取得完了を通知
        [self.delegate peripheralManager:self didCheckBattery:value Type:@"black"];
    }else if ([characteristic isEqual:batteryLevelCharacteristic_white])
    {
        // バッテリー情報の値を取得
        ushort value;
        NSMutableData *data = [NSMutableData dataWithData:characteristic.value];
        [data increaseLengthBy:8];
        [data getBytes:&value length:sizeof(value)];
        // バッテリー情報取得完了を通知
        [self.delegate peripheralManager:self didCheckBattery:value Type:@"white"];
    }
}

@end
