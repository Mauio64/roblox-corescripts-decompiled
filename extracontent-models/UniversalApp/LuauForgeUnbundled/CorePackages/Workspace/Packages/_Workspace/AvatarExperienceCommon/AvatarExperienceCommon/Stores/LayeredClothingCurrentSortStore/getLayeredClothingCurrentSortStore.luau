local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Signals")

local createLayeredClothingCurrentSortStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/LayeredClothingCurrentSortStore/createLayeredClothingCurrentSortStore")

return Signals.createComputed(createLayeredClothingCurrentSortStore)
