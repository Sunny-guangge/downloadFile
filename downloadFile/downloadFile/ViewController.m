//
//  ViewController.m
//  fileDownload
//
//  Created by user on 16/1/28.
//  Copyright © 2016年 user. All rights reserved.
//

#import "ViewController.h"
#import "CKVideoViewController.h"

@interface ViewController ()<NSURLConnectionDataDelegate>

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) NSMutableData *allData;

@property (nonatomic,strong) NSURLConnection *connection;

@property (nonatomic,assign) long long allM;

@property (nonatomic,copy) NSString *name;

//用filehandle 管理下载文件，下载一部分就写入沙盒，不会引起内存的暴涨
@property (nonatomic,strong) NSFileHandle *fileHandle;
@end

@implementation ViewController
{
    UIProgressView *progressView;
    float zhi;
    UILabel *label;
    CGFloat length ;
    BOOL isDownLoading;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.imageView];
    
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 200)];
    testView.backgroundColor = [UIColor redColor];
    [self.view addSubview:testView];
    
    length = 0;
    
    //异步下载图片
    [self asynchronousDownloadImage];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 80, self.view.frame.size.width, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    [self.view addSubview:label];
    
    progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - 40, self.view.frame.size.width - 40, 40)];
    [self.view addSubview:progressView];
    
    zhi = 0.0f;
    
    [self asyDownloadBigFile];
    
    //设置控制暂停开始下载按钮
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopDownLoadFile)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(nextViewController)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    isDownLoading = YES;
}

- (void)nextViewController
{
    CKVideoViewController *videoVC = [[CKVideoViewController alloc] init];
    [self.navigationController pushViewController:videoVC animated:YES];
}

#pragma mark - NSURLConnection 异步下载图片(小文件)
- (void)asynchronousDownloadImage
{
    NSURL *url = [NSURL URLWithString:@"https://picjumbo.imgix.net/HNCK8461.jpg?q=40&w=1650&sharp=30"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        _imageView.image = [UIImage imageWithData:data];
        
    }];
}

#pragma mark - NSURLConnection 异步下载大文件
- (void)asyDownloadBigFile
{
    NSURL *url = [NSURL URLWithString:@"http://7xi66y.com1.z0.glb.clouddn.com/winnovator_home%2Fwinnovator_media.mp4"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.allM = response.expectedContentLength;
    
    self.name = response.suggestedFilename;
    
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *file = [cache stringByAppendingPathComponent:self.name];
    
    NSLog(@"%@",file);
    
    NSFileManager *mgr = [[NSFileManager alloc] init];
    [mgr createFileAtPath:file contents:nil attributes:nil];
    
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:file];
    
    label.text = [NSString stringWithFormat:@"/%lld",self.allM];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    length += data.length;
    
    label.text = [NSString stringWithFormat:@"%.1fM/%.1fM",length / 1024.0 / 1024.0 ,self.allM / 1024.0 / 1024.0];
    
    [progressView setProgress:(double)self.allData.length / self.allM animated:YES];
    
    [self.fileHandle seekToEndOfFile];
    
    [self.fileHandle writeData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    [self.fileHandle closeFile];
    
    self.fileHandle = nil;
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"下载完成" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
    
    
}

- (void)stopDownLoadFile
{
    if (isDownLoading) {
        
        [self.connection cancel];
        self.connection = nil;
        isDownLoading = NO;
        
    }else
    {
        NSURL *url = [NSURL URLWithString:@"http://7xi66y.com1.z0.glb.clouddn.com/winnovator_home%2Fwinnovator_media.mp4"];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        
        //设置请求头
        NSString *range = [NSString stringWithFormat:@"bytes=%lld-",(long long)length];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        isDownLoading = YES;
    }
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 300)];
        
    }
    return _imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
