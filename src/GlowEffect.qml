// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file
import QtQuick 2.12
import QtGraphicalEffects 1.12

Glow {
    property var image: null
    parent: image.parent
    width: image.width
    height: image.height
    radius: 20
    samples: 17
    color: "#00dce7"
    source: image
    Behavior on radius { NumberAnimation {duration: 2000}}
}
