//
//  ViewController.m
//  LoboMaps
//
//  Created by Alfred Sanchez on 12/4/14.
//  Copyright (c) 2014 Alfred Sanchez. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property CGFloat viewWidth;
@property CGFloat viewHeight;
@property NSString* currentParserKey;
@property NSString* currentLocationKey;
@property NSDictionary* tasks;
@property NSDictionary* XMLData;
@property NSMutableDictionary* parsers;
@property NSMutableDictionary* parserKeys;
@property NSMutableDictionary* locations;
@property UIActivityIndicatorView* spinner;
@property NSURLSession* session;

@property Downloads* dlObj;

@end

@implementation ViewController

@synthesize downloadRequests;
@synthesize persistentStoreCoordinator;
@synthesize managedObjectContext;
@synthesize managedObjectModel;

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  self.locations = [NSMutableDictionary dictionary];
  
  //Setup UI Elements
  self.title = @"INTRO";
  NSString* labelTextString = @"Loading...";
  NSInteger stringLength = [labelTextString length];
  
  NSMutableAttributedString* labelText = [[NSMutableAttributedString alloc] initWithString:labelTextString];
  
  UIColor* textColor = [UIColor redColor];
  UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:32.0f];
  NSShadow* textShadow = [[NSShadow alloc] init];
  [textShadow setShadowBlurRadius:5.0];
  [textShadow setShadowColor:[UIColor grayColor]];
  [textShadow setShadowOffset:CGSizeMake(0, 3)];
  
  [labelText addAttribute:NSFontAttributeName
                    value:font
                    range:NSMakeRange(0, stringLength)];
  
  [labelText addAttribute:NSForegroundColorAttributeName
                    value:textColor
                    range:NSMakeRange(0, stringLength)];
  
  [labelText addAttribute:NSShadowAttributeName
                    value:textShadow
                    range:NSMakeRange(0, stringLength)];
  
  self.viewWidth  = self.view.frame.size.width;
  self.viewHeight = self.view.frame.size.height;
  CGPoint viewCenter = CGPointMake(self.viewWidth/2.0, self.viewHeight/2.0);
  
  CGRect loadingLabelFrame = CGRectMake(0.0, self.viewHeight/3, 160, 40);
  UILabel* loadingLabel = [[UILabel alloc] initWithFrame:loadingLabelFrame];
  loadingLabel.center = CGPointMake(self.viewWidth/2, self.viewHeight/3);
  loadingLabel.attributedText = labelText;
  loadingLabel.textColor = [UIColor redColor];
  
  CALayer* labelLayer = [loadingLabel layer];
  
  CABasicAnimation* fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.0];
  fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
  fadeInAnimation.duration = 1.0;
  fadeInAnimation.removedOnCompletion = NO;
  fadeInAnimation.fillMode = kCAFillModeForwards;
  
  [labelLayer addAnimation:fadeInAnimation
                    forKey:@"opacity"];
  
  [self.view addSubview:loadingLabel];
  
  self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
  
  //Fetch and see if BOOLS are present if not load data
  self.spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  self.spinner.center = viewCenter;
  self.spinner.hidesWhenStopped = YES;
  [self.view addSubview:self.spinner];
  [self.spinner startAnimating];
  
  //Check if downloads have been done before
  NSError* downloadsFetchError;
  NSFetchRequest* downloadsFetch = [[NSFetchRequest alloc] init];
  NSEntityDescription* dataDownloads = [NSEntityDescription entityForName:@"Downloads"inManagedObjectContext:self.managedObjectContext];
  
  [downloadsFetch setEntity:dataDownloads];
  
  NSArray* downloads = [self.managedObjectContext executeFetchRequest:downloadsFetch error:&downloadsFetchError];
  
  if (downloadsFetchError)
  {
    NSLog(@"DOWNLOAD_FETCH_ERROR: %@", downloadsFetchError);
  }
  
  if ([downloads count] == 0)
  {
    
    //check for newtwork. 
    Reachability* reachable = [Reachability reachabilityForInternetConnection];
    if (!reachable.isReachable)
    {
      UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Network Detected"
                                                      message:@"Cannot establish database"
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
      [alert show];

    }
    else
    {
      NSLog(@"Device is Reachable");

    
    
      self.dlObj = [NSEntityDescription insertNewObjectForEntityForName:@"Downloads" inManagedObjectContext:self.managedObjectContext];
  
    //fire up session and get data
      NSURLSessionDataTask* mapBuildings = [self.session dataTaskWithRequest:[self.downloadRequests objectForKey:@"mapBuildings"]];
    
      NSURLSessionDataTask* bluePhonesNorth = [self.session dataTaskWithRequest:[self.downloadRequests objectForKey:@"bluePhonesNorth"]];
    
      NSURLSessionDataTask* bluePhonesSouth = [self.session dataTaskWithRequest:[self.downloadRequests objectForKey:@"bluePhonesSouth"]];
    
      NSURLSessionDataTask* restrooms = [self.session dataTaskWithRequest:[self.downloadRequests objectForKey:@"restrooms"]];
    
      NSURLSessionDataTask* computerPods = [self.session dataTaskWithRequest:[self.downloadRequests objectForKey:@"computerPods"]];
    
      NSURLSessionDataTask* dining = [self.session dataTaskWithRequest:[self.downloadRequests objectForKey:@"dining"]];
    
      NSURLSessionDataTask* gyms = [self.session dataTaskWithRequest:[self.downloadRequests objectForKey:@"gyms"]];
    
      NSURLSessionDataTask* healthyVending = [self.session dataTaskWithRequest:[self.downloadRequests objectForKey:@"healthyVending"]];
    
      NSURLSessionDataTask* lactationStation = [self.session dataTaskWithRequest:[self.downloadRequests objectForKey:@"lactationStation"]];
    
      NSURLSessionDataTask* libraries = [self.session dataTaskWithRequest:[self.downloadRequests objectForKey:@"libraries"]];
    
      NSURLSessionDataTask* meteredParking = [self.session dataTaskWithRequest:[self.downloadRequests objectForKey:@"meteredParking"]];
    
      NSURLSessionDataTask* otherCampuses = [self.session dataTaskWithRequest:[self.downloadRequests objectForKey:@"otherCampuses"]];
    
      NSURLSessionDataTask* placesOfInterest = [self.session dataTaskWithRequest:[self.downloadRequests objectForKey:@"placesOfInterest"]];
    
      NSURLSessionDataTask* shuttles = [self.session dataTaskWithRequest:[self.downloadRequests objectForKey:@"shuttles"]];
    
      NSURLSessionDataTask* walkingRoutes = [self.session dataTaskWithRequest:[self.downloadRequests objectForKey:@"walkingRoutes"]];
    
      self.tasks = [NSDictionary dictionaryWithObjectsAndKeys:
                  @"mapBuildings", mapBuildings,
                  @"bluePhonesNorth", bluePhonesNorth,
                  @"bluePhonesSouth", bluePhonesSouth,
                  @"restrooms", restrooms,
                  @"computerPods", computerPods,
                  @"dining", dining,
                  @"gyms", gyms,
                  @"healthyVending", healthyVending,
                  @"lactationStation", lactationStation,
                  @"libraries", libraries,
                  @"meteredParking", meteredParking,
                  @"otherCampuses", otherCampuses,
                  @"placesOfInterest", placesOfInterest,
                  @"shuttles", shuttles,
                  @"walkingRoutes", walkingRoutes, nil];
    
      self.XMLData = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSMutableData data], @"mapBuildings",
                    [NSMutableData data], @"bluePhonesNorth",
                    [NSMutableData data], @"bluePhonesSouth",
                    [NSMutableData data], @"restrooms",
                    [NSMutableData data], @"computerPods",
                    [NSMutableData data], @"dining",
                    [NSMutableData data], @"gyms",
                    [NSMutableData data], @"healthyVending",
                    [NSMutableData data], @"lactationStation",
                    [NSMutableData data], @"libraries",
                    [NSMutableData data], @"meteredParking",
                    [NSMutableData data], @"otherCampuses",
                    [NSMutableData data], @"placesOfInterest",
                    [NSMutableData data], @"shuttles",
                    [NSMutableData data], @"walkingRoutes",nil];
    
      self.parsers = [NSMutableDictionary dictionary];
      self.parserKeys = [NSMutableDictionary dictionary];
    
      [mapBuildings resume];
      [bluePhonesNorth resume];
      [bluePhonesSouth resume];
      [restrooms resume];
      [computerPods resume];
      [dining resume];
      [gyms resume];
      [healthyVending resume];
      [lactationStation resume];
      [libraries resume];
      [meteredParking resume];
      [otherCampuses resume];
      [placesOfInterest resume];
      [shuttles resume];
      [walkingRoutes resume];
    
      [self.session finishTasksAndInvalidate];
    }
  }
  else
  {
    //read in from database
    Downloads* dl = [downloads firstObject];

    if (![dl allDownloadsComplete])
    {
      //something is wrong
  
    }
    else
    {
      //read in from database
      Reachability* reachable = [Reachability reachabilityForInternetConnection];
      if (!reachable.isReachable)
      {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Network Detected"
                                                        message:@"Location services will be unavailable"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
      }
      
      NSError* error;
      NSFetchRequest* downloadsFetch = [[NSFetchRequest alloc] init];
      NSEntityDescription* downloadsEntity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
      [downloadsFetch setEntity:downloadsEntity];
      NSArray* locations = [self.managedObjectContext executeFetchRequest:downloadsFetch error:&error];
      if (error)
      {
        NSLog(@"ERROR: Could not fetch downloads %@", [error localizedDescription]);
      }
     
      [self.spinner stopAnimating];
      //Get Ready for VC Transition

      UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
      
      CategoriesViewController* categories = [storyboard instantiateViewControllerWithIdentifier:@"Categories"];
      [categories setLocations:locations];
      [categories setPersistentStoreCoordinator:self.persistentStoreCoordinator];
      [categories setManagedObjectContext:self.managedObjectContext];
      [categories setManagedObjectModel:self.managedObjectModel];

      [self.navigationController pushViewController:categories animated:YES];
    }
    
  }
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark Utility Methods

- (NSString*)taskKey:(NSURLSessionDataTask*) dataTask
{
  return [self.tasks objectForKey:dataTask];
}

- (NSString*)parserKey:(NSXMLParser*)parser
{
  NSString* pKey;
  NSArray* keys = [self.parsers allKeys];
  for (NSString* key in keys)
  {
    if (parser == [self.parsers objectForKey:key])
    {
      pKey = key;
    }
  }
  
  return pKey;
}

#pragma mark Session Delegate Methods

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
  if (error)
  {
    NSLog(@"SESSION ERROR %@", error);
  }
  else
  {
    
    NSArray* vals = [self.locations allValues];
    NSError* error;
    for (LocationHelper* loc in vals)
    {
      Location* newLocation = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
      
      newLocation.latitude  = loc.latitude;
      newLocation.longitude = loc.longitude;
      newLocation.title     = loc.title;
      newLocation.type      = loc.type;
      newLocation.campus    = loc.campus;
      newLocation.address   = loc.address;
      newLocation.keywords  = loc.keywords;
      newLocation.snippet   = loc.desc;
      newLocation.buildingNumber = loc.buildingNumber;
     
      if ([loc.title compare:@"Student Union Building"] == NSOrderedSame)
      {
        DefaultLocation* defaultLocation = [NSEntityDescription insertNewObjectForEntityForName:@"DefaultLocation" inManagedObjectContext:self.managedObjectContext];
        defaultLocation.latitude  = loc.latitude;
        defaultLocation.longitude = loc.longitude;
        defaultLocation.title     = loc.title;
        defaultLocation.nickname  = @"SUB"; 
      }
      
    }
    
    if (![self.managedObjectContext save:&error])
    {
      NSLog(@"ERROR: Could not save | %@", [error localizedDescription]);
    }
    
    [self.spinner stopAnimating];
    
    //Get Ready for VC Transition
    NSDictionary* nextLocations = [NSDictionary dictionaryWithDictionary:self.locations];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
  
    CategoriesViewController* categories = [storyboard instantiateViewControllerWithIdentifier:@"Categories"];
    
    [categories setLocations:[nextLocations allValues]];
    [categories setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    [categories setManagedObjectContext:self.managedObjectContext];
    [categories setManagedObjectModel:self.managedObjectModel];
    
    [self.navigationController pushViewController:categories animated:YES]; 
  }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
  NSHTTPURLResponse* rsp = (NSHTTPURLResponse*) response;
  if ([rsp statusCode] != 200)
  {
    //handle error
    NSLog(@"RESPONSE ERROR %@", [self taskKey:dataTask]);
    exit(1);
  }
  else completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
  NSMutableData* mData = [self.XMLData objectForKey:[self.tasks objectForKey:dataTask]];
  [mData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
  if (error)
  {
    NSLog(@"Task Complete ERROR %@", error);
  }
  else
  {
    NSString* key = [self.tasks objectForKey:task];
    
    [self.parsers setObject:[[NSXMLParser alloc] initWithData:[self.XMLData objectForKey:key]] forKey:key];
    NSXMLParser* parser = [self.parsers objectForKey:key];
    [parser setDelegate:self];
    
    if (![parser parse])
    {
      NSLog(@"Parser didn't parse for %@", key);
    }
  }
}

#pragma mark NSXMLParser Methods

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
  self.currentParserKey = [self parserKey:parser];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
  
  if ([[self parserKey:parser] compare:@"lactationStation"] == NSOrderedSame)
  {
    [self.dlObj setLactationStation:[NSNumber numberWithBool:YES]];
  }
  else if ([[self parserKey:parser] compare:@"computerPods"] == NSOrderedSame)
  {
    [self.dlObj setComputerPods:[NSNumber numberWithBool:YES]];
  }
  else if ([[self parserKey:parser] compare:@"healthyVending"] == NSOrderedSame)
  {
    [self.dlObj setHealthyVending:[NSNumber numberWithBool:YES]];
  }
  else if ([[self parserKey:parser] compare:@"otherCampuses"] == NSOrderedSame)
  {
    [self.dlObj setOtherCampuses:[NSNumber numberWithBool:YES]];
  }
  else if ([[self parserKey:parser] compare:@"restrooms"] == NSOrderedSame)
  {
    [self.dlObj setRestrooms:[NSNumber numberWithBool:YES]];
  }
  else if ([[self parserKey:parser] compare:@"gyms"] == NSOrderedSame)
  {
    [self.dlObj setGyms:[NSNumber numberWithBool:YES]];
  }
  else if ([[self parserKey:parser] compare:@"walkingRoutes"] == NSOrderedSame)
  {
    [self.dlObj setWalkingRoutes:[NSNumber numberWithBool:YES]];
  }
  else if ([[self parserKey:parser] compare:@"placesOfInterest"] == NSOrderedSame)
  {
    [self.dlObj setPlacesOfInterest:[NSNumber numberWithBool:YES]];
  }
  else if ([[self parserKey:parser] compare:@"bluePhonesNorth"] == NSOrderedSame)
  {
    [self.dlObj setBluePhonesNorth:[NSNumber numberWithBool:YES]];
  }
  else if ([[self parserKey:parser] compare:@"bluePhonesSouth"] == NSOrderedSame)
  {
    [self.dlObj setBluePhonesSouth:[NSNumber numberWithBool:YES]];
  }
  else if ([[self parserKey:parser] compare:@"mapBuildings"] == NSOrderedSame)
  {
    [self.dlObj setMapBuildings:[NSNumber numberWithBool:YES]];
  }
  else if ([[self parserKey:parser] compare:@"shuttles"] == NSOrderedSame)
  {
    [self.dlObj setShuttles:[NSNumber numberWithBool:YES]];
  }
  else if ([[self parserKey:parser] compare:@"dining"] == NSOrderedSame)
  {
    [self.dlObj setDining:[NSNumber numberWithBool:YES]];
  }
  else if ([[self parserKey:parser] compare:@"meteredParking"] == NSOrderedSame)
  {
    [self.dlObj setMeteredParking:[NSNumber numberWithBool:YES]];
  }
  else if ([[self parserKey:parser] compare:@"libraries"] == NSOrderedSame)
  {
    [self.dlObj setLibraries:[NSNumber numberWithBool:YES]];
  }
  
  self.currentParserKey = nil;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
  NSString* parserKey = [self parserKey:parser];
  
  if ([elementName compare:@"loc"] == NSOrderedSame)
  {
    self.currentLocationKey = [attributeDict objectForKey:@"title"];
    
    LocationHelper* location = [[LocationHelper alloc] init];
    location.type  = parserKey;
    location.title = [attributeDict objectForKey:@"title"];
    location.buildingNumber = [NSNumber numberWithInteger:[[attributeDict objectForKey:@"buildingnum"] integerValue]];
    location.abbr = [attributeDict objectForKey:@"abbr"];
    location.campus = [attributeDict objectForKey:@"campus"];
    location.latitude = [NSNumber numberWithDouble:[[attributeDict objectForKey:@"latitude"]doubleValue]];
    location.longitude = [NSNumber numberWithDouble:[[attributeDict objectForKey:@"longitude"]doubleValue]];
    location.keywords = [attributeDict objectForKey:@"keywords"];
  
    [self.locations setObject:location forKey:self.currentLocationKey];
  }
}
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
  NSString* description = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];

  
  
  LocationHelper* location = [self.locations objectForKey:self.currentLocationKey];
  location.desc = description;
}

#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if ([alertView.message compare:@"Cannot establish database"] == NSOrderedSame)
  {
    exit(1);
  }
}

@end
