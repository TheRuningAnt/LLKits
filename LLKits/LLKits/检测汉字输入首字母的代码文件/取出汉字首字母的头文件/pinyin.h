/*
 *  pinyin.h
 *  Chinese Pinyin First Letter
 *
 *  Created by zhaoguangliang on 4/21/10.
 *  Copyright 2010 RED/SAFI. All rights reserved.
 *
 */


#define ALPHA	@"ABCDEFGHIJKLMNOPQRSTUVWXYZ#"
char pinyinFirstLetter(unsigned short hanzi);


@interface NSString(FirstLetter)


- (NSString *) uppercasePinYinFirstLetter;
- (NSString *) lowercasePinYinFirstLetter;


@end
