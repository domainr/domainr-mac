//
//  DMRViewController.m
//  Domai.nr
//
//  Created by Connor Montgomery on 02/04/2014.
//  Copyright (c) 2014 Domai.nr. All rights reserved.
//

#import "DMRViewController.h"
#import "DMRTableRowView.h"
#import "DMRTextFieldView.h"
#import "DMRResultsTableView.h"
#import <QuartzCore/QuartzCore.h>
#import <SVHTTPRequest.h>

#define kSpacer ((int) 16)
#define kAvailabilityImageDimension ((int) 16)
#define kResultCellHeight ((int) 30)

@interface DMRViewController ()
    @property(nonatomic) NSProgressIndicator *spinner;
    @property(nonatomic) NSMutableArray *domains;
    @property(nonatomic) NSString *query;
    @property(nonatomic) DMRResultsTableView *tableView;
    @property(nonatomic) BOOL shouldOpenBrowser;
@end

@implementation DMRViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _shouldOpenBrowser = NO;
        _searchBox = [[DMRTextFieldView alloc] initWithFrame:CGRectMake(
                                                                               kSpacer,
                                                                               self.view.frame.size.height - 40,
                                                                               self.view.frame.size.width - (kSpacer * 2),
                                                                               30)];

        [_searchBox.cell setPlaceholderString:@"search"];
        _searchBox.extendedDelegate = self;
        [_searchBox.cell setFocusRingType:NSFocusRingTypeNone];
        _searchBox.textColor = [NSColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
        _searchBox.target = self;
        _searchBox.action = @selector(searchBoxAction:);
        _searchBox.bezelStyle = NSTextFieldRoundedBezel;
        [_searchBox becomeFirstResponder];
        [self.view addSubview:_searchBox];
        
        _spinner = [[NSProgressIndicator alloc] initWithFrame:CGRectMake(
                                                                                             _searchBox.bounds.size.width - 10,                           self.view.frame.size.height - 33,
                                                                                            16,
                                                                                            16)];
        
        [self.view addSubview:_spinner];
        [_spinner setHidden:YES];
        _spinner.style = NSProgressIndicatorSpinningStyle;
        
        NSScrollView *tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(2,
                                                                                      kSpacer + 23,
                                                                                      self.view.frame.size.width - 4,
                                                                                      self.view.frame.size.height - 40 - _searchBox.frame.size.height - kSpacer)];
        tableContainer.wantsLayer = YES;
        _tableView = [[DMRResultsTableView alloc] initWithFrame:NSMakeRect(0, 0, self.view.frame.size.width, tableContainer.frame.size.height)];
        NSTableColumn *column1 = [[NSTableColumn alloc] initWithIdentifier:@"Col1"];
        _tableView.backgroundColor = [NSColor whiteColor];
        [column1 setWidth:self.view.frame.size.width];
        [_tableView addTableColumn:column1];
        _tableView.extendedDelegate = self;
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[NSColor clearColor]];
        [_tableView setDataSource:self];
        [_tableView reloadData];
        [tableContainer setDocumentView:_tableView];
        _tableView.headerView = nil;
        [tableContainer setHasVerticalScroller:YES];
        [self.view addSubview:tableContainer];

        NSButton *poweredByDomainr = [[NSButton alloc] initWithFrame:NSMakeRect(kSpacer,
                                                                                self.view.frame.size.height - self.view.frame.size.height + (kSpacer),
                                                                                      self.view.frame.size.width - (kSpacer * 2),
                                                                                      14)];
        [poweredByDomainr setBordered:NO];
        poweredByDomainr.title = @"Powered by Domainr";
        [poweredByDomainr setAction:@selector(didClickPoweredBy:)];
        poweredByDomainr.target = self;
        poweredByDomainr.font = [NSFont fontWithName:poweredByDomainr.font.fontName size:11.0f];
        [poweredByDomainr sizeToFit];
        NSMutableAttributedString *labelTitle =
        [[NSMutableAttributedString alloc] initWithAttributedString:[poweredByDomainr attributedTitle]];
        
        [poweredByDomainr setAlignment:NSLeftTextAlignment];
        
        NSRange titleRange = NSMakeRange(0, [labelTitle length]);
        
        [labelTitle addAttribute:NSForegroundColorAttributeName
                           value:[NSColor colorWithRed:180/255.0f green:189/255.0f blue:175/255.0f alpha:1.0]
                           range:titleRange];
        
        [poweredByDomainr setAttributedTitle:labelTitle];
        [self.view addSubview:poweredByDomainr positioned:NSWindowAbove relativeTo:nil];

        NSInteger popupButtonSize = 44;

        NSBox *box = [[NSBox alloc] initWithFrame:NSMakeRect(0, 38, self.view.frame.size.width, 3)];
        [self.view addSubview:box];


        NSPopUpButton *popupButton = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(self.view.frame.size.width - kSpacer - popupButtonSize,

                                                                                0,
                                                                                popupButtonSize,
                                                                                popupButtonSize)];

        NSMenu *menu = [[NSMenu alloc] init];
        popupButton.pullsDown = YES;
        popupButton.bordered = NO;

        [self.view addSubview:popupButton];

        NSMenuItem *dummy = [[NSMenuItem alloc] init];
        dummy.title = @"";
        dummy.image = [NSImage imageNamed:NSImageNameActionTemplate];
        [menu addItem:dummy];
        NSMenuItem *fooMenuItem = [[NSMenuItem alloc] initWithTitle:@"Preferences" action:NULL keyEquivalent:@","];
        NSMenuItem *barMenuItem = [[NSMenuItem alloc] initWithTitle:@"Quit" action:NULL keyEquivalent:@"q"];
        [menu addItem:fooMenuItem];
        [menu addItem:[NSMenuItem separatorItem]];
        [menu addItem:barMenuItem];
        
        popupButton.menu = menu;
    }
    return self;
}

- (void)didClickPoweredBy: (id)sender {
    [_tracker trackEvent:@"macAppOpenURLFromPoweredByLink"
                  action:@"clickPoweredByLink"
                   label:nil
                   value:-1
               withError:nil];
    NSString *url = @"https://domainr.com/about";
    url = [self urlWithMacID:url];
    [self openUrl:url];
}

- (void)tableView:(NSTableView *)tableView didPressEnter:(NSEvent *)theEvent {
    NSDictionary *domainObject = _domains[[_tableView selectedRow]];
    NSString *url = [self urlForDomainObject:domainObject];
    url = [self urlWithMacID:url];
    [self openUrl:url];
}

- (NSString *)urlWithMacID:(NSString *)url {
    NSString *newUrl = [NSString stringWithFormat:@"%@?client_id=mac", url];
    return newUrl;
}

- (void)openUrl:(NSString *)url {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
    [_statusItemPopup hidePopover];
}

- (NSString *)urlForDomainObject:(NSDictionary *)domainObject {
    NSString *domain = domainObject[@"domain"];
    NSString *safeQuery = [_query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *URL = [NSString stringWithFormat:@"https://domai.nr/%@/with/%@", safeQuery, domain];
    return URL;
}

- (void)tableView:(NSTableView *)tableView didClickedRow:(NSInteger)row {
    NSString *url = [self urlForDomainObject:_domains[row]];
    url = [self urlWithMacID:url];
    [self openUrl:url];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return kResultCellHeight;
}

- (void)timerDidExpire:(NSTimer *)timer {
    [self search:nil];
}

- (void)didKeyUp:(NSEvent *)theEvent {
    int keycode = theEvent.keyCode;
    NSInteger currentIndex = [_tableView selectedRow];
    NSInteger desiredIndex;
    
    if (keycode == 126 || keycode == 125) {
        _shouldOpenBrowser = YES;
    } else {
        _shouldOpenBrowser = NO;
    }
    
    if (keycode == 126) {
        if (currentIndex == 0) {
            desiredIndex = [_domains count] - 1;
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:desiredIndex];
            [_tableView selectRowIndexes:indexSet byExtendingSelection:NO];
        } else {
            desiredIndex = currentIndex - 1;
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:desiredIndex];
            [_tableView selectRowIndexes:indexSet byExtendingSelection:NO];
        }
    } else if (keycode == 125) {
        if (currentIndex == [_domains count] - 1) {
            desiredIndex = 0;
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:desiredIndex];
            [_tableView selectRowIndexes:indexSet byExtendingSelection:NO];
        } else {
            desiredIndex = currentIndex + 1;
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:currentIndex + 1];
            [_tableView selectRowIndexes:indexSet byExtendingSelection:NO];
        }
    }
    
    [_tableView scrollRowToVisible:desiredIndex];
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    return YES;
}

- (void)search:(id)selector {
    [_spinner setHidden:NO];
    [_spinner startAnimation:self];

    [_tracker trackEvent:@"macAppSearch"
                  action:@"searchBegin"
                   label:nil
                   value:-1
               withError:nil];

    [SVHTTPRequest GET:@"https://domai.nr/api/json/search"
            parameters:@{
                         @"q": _searchBox.stringValue,
                         @"client_id": @"mac"
                         }
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {

                if (error != nil) {
                    [_tracker trackEvent:@"macAppSearch"
                                  action:@"searchError"
                                   label:nil
                                   value:-1
                               withError:nil];
                } else {
                    [_tracker trackEvent:@"macAppSearch"
                                  action:@"searchSuccess"
                                   label:nil
                                   value:-1
                               withError:nil];
                    _domains = response[@"results"];
                    _query = response[@"query"];

                    [_tableView enumerateAvailableRowViewsUsingBlock:^(NSTableRowView *rowView, NSInteger row){
                        NSTableCellView *cellView = [rowView viewAtColumn:0];
                        cellView.textField.textColor = [NSColor colorWithRed:40/255.0f green:112/255.0f blue:176/255.0f alpha:1.0];
                    }];


                    [_tableView reloadData];
                    [_spinner stopAnimation:self];
                    [_spinner setHidden:YES];
                }
            }
     ];
}

- (void)searchBoxAction:(id)selector {
    if (_shouldOpenBrowser) {
        NSDictionary *domainObject = _domains[[_tableView selectedRow]];
        NSString *url = [self urlForDomainObject:domainObject];
        url = [self urlWithMacID:url];
        [self openUrl:url];
        [_tracker trackEvent:@"macAppOpenURLFromResult"
                      action:@"clickResult"
                       label:nil
                       value:-1
                   withError:nil];
    } else {
        [self search:selector];
    }
}

-(NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row{
    
    static NSString *cellID = @"cell_identifier";
    
    //use this if you want to reuse the cells
    DMRTableRowView *result = [tableView makeViewWithIdentifier:cellID owner:self];
    
    if (result == nil) {
        
        result = [[DMRTableRowView alloc] initWithFrame:NSMakeRect(0, 0, self.view.frame.size.width, kResultCellHeight)];
        result.identifier = cellID;
        
    }
    
    // Return the result
    return result;
    
}

-(void)tableViewSelectionIsChanging:(NSNotification *)notification {
    [self updateSelectedRowColor];
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification {
    [self updateSelectedRowColor];
}

- (void)updateSelectedRowColor {
    [_tableView enumerateAvailableRowViewsUsingBlock:^(NSTableRowView *rowView, NSInteger row){
        NSTableCellView *cellView = [rowView viewAtColumn:0];
        if (rowView.selected){
            cellView.textField.textColor = [NSColor whiteColor];
        } else{
            cellView.textField.textColor = [NSColor colorWithRed:40/255.0f green:112/255.0f blue:176/255.0f alpha:1.0];
        }
    }];
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    
    NSTableCellView *result = [tableView makeViewWithIdentifier:@"MyView" owner:self];
    
    if (result == nil) {
        result = [[NSTableCellView alloc] initWithFrame:CGRectMake(kSpacer,
                                                                   kSpacer,
                                                                   self.view.frame.size.width - (2 * kSpacer),
                                                                   kResultCellHeight)];
    }

    if (result.textField == nil) {
        NSTextField *textField = [[NSTextField alloc] initWithFrame:CGRectMake(
                                                                               kSpacer + kAvailabilityImageDimension,
                                                                               3,
                                                                               self.view.frame.size.width - (2 * kSpacer) - kAvailabilityImageDimension,
                                                                               kResultCellHeight - 6)];
        textField.font = [NSFont fontWithName:@"HelveticaNeue" size:15.0f];
        textField.textColor = [NSColor colorWithRed:40/255.0f green:112/255.0f blue:176/255.0f alpha:1.0];
        textField.backgroundColor = [NSColor clearColor];
        [textField setBordered:NO];
        [textField setEditable:NO];
        [result addSubview:textField];
        result.textField = textField;
    }
    
    if (result.imageView == nil) {
        NSImageView *imageView = [[NSImageView alloc] initWithFrame:CGRectMake(
                                                                               0,
                                                                               -6,
                                                                               40,
                                                                               40)];
        [result addSubview:imageView];
        result.imageView = imageView;
    }
    
    result.textField.stringValue = _domains[row][@"domain"];
    NSImage *image = [NSImage imageNamed:_domains[row][@"availability"]];
    [image setSize:NSSizeFromCGSize(CGSizeMake(10.0f, 10.0f))];
    [result.imageView setImage:image];

    result.identifier = @"MyView";
    
    return result;
    
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [_domains count];
}

@end
