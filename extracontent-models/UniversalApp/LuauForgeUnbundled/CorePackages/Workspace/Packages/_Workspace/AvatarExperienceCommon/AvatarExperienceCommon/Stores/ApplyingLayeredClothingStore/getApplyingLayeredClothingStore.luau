local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Signals")

local createApplyingLayeredClothingStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/ApplyingLayeredClothingStore/createApplyingLayeredClothingStore")

return Signals.createComputed(createApplyingLayeredClothingStore)
