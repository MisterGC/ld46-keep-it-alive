// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file
import QtQuick 2.12

Item {
    property var gardens: []
    property var player: undefined
    property real gardenPercentage: 100.0
    property int maxEnergyGarden: 0

    property int seasonLength: 100
    property int timeElapsed: 0
    property real seasonPercentage: Math.round(timeElapsed / seasonLength)

    signal playerDied()
    signal gardenDied()
    signal seasonEnded()

    Timer {
        id: theGameTime
        interval: 50000
        Component.onCompleted: start()
        onTriggered: seasonEnded()
    }

    onGardenPercentageChanged: {
        if (gardenPercentage <= 0) gardenDied()
    }

    function addGarden(garden) {
        gardens.push(garden);
        garden.energyChanged.connect(_onGardenEnergyChanged);
        maxEnergyGarden += garden.maxEnergy;
    }

    function _onGardenEnergyChanged() {
        let energy = 0;
        for (const g of gardens)
            energy += g.energy;
        gardenPercentage = Math.round((energy/maxEnergyGarden) * 100.0);
    }

    onPlayerChanged: {
        if (player)
            player.energyChanged.connect(_onPlayerEnergyChanged);
    }

    function _onPlayerEnergyChanged() {
        if (player.energy <= 0)
            playerDied();
    }

}
