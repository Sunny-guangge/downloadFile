//
//  CKURLSessionViewController.m
//  downloadFile
//
//  Created by user on 16/2/2.
//  Copyright © 2016年 user. All rights reserved.
//

#import "CKURLSessionViewController.h"

@interface CKURLSessionViewController ()<NSURLSessionDownloadDelegate>

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UIProgressView *progressView;

@property (nonatomic,strong) NSURLSession *session;

@property (nonatomic,strong) NSData *resumData;

@property (nonatomic,strong) NSURLSessionDownloadTask *sessionDownLoadTask;

@property (nonatomic,strong) UILabel *label;

@end

@implementation CKURLSessionViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    
    [self.view addSubview:self.label];
    [self.view addSubview:self.progressView];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(didClickPlayBarButtonItem)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    //NSURLSession异步下载图片
    [self downLoadImage];
}
#pragma mark - NSURLSession异步下载图片
- (void)downLoadImage
{
    NSURL *url = [NSURL URLWithString:@"https://picjumbo.imgix.net/HNCK8461.jpg?q=40&w=1650&sharp=30"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _imageView.image = [UIImage imageWithData:data];
            
        });
        
    }];
    
    [dataTask resume];
}

#pragma mark - 开始下载大文件
- (void)didClickPlayBarButtonItem
{
    if (self.sessionDownLoadTask == nil) {
        
        if (self.resumData) {
            
            [self goOnDownload];
            
        }
        else
        {
            [self startDownLoad];
        }
        
    }
    else{
        [self pause];
    }
}

//从0开始下载
- (void)startDownLoad
{
    NSURL *url = [NSURL URLWithString:@"http://7xi66y.com1.z0.glb.clouddn.com/winnovator_home%2Fwinnovator_media.mp4"];
    
    self.sessionDownLoadTask = [self.session downloadTaskWithURL:url];
    
    [self.sessionDownLoadTask resume];
}


//接着上一次下载的内容，继续下载
- (void)goOnDownload
{
    
    self.sessionDownLoadTask = [self.session downloadTaskWithResumeData:self.resumData];
    
    [self.sessionDownLoadTask resume];
    
    self.resumData = nil;
    
}

//暂停下载
- (void)pause
{
    __weak typeof(self) selfVC = self;
    
    [self.sessionDownLoadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        
        selfVC.resumData = resumeData;
        selfVC.sessionDownLoadTask = nil;
        
    }];
}

- (NSURLSession *)session
{
    if (_session == nil) {
        
        NSURLSessionConfiguration *mgc = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session = [NSURLSession sessionWithConfiguration:mgc delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
    }
    
    return _session;
}


- (UIImageView *)imageView
{
    if (_imageView == nil) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 200)];
        
    }
    return _imageView;
}

- (UIProgressView *)progressView
{
    if (_progressView == nil) {
        
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
        _progressView.progress = 0;
        
    }
    return _progressView;
}

#pragma mark - NSURLSessionDownloadDelegate
//下载完成之后的代理
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // response.suggestedFilename ： 建议使用的文件名，一般跟服务器端的文件名一致
    NSString *file = [caches stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    NSLog(@"地址是：     %@",file);
    
    // 将临时文件剪切或者复制Caches文件夹
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // AtPath : 剪切前的文件路径
    // ToPath : 剪切后的文件路径
    [mgr moveItemAtPath:location.path toPath:file error:nil];
    
    // 提示下载完成
    [[[UIAlertView alloc] initWithTitle:@"下载完成" message:downloadTask.response.suggestedFilename delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil] show];
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    _progressView.progress = (double)totalBytesWritten/totalBytesExpectedToWrite;
    self.label.text = [NSString stringWithFormat:@"下载进度:%f",(double)totalBytesWritten/totalBytesExpectedToWrite];
}

- (UILabel *)label
{
    if (_label == nil) {
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 40)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor redColor];
        
    }
    return _label;
}

/* Sent when a download has been resumed. If a download failed with an
 * error, the -userInfo dictionary of the error will contain an
 * NSURLSessionDownloadTaskResumeData key, whose value is the resume
 * data.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

@end
