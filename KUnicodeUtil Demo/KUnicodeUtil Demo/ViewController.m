//
//  ViewController.m
//  KUnicodeUtil Demo
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

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *tamil = [[KUnicodeUtil sharedInstance] getUnicodeConvertedString:@"thamiz" ofLanguage:@"tamil"];
    NSString *telugu = [[KUnicodeUtil sharedInstance] getUnicodeConvertedString:@"telugu" ofLanguage:@"telugu"];
    NSString *bengali = [[KUnicodeUtil sharedInstance] getUnicodeConvertedString:@"bMlaa" ofLanguage:@"bengali"];
    NSString *gujarati = [[KUnicodeUtil sharedInstance] getUnicodeConvertedString:@"gujaraathI" ofLanguage:@"gujarati"];
    NSString *hindi = [[KUnicodeUtil sharedInstance] getUnicodeConvertedString:@"hindhI" ofLanguage:@"hindi"];
    NSString *kannada = [[KUnicodeUtil sharedInstance] getUnicodeConvertedString:@"Kannadakke" ofLanguage:@"kannada"];
    NSString *malayalam = [[KUnicodeUtil sharedInstance] getUnicodeConvertedString:@"malayaaLAm" ofLanguage:@"malayalam"];
    NSString *oriya = [[KUnicodeUtil sharedInstance] getUnicodeConvertedString:@"oRiaa" ofLanguage:@"oriya"];
    NSString *punjabi = [[KUnicodeUtil sharedInstance] getUnicodeConvertedString:@"guramukhee" ofLanguage:@"punjabi"];
    
    self.txtUnicode.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@",tamil,telugu,hindi,bengali,gujarati,kannada,malayalam,oriya,punjabi];
}

@end
