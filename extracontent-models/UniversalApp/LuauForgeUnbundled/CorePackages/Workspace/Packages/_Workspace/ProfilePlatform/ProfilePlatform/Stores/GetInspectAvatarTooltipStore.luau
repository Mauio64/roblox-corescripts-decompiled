local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Signals")

local createInspectAvatarTooltipStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Stores/GetInspectAvatarTooltipStore/createInspectAvatarTooltipStore")

return Signals.createComputed(createInspectAvatarTooltipStore)
