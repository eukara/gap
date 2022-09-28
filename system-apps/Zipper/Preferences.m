/*

  Preferences.m
  Zipper

  Copyright (C) 2012 Free Software Foundation, Inc

  Authors: Dirk Olmes <dirk@xanthippe.ping.de>
           Riccardo Mottola <rm@gnu.org>

  This application is free software; you can redistribute it and/or modify it
  under the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 2 of the License, or (at your option)
  any later version.

  This program is distributed in the hope that it will be useful, but
  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
  or FITNESS FOR A PARTICULAR PURPOSE.
  See the GNU General Public License for more details

 */

#import <Foundation/Foundation.h>
#import "Preferences.h"
#import "NSFileManager+Custom.h"

#define X_MISSING_PREF @"MissingPreferenceException"
#define X_WRONG_PREF @"WrongPreferenceException"

@interface Preferences (PrivateAPI)
+ (NSString *)stringForKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;
+ (void)checkExecutable:(NSString *)executable withName:(NSString *)name;
@end

/**
 * This class encapsulates the access to the app's preferences. It faciliates providing a
 * Dictionary that will be used instead of NSUserDefaults and searching the PATH environment
 * variable.
 */
@implementation Preferences : NSObject

/**
 * To faciliate unit testing it's possible to provide the Preferences class with an NSDictionary
 * that makes up the preferences.
 */
static NSDictionary *_replacementPrefs = nil;

/**
 * Additional Preferences loaded from PropertyList file
 */
static NSDictionary *_plistPrefs;

/**
 * This is the mapping between file extensions and tar's extract option. This option differs
 * from platform to platform. In order to encapsulate this, Preferences manages this mapping
 * and clients can ask for a compression argument with <code>compressionArgumentForFile:</code>
 */
static NSMutableDictionary *_extensionMapping = nil;

+ (void)initialize
{
	NSString *path;
	
	if (_extensionMapping == nil)
	{
		_extensionMapping = [[NSMutableDictionary dictionaryWithObjectsAndKeys:
			@"", @"tar",
			@"-z", @"gz",
			@"-z", @"tgz",
			@"-j", @"bz2",
			@"-t", @"xz",
			nil] retain];
	}
	
	// see if there's a property list containing preferences to use
	path = [[NSBundle bundleForClass:self] pathForResource:@"DefaultPreferences" ofType:@"plist"];
	if (path != nil)
	{
		_plistPrefs = [[NSDictionary dictionaryWithContentsOfFile:path] retain];
	}
}

+ (void)usePreferences:(NSDictionary *)newPrefs;
{
  [_replacementPrefs release];
  _replacementPrefs = newPrefs;
  [_replacementPrefs retain];
}

+ (NSString *)tarExecutable;
{
	NSString *tar = [self stringForKey:PREF_KEY_TAR];
	if (tar == nil)
	{
		// search the PATH
		tar = [[NSFileManager defaultManager] locateExecutable:@"tar"];
	}
	return tar;
}

+ (void)setTarExecutable:(NSString *)newTar
{
	if (newTar != nil)
	{
		[[NSUserDefaults standardUserDefaults] setObject:newTar forKey:PREF_KEY_TAR];
	}
}

+ (BOOL)isBsdTar;
{
	return [self boolForKey:PREF_KEY_BSD_TAR];
}

+ (void)setIsBsdTar:(BOOL)flag
{
	[[NSUserDefaults standardUserDefaults] setBool:flag forKey:PREF_KEY_BSD_TAR];
	if (flag == YES)
	{
		// on BSD tar also uses -z for extracting .bz archives
		[_extensionMapping setObject:@"-z" forKey:@"bz2"];
	}
	else
	{
		[_extensionMapping setObject:@"-j" forKey:@"bz2"];
	}
}

+ (NSString *)zipExecutable;
{
	NSString *zip = [self stringForKey:PREF_KEY_ZIP];
	if (zip == nil)
	{
		zip = [[NSFileManager defaultManager] locateExecutable:@"zip"];
	}
	return zip;
}
+ (void)setZipExecutable:(NSString *)newZip
{
	if (newZip != nil)
	{
		[[NSUserDefaults standardUserDefaults] setObject:newZip forKey:PREF_KEY_ZIP];
	}
}

+ (NSString *)unzipExecutable;
{
	NSString *unzip = [self stringForKey:PREF_KEY_UNZIP];
	if (unzip == nil)
	{
		unzip = [[NSFileManager defaultManager] locateExecutable:@"unzip"];
	}
	return unzip;
}

+ (void)setUnzipExecutable:(NSString *)newUnzip
{
	if (newUnzip != nil)
	{
		[[NSUserDefaults standardUserDefaults] setObject:newUnzip forKey:PREF_KEY_UNZIP];
	}
}

+ (NSString *)sevenZipExecutable;
{
	NSString *zip = [self stringForKey:PREF_KEY_SEVEN_ZIP];
	if (zip == nil)
	{
		zip = [[NSFileManager defaultManager] locateExecutable:@"7z"];

        // corner case: only 7za may be available on the system
        if (zip == nil)
        {
            zip = [[NSFileManager defaultManager] locateExecutable:@"7za"];
        }
	}
	return zip;
}

+ (void)setSevenZipExecutable:(NSString *)new7zip
{
	if (new7zip != nil)
	{
		[[NSUserDefaults standardUserDefaults] setObject:new7zip forKey:PREF_KEY_SEVEN_ZIP];
	}
}

+ (NSString *)rarExecutable;
{
	NSString *rar = [self stringForKey:PREF_KEY_RAR];
	if (rar == nil)
	{
		rar = [[NSFileManager defaultManager] locateExecutable:@"unrar"];
	}
	return rar;
}

+ (void)setRarExecutable:(NSString *)newRar;
{
	if (newRar != nil)
	{
		[[NSUserDefaults standardUserDefaults] setObject:newRar forKey:PREF_KEY_RAR];
	}
}

+ (NSString *)lhaExecutable
{
	NSString *lha = [self stringForKey:PREF_KEY_LHA];
	if (lha == nil)
	{
		lha = [[NSFileManager defaultManager] locateExecutable:@"lha"];
	}
	return lha;
}

+ (void)setLhaExecutable:(NSString *)newLha;
{
	if (newLha != nil)
	{
		[[NSUserDefaults standardUserDefaults] setObject:newLha forKey:PREF_KEY_LHA];
	}
}

+ (NSString *)lzxExecutable
{
	NSString *lzx = [self stringForKey:PREF_KEY_LZX];
	if (lzx == nil)
	{
		lzx = [[NSFileManager defaultManager] locateExecutable:@"unlzx"];
	}
	return lzx;
}

+ (void)setLzxExecutable:(NSString *)newLzx;
{
	if (newLzx != nil)
	{
		[[NSUserDefaults standardUserDefaults] setObject:newLzx forKey:PREF_KEY_LZX];
	}
}

+ (NSString *)gzipExecutable
{
	NSString *gzip = [self stringForKey:PREF_KEY_GZIP];
	if (gzip == nil)
	{
		gzip = [[NSFileManager defaultManager] locateExecutable:@"gzip"];
	}
	return gzip;
}

+ (void)setGzipExecutable:(NSString *)newGzip
{
	if (newGzip != nil)
	{
		[[NSUserDefaults standardUserDefaults] setObject:newGzip forKey:PREF_KEY_GZIP];
	}
}

+ (NSString *)gunzipExecutable
{
	NSString *gunzip = [self stringForKey:PREF_KEY_GUNZIP];
	if (gunzip == nil)
	{
		gunzip = [[NSFileManager defaultManager] locateExecutable:@"gunzip"];
	}
	return gunzip;
}

+ (void)setGunzipExecutable:(NSString *)newGunzip
{
	if (newGunzip != nil)
	{
		[[NSUserDefaults standardUserDefaults] setObject:newGunzip forKey:PREF_KEY_GUNZIP];
	}
}

+ (NSString *)bzip2Executable
{
	NSString *bzip2 = [self stringForKey:PREF_KEY_BZIP2];
	if (bzip2 == nil)
	{
		bzip2 = [[NSFileManager defaultManager] locateExecutable:@"bzip2"];
	}
	return bzip2;
}

+ (void)setBzip2Executable:(NSString *)newBzip2
{
	if (newBzip2 != nil)
	{
		[[NSUserDefaults standardUserDefaults] setObject:newBzip2 forKey:PREF_KEY_BZIP2];
	}
}

+ (NSString *)bunzip2Executable
{
	NSString *bunzip2 = [self stringForKey:PREF_KEY_BUNZIP2];
	if (bunzip2 == nil)
	{
		bunzip2 = [[NSFileManager defaultManager] locateExecutable:@"bunzip2"];
	}
	return bunzip2;
}

+ (void)setBunzip2Executable:(NSString *)newBunzip2
{
	if (newBunzip2 != nil)
	{
		[[NSUserDefaults standardUserDefaults] setObject:newBunzip2 forKey:PREF_KEY_BUNZIP2];
	}
}

+ (NSString *)unarjExecutable
{
	NSString *unarj = [self stringForKey:PREF_KEY_UNARJ];
	if (unarj == nil)
	{
		unarj = [[NSFileManager defaultManager] locateExecutable:@"unarj"];
	}
	return unarj;
}

+ (void)setUnarjExecutable:(NSString *)newUnarj
{
	if (newUnarj != nil)
	{
		[[NSUserDefaults standardUserDefaults] setObject:newUnarj forKey:PREF_KEY_UNARJ];
	}
}

+ (NSString *)unaceExecutable
{
	NSString *unace = [self stringForKey:PREF_KEY_UNACE];
	if (unace == nil)
	{
		unace = [[NSFileManager defaultManager] locateExecutable:@"unace"];
	}
	return unace;
}

+ (void)setUnaceExecutable:(NSString *)newUnace
{
	if (newUnace != nil)
	{
		[[NSUserDefaults standardUserDefaults] setObject:newUnace forKey:PREF_KEY_UNACE];
	}
}

+ (NSString *)zooExecutable
{
	NSString *zoo = [self stringForKey:PREF_KEY_ZOO];
	if (zoo == nil)
	{
		zoo = [[NSFileManager defaultManager] locateExecutable:@"zoo"];
	}
	return zoo;
}

+ (void)setZooExecutable:(NSString *)newZoo
{
	if (newZoo != nil)
	{
		[[NSUserDefaults standardUserDefaults] setObject:newZoo forKey:PREF_KEY_ZOO];
	}
}

+ (NSString *)xzExecutable
{
	NSString *xz = [self stringForKey:PREF_KEY_XZ];
	if (xz == nil)
	{
		xz = [[NSFileManager defaultManager] locateExecutable:@"xz"];
	}
	return xz;
}

+ (void)setXzExecutable:(NSString *)newXz
{
	if (newXz != nil)
	{
		[[NSUserDefaults standardUserDefaults] setObject:newXz forKey:PREF_KEY_XZ];
	}
}

+ (NSString *)lastOpenDirectory
{
	return [self stringForKey:PREF_KEY_OPEN_DIR];
}

+ (void)setLastOpenDirectory:(NSString *)path;
{
	[[NSUserDefaults standardUserDefaults] setObject:path forKey:PREF_KEY_OPEN_DIR];
}

+ (NSString *)lastExtractDirectory;
{
	return [self stringForKey:PREF_KEY_EXTRACT_DIR];
}

+ (void)setLastExtractDirectory:(NSString *)path;
{
	[[NSUserDefaults standardUserDefaults] setObject:path forKey:PREF_KEY_EXTRACT_DIR];
}

+ (NSString *)compressionArgumentForFile:(NSString *)fileName
{
	if (fileName != nil)
	{
		return [_extensionMapping objectForKey:[fileName pathExtension]];
	}
	return nil;
}

/**
 * Returns the name of the app that will be used to open files that don't have a
 * pathExtension.
 */
+ (NSString *)defaultOpenApp;
{
	return [self stringForKey:PREF_KEY_DEFAULT_OPEN_APP];
}

+ (void)setDefaultOpenApp:(NSString *)path;
{
	[[NSUserDefaults standardUserDefaults] setObject:path forKey:PREF_KEY_DEFAULT_OPEN_APP];
}

+ (void)save
{
	[[NSUserDefaults standardUserDefaults] synchronize];
}

//------------------------------------------------------------------------------
// private API
//------------------------------------------------------------------------------
+ (NSString *)stringForKey:(NSString *)key;
{
	NSString *value;
	
	if (_replacementPrefs != nil)
	{
		return [_replacementPrefs objectForKey:key];
	}
	
	value = [[NSUserDefaults standardUserDefaults] stringForKey:key];
	if ((value == nil) && (_plistPrefs != nil))
	{
		value = [_plistPrefs objectForKey:key];
	}
	return value;
}

+ (BOOL)boolForKey:(NSString *)key
{
	if (_replacementPrefs != nil)
	{
		NSString *value = [_replacementPrefs objectForKey:key];
		return [value isEqual:@"YES"];
	}
	return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

@end
