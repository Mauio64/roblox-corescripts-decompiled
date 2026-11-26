local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/Signals")

local createLayeredClothingEntryPageStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Stores/LayeredClothingEntryPageStore/createLayeredClothingEntryPageStore")

return Signals.createComputed(createLayeredClothingEntryPageStore)
