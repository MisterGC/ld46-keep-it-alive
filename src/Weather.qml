// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file
import QtQuick 2.12

Item {
    id: theWeather

    signal _destroyStorms()
    enabled: false
    onEnabledChanged: {
        if (enabled)
            theTimer.start();
        else {
            theTimer.stop();
            _destroyStorms();
        }
    }

    Timer {
        id: theTimer
        interval: 20000
        onTriggered: {
            let wWu = 75;
            let hWu = 37;
            let x = Math.random() * (theWorld.worldXMax - wWu);
            let y = Math.random() * (theWorld.worldYMax - hWu);
            let storm = theStorm.createObject(theWorld.coordSys,
                                              {
                                                  world: theWorld.physics,
                                                  duration: 8000 + Math.random() * 7000,
                                                  pixelPerUnit: theWorld.pixelPerUnit,
                                                  xWu: x,
                                                  yWu: y,
                                                  widthWu: 75,
                                                  heightWu: 37
                                              });
            theWeather._destroyStorms.connect(storm.destroy);
        }
        repeat: true
        triggeredOnStart: true
    }

    Component { id: theStorm; Storm {} }
}
