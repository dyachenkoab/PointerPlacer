import QtQuick.Controls 2.12
import QtQuick 2.12
import QtPositioning 5.6
import QtQuick.Dialogs 1.0
import QtLocation 5.6

Map {
    id: mapview
    anchors.fill: parent
    plugin: plugin
    center: QtPositioning.coordinate(59.89435, 30.28225)
    zoomLevel: 17
    copyrightsVisible: false

    Plugin {
        id: plugin
        name: "osm"
//        PluginParameter {
//            name: "osm.mapping.custom.host";
//            value: "https://c.tile.openstreetmap.de/${z}/${x}/${y}.png"
//        }
    }

//    Component.onCompleted: {
//        console.log(mapview.supportedMapTypes.length)
//        for( var i_type in supportedMapTypes ) {
//            console.log(supportedMapTypes[i_type].name)
//            if( supportedMapTypes[i_type].name.localeCompare( "Custom URL Map" ) === 0 ) {
//                activeMapType = supportedMapTypes[i_type]
//            }
//        }
//    }

    function addMark(coord) {
        var component = Qt.createComponent("Pointer.qml")

        if (component.status === Component.Ready) {
            var item = component.createObject(mapview, {center: coord})
            mapview.addMapItem(item)
        }
    }

    function place(rawCoord) {
        let re = new RegExp('[0-9]{2}\\.[0-9]+', 'g')
        let lat = re.exec(rawCoord)
        let lon = re.exec(rawCoord)

        if (lon)
            mapview.center = QtPositioning.coordinate(lat, lon)

        while(lon) {
            let pointed = QtPositioning.coordinate(lat, lon)
            addMark(pointed)
            lat = re.exec(rawCoord)
            lon = re.exec(rawCoord)
        }
    }
}
