local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Signals")

local createMainCollectionLayoutStore = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionLayoutStore/createMainCollectionLayoutStore")

return Signals.createComputed(createMainCollectionLayoutStore)
