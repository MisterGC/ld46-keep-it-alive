// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick 2.12
import Box2D 2.0
import Clayground.Physics 1.0

VisualizedBoxBody
{
    bodyType: Body.Static
    color: "#7084aa"
    categories: collCat.staticGeo
    collidesWith: collCat.player
}
