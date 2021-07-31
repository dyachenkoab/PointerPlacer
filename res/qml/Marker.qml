import QtQuick 2.0
import QtLocation 5.6

MapQuickItem {
    id: marker
    anchorPoint.x: image.width/2
    anchorPoint.y: image.height
    sourceItem: Image {
        id: image
        source: "loc.png"
    }
}
