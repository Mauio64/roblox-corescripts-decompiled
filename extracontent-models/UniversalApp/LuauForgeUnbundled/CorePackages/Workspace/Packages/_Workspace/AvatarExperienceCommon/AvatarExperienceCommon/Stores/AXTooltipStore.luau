local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Signals")

local createAXTooltipStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/AXTooltipStore/createAXTooltipStore")

return Signals.createComputed(createAXTooltipStore)
