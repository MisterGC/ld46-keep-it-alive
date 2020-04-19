// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file
import QtQuick 2.12
import Clayground.Physics 1.0
import Clayground.ScalingCanvas 1.0
import QtQuick.Shapes 1.14
import Box2D 2.0

Item {
    id: theMaster
    property var path: []
    property var _waypoints: []
    property var gameWorld: parent
    property var _spawned: []
    onEnabledChanged: {
        if (enabled) spawnTimer.start();
        else spawnTimer.stop();
    }

    Component.onCompleted: {
        let lenWuH = 1.0;
        for (let i=1; i<path.length; ++i) {
            let p = path[i];
            let ent = theWayPointComp.createObject(gameWorld.coordSys,
                                                  {
                                                      world: gameWorld.physics,
                                                      pixelPerUnit: gameWorld.pixelPerUnit,
                                                      xWu: p.x - lenWuH,
                                                      yWu: p.y + lenWuH,
                                                      widthWu: 2*lenWuH,
                                                      heightWu: 2*lenWuH
                                                  });
            _waypoints.push(ent);
            _spawned.push(ent);
        }
    }

    Component { id: theWayPointComp; Waypoint {}}
    Timer {
        id: spawnTimer
        interval: 10000
        repeat: true
        onTriggered: {
            let enemy = theSpawner.createObject(gameWorld.coordSys,
                                                {
                                                    world: gameWorld.physics,
                                                    pixelPerUnit: gameWorld.pixelPerUnit,
                                                    xWu: path[0].x,
                                                    yWu: path[0].y,
                                                    widthWu: 5,
                                                    heightWu: 5,
                                                    wpPath: _waypoints
                                                });
            enemy.pixelPerUnit = Qt.binding( _ => {return gameWorld.pixelPerUnit;} );
            enemy.active =  Qt.binding( _ => {return gameWorld.running;} );
            _spawned.push(enemy);
        }
        triggeredOnStart: true
    }

    Component { id: theSpawner; Enemy {} }


    ScalingPoly {
        canvas: gameWorld
        strokeStyle: ShapePath.DashLine
        dashPattern: [ 1, 4 ]
        vertices: path
        strokeColor: "red"
        opacity: .5
    }

    Component.onDestruction: {
        spawnTimer.stop()
        for (let i=0; i<_spawned.length; ++i) {
            let ent = _spawned[i];
            if (typeof ent !== 'undefined' &&
                    ent.hasOwnProperty("destroy"))
                ent.destroy();
        }
        _spawned = [];
    }
}
