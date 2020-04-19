// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file
import QtQuick 2.12
import Clayground.Physics 1.0
import Box2D 2.0

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
