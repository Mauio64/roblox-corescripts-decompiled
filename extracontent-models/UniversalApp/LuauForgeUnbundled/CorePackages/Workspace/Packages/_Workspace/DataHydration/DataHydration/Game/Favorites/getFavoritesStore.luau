local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createFavoritesStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Favorites/createFavoritesStore")

return Signals.createComputed(createFavoritesStore)
