//
//  signatureView.m
//  SignProduct
//
//  Created by ptteng on 16/11/12.
//  Copyright © 2016年 ptteng. All rights reserved.
//

#import "signatureView.h"
#import <QuartzCore/QuartzCore.h>
#define StrWidth 150
#define StrHeight 20

static CGPoint midpoint(CGPoint p0,CGPoint p1) {
    return (CGPoint) {
        (p0.x + p1.x) /2.0,
        (p0.y + p1.y) /2.0
    };
}

@interface signatureView () {
    UIBezierPath *path;
    CGPoint previousPoint;
}
@end

@implementation signatureView
- (void)commonInit {
    
    path = [UIBezierPath bezierPath];
    [path setLineWidth:2];
    
    max = 0;
    min = 0;
    // Capture touches
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.maximumNumberOfTouches = pan.minimumNumberOfTouches =1;
    [self addGestureRecognizer:pan];
    
}

-(void)clearPan
{
    path = [UIBezierPath bezierPath];
    [path setLineWidth:3];
    
    [self setNeedsDisplay];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) [self commonInit];
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) [self commonInit];
    return self;
}


void ProviderReleaseData (void *info,const void *data,size_t size)
{
    free((void*)data);
}

- (UIImage*) imageBlackToTransparent:(UIImage*) image
{
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace =CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i =0; i < pixelNum; i++, pCurPtr++)
    {
        //        if ((*pCurPtr & 0xFFFFFF00) == 0)    //将黑色变成透明
        if (*pCurPtr == 0xffffff)
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] =0;
        }
        
        //改成下面的代码，会将图片转成灰度
        /*uint8_t* ptr = (uint8_t*)pCurPtr;
         // gray = red * 0.11 + green * 0.59 + blue * 0.30
         uint8_t gray = ptr[3] * 0.11 + ptr[2] * 0.59 + ptr[1] * 0.30;
         ptr[3] = gray;
         ptr[2] = gray;
         ptr[1] = gray;*/
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight,ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8,32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true,kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return resultUIImage;
}


-(void)handelSingleTap:(UITapGestureRecognizer*)tap
{
    return [self imageRepresentation];
}
-(void) imageRepresentation {
    
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size,NO, [UIScreen mainScreen].scale);
    }else {
        UIGraphicsBeginImageContext(self.bounds.size);
        
    }
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    image = [self imageBlackToTransparent:image];
    
    UIImage *img = [self cutImage:image];

    [self.delegate getSignatureImg:[self scaleToSize:img]];
}

//压缩图片,最长边为128
- (UIImage *)scaleToSize:(UIImage *)img {
    CGRect rect ;
    CGFloat imageWidth = img.size.width;
    //判断图片宽度
    if(imageWidth >= 128)
    {
        rect =CGRectMake(0,0, 128, 128/img.size.width*self.frame.size.height);
    }
    else
    {
        rect =CGRectMake(0,0, img.size.width,self.frame.size.height);
    }
    
    CGSize size = rect.size;
    UIGraphicsBeginImageContext(size);
    [img drawInRect:rect];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(scaledImage,nil, nil, nil);
    
    [self setNeedsDisplay];
    return scaledImage;
}

//只截取签名部分图片
- (UIImage *)cutImage:(UIImage *)image
{
    CGRect rect ;
    //签名事件没有发生
    if(min == 0&&max == 0)
    {
        rect =CGRectMake(0,0, 0, 0);
    }
    else//签名发生
    {
        rect =CGRectMake(min-3,0, max-min+6,self.frame.size.height);
    }
    CGImageRef imageRef =CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage * img = [UIImage imageWithCGImage:imageRef];
    
    UIImage *lastImage = [self addText:img text:self.showMessage];
    
    [self setNeedsDisplay];
    return img;
}

//签名完成，给签名照添加新的水印
- (UIImage *) addText:(UIImage *)img text:(NSString *)mark {
    int w = img.size.width;
    int h = img.size.height;
    
    //根据截取图片大小改变文字大小
    CGFloat size = 20;
    UIFont *textFont = [UIFont systemFontOfSize:size];
    CGSize sizeOfTxt = [mark sizeWithFont:textFont constrainedToSize:CGSizeMake(128,30)];
    
    if(w<sizeOfTxt.width)
    {
        
        while (sizeOfTxt.width>w) {
            size --;
            textFont = [UIFont systemFontOfSize:size];
            
            sizeOfTxt = [mark sizeWithFont:textFont constrainedToSize:CGSizeMake(128,30)];
        }
        
    }
    else
    {
        
        size =45;
        textFont = [UIFont systemFontOfSize:size];
        sizeOfTxt = [mark sizeWithFont:textFont constrainedToSize:CGSizeMake(self.frame.size.width,30)];
        while (sizeOfTxt.width>w) {
            size ++;
            textFont = [UIFont systemFontOfSize:size];
            sizeOfTxt = [mark sizeWithFont:textFont constrainedToSize:CGSizeMake(self.frame.size.width,30)];
        }
        
    }
    UIGraphicsBeginImageContext(img.size);
    [[UIColor redColor] set];
    [img drawInRect:CGRectMake(0,0, w, h)];
    [mark drawInRect:CGRectMake((w-sizeOfTxt.width)/2,(h-sizeOfTxt.height)/2, sizeOfTxt.width, sizeOfTxt.height)withFont:textFont];
    UIImage *aimg =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}
- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint currentPoint = [pan locationInView:self];
    CGPoint midPoint = midpoint(previousPoint, currentPoint);
    
    CGFloat viewHeight = self.frame.size.height;
    CGFloat currentY = currentPoint.y;
    if (pan.state ==UIGestureRecognizerStateBegan) {
        [path moveToPoint:currentPoint];
        
    } else if (pan.state ==UIGestureRecognizerStateChanged) {
        [path addQuadCurveToPoint:midPoint controlPoint:previousPoint];
        
        
    }
    
    if(0 <= currentY && currentY <= viewHeight)
    {
        if(max == 0&&min == 0)
        {
            max = currentPoint.x;
            min = currentPoint.x;
        }
        else
        {
            if(max <= currentPoint.x)
            {
                max = currentPoint.x;
            }
            if(min>=currentPoint.x)
            {
                min = currentPoint.x;
            }
        }
        
    }
    
    previousPoint = currentPoint;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    self.backgroundColor = [UIColor whiteColor];
    [[UIColor blackColor] setStroke];
    [path stroke];
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    if(!isSure)
    {
        
        CGContextSetRGBFillColor (context,  108/255, 108/255,108/255, 0.3);//设置填充颜色
        CGRect rect1 = CGRectMake((rect.size.width -StrWidth)/2, (rect.size.height -StrHeight)/2-5,StrWidth, StrHeight);
        origionX = rect1.origin.x;
        totalWidth = rect1.origin.x+StrWidth;
    }
    else
    {
        isSure = NO;
    }
}

- (void)clear
{
    max = 0;
    min = 0;
    path = [UIBezierPath bezierPath];
    [path setLineWidth:2];
    
    [self setNeedsDisplay];
}


- (void)sure
{
    //没有签名发生时
    if(min == 0&&max == 0)
    {
        min = 0;
        max = 0;
    }
    isSure = YES;
    [self setNeedsDisplay];
    return [self imageRepresentation];
}



@end
