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

@end

@implementation CKURLSessionViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    
    [self.view addSubview:self.progressView];
    
    //NSURLSession异步下载图片
    [self downLoadImage];
    
    [self downLoadBigFile];
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

- (void)downLoadBigFile
{
    //block的下载大文件方法
    NSURL *url = [NSURL URLWithString:@"http://7xi66y.com1.z0.glb.clouddn.com/winnovator_home%2Fwinnovator_media.mp4"];

    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *downLoadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        // response.suggestedFilename ： 建议使用的文件名，一般跟服务器端的文件名一致
        NSString *file = [caches stringByAppendingPathComponent:response.suggestedFilename];
        
        // 将临时文件剪切或者复制Caches文件夹
        NSFileManager *mgr = [NSFileManager defaultManager];
        
        // AtPath : 剪切前的文件路径
        // ToPath : 剪切后的文件路径
        [mgr moveItemAtPath:location.path toPath:file error:nil];
        
        NSLog(@"%@",location);
        
    }];
    
    [downLoadTask resume];
    
    
//    //使用代理下载文件的方法
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    
//    NSURLSessionDownloadTask *downLoadTask = [session downloadTaskWithURL:url];
//    
//    [downLoadTask resume];
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

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"%@%@",location,downloadTask.response.suggestedFilename);
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"%f",(double)totalBytesWritten / totalBytesExpectedToWrite);
    
    [_progressView setProgress:(double)totalBytesWritten / totalBytesExpectedToWrite animated:YES];
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
