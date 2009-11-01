/*
   Grr RSS Reader
   
   Copyright (C) 2006, 2007 Guenther Noack <guenther@unix-ag.uni-kl.de>
   Copyright (C) 2009  GNUstep Application Team
                       Riccardo Mottola

   This application is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either
   version 3 of the License, or (at your option) any later version.
 
   This application is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.
 
   You should have received a copy of the GNU General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA. 
*/

#import "NSURL+Proxy.h"
#import <Foundation/NSUserDefaults.h>

@implementation NSURL (Proxy)
-(void) applyProxySettings
{
#ifdef GNUSTEP
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL proxyEnabled = [defaults boolForKey: @"ProxyEnabled"];
    NSString* proxyPort = [defaults stringForKey: @"ProxyPort"];
    NSString* proxyHostname = [defaults stringForKey: @"ProxyHostname"];
    
    if (proxyEnabled == YES) {
        [self setProperty: proxyHostname forKey: GSHTTPPropertyProxyHostKey];
        [self setProperty: proxyPort forKey: GSHTTPPropertyProxyPortKey];
    }
#endif //GNUSTEP
    // FIXME: Find out how proxies on MacOSX work!
}
@end
