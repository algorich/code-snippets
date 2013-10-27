$(function() {
    // is addresspicker defined?
    if (jQuery.prototype.addresspicker) {
        var $address_input = $('#addresspicker'),
            lat = $address_input.data('lat') || -14, // lat of brazil
            lng = $address_input.data('lng') || -51, // lng of brazil
            addresspickerMap = $address_input.addresspicker({
                reverseGeocode: true,
                componentsFilter: 'country:BR',
                regionBias: 'br',
                // updateCallback: doSomething,
                mapOptions: {
                    zoom: 16,
                    center: new google.maps.LatLng(lat, lng),
                },
                elements: {
                    map: '#adresspicker-map',
                    lat: '#lat',
                    lng: '#lng'
                }
            });

        var gmarker = addresspickerMap.addresspicker('marker');
        gmarker.setVisible(true);
        addresspickerMap.addresspicker('updatePosition');
    }
});