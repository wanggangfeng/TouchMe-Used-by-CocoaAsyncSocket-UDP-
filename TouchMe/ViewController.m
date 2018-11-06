//
//  ViewController.m
//  TouchMe
//
//  Created by 王钢锋 on 2018/11/5.
//  Copyright © 2018年 wang. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncUdpSocket.h"
@interface ViewController ()<GCDAsyncUdpSocketDelegate>
	@property (strong,nonatomic) GCDAsyncUdpSocket * socket;
@end


@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	_socket=[[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	NSError * error=nil;
	[_socket bindToPort:6666 error:&error];
	[_socket enableBroadcast:YES error:&error];
	if (error) {//监听错误打印错误信息
		NSLog(@"error:%@",error);
	}else {//监听成功则开始接收信息
		[_socket beginReceiving:&error];
	}
}
- (IBAction)TurnLeft:(UIButton *)sender {
	NSString *str = @"Turn Left";
	NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
	[self.socket sendData:data toHost:@"255.255.255.255" port:6666 withTimeout:-1 tag:10];      // 发送
}
- (IBAction)TurnRight:(UIButton *)sender {
	NSString *str = @"Turn Right";
	NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
	[self.socket sendData:data toHost:@"255.255.255.255" port:6666 withTimeout:-1 tag:10];      // 发送
}
#pragma mark - GCDAsyncUdpSocket delegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
	if(tag==10)
	NSLog(@"发送信息成功");
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
	NSLog(@"发送信息失败");
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
	NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
	uint16_t port=[GCDAsyncUdpSocket portFromAddress:address];
	NSString * sendMessage = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"接收到%@:%d的消息：%@",ip,port,sendMessage);
//	[self sendMessage:sendMessage andType:@1];//原样转回
}
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
	NSLog(@"udpSocket关闭");
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
	NSLog(@"请检查w无线局域网连接状态");
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
	NSLog(@"连接成功");
}
@end
