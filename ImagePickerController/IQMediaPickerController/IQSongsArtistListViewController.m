//
//  IQSongsArtistListViewController.m
//  IQAudioPickerController
//
//  Created by Iftekhar on 12/08/14.
//  Copyright (c) 2014 Iftekhar. All rights reserved.
//

#import "IQSongsArtistListViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "IQSongListViewController.h"

@implementation IQSongsArtistListViewController
{
    NSArray *collections;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    MPMediaQuery *query = [MPMediaQuery albumsQuery];
    [query setGroupingType:MPMediaGroupingAlbumArtist];
    
    collections = [query collections];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return collections.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    MPMediaItemCollection *item = [collections objectAtIndex:indexPath.row];
    
    MPMediaItemArtwork *artwork = [item.representativeItem valueForProperty:MPMediaItemPropertyArtwork];
    UIImage *image = [artwork imageWithSize:artwork.bounds.size];
    cell.imageView.image = image;
    cell.textLabel.text = [item.representativeItem valueForProperty:MPMediaItemPropertyAlbumArtist];
    
    MPMediaQuery *query = [MPMediaQuery albumsQuery];
    [query setGroupingType:MPMediaGroupingAlbum];
    [query addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:[item.representativeItem valueForProperty:MPMediaItemPropertyAlbumArtist] forProperty:MPMediaItemPropertyAlbumArtist]];
    
    NSUInteger albums = [[query collections] count];
    NSUInteger songs = [[query items] count];

    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu %@, %lu %@",(unsigned long)albums,(albums>1?@"albums":@"album"),(unsigned long)songs,(songs>1?@"songs":@"song")];

    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:NSStringFromClass([IQSongListViewController class])])
    {
        IQSongListViewController *controller = segue.destinationViewController;

        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        MPMediaItemCollection *item = [collections objectAtIndex:indexPath.row];

        controller.title = [item.representativeItem valueForProperty:MPMediaItemPropertyAlbumArtist];
        
        MPMediaQuery *query = [MPMediaQuery albumsQuery];
        [query setGroupingType:MPMediaGroupingAlbum];
        [query addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:controller.title forProperty:MPMediaItemPropertyAlbumArtist]];

        controller.collections = [query collections];
    }
}

@end
