#import "GRTextEditor.h"

@implementation GRTextEditor

- (id)initAtPoint:(NSPoint)p 
		 withString:(NSString *)string
		 attributes:(NSDictionary *)attributes
{
	unsigned int style = NSTitledWindowMask | NSResizableWindowMask;

	self = [super initWithContentRect: NSMakeRect(0, 0, 500, 300)
									styleMask: style
									  backing: NSBackingStoreRetained
										 defer: NO];
  	if(self) {
		[self setMaxSize: NSMakeSize(500, 2000)];
		[self setMinSize: NSMakeSize(500, 300)];
		[self setTitle: @"Text Editor"];
// ##### this must be fixed, frame is undeclared !
//		myView = [[TextEditorView alloc] initWithFrame: frame withString: string attributes: attributes];
		[self setContentView: myView];
		[self center];
	}
	return self;
}

- (void)dealloc
{
	[myView release];
	[super dealloc];
}

- (GRTextEditorView *)editorView
{
	return myView;
}

@end
