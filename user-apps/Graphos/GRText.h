/*
 Project: Graphos
 GRText.h

 Copyright (C) 2000-2011 GNUstep Application Project

 Author: Enrico Sersale (original GDraw implementation)
 Author: Ing. Riccardo Mottola

 This application is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public
 License as published by the Free Software Foundation; either
 version 2 of the License, or (at your option) any later version.

 This application is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Library General Public License for more details.

 You should have received a copy of the GNU General Public
 License along with this library; if not, write to the Free
 Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */


#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "GRDrawableObject.h"

@class GRDocView;

@interface GRText : GRDrawableObject
{
    NSString *str;
    NSFont *font;
    NSPoint pos;
    float fsize;
    NSTextAlignment align;
    float parspace;
    NSSize size;
    NSRect bounds;
    float scalex, scaley;
    float rotation;
    NSRect selRect;
}

- (id)initInView:(GRDocView *)aView
         atPoint:(NSPoint)p
                    zoomFactor:(float)zf
                    openEditor:(BOOL)openedit;

- (id)initFromData:(NSDictionary *)description
            inView:(GRDocView *)aView
        zoomFactor:(float)zf;


- (NSString *)fontName;

- (void)setString:(NSString *)aString attributes:(NSDictionary *)attrs;

- (void)edit;

- (BOOL)pointInBounds:(NSPoint)p;

- (void)moveAddingCoordsOfPoint:(NSPoint)p;

- (void)setZoomFactor:(float)f;

- (void)setScalex:(float)x scaley:(float)y;

- (void)setRotation:(float)r;

- (void)draw;


- (NSBezierPath *) makePathFromString: (NSString *) aString
                              forFont: (NSFont *) aFont
                              atPoint: (NSPoint) aPoint;
@end

