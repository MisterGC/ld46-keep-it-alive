// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file
import QtQuick 2.12
import Clayground.Physics 1.0
import Clayground.ScalingCanvas 1.0
import QtQuick.Shapes 1.14

Item {
    property var path: []
    Timer {
        Component.onCompleted: start()
        interval: 1000
        repeat: true
        onTriggered: {
           // TODO Spawn Enemy
           console.log("Time to spawn an enemy!")
        }
    }

    ScalingPoly {
        canvas: theWorld
        strokeStyle: ShapePath.DashLine
        dashPattern: [ 1, 4 ]
        vertices: path
        strokeColor: "red"
        opacity: .5
    }
}
