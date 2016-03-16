//
//  ROADNoteBookView.m
//  Road
//
//  Created by Li Pan on 2016-03-01.
//  Copyright © 2016 Li Pan. All rights reserved.
//

#import "ROADNoteBookView.h"
#import "ROADConstants.h"
#import "ROADNoteBookDrawTool.h"
#import "ROADNoteBookImageEditingTool.h"
#import "ROADNoteBookFeatureButtonShapeLayer.h"
#import "ROADColors.h"

@interface ROADNoteBookView ()
@property (nonatomic, strong) UIView *canvasView;
@property (nonatomic, strong) ROADNoteBookDrawTool *drawToolView;
@property (nonatomic, strong) ROADNoteBookImageEditingTool *imageEditingToolView;

@property (nonatomic, strong) UIButton *returnButton;
@property (nonatomic, strong) UIButton *pencilButton;
@property (nonatomic, strong) UIButton *pictureButton;
@property (nonatomic, strong) UIButton *exportButton;

@property (nonatomic, strong) UIButton *toggleImageFilterOptions;
@property (nonatomic, strong) UIButton *toggleImageAdjustmentOptions;

@property (nonatomic, strong) UIButton *shareInstagramButton;
@property (nonatomic, strong) UIButton *shareFacebookButton;
@property (nonatomic, strong) UIButton *shareTwitterButton;
@property (nonatomic, strong) UIView *shareButtonsContainer;

@property (nonatomic, strong) ROADColors *userColors;
@property (nonatomic, strong) ROADNoteBookFeatureButtonShapeLayer *buttonContour;
@property (nonatomic, assign) BOOL drawingToolActivated;
@property (nonatomic, assign) BOOL imageViewActivated;
@property (nonatomic, assign) BOOL shareViewActivated;
@property (nonatomic, assign) BOOL imageFilterActivated;
@property (nonatomic, assign) BOOL imageAdjustmentActivated;

@property (nonatomic, strong) UILabel *notesLabel;

@property (nonatomic, assign) CGPoint startPoint;

@end

@implementation ROADNoteBookView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Notes %@", self.arrayOfNotes);
    
    self.drawingToolActivated = NO;
    self.imageViewActivated = NO;
    self.shareViewActivated = NO;
    self.imageFilterActivated = NO;
    self.imageAdjustmentActivated = NO;
    
    self.userColors = [[ROADColors alloc]init];
    self.buttonContour = [[ROADNoteBookFeatureButtonShapeLayer alloc]init];
    UIView *backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    UIImage *ivoryPaper = [UIImage imageNamed:@"ivoryPaper.png"];
    UIImage *pencilImage = [UIImage imageNamed:@"drawingPencil"];
    UIImage *imageImage = [UIImage imageNamed:@"imageIcon"];
    UIImage *shareImage = [UIImage imageNamed:@"share.png"];
    
    UIImage *instagrameIconImage = [UIImage imageNamed:@"instagramIcon"];
    UIImage *facebookIconImage = [UIImage imageNamed:@"faceBookIcon"];
    UIImage *twitterIconImage = [UIImage imageNamed:@"twitterIcon"];
    backgroundView.layer.contents = (__bridge id)ivoryPaper.CGImage;
    [self.view addSubview:backgroundView];
    
    self.returnButton = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, self.view.frame.size.height - kAccessButtonHeight - 10.0f, kAccessButtonHeight, kAccessButtonHeight)];
    [self.returnButton.layer addSublayer:self.buttonContour];
//    self.returnButton.layer.borderWidth = kBorderWidth;
    [self.returnButton setTitle:@"<" forState:UIControlStateNormal];
//    self.returnButton.layer.shadowOffset = CGSizeMake(-1.0f, 6.0f);
//    self.returnButton.layer.cornerRadius = kAccessButtonHeight/2;
//    self.returnButton.layer.shadowOpacity = kShadowOpacity;
    self.returnButton.layer.opacity = kUINormaAlpha;
    self.returnButton.alpha = kUINormaAlpha;
    [self.returnButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.returnButton addTarget:self action:@selector(backtoBook:) forControlEvents:UIControlEventTouchUpInside];
    
    self.pencilButton = [[UIButton alloc]initWithFrame:CGRectMake(65.0f, self.view.frame.size.height - kAccessButtonHeight - 10.0f, kAccessButtonHeight, kAccessButtonHeight)];
    self.pencilButton.layer.borderWidth = kBorderWidth;
    self.pencilButton.layer.contents = (__bridge id)pencilImage.CGImage;
    self.pencilButton.layer.shadowOffset = CGSizeMake(-1.0f, 6.0f);
    self.pencilButton.layer.cornerRadius = kAccessButtonHeight/2;
    self.pencilButton.layer.shadowOpacity = kShadowOpacity;
    self.pencilButton.alpha = kUINormaAlpha;
    self.pencilButton.layer.opacity = kUINormaAlpha;
    [self.pencilButton addTarget:self action:@selector(toggleDrawingTool:) forControlEvents:UIControlEventTouchUpInside];
    
    self.pictureButton = [[UIButton alloc]initWithFrame:CGRectMake(120.0f, self.view.frame.size.height - kAccessButtonHeight - 10.0f, kAccessButtonHeight, kAccessButtonHeight)];
    self.pictureButton.layer.borderWidth = kBorderWidth;
    self.pictureButton.layer.contents = (__bridge id)imageImage.CGImage;
    self.pictureButton.layer.shadowOffset = CGSizeMake(-1.0f, 6.0f);
    self.pictureButton.layer.cornerRadius = kAccessButtonHeight/2;
    self.pictureButton.layer.shadowOpacity = kShadowOpacity;
    self.pictureButton.alpha = kUINormaAlpha;
    [self.pictureButton addTarget:self action:@selector(toggleImageView:) forControlEvents:UIControlEventTouchUpInside];
    
    self.exportButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) - 20 - kAccessButtonHeight, self.view.frame.size.height - kAccessButtonHeight - 10.0f, kAccessButtonHeight, kAccessButtonHeight)];
    self.exportButton.layer.borderWidth = kBorderWidth;
    self.exportButton.layer.contents = (__bridge id)shareImage.CGImage;
    self.exportButton.layer.shadowOffset = CGSizeMake(-1.0f, 6.0f);
    self.exportButton.layer.cornerRadius = kAccessButtonHeight/2;
    self.exportButton.layer.shadowOpacity = kShadowOpacity;
    self.exportButton.alpha = kUINormaAlpha;
    [self.exportButton addTarget:self action:@selector(toggleShareView:) forControlEvents:UIControlEventTouchUpInside];
    
    self.shareButtonsContainer = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) - 20 - kAccessButtonHeight, self.view.frame.size.height - 10.0f, kAccessButtonHeight, kZero)];
    self.shareButtonsContainer.backgroundColor = [UIColor whiteColor];
    self.shareButtonsContainer.layer.borderWidth = kBorderWidth;
    self.shareButtonsContainer.layer.shadowOffset = CGSizeMake(-1.0f, 6.0f);
    self.shareButtonsContainer.layer.cornerRadius = kAccessButtonHeight/2;
    self.shareButtonsContainer.layer.shadowOpacity = kShadowOpacity;
    
    self.shareInstagramButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) - 20 - kAccessButtonHeight, self.view.frame.size.height - kAccessButtonHeight - 10.0f, kAccessButtonHeight, kAccessButtonHeight)];
    self.shareInstagramButton.layer.borderWidth = kBorderWidth;
    self.shareInstagramButton.layer.contents = (__bridge id)instagrameIconImage.CGImage;
    self.shareInstagramButton.layer.shadowOffset = CGSizeMake(-1.0f, 6.0f);
    self.shareInstagramButton.layer.cornerRadius = kAccessButtonHeight/2;
    self.shareInstagramButton.layer.shadowOpacity = kShadowOpacity;
    self.shareInstagramButton.alpha = kUINormaAlpha;
    
    self.shareFacebookButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) - 20 - kAccessButtonHeight, self.view.frame.size.height - kAccessButtonHeight - 10.0f, kAccessButtonHeight, kAccessButtonHeight)];
    self.shareFacebookButton.layer.borderWidth = kBorderWidth;
    self.shareFacebookButton.layer.contents = (__bridge id)facebookIconImage.CGImage;
    self.shareFacebookButton.layer.shadowOffset = CGSizeMake(-1.0f, 6.0f);
    self.shareFacebookButton.layer.cornerRadius = kAccessButtonHeight/2;
    self.shareFacebookButton.layer.shadowOpacity = kShadowOpacity;
    self.shareFacebookButton.alpha = kUINormaAlpha;
    
    self.shareTwitterButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) - 20 - kAccessButtonHeight, self.view.frame.size.height - kAccessButtonHeight - 10.0f, kAccessButtonHeight, kAccessButtonHeight)];
    self.shareTwitterButton.layer.borderWidth = kBorderWidth;
    self.shareTwitterButton.layer.contents = (__bridge id)twitterIconImage.CGImage;
    self.shareTwitterButton.layer.shadowOffset = CGSizeMake(-1.0f, 6.0f);
    self.shareTwitterButton.layer.cornerRadius = kAccessButtonHeight/2;
    self.shareTwitterButton.layer.shadowOpacity = kShadowOpacity;
    self.shareTwitterButton.alpha = kUINormaAlpha;
    
    self.shareInstagramButton.alpha = kZero;
    self.shareFacebookButton.alpha = kZero;
    self.shareTwitterButton.alpha = kZero;
    
    self.canvasView = [[UIView alloc]initWithFrame:CGRectMake(20, 20, CGRectGetWidth(self.view.frame)-40, CGRectGetHeight(self.view.frame)-80)];
    self.canvasView.layer.shadowOffset = CGSizeMake(-1.0f, 6.0f);
    self.canvasView.layer.borderWidth = kBorderWidth;
    self.canvasView.layer.shadowOpacity = kShadowOpacity;
    self.canvasView.clipsToBounds = YES;
    
    [self setDrawingTool];
    [self setImageEditingTool];
    [self.imageEditingToolView setupImageView];
    
    [self.view addSubview:self.canvasView];
    [self.view addSubview:self.shareButtonsContainer];
    [self.canvasView addSubview:self.imageEditingToolView];
    [self.canvasView addSubview:self.drawToolView];
    [self.view addSubview:self.returnButton];
    [self.view addSubview:self.pencilButton];
    [self.view addSubview:self.pictureButton];
    [self.view addSubview:self.exportButton];
    [self.view bringSubviewToFront:self.notesLabel];
    
    
    [self displayNotes];
}

- (void)backtoBook: (UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleDrawingTool: (UIButton *)sender {
    self.drawingToolActivated = !self.drawingToolActivated;
    if (self.drawingToolActivated) {
        self.imageEditingToolView.userInteractionEnabled = NO;
        self.drawToolView.layer.zPosition = 1.0f;
        [UIView animateWithDuration:0.20f animations:^{
            self.drawToolView.alpha = 1.0f;
        }];
        [UIView animateWithDuration:1.0f animations:^{
            self.pencilButton.alpha = 1.0f;
        }];
    }
    if (!self.drawingToolActivated) {
        self.imageEditingToolView.userInteractionEnabled = YES;
        self.drawToolView.layer.zPosition = -1.0f;
        [UIView animateWithDuration:0.20f animations:^{
            self.drawToolView.alpha = kZero;
        }];
        [UIView animateWithDuration:1.0f animations:^{
            self.pencilButton.alpha = 0.2f;
        }];
    }
    NSLog(@"%d", self.drawingToolActivated);
}

- (void)toggleImageView: (UIButton *)sender {
    self.imageViewActivated = !self.imageViewActivated;
    self.imageEditingToolView.imageAdjustmentSlider.alpha = kZero;
    self.imageEditingToolView.imageAdjustmentSlider.tintColor = self.userColors.colorOne;
    if (self.imageViewActivated) {
        self.imageEditingToolView.userInteractionEnabled = YES;
        self.toggleImageFilterOptions = [[UIButton alloc]initWithFrame:CGRectMake(-kAccessButtonWidth/2, CGRectGetMidX(self.canvasView.frame), kAccessButtonWidth, kAccessButtonWidth)];
        self.toggleImageFilterOptions.layer.borderWidth = kBorderWidth;
        self.toggleImageFilterOptions.layer.shadowOffset = CGSizeMake(-1.0f, 6.0f);
//        self.toggleImageFilterOptions.layer.cornerRadius = kAccessButtonHeight/2;
        self.toggleImageFilterOptions.layer.shadowOpacity = kShadowOpacity;
        self.toggleImageFilterOptions.alpha = kZero;
        [self.toggleImageFilterOptions addTarget:self action:@selector(toggleImageFilterBar:) forControlEvents:UIControlEventTouchUpInside];
        [self.canvasView addSubview:self.toggleImageFilterOptions];
        
        self.toggleImageAdjustmentOptions = [[UIButton alloc]initWithFrame:CGRectMake(-kAccessButtonWidth/2, CGRectGetMidX(self.canvasView.frame)-kAccessButtonWidth, kAccessButtonWidth, kAccessButtonWidth)];
        self.toggleImageAdjustmentOptions.layer.borderWidth = kBorderWidth;
        self.toggleImageAdjustmentOptions.layer.shadowOffset = CGSizeMake(-1.0f, 6.0f);
//        self.toggleImageAdjustmentOptions.layer.cornerRadius = kAccessButtonHeight/2;
        self.toggleImageAdjustmentOptions.layer.shadowOpacity = kShadowOpacity;
        self.toggleImageAdjustmentOptions.alpha = kZero;
        [self.toggleImageAdjustmentOptions addTarget:self action:@selector(toggleImageAdjustmentBar:) forControlEvents:UIControlEventTouchUpInside];
        [self.canvasView addSubview:self.toggleImageAdjustmentOptions];
        
        [UIView animateWithDuration:1.0f animations:^{
            self.pictureButton.alpha = kOne;
            self.imageEditingToolView.alpha = kOne;
            self.toggleImageFilterOptions.alpha = kUINormaAlpha;
            self.toggleImageAdjustmentOptions.alpha = kUINormaAlpha;
        }];
    }
    if (!self.imageViewActivated) {
        self.imageEditingToolView.userInteractionEnabled = NO;
        [UIView animateWithDuration:1.0f animations:^{
            self.pictureButton.alpha = kHiddenControlRevealedAlhpa;
            self.imageEditingToolView.alpha = kZero;
            self.toggleImageFilterOptions.alpha = kZero;
            self.toggleImageAdjustmentOptions.alpha = kZero;
        }];
    }
}

- (void)setDrawingTool {
    self.drawToolView = [[ROADNoteBookDrawTool alloc] initWithFrame:self.canvasView.bounds];
    self.drawToolView.currentColor = self.userColors.colorFive;
    self.drawToolView.backgroundColor = [UIColor colorWithRed:28.0/255.0 green:47.0/255.0 blue:64.0/255.0 alpha:0.01];
    self.drawToolView.userInteractionEnabled = YES;
    self.drawToolView.alpha = kZero;
}

- (void)setImageEditingTool {
    self.imageEditingToolView = [[ROADNoteBookImageEditingTool alloc]init];
    self.imageEditingToolView.frame = CGRectMake(0, 0, self.canvasView.frame.size.width, self.canvasView.frame.size.height);
    self.imageEditingToolView.userInteractionEnabled = YES;
    self.imageEditingToolView.backgroundColor = [UIColor blackColor];
}

- (void)displayNotes {
    int indexCount = 1;
    for (NSString *notesString in self.arrayOfNotes) {
        //        indexCount++;
        //        UILabel *notesLabel = [[UILabel alloc]initWithFrame:CGRectMake(30.0f, 40.0f + indexCount*40.0f, 400.0f, 200.0f)];
        //        notesLabel.text = notesString;
        //        notesLabel.textColor = self.userColors.colorSix;
        //        notesLabel.font = [UIFont fontWithName:@"American Typewriter" size:13.0f];
        //        [self.imageView addSubview:notesLabel];
        
        indexCount ++;
        self.notesLabel = [[UILabel alloc]initWithFrame:CGRectMake(30.0f, 40.0f + indexCount*40.0f, 200.0f, 100.0f)];
        self.notesLabel.text = notesString;
        self.notesLabel.textColor = self.userColors.colorSix;
        self.notesLabel.numberOfLines = kZero;
        self.notesLabel.textAlignment = NSTextAlignmentCenter;
        self.notesLabel.font = [UIFont fontWithName:@"American Typewriter" size:18.0f];
        [self.canvasView addSubview:self.notesLabel];
    }
}

- (void)toggleShareView: (UIButton *)sender {
    self.shareViewActivated = !self.shareViewActivated;
    if (self.shareViewActivated) {
        [self.view addSubview:self.shareInstagramButton];
        [self.view addSubview:self.shareFacebookButton];
        [self.view addSubview:self.shareTwitterButton];
        
        [UIView animateWithDuration:0.75f animations:^{
            self.exportButton.alpha = 1.0f;
            
            self.shareInstagramButton.alpha = 1.0f;
            self.shareFacebookButton.alpha = 1.0f;
            self.shareTwitterButton.alpha = 1.0f;
            
            self.shareButtonsContainer.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - 20 - kAccessButtonHeight, self.view.frame.size.height - 4*kAccessButtonHeight-10, kAccessButtonHeight, 4*kAccessButtonHeight-5);
            
            self.shareFacebookButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - 20 - kAccessButtonHeight, self.view.frame.size.height - 3* kAccessButtonHeight - 10.0f, kAccessButtonHeight, kAccessButtonHeight);
            
            self.shareTwitterButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - 20 - kAccessButtonHeight, self.view.frame.size.height - 4* kAccessButtonHeight - 10.0f, kAccessButtonHeight, kAccessButtonHeight);
            
            self.shareInstagramButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - 20 - kAccessButtonHeight, self.view.frame.size.height - 2* kAccessButtonHeight - 10.0f, kAccessButtonHeight, kAccessButtonHeight);
        }];
    }
    if (!self.shareViewActivated) {
        [UIView animateWithDuration:1.5 animations:^{
            self.exportButton.alpha = kUINormaAlpha;
            self.shareInstagramButton.alpha = kZero;
            self.shareFacebookButton.alpha = kZero;
            self.shareTwitterButton.alpha = kZero;
            
            self.shareButtonsContainer.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - 20 - kAccessButtonHeight, self.view.frame.size.height - 10.0f, kAccessButtonHeight, kZero);
            
            self.shareFacebookButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - 20 - kAccessButtonHeight, self.view.frame.size.height - kAccessButtonHeight - 10.0f, kAccessButtonHeight, kAccessButtonHeight);
            
            self.shareTwitterButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - 20 - kAccessButtonHeight, self.view.frame.size.height - kAccessButtonHeight - 10.0f, kAccessButtonHeight, kAccessButtonHeight);
            
            self.shareInstagramButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - 20 - kAccessButtonHeight, self.view.frame.size.height - kAccessButtonHeight - 10.0f, kAccessButtonHeight, kAccessButtonHeight);
        }completion:^(BOOL finished) {
            [self.shareInstagramButton removeFromSuperview];
            [self.shareFacebookButton removeFromSuperview];
            [self.shareTwitterButton removeFromSuperview];
        }];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchLabelPoint = [[touches anyObject] locationInView:self.canvasView];
    self.notesLabel.center = touchLabelPoint;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)toggleImageFilterBar: (UIButton *)sender {
    self.imageFilterActivated = !self.imageFilterActivated;
    if (self.imageFilterActivated) {
        self.imageEditingToolView.filterGallery.frame = CGRectMake(kZero, CGRectGetMidY(self.imageEditingToolView.frame)- 75.5f, kZero, 2.0f);
        [UIView animateWithDuration:0.5f animations:^{
            self.imageEditingToolView.filterGallery.frame = CGRectMake(kZero, CGRectGetMidY(self.imageEditingToolView.frame)- 75.5f, self.imageEditingToolView.frame.size.width, 2.0f);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5f animations:^{
                self.imageEditingToolView.filterGallery.frame = CGRectMake(kZero, CGRectGetMidY(self.imageEditingToolView.frame)- 75.5f, self.imageEditingToolView.frame.size.width, 51.0f);
            }];
        }];
    }
    if (!self.imageFilterActivated) {
        self.imageEditingToolView.filterGallery.frame = CGRectMake(kZero, CGRectGetMidY(self.imageEditingToolView.frame)- 75.5f, self.imageEditingToolView.frame.size.width, 51.0f);
        [UIView animateWithDuration:0.5f animations:^{
            self.imageEditingToolView.filterGallery.frame = CGRectMake(kZero, CGRectGetMidY(self.imageEditingToolView.frame)- 75.5f, self.imageEditingToolView.frame.size.width, 2.0f);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5f animations:^{
                self.imageEditingToolView.filterGallery.frame = CGRectMake(kZero, CGRectGetMidY(self.imageEditingToolView.frame)- 75.5f, kZero, 2.0f);
            }];
        }];
    }
}

- (void)toggleImageAdjustmentBar: (UIButton *)sender {
    self.imageAdjustmentActivated = !self.imageAdjustmentActivated;
    if (self.imageAdjustmentActivated) {
        self.imageEditingToolView.adjustmentsGallery.frame = CGRectMake(kZero, CGRectGetMidY(self.imageEditingToolView.frame)- 25.5f, kZero, 2.0f);
        self.imageEditingToolView.imageAdjustmentSlider.frame = CGRectMake(self.imageEditingToolView.frame.size.width - 205.0f, CGRectGetMidY(self.imageEditingToolView.frame) + 50.0f, kZero, 20.0f);
        self.imageEditingToolView.imageAdjustmentSlider.alpha = kZero;
        
        [UIView animateWithDuration:0.5f animations:^{
            self.imageEditingToolView.adjustmentsGallery.frame = CGRectMake(kZero, CGRectGetMidY(self.imageEditingToolView.frame)- 25.5f, self.imageEditingToolView.frame.size.width, 2.0f);
            self.imageEditingToolView.imageAdjustmentSlider.alpha = kOne;
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5f animations:^{
                self.imageEditingToolView.adjustmentsGallery.frame = CGRectMake(kZero, CGRectGetMidY(self.imageEditingToolView.frame)- 25.5f, self.imageEditingToolView.frame.size.width, 51.0f);
                self.imageEditingToolView.imageAdjustmentSlider.frame = CGRectMake(self.imageEditingToolView.frame.size.width - 205.0f, CGRectGetMidY(self.imageEditingToolView.frame) + 50.0f, 200.0f, 20.0f);
            }];
        }];
    }
    if (!self.imageAdjustmentActivated) {
        self.imageEditingToolView.adjustmentsGallery.frame = CGRectMake(kZero, CGRectGetMidY(self.imageEditingToolView.frame)- 25.5f, self.imageEditingToolView.frame.size.width, 51.0f);
        self.imageEditingToolView.imageAdjustmentSlider.frame = CGRectMake(self.imageEditingToolView.frame.size.width - 205.0f, CGRectGetMidY(self.imageEditingToolView.frame) + 50.0f, 200.0f, 20.0f);
        self.imageEditingToolView.imageAdjustmentSlider.alpha = kOne;
        [UIView animateWithDuration:0.5f animations:^{
            self.imageEditingToolView.adjustmentsGallery.frame = CGRectMake(kZero, CGRectGetMidY(self.imageEditingToolView.frame)- 25.5f, self.imageEditingToolView.frame.size.width, 2.0f);
            self.imageEditingToolView.imageAdjustmentSlider.alpha = kOne;
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5f animations:^{
                self.imageEditingToolView.adjustmentsGallery.frame = CGRectMake(kZero, CGRectGetMidY(self.imageEditingToolView.frame)- 25.5f, kZero, 2.0f);
                self.imageEditingToolView.imageAdjustmentSlider.frame = CGRectMake(self.imageEditingToolView.frame.size.width - 205.0f, CGRectGetMidY(self.imageEditingToolView.frame) + 50.0f, kZero, 20.0f);
                self.imageEditingToolView.imageAdjustmentSlider.alpha = kZero;
                
            }];
        }];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
