//
//  KUnicodeUtil.h
//  TamilTransliterate
//
//  Copyright (c) 2012 @KishoreK (http://techlona.in)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

// Uses logic from Indian Language Converter -  http://www.yash.info/indianLanguageConverter
// Also thanks to - http://www.cocoadev.com/index.pl?UniCode

#import "KUnicodeUtil.h"

@interface KUnicodeUtil (PrivateMethods)

- (NSString *) convertMultipleWords: (NSString *) sentence;
- (NSMutableArray *) splitWord:(NSString *) word;
- (NSString *) convertSingleWord: (NSString *) word_ow;
- (void) setupLanguage:(NSString *) lang;

@end


@implementation KUnicodeUtil

#pragma mark -
#pragma mark Singleton Methods

+ (KUnicodeUtil*)sharedInstance {
    
	static KUnicodeUtil *_sharedInstance;
	if(!_sharedInstance) {
		static dispatch_once_t oncePredicate;
		dispatch_once(&oncePredicate, ^{
			_sharedInstance = [[super allocWithZone:nil] init];
        });
    }
    
    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    
	return [self sharedInstance];
}


- (id)copyWithZone:(NSZone *)zone {
	return self;
}

#if (!__has_feature(objc_arc))

- (id)retain {
    
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release {
	//do nothing
}

- (id)autorelease {
    
	return self;	
}
#endif

-(NSString *) getUnicodeConvertedString: (NSString *) str ofLanguage:(NSString *) lang{
    [self setupLanguage:lang];
	// Build the array from the plist
	return [self convertMultipleWords:str];
}

- (void) setupLanguage:(NSString *) lang{
    NSString *path = nil;
    
    if ([lang isEqualToString:@"tamil"]) {
		path = [[NSBundle mainBundle] pathForResource:
				@"Tamil" ofType:@"plist"];
		self.vowels = ta_vowels;
		self.consonants = ta_consonants;
	} else if ([lang isEqualToString:@"hindi"]) {
		path = [[NSBundle mainBundle] pathForResource:
				@"Hindi" ofType:@"plist"];
		self.vowels = hi_vowels;
		self.consonants = hi_consonants;
	} else if ([lang isEqualToString:@"malayalam"]) {
		path = [[NSBundle mainBundle] pathForResource:
				@"Malayalam" ofType:@"plist"];
		self.vowels = ma_vowels;
		self.consonants = ma_consonants;
	} else if ([lang isEqualToString:@"telugu"]) {
		path = [[NSBundle mainBundle] pathForResource:
				@"Telugu" ofType:@"plist"];
		self.vowels = te_vowels;
		self.consonants = te_consonants;
	} else if ([lang isEqualToString:@"punjabi"]) {
		path = [[NSBundle mainBundle] pathForResource:
				@"Punjabi" ofType:@"plist"];
		self.vowels = pu_vowels;
		self.consonants = pu_consonants;
	} else if ([lang isEqualToString:@"bengali"]) {
		path = [[NSBundle mainBundle] pathForResource:
				@"Bengali" ofType:@"plist"];
		self.vowels = be_vowels;
		self.consonants = be_consonants;
	} else if ([lang isEqualToString:@"gujarati"]) {
		path = [[NSBundle mainBundle] pathForResource:
				@"Gujarati" ofType:@"plist"];
		self.vowels = gu_vowels;
		self.consonants = gu_consonants;
	} else if ([lang isEqualToString:@"kannada"]) {
		path = [[NSBundle mainBundle] pathForResource:
				@"Kannada" ofType:@"plist"];
		self.vowels = ka_vowels;
		self.consonants = ka_consonants;
	} else if ([lang isEqualToString:@"oriya"]) {
		path = [[NSBundle mainBundle] pathForResource:
				@"Oriya" ofType:@"plist"];
		self.vowels = or_vowels;
		self.consonants = or_consonants;
	}
    
    self.chars = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
}

- (NSString *) convertMultipleWords: (NSString *) sentence{	
    NSString *regex =[NSString stringWithFormat:@"^((%@)|(%@))+",self.vowels,self.consonants];
    NSMutableArray *words = [[NSMutableArray alloc] init];
	
    while ([sentence length] >= 1) {
        NSArray *match = [sentence componentsMatchedByRegex:regex];
		NSString *matchStr = nil;
        if (match != nil && [match count]>0) {
            matchStr = [match objectAtIndex:0];
			[words addObject:[self convertSingleWord:matchStr]];
            sentence = [sentence substringFromIndex:[matchStr length]];
        } else {
			[words addObject:[NSString stringWithFormat:@"%@",[sentence substringToIndex:1] ]];
            sentence = [sentence substringFromIndex:1];
        }
    }
	
	NSMutableString *str = [[NSMutableString alloc] initWithString:@""] ;
	for (id key in words) {
		[str appendString:key];
	}
		
	return str;
}

- (NSMutableArray *) splitWord:(NSString *) word{
	NSMutableArray *syllables = [[NSMutableArray alloc] init];
    BOOL vowel_start_p = YES;
	
    while (word!=nil && [word length]>0) {
		NSRange index = [word rangeOfString:self.vowels options:NSRegularExpressionSearch];
		
        if (index.location==0) {
			NSArray *matched = [word componentsMatchedByRegex:self.vowels];
			NSString *matchedStr = [matched objectAtIndex:0];
            
            if (vowel_start_p) {
				[syllables addObject:[NSString stringWithFormat:@"~%@",matchedStr]];
            } else {
				[syllables addObject:matchedStr];
            }
            vowel_start_p = YES;
            word = [word substringFromIndex:[matchedStr length]];
        } else {
			index = [word rangeOfString:self.consonants options:NSRegularExpressionSearch];
            if (index.location == 0) {
                NSArray *matched = [word componentsMatchedByRegex:self.consonants];
				NSString *matchedStr = [matched objectAtIndex:0];
				
                [syllables addObject:matchedStr];
                vowel_start_p = NO;
                word = [word substringFromIndex:[matchedStr length]];
				
				NSRange next = [word rangeOfString:self.vowels options:NSRegularExpressionSearch];
                if (next.location != 0 || word.length == 0) [syllables addObject:@"*"];
            } else {
                [syllables addObject:[NSString stringWithFormat:@"%@",[word substringToIndex:1]]];
                word = [word substringFromIndex:1];
            }
        }
    }
    return syllables;
}

- (NSString *) convertSingleWord: (NSString *) word_ow{
	if (!word_ow) return @"";
	
    NSMutableArray *syllables_ow = [self splitWord:word_ow];//splitWord(word_ow);
    NSMutableArray *letters_ow = [[NSMutableArray alloc] init];
	
    for (int i_ow = 0; i_ow < syllables_ow.count; i_ow++) {
		if (i_ow==0) {
			NSRange next = [[syllables_ow objectAtIndex:0] rangeOfString:self.consonants options:NSRegularExpressionSearch];
			if (next.location == 0) {
				if ([self.chars objectForKey:[NSString stringWithFormat:@"~%@",[syllables_ow objectAtIndex:i_ow]]]) {
					[letters_ow addObject: [self.chars objectForKey:[NSString stringWithFormat:@"~%@",[syllables_ow objectAtIndex:i_ow]]]];
					continue;
				}
			}
		} 
			
        if ([self.chars objectForKey:[syllables_ow objectAtIndex:i_ow]]) {
            [letters_ow addObject: [self.chars objectForKey:[syllables_ow objectAtIndex:i_ow]]];
        }  
    }
	
	NSMutableString *temp = [[NSMutableString alloc] initWithString:@""];
	for(id key in letters_ow){
		[temp appendString:key];
	}
		
    return temp;
}

@end
