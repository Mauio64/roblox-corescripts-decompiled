local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/Signals")

local createLayeredClothingLastSavedSortStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Stores/LayeredClothingLastSavedSortStore/createLayeredClothingLastSavedSortStore")

return Signals.createComputed(createLayeredClothingLastSavedSortStore)
