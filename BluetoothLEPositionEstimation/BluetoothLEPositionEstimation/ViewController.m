//
//  ViewController.m
//  BluetoothLESample
//


#import "ViewController.h"

@implementation ViewController

@synthesize label;
@synthesize connectButton;
@synthesize alertButton;
@synthesize batteryButton;

#pragma mark - View lifecycle methods

- (void)initialize {
    
    // ここで子ビューの初期化
    self.label.text = @"未接続";
    self.alertButton.enabled = NO;
    self.batteryButton.enabled = NO;
    self.label_black.text = @"未接続";
    self.alertButton_black.enabled = NO;
    self.batteryButton_black.enabled = NO;
    self.label_white.text = @"未接続";
    self.alertButton_white.enabled = NO;
    self.batteryButton_white.enabled = NO;
    // Bluetoothデバイスのマネージャーを作成
    if(self.peripheralManager.targetPeripheral_red.state == CBPeripheralStateConnected){
        [self.connectButtonRed setTitle:@"切断" forState:UIControlStateNormal];
        self.connectButtonRed.enabled = true;
        self.label.text = @"接続";
        self.alertButton.enabled = YES;
        self.batteryButton.enabled = YES;
        _timer = [NSTimer
                  scheduledTimerWithTimeInterval:0.2
                  target:self selector:@selector(updateRSSI:) userInfo:nil repeats:YES];
    }
    if(self.peripheralManager.targetPeripheral_black.state == CBPeripheralStateConnected){
        [self.connectButtonBlack setTitle:@"切断" forState:UIControlStateNormal];
        self.connectButtonBlack.enabled = true;
        self.label_black.text = @"接続";
        self.alertButton_black.enabled = YES;
        self.batteryButton_black.enabled = YES;
        _timer = [NSTimer
                  scheduledTimerWithTimeInterval:0.2
                  target:self selector:@selector(updateRSSI:) userInfo:nil repeats:YES];
    }
    if(self.peripheralManager.targetPeripheral_white.state == CBPeripheralStateConnected){
        [self.connectButtonWhite setTitle:@"切断" forState:UIControlStateNormal];
        self.connectButtonWhite.enabled = true;
        self.label_white.text = @"接続";
        self.alertButton_white.enabled = YES;
        self.batteryButton_white.enabled = YES;
        _timer = [NSTimer
                  scheduledTimerWithTimeInterval:0.2
                  target:self selector:@selector(updateRSSI:) userInfo:nil repeats:YES];
    }
    if(self.peripheralManager.targetPeripheral_red.state == CBPeripheralStateConnected && self.peripheralManager.targetPeripheral_black.state == CBPeripheralStateConnected && self.peripheralManager.targetPeripheral_white.state == CBPeripheralStateConnected){
        [self.connectButton setTitle:@"切断" forState:UIControlStateNormal];
        self.connectButton.enabled = true;
    }
    //self.peripheralManager = [[PeripheralManager alloc] init];
    //self.peripheralManager.delegate = self;
    //[self.peripheralManager.targetPeripheral_red addObserver:self forKeyPath:@"RSSI" options:0 context:nil];
    NSLog(@"init");
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initialize];
    NSLog(@"viewdidload");

}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewdidappear");
    
}
- (void)viewDidUnload
{
    if(_timer != nil){
        _timer = nil;
    }
    NSLog(@"viewdidunload");
    [self setLabel:nil];
    [self setConnectButton:nil];
    [self setAlertButton:nil];
    [self setBatteryButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - PefipheralManagerDelegate methods
/*
-(void)endScan:(PeripheralManager *)manager
{
    if(manager.isConnect){
        [self peripheralManagerDidConnectPeripheral:manager];
    }else{
        [self peripheralManagerDidDisconnectPeripheral:manager];
    }
    
}
*/

- (void)peripheralManagerDidConnectPeripheral:(PeripheralManager *)manager Type:(NSString *)type
{
    if([type isEqualToString:@"red"]){
        self.label.text = @"接続中";//[NSString stringWithFormat:@"接続中:%@", manager.deviceName];
        self.connectButton.enabled = true;
        [self.connectButtonRed setTitle:@"切断" forState:UIControlStateNormal];
        self.connectButtonRed.enabled = true;
        
    }else if([type isEqualToString:@"black"]){
        self.label_black.text = @"接続中";//[NSString stringWithFormat:@"接続中:%@", manager.deviceName];
        self.connectButton.enabled = true;
        [self.connectButtonBlack setTitle:@"切断" forState:UIControlStateNormal];
        self.connectButtonBlack.enabled = true;
    } else if([type isEqualToString:@"white"]){
        self.label_white.text = @"接続中";//[NSString stringWithFormat:@"接続中:%@", manager.deviceName];
        self.connectButton.enabled = true;
        [self.connectButtonWhite setTitle:@"切断" forState:UIControlStateNormal];
        self.connectButtonWhite.enabled = true;
    }
        _timer = [NSTimer
              scheduledTimerWithTimeInterval:0.2
              target:self selector:@selector(updateRSSI:) userInfo:nil repeats:YES];

}
- (void)peripheralManagerFinishSerchPeripheral:(PeripheralManager *)manager{
    if(manager.targetPeripheral_red.state ==  CBPeripheralStateConnected && manager.targetPeripheral_black.state ==  CBPeripheralStateConnected && manager.targetPeripheral_white.state ==  CBPeripheralStateConnected){
        [self.connectButton setTitle:@"切断" forState:UIControlStateNormal];
    }
    else{
        [self.connectButton setTitle:@"接続" forState:UIControlStateNormal];
        self.connectButton.enabled = true;
    }
    if(manager.targetPeripheral_red.state ==  CBPeripheralStateDisconnected){
        //NSLog(@"finish serch peripheral :%d",manager.isConnect_red);
        [_connectButtonRed setTitle:@"接続" forState:UIControlStateNormal];
        self.connectButtonRed.enabled = true;
    }
    if(manager.targetPeripheral_black.state ==  CBPeripheralStateDisconnected){
        //NSLog(@"finish serch peripheral :%d",manager.isConnect_red);
        [_connectButtonBlack setTitle:@"接続" forState:UIControlStateNormal];
        self.connectButtonBlack.enabled = true;
    }
    if(manager.targetPeripheral_white.state ==  CBPeripheralStateDisconnected){
        //NSLog(@"finish serch peripheral :%d",manager.isConnect_red);
        [_connectButtonWhite setTitle:@"接続" forState:UIControlStateNormal];
        self.connectButtonWhite.enabled = true;
    }

    //NSLog(@"finish serch peripheral :%d",manager.isConnect_red);
    //[self.connectButtonRed setTitle:@"接続" forState:UIControlStateNormal];

}
- (void)peripheralManagerDidDisconnectPeripheral:(PeripheralManager *)manager Type:(NSString *)type
{
    NSLog(@"peripheralManagerDidDisconnectPeripheral %@",type);
    if([type isEqualToString:@"red"]){
        NSLog(@"peripheralManagerDidDisconnectPeripheral %@",type);
        self.label.text = @"未接続";
        NSLog(@"%@",self.label.text);
        self.RSSI_label.text = @"-";
        self.alertButton.enabled = NO;
        self.batteryButton.enabled = NO;
    }else if([type isEqualToString:@"black"]){
        self.label_black.text = @"未接続";
        self.RSSI_label_black.text = @"-";
        self.alertButton_black.enabled = NO;
        self.batteryButton_black.enabled = NO;
    }else if([type isEqualToString:@"white"]){
        self.label_white.text = @"未接続";
        self.RSSI_label_white.text = @"-";
        self.alertButton_white.enabled = NO;
        self.batteryButton_white.enabled = NO;
    }
    if(manager.targetPeripheral_red.state ==  CBPeripheralStateDisconnected && manager.targetPeripheral_black.state ==  CBPeripheralStateDisconnected && manager.targetPeripheral_white.state ==  CBPeripheralStateDisconnected){
        [self.connectButton setTitle:@"接続" forState:UIControlStateNormal];
        _timer = nil;
        self.connectButton.enabled = YES;
    }
    //NSLog(@"is_connect red %d",manager.isConnect_red);
    if(manager.targetPeripheral_red.state ==  CBPeripheralStateDisconnected){
        //NSLog(@"peripheralManagerDidDisconnectPeripheral");
        
        [self.connectButtonRed setTitle:@"接続" forState:UIControlStateNormal];
        _timer = nil;
        self.connectButtonRed.enabled = YES;
    }
    if(manager.targetPeripheral_black.state ==  CBPeripheralStateDisconnected){
        //NSLog(@"peripheralManagerDidDisconnectPeripheral");
        
        [self.connectButtonBlack setTitle:@"接続" forState:UIControlStateNormal];
        _timer = nil;
        self.connectButtonBlack.enabled = YES;
    }
    if(manager.targetPeripheral_white.state ==  CBPeripheralStateDisconnected){
        //NSLog(@"peripheralManagerDidDisconnectPeripheral");
        
        [self.connectButtonWhite setTitle:@"接続" forState:UIControlStateNormal];
        _timer = nil;
        self.connectButtonWhite.enabled = YES;
    }
}

- (void)peripheralManagerNotifyAlertReady:(PeripheralManager *)manager Type:(NSString *)type
{
    NSLog(@"notifyalertready %@",type);
    if([type isEqualToString:@"red"]){
        self.alertButton.enabled = YES;
    }else if([type isEqualToString:@"black"]){
        self.alertButton_black.enabled = YES;
    }else if([type isEqualToString:@"white"]){
        self.alertButton_white.enabled = YES;
    }

}

- (void)peripheralManagerCheckBatteryReady:(PeripheralManager *)manager Type:(NSString *)type
{
    if([type isEqualToString:@"red"]){
        self.batteryButton.enabled = YES;
    }else if([type isEqualToString:@"black"]){
        self.batteryButton_black.enabled = YES;
    }else if([type isEqualToString:@"white"]){
        self.batteryButton_white.enabled = YES;
    }

}

- (void)peripheralManager:(PeripheralManager *)manager
          didCheckBattery:(ushort)value Type:(NSString *)type
{
    // 接続デバイスのバッテリー残量をアラートで表示
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"バッテリー残量" 
                                                    message:[NSString stringWithFormat:@"接続先デバイスのバッテリー残量は%d%%です", value] 
                                                   delegate:nil 
                                          cancelButtonTitle:nil 
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

#pragma mark - Handlers

// 接続ボタンタップイベントハンドラ
-(void)connect{
    self.connectButton.enabled = false;
    [self.connectButton setTitle:@"検索中" forState:UIControlStateNormal];
    // デバイスのスキャンと接続を開始
    [self.peripheralManager scanForPeripheralsAndConnect];

}
-(void)disconnect{
    if(self.peripheralManager.targetPeripheral_red.state ==  CBPeripheralStateConnected)[self.peripheralManager disconnectofType:@"red"];
    if(self.peripheralManager.targetPeripheral_black.state ==  CBPeripheralStateConnected)[self.peripheralManager disconnectofType:@"black"];
    if(self.peripheralManager.targetPeripheral_white.state ==  CBPeripheralStateConnected)[self.peripheralManager disconnectofType:@"white"];
}
- (IBAction)connectButtonTouched:(id)sender
{
    if(self.peripheralManager.targetPeripheral_red.state ==  CBPeripheralStateConnected && self.peripheralManager.targetPeripheral_black.state ==  CBPeripheralStateConnected && self.peripheralManager.targetPeripheral_white.state ==  CBPeripheralStateConnected){
        [self disconnect];
    }else{
        self.peripheralManager.search_mode = MULTIPLE;
        [self connect];
    }
}

- (IBAction)connectButtonRedTouched:(id)sender {
    if(self.peripheralManager.targetPeripheral_red.state ==  CBPeripheralStateConnected){
        //NSLog(@"viewcontroller disconenct");
        [self.peripheralManager disconnectofType:@"red"];
    }else{
        self.peripheralManager.search_mode = RED;
        self.connectButtonRed.enabled = false;
        [self.connectButtonRed setTitle:@"検索中" forState:UIControlStateNormal];
        // デバイスのスキャンと接続を開始
        [self.peripheralManager scanForPeripheralsAndConnect];
    }
}

- (IBAction)connectButtonBlackTouched:(id)sender {
    if(self.peripheralManager.targetPeripheral_black.state ==  CBPeripheralStateConnected){
        //NSLog(@"viewcontroller disconenct");
        [self.peripheralManager disconnectofType:@"black"];
    }else{
        self.peripheralManager.search_mode = BLACK;
        self.connectButtonBlack.enabled = false;
        [self.connectButtonBlack setTitle:@"検索中" forState:UIControlStateNormal];
        // デバイスのスキャンと接続を開始
        [self.peripheralManager scanForPeripheralsAndConnectSingle];
    }
}

- (IBAction)connectButtonWhiteTouched:(id)sender {
    if(self.peripheralManager.targetPeripheral_white.state ==  CBPeripheralStateConnected){
        //NSLog(@"viewcontroller disconenct");
        [self.peripheralManager disconnectofType:@"white"];
    }else{
        self.peripheralManager.search_mode = WHITE;
        self.connectButtonWhite.enabled = false;
        [self.connectButtonWhite setTitle:@"検索中" forState:UIControlStateNormal];
        // デバイスのスキャンと接続を開始
        [self.peripheralManager scanForPeripheralsAndConnectSingle];
    }
}

// アラートボタンタップイベントハンドラ
- (IBAction)alertButtonTouched:(id)sender
{
    // 接続デバイスを鳴動させる
    if(self.peripheralManager.isAlerting_red){
        [self.peripheralManager stopAlertofType:@"red"];
    }else{
        [self.peripheralManager notifyAlertofType:@"red"];
    }
}

// バッテリーチェックボタンタップイベントハンドラ
- (IBAction)batteryButtonTouched:(id)sender
{
    // 接続デバイスのバッテリー情報を取得
    [self.peripheralManager checkBatteryofType:@"red"];
    //[peripheralManager.targetPeripheral readRSSI];
    //NSLog(@"%d",[peripheralManager.targetPeripheral.RSSI integerValue]);
}

- (IBAction)alertButtonBlackTouched:(id)sender {
    // 接続デバイスを鳴動させる
    if(self.peripheralManager.isAlerting_black){
        [self.peripheralManager stopAlertofType:@"black"];
    }else{
        [self.peripheralManager notifyAlertofType:@"black"];
    }

}
- (IBAction)batteryButtonBlackTouched:(id)sender{
    // 接続デバイスのバッテリー情報を取得
    [self.peripheralManager checkBatteryofType:@"black"];
    
}
- (IBAction)alertButtonWhiteTouched:(id)sender {
    // 接続デバイスを鳴動させる
    if(self.peripheralManager.isAlerting_white){
        [self.peripheralManager stopAlertofType:@"white"];
    }else{
        [self.peripheralManager notifyAlertofType:@"white"];
    }

}
- (IBAction)batteryButtonWhiteTouched:(id)sender {
    // 接続デバイスのバッテリー情報を取得
    [self.peripheralManager checkBatteryofType:@"white"];
    
}
- (void)updateRSSI:(NSTimer*)timer{
    if(self.peripheralManager.targetPeripheral_red.state ==  CBPeripheralStateConnected){
        [self.peripheralManager readRSSIofType:@"red"];
        //NSLog(@"%d",[peripheralManager.targetPeripheral.RSSI integerValue]);
        self.RSSI_label.text = [self.peripheralManager.targetPeripheral_red.RSSI stringValue];
    }
    if(self.peripheralManager.targetPeripheral_black.state ==  CBPeripheralStateConnected){
        [self.peripheralManager readRSSIofType:@"black"];
        //NSLog(@"%d",[peripheralManager.targetPeripheral.RSSI integerValue]);
        self.RSSI_label_black.text = [self.peripheralManager.targetPeripheral_black.RSSI stringValue];
    }
    if(self.peripheralManager.targetPeripheral_white.state ==  CBPeripheralStateConnected){
        [self.peripheralManager readRSSIofType:@"white"];
        //NSLog(@"%d",[peripheralManager.targetPeripheral.RSSI integerValue]);
        self.RSSI_label_white.text = [self.peripheralManager.targetPeripheral_white.RSSI stringValue];
    }

    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"keyPath=%@\nobject=%@\nchange=%@\ncontext=%@", keyPath, object, change, context);
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Segueの特定
    if ( [[segue identifier] isEqualToString:@"toMap"] ) {
        NSLog(@"prepareForSegue toMap");
        RSSIMapViewController *RSSIMapViewController = [segue destinationViewController];
        //ここで遷移先ビューのクラスの変数receiveStringに値を渡している
        RSSIMapViewController.peripheralManager = self.peripheralManager;
    }
}

@end
