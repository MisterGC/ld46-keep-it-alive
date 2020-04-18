// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file
import QtQuick 2.12

Item {
    id: theWeather

    property bool running: false
    signal _destroyStorms()
    onRunningChanged: {
        if (running) theTimer.start()
        else {
            theTimer.stop()
            _destroyStorms()
        }
    }

    Timer {
        id: theTimer
        interval: 2000
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
            theWeather._destroyStorms.connect(storm.destroy);
        }
        repeat: true
    }

    Component { id: theStorm; Storm {} }
}