local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Signals")

local createAdjustmentTypeSelectedStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/AdjustmentTypeSelectedStore/createAdjustmentTypeSelectedStore")

return Signals.createComputed(createAdjustmentTypeSelectedStore)
