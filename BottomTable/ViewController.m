//
//  ViewController.m
//  BottomTable
//
//  Created by Brennan Stehling on 8/26/15.
//  Copyright (c) 2015 Acme. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *markerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *markerView;

@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *additionalItems;

@end

@implementation ViewController

#pragma mark - View Lifecycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Sample data courtesy of Coffee Ipsum
    // http://coffeeipsum.com
    
    self.items = @[
                   @"Shop espresso coffee black cultivar whipped sugar carajillo rich spoon bar grinder.",
                   @"Sit to go, body, fair trade, java fair trade body percolator to go qui cup turkish.",
                   @"To go instant, est espresso chicory ut acerbic."
                   ].mutableCopy;
    
    self.additionalItems = @[
                             @"Seasonal robusta, aged crema frappuccino medium kopi-luwak that aged strong flavour.",
                             @"Et acerbic brewed turkish aromatic instant, french press seasonal robusta latte blue mountain.",
                             @"Caffeine id crema, est french press irish turkish milk.",
                             @"Grinder, grounds qui, coffee et ristretto cream, plunger pot americano body id single shot.",
                             @"Strong coffee so qui mug saucer strong doppio.",
                             @"Fair trade and, viennese, arabica, dark and to go brewed galão.",
                             @"Filter dark aftertaste cup white variety mug variety.",
                             @"Americano java grinder est black, skinny carajillo frappuccino sit viennese single shot.",
                             @"Aroma decaffeinated coffee fair trade cup as body at breve cinnamon.",
                             @"Sweet, ristretto grounds a sugar café au lait mocha.",
                             @"Coffee in dripper cultivar kopi-luwak seasonal cup single shot.",
                             @"Spoon, cultivar galão white percolator mug aroma."
                             ].mutableCopy;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self addAnotherRow];
    });
}

- (void)viewDidLayoutSubviews {
    [self updateContentInsetForTableView:self.tableView animated:NO];
}

#pragma mark - UITableViewDataSource
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *item = self.items[indexPath.row];
    UILabel *textLabel = (UILabel *)[cell viewWithTag:1];
    textLabel.text = item;
    
    return cell;
}

#pragma mark - UITableViewDelegate
#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - Table Helper
#pragma mark -

- (void)updateContentInsetForTableView:(UITableView *)tableView animated:(BOOL)animated {
    NSUInteger lastRow = [self tableView:tableView numberOfRowsInSection:0];
    NSLog(@"last row: %lu", (unsigned long)lastRow);
    NSLog(@"items count: %lu", (unsigned long)self.items.count);
    
    NSUInteger lastIndex = lastRow > 0 ? lastRow - 1 : 0;
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:lastIndex inSection:0];
    CGRect lastCellFrame = [self.tableView rectForRowAtIndexPath:lastIndexPath];

    // top inset = table view height - top position of last cell - last cell height
    CGFloat topInset = MAX(CGRectGetHeight(self.tableView.frame) - lastCellFrame.origin.y - CGRectGetHeight(lastCellFrame), 0);
    NSLog(@"top inset: %f", topInset);
    
    UIEdgeInsets contentInset = tableView.contentInset;
    contentInset.top = topInset;
    NSLog(@"inset: %f, %f : %f, %f", contentInset.top, contentInset.bottom, contentInset.left, contentInset.right);
    
    NSLog(@"table height: %f", CGRectGetHeight(self.tableView.frame));
    
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState;
    [UIView animateWithDuration:animated ? 0.25 : 0.0 delay:0.0 options:options animations:^{
        self.markerHeightConstraint.constant = ABS(topInset);
        tableView.contentInset = contentInset;
        
        [self.markerView setNeedsLayout];
        [self.markerView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)addAnotherRow {
    if (self.additionalItems.count) {
        NSString *item = self.additionalItems.firstObject;
        [self.additionalItems removeObjectAtIndex:0];
        [self.items addObject:item];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(self.items.count - 1) inSection:0];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        [self updateContentInsetForTableView:self.tableView animated:YES];
        
        // TODO: if the scroll offset was at the bottom it can be scrolled down (allow user to scroll up and not override them)
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

    if (self.additionalItems.count) {
        [self performSelector:@selector(addAnotherRow) withObject:nil afterDelay:0.5];
    }
}

@end
