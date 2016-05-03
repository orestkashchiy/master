//
//  ImageDetailsViewController.m
//  31_DownloadImages
//
//  Created by oreko on 29.04.16.
//  Copyright © 2016 Orest Kashchiy. All rights reserved.
//

#import "ImageDetailsViewController.h"

@interface ImageDetailsViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTrailingConstraint;

@end

@implementation ImageDetailsViewController

#pragma mark - Lifecicle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureImageViewFrame];
    self.imageView.image = self.image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self updateMinZoomScaleForSize:self.view.bounds.size];
}

#pragma mark - <UIScrollViewDelegate>

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self updateConstraintsForSize:self.view.bounds.size];
}

#pragma mark - Private

- (void)configureImageViewFrame {
    CGFloat width = self.image.size.width;
    CGFloat height = self.image.size.height;
    CGFloat y = (CGRectGetMinY(self.view.frame) - height) / 2;
    self.imageView.frame = CGRectMake(0, y, width, height);
}

- (void)updateMinZoomScaleForSize:(CGSize)size {
    CGFloat widthScale = size.width / CGRectGetWidth(self.imageView.bounds);
    CGFloat heightScale = size.height / CGRectGetHeight(self.imageView.bounds);
    CGFloat minScale = MIN(widthScale, heightScale);
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.zoomScale = minScale;
}

- (void)updateConstraintsForSize:(CGSize)size {
    [self.view layoutIfNeeded];
    CGFloat yOffset = MAX(0, (size.height - CGRectGetHeight(self.imageView.frame)) / 2);
    self.imageViewTopConstraint.constant = yOffset;
    self.imageViewBottomConstraint.constant = yOffset;
    
    CGFloat xOffset = MAX(0, (size.width - CGRectGetWidth(self.imageView.frame)) / 2);
    self.imageViewLeadingConstraint.constant = xOffset;
    self.imageViewTrailingConstraint.constant = xOffset;
    
    [self.view layoutIfNeeded];
}

@end
