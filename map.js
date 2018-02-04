function initMap() {
    var directionsService = new google.maps.DirectionsService;
    var directionsDisplay = new google.maps.DirectionsRenderer ({suppressMarker: true});
    
    var map = new google.maps.Map(document.getElementById('map'), {
        zoom: 10,
        center: {
            lat: 57.14,
            lng: -2.05
        }
    });
    
    var contentString='<div id="content">'+
        '<div id="siteNotice">'+
        '</div>'+
        '<h1 id="firstHeading" class="firstHeading">Aberdeen</h1>'
        '<div id="bodyContent">'+
        '<p></p>'+
        '</div>'+
        '</div>';
    
    var infowindow=new google.maps.InfoWindow({
        content:contentString
    });
    
    
    
    var marker = new google.maps.Marker({
        position: {lat:57.14, lng:-2.05},
        map: map,
        title:'Aberdeen(Scotland)'
    });
    
    marker.addListener('click',function() {
        infowindow.open(map, marker);
    });
    
    directionsDisplay.setMap(map);

    document.getElementById('submit').addEventListener('click', function() {
        calculateAndDisplayRoute(directionsService, directionsDisplay);
    });
}

function makeMarker(position, icon, title) {
                new google.maps.Marker({
                    position: position,
                    map: map,
                    icon: icon,
                    title: title
                }),

function calculateAndDisplayRoute(directionsService, directionsDisplay) {
    var waypts = [];
    var checkboxArray = document.getElementById('waypoints');
    for (var i = 0; i < checkboxArray.length; i++) {
        if (checkboxArray.options[i].selected) {
            waypts.push({
                location: checkboxArray[i].value,
                stopover: true
            });
        }
    }

    directionsService.route({
        origin: document.getElementById('start').value,
        destination: document.getElementById('end').value,
        waypoints: waypts,
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
            for (var j = 0; j < route.legs[i].steps.length; j++) {
                summaryPanel.innerHTML += '<p>'+ route.legs[i].steps[j].instructions+'</p>';
            }};
            
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
};
