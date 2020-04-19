// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file
import QtQuick 2.12
import Clayground.Physics 1.0
import Clayground.ScalingCanvas 1.0
import QtQuick.Shapes 1.14
import Box2D 2.0

Item {
    property var path: []
    property var _waypoints: []

    Component.onCompleted: {
        let lenWuH = 1.0;
        for (let i=1; i<path.length; ++i) {
            let p = path[i];
            let ent = theWayPointComp.createObject(theWorld.coordSys,
                                                  {
                                                      world: theWorld.physics,
                                                      pixelPerUnit: theWorld.pixelPerUnit,
                                                      xWu: p.x - lenWuH,
                                                      yWu: p.y + lenWuH,
                                                      widthWu: 2*lenWuH,
                                                      heightWu: 2*lenWuH
                                                  });
            _waypoints.push(ent);
            theWorld.entities.push(ent);
        }
    }

    Component {
        id: theWayPointComp
        PhysicsItem {
            id: thePhyItem

            fixtures: [
                Box {
                    sensor: true
                    width: thePhyItem.width
                    height: thePhyItem.height
                    categories: collCat.waypoint
                    collidesWith: collCat.enemy
                }
            ]

        }
    }

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
