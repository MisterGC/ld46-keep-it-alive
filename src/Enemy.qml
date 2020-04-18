// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick 2.12
import Box2D 2.0
import Clayground.Physics 1.0

VisualizedBoxBody
{
    id: theEnemy
    bodyType: Body.Dynamic
    bullet: true
    categories: Box.Category3
    collidesWith: Box.Category1 | Box.Category2
    property int energy: 10000
}
