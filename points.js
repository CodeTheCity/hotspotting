
x = [-2.06968525,-2.09367475,-2.070803375,-2.12276175,-2.06941816666667,-2.09256566666667,-2.07242291666667,-2.09916154166667,-2.10510345833333,-2.08430675,-2.118656375,-2.14964,-2.067017,-2.091115375,-2.098000625,-2.07126483333333,-2.10177333333333,-2.09499366666667,-2.070829625,-2.104875875,-2.14964,-2.10554833333333,-2.10603608333333,-2.149715,-2.07243691666667,-2.10558270833333,-2.11611508333333,-2.14771220833333,-2.10558270833333,-2.098561125,-2.077496375];
y = [57.14273875,57.147898625,57.141776,57.1762435833333,57.14161,57.1477373333333,57.143254,57.147638,57.132294,57.145446,57.175581375,57.175581375,57.132432,57.175581375,57.175581375,57.1425771666667,57.1636886666667,57.1478550416667,57.1434555,57.131788,57.17539025,57.131788,57.1324886666667,57.1760778333333,57.1439595,57.1317737916667,57.176483375,57.176483375,57.16690275,57.176483375,57.176483375];
labels = ["castles","castles","waterfall","waterfall","unique","unique","outdoor","outdoor","outdoor","outdoor","wildlife","wildlife","wildlife","wildlife","wildlife","historic","historic","historic","family","family","peaceful","peaceful","beautiful","beautiful","beautiful","nature","nature","nature","nature","nature","nature"];
points = [{lat:57.147, lng:-2.103}, {lat:57.145, lng:-2.102}]
      
var markers = [];

var wpts = [];

// var newIcon = MapIconMaker.createMarkerIcon({width: 20, height: 34, primaryColor: "#0000FF", cornercolor:"#0000FF"});

function createMarker(pos, map,  title) {
    var marker = new google.maps.Marker({
        position:pos,
        map:map,
        title:title});
    markers.push(marker);
    google.maps.event.addListener(marker, 'click', function() { 
        console.log('Clicked.');
        console.log(pos);
        wpts.push(pos);
        marker.icon = "http://maps.google.com/mapfiles/ms/icons/green-dot.png";
    });
}

function initMap() {
    var directionsService = new google.maps.DirectionsService;
    var directionsDisplay = new google.maps.DirectionsRenderer ({suppressMarker: true});
 
    var abdnLatLng = {lat: 57.14, lng: -2.09};

    var map = new google.maps.Map(document.getElementById('map'), {
        zoom: 13,
        center: abdnLatLng
    });

    for(var i = 0; i < x.length; i++) {
        createMarker({lat: y[i], lng: x[i]}, map, labels[i]);
    }

    directionsDisplay.setMap(map);


    document.getElementById('submit').addEventListener('click', function() {
        calculateAndDisplayRoute(directionsService, directionsDisplay);
    });
}
 
function calculateAndDisplayRoute(directionsService, directionsDisplay) {
    var start = wpts.shift();
    var end = wpts.pop();
    var waypoints = [];
    for(var n=0; n<wpts.length; n++) {
        waypoints.push({
            location: wpts[n],
            stopover: true
        })}
    directionsService.route({
        origin: start,
        destination: end,
        waypoints: waypoints,
        optimizeWaypoints: true,
        travelMode: 'WALKING'
    }, function(response, status) {
        if (status === 'OK') {
            console.log(response);
            directionsDisplay.setDirections(response);
            var route = response.routes[0];
            var summaryPanel = document.getElementById('directions-panel');
            summaryPanel.innerHTML = '';
            // For each route, display summary information.
            for (var i = 0; i < route.legs.length; i++) {
                var routeSegment = i + 1;
                summaryPanel.innerHTML += '<b>Route Segment: ' + routeSegment +
                    '</b><br>';
                summaryPanel.innerHTML += route.legs[i].start_address + ' to ';
                summaryPanel.innerHTML += route.legs[i].end_address + '<br>';
                summaryPanel.innerHTML += route.legs[i].distance.text + '<br><br>';
                summaryPanel.innerHTML += '<div class="instruction" id="instructions' + i + '"> </div>';
                instructions = document.getElementById('instructions'+i);
                for (var j = 0; j < route.legs[i].steps.length; j++) {
                    instructions.innerHTML += '<p>'+ route.legs[i].steps[j].instructions+ ' ' +
                        route.legs[i].steps[j].distance.text + '</p>';
                }
            };
            
            //service.route( {origin: origin, destination: destination }, function( response, status ) {
            //        if ( status == google.maps.DirectionsStatus.OK ) {
            //            display.setDirections( response );
            //            var leg = response.routes[ 0 ].legs[ 0 ];
            //            makeMarker( leg.start_location, icons.start, "title" );
            //            makeMarker(leg.end_location, icons.end, 'title' );
            //            }
            //        
                          
            
            
                                
        } else {
            window.alert('Directions request failed due to ' + status);
        }
    });
}
