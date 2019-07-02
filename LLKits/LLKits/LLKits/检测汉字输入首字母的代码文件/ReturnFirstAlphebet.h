//
//  ReturnFirstAlphebet.h
//  UI_11_Test
//
//  Created by zhaoguangliang on 15/8/22.
//  Copyright (c) 2015年 zhaoguangliang. All rights reserved.
//

/*
 使用说明:
 
将.h和,m文件添加到左侧的文件列表中去,然后将.h文件导入自己的.h或者.m文件中.然后创建ReturnFirstAlphebet对象,然后直接使用ReturnFirstAlphebet 调用getFirstAlfOFHanZi:方法.   示例:
 
 ReturnFirstAlphebet *retF = [ReturnFirstAlphebet new];
 NSString *fir = [retF getFirstAlfOFHanZi:@"汉字"];
 
 代码运行完之后,fir里面就是@"H"(自动转换成大写了),然后就可以和名称首字母的大写比较了
 
 原理:
 
    原理很简单:
        oc使用的unicode编码方式,unicode里面包含了很多的各种各样的字符,其中汉字的字符编号是从19968 开始到20902为止.先说一下上面的数组,看着很长很牛逼的样子,其实是所有汉字的首字母组成的数组,不知道是谁整理的,反正现在有,直接用就行也不用给钱.
 
    -(NSString*)getFirstAlfOFHanZi:(NSString*)name 方法里除了那个很长的数组之外只有只有3句话
       char first =  firstLetterArray [ [name characterAtIndex:0 ]- HANZI_START ] ;
       NSString * str = [[NSString stringWithFormat:@"%c",first] uppercaseString];
        return str;

      char first =  firstLetterArray [ [name characterAtIndex:0 ]- HANZI_START ] ;
    这句话是先从给的字符串中取出第一个汉字,使用[name characterAtIndex:0 ]方法来取,这样取出来的汉字就是字符类型的,然后将其与19968相减,使用得到的值作为下标从首字母数组firstLetterArray中取出来,就是对应的汉字的首字母了.
 
  NSString * str = [[NSString stringWithFormat:@"%c",first] uppercaseString];
 这句话是将取出来的首字母转换成NSString格式的对象,然后转换成大写.然后将其以返回就好了.这样就得到汉字的首字母大写了(NSStirng格式的).
 
                        ====== 恩,就这样,  亮仔整理,至于能不能用就看人品了,O(∩_∩)O哈哈~
 
 */

#import <Foundation/Foundation.h>

@interface ReturnFirstAlphebet : NSObject

-(NSString*)getFirstAlfOFHanZi:(NSString*)name;

@end
