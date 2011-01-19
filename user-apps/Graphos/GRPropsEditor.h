/*
 Project: Graphos
 GRPropsEditor.h

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

@class GRDocView;

/**
 * Object properties editor
 */


@interface GRPropsEditor : NSObject
{
  IBOutlet NSPanel *propsPanel;

  IBOutlet NSButton *stkButt;
  IBOutlet NSButton *fllButt;

  IBOutlet NSMatrix *lineCapMatrix;
  IBOutlet NSMatrix *lineJoinMatrix;

  IBOutlet NSTextField *flatnessField;
  IBOutlet NSTextField *miterlimitField;
  IBOutlet NSTextField *linewidthField;

  IBOutlet NSColorWell *strokeColorWell;
  IBOutlet NSColorWell *fillColorWell;

  IBOutlet NSButton *cancelButt;
  IBOutlet NSButton *okButt;

  BOOL ispath;
  float flatness, miterlimit, linewidth;
  int linejoin, linecap;
  BOOL stroked;
  NSColor *strokeColor;
  BOOL filled;
  NSColor *fillColor;
  
  GRDocView *docView;
}

- (void)setControlsEnabled:(BOOL)state;

/** reads the selection properties from the current view */
- (void)readProperties;

/** sets the view which contains the objects.
  The view needs to needs to be set so that the selection properties
  can be read or applied. */
- (void)setDocView: (GRDocView *)view;

- (void)makeKeyAndOrderFront:(id)sender;

- (void)selectionChanged: (NSNotification *)notif;

- (void)controlTextDidEndEditing:(NSNotification *)aNotification;

- (IBAction)setLnCap:(id)sender;

- (IBAction)setLnJoin:(id)sender;

- (IBAction)fllButtPressed:(id)sender;

- (IBAction)stkButtPressed:(id)sender;

- (IBAction)cancelPressed:(id)sender;

- (IBAction)okPressed:(id)sender;

- (NSDictionary *)properties;

@end
