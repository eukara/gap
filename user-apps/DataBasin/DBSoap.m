/*
   Project: DataBasin

   Copyright (C) 2008 Free Software Foundation

   Author: Riccardo Mottola

   Created: 2008-11-13 22:44:45 +0100 by multix

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
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA.
*/

#import "DBSoap.h"

#import <AppKit/AppKit.h>


@implementation DBSoap

- (void)login :(NSString *)userName :(NSString *)password
{
  GWSSOAPCoder          *coder;
  NSUserDefaults        *defs;
  NSMutableArray        *orderArray;
  NSMutableDictionary   *parmsDict;
  NSMutableDictionary   *loginParmDict;
  NSURL                 *url;
  NSDictionary          *resultDict;
  NSEnumerator          *enumerator;
  NSString              *key;


  defs = [NSUserDefaults standardUserDefaults];
  [defs registerDefaults:
    [NSDictionary dictionaryWithObjectsAndKeys:
      @"80", @"Port",
      nil]
    ];
    
  NSLog(@"init service");

  /* initialize the coder */
  coder = [GWSSOAPCoder new];
  
  /* salesforce WSDL specifies it to be literal */
  [coder setUseLiteral:YES];

  /* init our service */
  service = [[GWSService alloc] init];
  
  [service setCoder:coder];
  
  /* set the SOAP action to an empty string, salesforce likes that more */
  [service setSOAPAction:@"\"\""];

  url = [NSURL URLWithString:@"http://www.salesforce.com/services/Soap/c/14.0"];
  [service setURL:url];
  
  [service setDebug:YES];
  
  
  /* prepare the parameters */
  loginParmDict = [NSMutableDictionary dictionaryWithCapacity: 3];
  [loginParmDict setObject: @"urn:partner.soap.sforce.com" forKey: GWSSOAPNamespaceURIKey];
  [loginParmDict setObject: userName forKey: @"username"];
  [loginParmDict setObject: password forKey: @"password"];

  parmsDict = [NSMutableDictionary dictionaryWithCapacity: 1];
  [parmsDict setObject: loginParmDict forKey: @"login"];

  
  /* invoke the login */  
  resultDict = [service invokeMethod: @"login"
                parameters : parmsDict
		order : nil
		timeout : 60];

  NSLog(@"dict is %d big", [resultDict count]);
  
  enumerator = [resultDict keyEnumerator];
  while (key = [enumerator nextObject])
  {
    NSLog(@"%@ - %@", key, [resultDict objectForKey:key]); 
  }
  

  NSLog(@"request: %@", [[NSString alloc] initWithData:
    	[resultDict objectForKey:@"GWSCoderRequestData"] encoding: NSUTF8StringEncoding]);
  
  [coder release];
}

- (void)dealloc
{
    NSLog(@"dealloc service");
    [service release];
}

@end
