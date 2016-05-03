//
//  ImagesCollectionViewController.m
//  31_DownloadImages
//
//  Created by oreko on 28.04.16.
//  Copyright © 2016 Orest Kashchiy. All rights reserved.
//

#import "ImagesCollectionViewController.h"
#import "CellModel.h"
#import "CustomCell.h"
#import "ImageDetailsViewController.h"

@interface ImagesCollectionViewController () <NSURLSessionDownloadDelegate, CustomCellDelegate>

@property (strong, nonatomic) NSArray *imagesLinks;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSURLSession *session;

@end

@implementation ImagesCollectionViewController

static NSString * const reuseIdentifier = @"CustomCell";

#pragma mark - Lifecicle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fillImagesLinks];
    [self fillDataSource];
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowImageDetails"]) {
        ImageDetailsViewController *imageDetailsViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.collectionView indexPathsForSelectedItems].firstObject;
        CellModel *cellModel = self.dataSource[indexPath.item];
        imageDetailsViewController.image = cellModel.image;
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    CellModel *cellModel = self.dataSource[indexPath.item];
    if (!cellModel.downloadTask) {
        NSURLSessionDownloadTask *task = [self.session downloadTaskWithURL:cellModel.url];
        cellModel.downloadTask = task;
        [task resume];
    }
    
    cell.cellModel = cellModel;
    cell.delegate = self;
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CellModel *cellModel = self.dataSource[indexPath.item];
    if (cellModel.image) {
        return YES;
    }
    return NO;
}

#pragma mark - <NSURLSessionDownloadDelegate>

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    CellModel *cellModel = [self cellModelWithDownloadTask:downloadTask];
    if (cellModel) {
        float progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
        if (progress > cellModel.progress) {
            cellModel.progress = progress;
            [self.collectionView reloadItemsAtIndexPaths:@[[self indexPathWithCellModel:cellModel]]];
        }
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    CellModel *cellModel = [self cellModelWithDownloadTask:downloadTask];
    if (cellModel) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        if (image) {
            cellModel.image = image;
            cellModel.buttonSelected = NO;
            [self.collectionView reloadItemsAtIndexPaths:@[[self indexPathWithCellModel:cellModel]]];
        }
    }
}

#pragma mark - <CustomCellDelegate>

- (void)customCell:(CustomCell *)customCell buttonTapped:(UIButton *)button {
    CellModel *cellModel = customCell.cellModel;
    if (!cellModel.image) {
        cellModel.buttonSelected = !button.selected;
        if (cellModel.buttonSelected) {
            [cellModel.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                cellModel.resumeData = resumeData;
            }];
        } else {
            NSURLSessionDownloadTask *task;
            if (cellModel.resumeData) {
                task = [self.session downloadTaskWithResumeData:cellModel.resumeData];
            } else {
                task = [self.session downloadTaskWithURL:cellModel.url];
            }
            cellModel.downloadTask = task;
            [task resume];
        }
        [self.collectionView reloadItemsAtIndexPaths:@[[self indexPathWithCellModel:cellModel]]];
    }
}

#pragma mark - Private

- (void)fillImagesLinks {
    self.imagesLinks = [NSArray arrayWithObjects:
                        @"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQvLvHhBP3TQpxIiSrmovfm8rgUyka3pj-dzTzc4L6RyZXp0RVt",
                        
                        @"http://all4desktop.com/data_images/original/4235778-wallpaper-full-hd.jpg",
                        @"https://www.planwallpaper.com/static/images/city_of_love-wallpaper-1366x768.jpg",
                        @"http://wallpaperswide.com/download/smily_face_2-wallpaper-1366x768.jpg",
                        @"http://wallpaperswide.com/download/the_avengers_age_of_ultron_3-wallpaper-1366x768.jpg",
                        @"https://www.planwallpaper.com/static/images/awesome-rain-wallpaper_0_SRyoi3m.jpg",
                        @"https://lh3.googleusercontent.com/iahizXeW59nRYu2PpVeDFVOQeu6kgYmqvo0UgfiyO9Rov1XuJ7BR-6_R0BxdDzzNGw=h900",
                        @"http://wallpaperswide.com/download/the_elder_scrolls_v_skyrim_3-wallpaper-1280x768.jpg",
                        @"https://images2.alphacoders.com/539/53920.jpg",
                        @"http://www.risewallpapers.com/wp-content/uploads/2016/01/02-Wallpaper-HD.jpg",
                        @"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTeBPCtwCa3HE2LXN-jtMSc_o8A_yV0QcxcjimSAs0aG-0YjqMa",
                        @"http://hd-wallpapers.xyz/wp-content/uploads/2016/03/tumblr_wallpaper_189.jpeg",
                        @"http://i.imgur.com/cjPnOhL.jpg",
                        @"http://www.hdwallpapers.in/walls/cute_cg_cat-HD.jpg",
                        @"http://www.intrawallpaper.com/static/images/Desktop-Wallpaper-HD51.jpg",
                        @"https://images5.alphacoders.com/324/324310.jpg",
                        @"http://www.wallpapereast.com/static/images/HD-Wallpapers1_QlwttNW.jpeg",
                        @"http://dotageeks.com/wp-content/uploads/2015/06/Terrorblade-Dota-2-Wallpaper-1.jpg",
                        @"http://cdn.superbwallpapers.com/wallpapers/games/prince-of-persia-24472-1920x1080.jpg",
                        @"http://wallup.net/wp-content/uploads/2016/01/255923-Dota_2-Rubick_the_Grand_Magus-Rubiks_Cube.jpg",
                        
                        nil];
}

- (void)fillDataSource {
    self.dataSource = [[NSMutableArray alloc] init];
    for (NSString *link in self.imagesLinks) {
        CellModel *cellModel = [CellModel cellModelWithUrl:[NSURL URLWithString:link]];
        [self.dataSource addObject:cellModel];
    }
}

- (CellModel *)cellModelWithDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    for (CellModel *cellModel in self.dataSource) {
        if ([cellModel.downloadTask isEqual:downloadTask]) {
            return cellModel;
        }
    }
    return nil;
}

- (NSIndexPath *)indexPathWithCellModel:(CellModel *)cellModel {
    NSInteger item = [self.dataSource indexOfObject:cellModel];
    return [NSIndexPath indexPathForItem:item inSection:0];
}

@end
