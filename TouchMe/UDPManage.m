//
//  UDPManage.m
//  TouchMe
//
//  Created by 王钢锋 on 2018/11/6.
//  Copyright © 2018年 wang. All rights reserved.
//

#import "UDPManage.h"

@interface UDPManage() 

@end

static UDPManage * myUDPManage=nil;

@implementation UDPManage
+(instancetype)shareUDPManage{
	static dispatch_once_t onceTocken;
	dispatch_once(&onceTocken, ^{myUDPManage=[[UDPManage alloc] init];[myUDPManage creatClientUdpSocket];});
	return myUDPManage;
}
-(void)creatClientUdpSocket{
	_socket=[[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
	NSError * error=nil;
	[_socket bindToPort:6666 error:&error];
	[_socket enableBroadcast:YES error:&error];
	if (error) {//监听错误打印错误信息
		NSLog(@"error:%@",error);
	}else {//监听成功则开始接收信息
		[_socket beginReceiving:&error];
	}
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
	if(tag==100){
		NSLog(@"发送信息成功");
	}
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
	NSLog(@"%ld发送信息失败,原因%@",tag,error);
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
	NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
	uint16_t port=[GCDAsyncUdpSocket portFromAddress:address];
	NSString *dat = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"收到%@:%hu回复：%@", ip,port,dat);
}


@end
