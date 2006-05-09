//
//  AppController.m
//  LaternaMagica
//
//  Created by Riccardo Mottola on Mon Jan 16 2006.
//  Copyright (c) 2006 Carduus. All rights reserved.
//

#import "AppController.h"


@implementation AppController

- (id) init
{
    if (self = [super init])
    {
        // add an observer for the file table view
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_selectionDidChange:) name:NSTableViewSelectionDidChangeNotification object:fileListView];
        // add an observer for the window resize
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_windowDidResize:) name:NSWindowDidResizeNotification object:window];
    }
    return self;
}

- (void)awakeFromNib
{
    NSRect frame;
    [self setScaleToFit:self];

    [view setImageAlignment:NSImageAlignTopLeft];
    window = smallWindow;
    view = smallView;

    frame = [[NSScreen mainScreen] frame];
    fullWindow = [[NSWindow alloc] initWithContentRect: frame
                                             styleMask: NSBorderlessWindowMask
                                               backing: NSBackingStoreBuffered
                                                 defer: NO];
    [fullWindow setAutodisplay:YES];
    [fullWindow setExcludedFromWindowsMenu: YES];
    [fullWindow setBackgroundColor: [NSColor blackColor]];
    [fullWindow setOneShot:YES];
    
    fullView = [[NSImageView alloc] init];
    [fullWindow setContentView: fullView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)changeImage:(NSString *) file
{
    NSImage *image;

    image = [[NSImage alloc] initByReferencingFile:file];
    [smallWindow orderWindow:NSWindowBelow relativeTo:[controlWin windowNumber]];
    [view setImage: image];
    [view setFrameSize: [image size]];
    [view setNeedsDisplay];
}


- (void)addFile:(NSString *)filename
{
    [fileListData addPath:filename];
    [fileListView reloadData];
}

- (void)addFiles:(id)sender
{
    NSOpenPanel   *openPanel;
    NSArray       *files;
    NSEnumerator  *e;
    NSString      *filename;
    NSFileManager *fmgr;
    NSDictionary  *attrs;

    openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowsMultipleSelection:YES];
    [openPanel setCanChooseDirectories:YES];
    if ([openPanel runModalForTypes:NULL] != NSOKButton)
    {
        return;
    }

    files = [openPanel filenames];
    e = [files objectEnumerator];
    fmgr = [NSFileManager defaultManager];
    while (filename = (NSString*)[e nextObject]) {
        attrs = [fmgr fileAttributesAtPath:filename traverseLink:YES];
        if (attrs)
            if ([attrs objectForKey:NSFileType] == NSFileTypeDirectory)
            {
                NSArray      *dirContents;
                NSEnumerator *e2;
                NSString     *filename2;
                NSDictionary  *attrs2;

                dirContents = [fmgr subpathsAtPath:filename];
                e2 = [dirContents objectEnumerator];
                while (filename2 = (NSString*)[e2 nextObject])
                {
                    NSString *tempName;

                    tempName = [filename stringByAppendingPathComponent:filename2];
                    attrs2 = [[NSFileManager defaultManager] fileAttributesAtPath:tempName traverseLink:YES];
                    if (attrs2)
                    {
                        if ([attrs2 objectForKey:NSFileType] != NSFileTypeDirectory)
                        {
                            [self addFile:tempName];
                        }
                    }
                }
            } else {
                [self addFile:filename];
        } else
        {
            NSLog(@"open panel did not return a valid path");
        }
    }
}

// scale image according to options
- (void)scaleView
{
    if (scaleToFit)
    {
        NSSize imageSize;
        NSSize rectSize;
        NSAffineTransform *at;
        float scaleH, scaleW;
        float scale;

        imageSize = [[view image] size];
        rectSize =  [window frame].size;

        scaleW = rectSize.width / imageSize.width;
        scaleH =  rectSize.height / imageSize.height;

        if (scaleW < scaleH)
            scale = scaleW;
        else
            scale = scaleH;
        NSLog(@"scale: %f", scale);
        at = [NSAffineTransform transform];
        [at scaleBy:scale];
        [view setFrameSize:[at transformSize:imageSize]];
        [view setNeedsDisplay:YES];
    }
}

- (IBAction)setScaleToFit:(id)sender
{
    if ([fitButton state] == NSOnState)
    {
        scaleToFit = YES;
        [view setImageScaling:NSScaleToFit];
    } else
    {
        scaleToFit = NO;
        [view setImageScaling:NSScaleNone];
        [view setFrameSize: [[view image] size]];
    }
    [scrollView setHasVerticalScroller:!scaleToFit];
    [scrollView setHasHorizontalScroller:!scaleToFit];
    [self scaleView];
}

// method called as a notification from the selection change
- (void)_selectionDidChange :(NSNotification *)notif
{
    NSTableView *table;
    
    table = [notif object];
    [self changeImage:[fileListData pathAtIndex:[table selectedRow]]];
    [self scaleView];
}

// method called as a notification from the window resize
// or if scale preferences changed
- (void)_windowDidResize :(NSNotification *)notif
{
    [self scaleView];
}


- (IBAction)setFullScreen :(id)sender
{
    NSImage *image;

    image = [view image];

    // check the sender and set the other item accordingly
    if (sender == fullScreenButton)
        [fullScreenMenuItem setState:[fullScreenButton state]];
    else {
        if ([fullScreenMenuItem state] == NSOnState)
            [fullScreenMenuItem setState:NSOffState];
        else
            [fullScreenMenuItem setState:NSOnState];
        [fullScreenButton setState:[fullScreenMenuItem state]];
    }

    if ([fullScreenButton state] == NSOnState)
    {
        [fullWindow setLevel: NSScreenSaverWindowLevel];
        window = fullWindow;
        view = fullView;
    } else
    {
        [fullWindow orderOut:self];
        window = smallWindow;
        view = smallView;
    }
    [view  setImage: image];
    [self scaleView];
    [window makeKeyAndOrderFront: self];
}

- (IBAction)prevImage:(id)sender
{
    int sr;

    sr = [fileListView selectedRow];
    if (sr > 0)
        [fileListView selectRow:sr-1 byExtendingSelection:NO];
}

- (IBAction)nextImage:(id)sender
{
    int sr;

    sr = [fileListView selectedRow];
    if (sr < [fileListView numberOfRows])
        [fileListView selectRow:sr+1 byExtendingSelection:NO];
}

- (IBAction)removeImage:(id)sender
{
    int sr;

    sr = [fileListView selectedRow];
    [fileListData removeObjectAtIndex:sr];
    [fileListView reloadData];
}
@end
