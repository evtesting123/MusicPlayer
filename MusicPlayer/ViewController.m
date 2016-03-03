//
//  ViewController.m
//  MusicPlayer
//
//  Created by ev_mac5 on 20/02/16.
//  Copyright © 2016 eventurers. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DetailViewController.h"

@interface ViewController ()
{
    NSMutableArray *tableArray;
    IBOutlet UITableView *tblView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Audio List";
    
    tableArray = [NSMutableArray array];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
    NSArray *contents = [fileManager contentsOfDirectoryAtURL:bundleURL
                                   includingPropertiesForKeys:@[]
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pathExtension ENDSWITH %@", @"mp3"];
    for (NSString *path in [contents filteredArrayUsingPredicate:predicate]) {
        // Enumerate each .png file in directory
        [tableArray addObject:path];
//        [self getAudioDetails:(NSURL*)path];
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

-(void)getAudioDetails:(NSURL*)soundUrl
{
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:soundUrl];
    NSArray *metadataList = [playerItem.asset commonMetadata];
    for (AVMetadataItem *metaItem in metadataList) {
        NSLog(@"%@",[metaItem commonKey]);
    }
}


#pragma mark - TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableArray.count)
        return tableArray.count;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableArray.count) {
        static NSString *simpleTableIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        UILabel *lbl = (UILabel*)[cell.contentView viewWithTag:10];
        NSString *path = tableArray[indexPath.row];
        lbl.text =  path.lastPathComponent;
        
        return cell;
        
    } else {
        static NSString *simpleTableIdentifier = @"NoResultsCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = @"No Music Found";
        
        return cell;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
    NSIndexPath *path = [tblView indexPathForSelectedRow];
    DetailViewController *vc = [segue destinationViewController];
    vc.index = (int)path.row;
    vc.audioAry = tableArray;
}





@end
