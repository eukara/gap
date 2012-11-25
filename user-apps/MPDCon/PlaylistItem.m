/*
   Project: MPDCon

   Copyright (C) 2004

   Author: Daniel Luederwald

   Created: 2004-05-14 11:53:40 +0200 by flip

   PlaylistItem

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

#include "PlaylistItem.h"

@implementation PlaylistItem

/* --------------------------
   - Initialization Methods -
   --------------------------*/

- (id) init
{
  MPDConDB = [SQLiteAdaptor sharedSQLiteAdaptor];
  return self;
}

- (void) dealloc
{
  RELEASE(artist);
  RELEASE(title);
  RELEASE(album);
  RELEASE(genre);
  RELEASE(trackNr);
  RELEASE(path);
  RELEASE(comment);
  RELEASE(composer);
  RELEASE(date);
  RELEASE(performer);
  RELEASE(disc);

  [super dealloc];
}

/* --------------------
   - Accessor Methods -
   --------------------*/

- (NSString *) getArtist
{
  return artist;
}

- (void) setArtist: (NSString *)newArtist
{
  AUTORELEASE(artist);
  artist = [newArtist copy];
}

- (NSString *) getAlbum
{
  return album;
}

- (void) setAlbum: (NSString *)newAlbum
{
  AUTORELEASE(album);
  album = [newAlbum copy];
}

- (NSString *) getGenre
{
  return genre;
}

- (void) setGenre: (NSString *)newGenre
{
  AUTORELEASE(genre);
  genre = [newGenre copy];
}

- (NSString *) getTitle
{
  return title;
}

- (void) setTitle: (NSString *)newTitle
{
  AUTORELEASE(title);
  title = [newTitle copy];
}

- (NSString *) getTrackNr
{
  return trackNr;
}

- (void) setTrackNr: (NSString *)newNr
{
  AUTORELEASE(trackNr);
  trackNr = [newNr copy];
}

- (NSString *) getComment
{
  return comment;
}

- (void) setComment: (NSString *)newComment
{
  AUTORELEASE(comment);
  comment = [newComment copy];
}

- (NSString *) getComposer
{
  return composer;
}

- (void) setComposer: (NSString *)newComposer
{
  AUTORELEASE(composer);
  composer = [newComposer copy];
}

- (NSString *) getDate
{
  return date;
}

- (void) setDate: (NSString *)newDate
{
  AUTORELEASE(date);
  date = [newDate copy];
}

- (NSString *) getPerformer
{
  return performer;
}

- (void) setPerformer: (NSString *)newPerformer
{
  AUTORELEASE(performer);
  performer = [newPerformer copy];
}

- (NSString *) getDisc
{
  return disc;
}

- (void) setDisc: (NSString *)newDisc
{
  AUTORELEASE(disc);
  disc = [newDisc copy];
}

- (int) getElapsedTime
{
  return elapsedTime;
}

- (void) setElapsedTime: (int)newTime
{
  elapsedTime = newTime;
}

- (int) getTotalTime
{
  return totalTime;
}

- (void) setTotalTime: (int)newTime
{
  totalTime = newTime;
}

- (NSString *) getPath
{
  return path;
}

- (void) setPath: (NSString *)newPath
{
  AUTORELEASE(path);
  path = [newPath copy];
}

- (NSUInteger) getRating
{
  return [MPDConDB getRatingForFile:path];
}

- (void) setRating: (NSUInteger)newRating
{
  [MPDConDB setRating: newRating forFile: path];
}

- (NSDictionary *) getLyrics
{
  return [MPDConDB getLyricsForFile:path];
}
- (void) setLyrics: (NSString *) lyricsText withURL: (NSString *)lyricsURL
{
  [MPDConDB setLyrics: lyricsText withURL: lyricsURL forFile: path];
}

- (void) setID: (int) newID
{
  ID = newID;
}

- (int) getID
{
  return ID;
}

- (void) setPos: (int) newPos
{
  pos = newPos;
}

- (int) getPos
{
  return pos;
}
@end
