//
//  UIColor+ColorWithHex.m
//  ColorWithHex
//
//  Created by Angelo Villegas on 3/24/11.
//  Copyright (c) 2011 Studio Villegas.
//	http://www.studiovillegas.com/
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "UIColor+ColorWithHex.h"


@implementation UIColor (ColorWithHex)

#pragma mark - Category Methods
// Direct Conversion to hexadecimal (Automatic)
+ (UIColor *)colorWithHex:(UInt32)hexadecimal
{    
	CGFloat red, green, blue;
	
	// Bit shift right the hexadecimal's first 2 values
	red = (hexadecimal >> 16) & 0xFF;
	// Bit shift right the hexadecimal's 2 middle values
	green = (hexadecimal >> 8) & 0xFF;
	// Bit shift right the hexadecimal's last 2 values
	blue = hexadecimal & 0xFF;
	
    return [UIColor colorWithRed: red / 255.0f green: green / 255.0f blue: blue / 255.0f alpha: 1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)hexadecimal
{
	// Convert Objective-C NSString to C string
	const char *cString = [hexadecimal cStringUsingEncoding: NSASCIIStringEncoding];
	long int hex;
	
	/*
	 If the string contains hash tag (#)
	 If yes then remove hash tag and convert the C string
	 to a base-16 int
	 */
	if (cString[0] == '#')
	{
		hex = strtol(cString + 1, NULL, 16);
	}
	else
	{
		hex = strtol(cString, NULL, 16);
	}
    
    NSLog(@"hexadecimal = %@ hex = %ld",hexadecimal, hex);
	
	return [UIColor colorWithHex: hex];
}

+ (UIColor *)colorWithAlphaHex:(UInt32)hexadecimal
{
	CGFloat red, green, blue, alpha;
	
	// Bit shift right the hexadecimal's first 2 values for alpha
	alpha = (hexadecimal >> 24) & 0xFF;
	red = (hexadecimal >> 16) & 0xFF;
	green = (hexadecimal >> 8) & 0xFF;
	blue = hexadecimal & 0xFF;
	
    return [UIColor colorWithRed: red / 255.0f green: green / 255.0f blue: blue / 255.0f alpha: alpha / 255.0f];
}

+ (UIColor *)colorWithAlphaHexString:(NSString *)hexadecimal
{
	const char *cString = [hexadecimal cStringUsingEncoding: NSASCIIStringEncoding];
	long long int hex;
	
	if (cString[0] == '#')
	{
		hex = strtoll(cString + 1, NULL, 16);
	}
	else
	{
		hex = strtoll(cString, NULL, 16);
	}
	
	return [UIColor colorWithAlphaHex: hex];
}

@end