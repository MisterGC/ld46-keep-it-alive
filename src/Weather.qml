// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file
import QtQuick 2.12

Item {
    Component.onCompleted: console.log("Test")
    Timer {
        Component.onCompleted: start()
        interval: 10000
        onTriggered: {
            let x = Math.random() * theWorld.worldXMax
            let y = Math.random() * theWorld.worldYMax
            let storm = theStorm.createObject(theWorld.coordSys,
                                              {
                                                  world: theWorld.physics,
                                                  duration: interval,
                                                  pixelPerUnit: theWorld.pixelPerUnit,
                                                  xWu: x,
                                                  yWu: y,
                                                  widthWu: 50,
                                                  heightWu: 50
                                              });
        }
        repeat: true
    }
    Component {
       id: theStorm
       Storm {}
    }
}
