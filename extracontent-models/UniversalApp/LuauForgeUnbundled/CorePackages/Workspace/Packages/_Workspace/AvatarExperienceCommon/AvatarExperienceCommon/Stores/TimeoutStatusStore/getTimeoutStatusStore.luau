local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Signals")

local createTimeoutStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/TimeoutStatusStore/createTimeoutStatusStore")

return Signals.createComputed(createTimeoutStatusStore)
