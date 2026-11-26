local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Signals")

local createStaleInventoryGrantStore = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Stores/createStaleInventoryGrantStore")

return Signals.createComputed(createStaleInventoryGrantStore)
