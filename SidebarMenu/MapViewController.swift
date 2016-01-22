//
//  MapViewController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import MapKit

// Bus Object
class Bus {
    internal var id: String
    internal var direc: String
    internal var exists: Bool
    internal var dropPin: MKPointAnnotation
    
    internal init(id: String, direc: String, exists: Bool, dropPin: MKPointAnnotation) {
        self.id = id
        self.direc = direc
        self.exists = exists
        self.dropPin = dropPin
    }
    
}

var dummyPoint = MKPointAnnotation()

// Dummy initializer for testing List of Bus Objects
//var listBuses = [Bus(id: "0", direc: "outer", exists: true, dropPin: dummyPoint)]


class MapViewController: UIViewController, NSXMLParserDelegate, MKMapViewDelegate {
    //@IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    var listBuses = [Bus]()
    var parser = NSXMLParser()
    var timer  = NSTimer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // Make hamburger icon clickable

        //if self.revealViewController() != nil {
        //    menuButton.target = self.revealViewController()
        //    menuButton.action = "revealToggle:"
        //    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //}
        
        // Center opening map to UC Santa Cruz
        let location = CLLocationCoordinate2D(latitude: 36.9900,
            longitude: -122.0605)
        let span = MKCoordinateSpanMake(0.03, 0.03)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        // Drop pin on 'location' coordinates
        let annotation = Capital(title: "UC Santa Cruz", coordinate: location, info: "Our School")
        mapView.addAnnotation(annotation)
        
        // XML file
        parser = NSXMLParser(contentsOfURL:(NSURL(string:"http://skynet.cse.ucsc.edu/bts/coord2.xml"))!)!
        
        // Build objects for xml data
        let coord = Coord2()
        parser.delegate = coord
        parser.parse()
        print("coord has a count attribute of \(coord.count)")
        print("coord has \(coord.markers.count) markers")
        
        var iterator = 0
        for marker in coord.markers {
            
            // Print XML tag values for verification of proper parsing
            print("marker id=\(marker.id), lat=\(marker.lati), lng=\(marker.lngi), route=\(marker.route)")
            
            var newMarker = MKPointAnnotation()
            newMarker.coordinate = CLLocationCoordinate2D(latitude: marker.lati, longitude: marker.lngi)
            
            // Append the Bus to the List of Bus Objects
            listBuses.append(Bus(id: marker.id, direc: marker.direc, exists: true, dropPin: newMarker))
            // Add marker to the map
            mapView.addAnnotation(listBuses[iterator].dropPin)
            iterator++
        }
        
        // Run reloadBuses() every 10 seconds
        timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: "reloadBuses", userInfo: nil, repeats: true)

    }
    
    // Function that continuously updates bus marker locations on map
    func reloadBuses() {
        
        // Assume that no Buses exist
        for buses in listBuses {
            buses.exists = false
        }
        
        // Communicate with XML file
        parser = NSXMLParser(contentsOfURL:(NSURL(string:"http://skynet.cse.ucsc.edu/bts/coord2.xml"))!)!
        
        // Build objects from XML data
        let coord = Coord2()
        parser.delegate = coord
        parser.parse()
        print("coord has a count attribute of \(coord.count)")
        print("coord has \(coord.markers.count) markers")
        print("listBuses after coord has \(listBuses.count)")
        
        var listBusesCount: Int
        // Cross reference global listBuses w/ actual buses from XML
        for marker in coord.markers {
            listBusesCount = -1
            for newBus in listBuses {
                listBusesCount++
                if marker.id == newBus.id {
                    // Bus exists
                    newBus.exists = true
                    newBus.dropPin.coordinate = CLLocationCoordinate2D(latitude: marker.lati, longitude: marker.lngi)
                    break
                }
                // If we've reached the end of listBuses w/o matching a bus ID
                // this is a new bus, so append it to listBuses and add to Map
                if listBusesCount == (listBuses.count - 1) {
                    var newBusToAppend = MKPointAnnotation()
                    newBusToAppend.coordinate = CLLocationCoordinate2D(latitude: marker.lati, longitude: marker.lngi)
                    listBuses.append(Bus(id: marker.id, direc: marker.direc, exists: true, dropPin: newBusToAppend))
                    mapView.addAnnotation(newBusToAppend)
                }
            }
        }

        print("listBuses has \(listBuses.count)")
        // Remove inactive buses from global listBuses
        var busToElim = 0
        for bus in listBuses {
            print(bus.id)
            if !bus.exists {
                mapView.removeAnnotation(listBuses[busToElim].dropPin)
                listBuses.removeAtIndex(busToElim)
            }
            busToElim++
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // 1
        let identifier = "Capital"
        
        // 2
        if annotation.isKindOfClass(Capital.self) {
            print("3")
            // 3
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if annotationView == nil {
                //4
                print("4")
                annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
                annotationView!.canShowCallout = true
                
                // 5
                let btn = UIButton(type: .DetailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
            } else {
                // 6
                print("6")
                annotationView!.annotation = annotation
            }
            
            return annotationView
        }
        
        // 7
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let capital = view.annotation as! Capital
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// ParseBase class
// simple base class that is used to consume foundCharacters
// via the parser
class ParserBase : NSObject, NSXMLParserDelegate  {
    
    var currentElement:String = ""
    var foundCharacters = ""
    weak var parent:ParserBase? = nil
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentElement = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        self.foundCharacters = string
    }
    
}

// Coord2 class
// represents a coord2 tag
// it has a count attribute
// and a collection of markers
class Coord2 : ParserBase {
    
    var count = 0
    var markers = [Marker]()
    
    // didStartElement()
    override func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        //print("processing <\(elementName)> tag from Coord")
        
        if elementName == "coord2" {
            
            // if we are processing a coord2 tag, we are at the root
            // of XML file, extract the count value and set it
            print(attributeDict["count"])
            if let c = Int(attributeDict["count"]!) {
                self.count = c
            }
        }
        
        // if we found a marker tag, delegate further responsibility
        // to parsing to a new instance of Marker
        if elementName == "marker" {
            let marker = Marker()
            self.markers.append(marker)
            
            // push responsibility
            parser.delegate = marker
            
            // let marker know who we are
            // so that once marker is done XML processing
            // it can return parsing responsibility back
            marker.parent = self
        }
    }
}

// Marker class
class Marker : ParserBase {
    
    var id = ""
    var lat = ""
    var lng = ""
    var route = ""
    var direc = ""
    var lati = 0.0
    var lngi = 0.0
    
    // didEndElement()
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        //print("processing <\(elementName)> tag from Marker")
        
        // if we finished an item tag, the ParserBase parent
        // would have accumulated the found characters
        // so just assign that to our item variable
        if elementName == "id" {
            self.id = foundCharacters
        }
            
            // convert the lat to a Double
        else if elementName == "lat" {
            self.lat = foundCharacters
            // cast self.lat as Double
            if let doubleFromlat = Double(self.lat) {
                self.lati = doubleFromlat
            } else { print("foundCharacters for lat does not hold double") }
            
        }
            
            // convert the lng to a Double
        else if elementName == "lng" {
            self.lng = foundCharacters
            if let doubleFromlng = Double(self.lng) {
                self.lngi = doubleFromlng
            } else { print("foundCharacters for lng does not hold double") }
        }
            
        else if elementName == "route" {
            self.route = foundCharacters
        }
            
        else if elementName == "direction" {
            self.direc = foundCharacters
        }
            
            // if we reached the </marker> tag, we do not
            // have anything further to do, so delegate
            // parsing responsibility to parent
        else if elementName == "marker" {
            parser.delegate = self.parent
        }
        
        // reset found characters
        foundCharacters = ""
    }
    
}
