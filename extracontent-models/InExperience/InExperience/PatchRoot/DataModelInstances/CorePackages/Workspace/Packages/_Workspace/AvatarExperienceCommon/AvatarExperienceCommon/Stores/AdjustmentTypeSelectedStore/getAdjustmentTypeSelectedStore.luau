local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local Signals = require(parent.Signals)

local createAdjustmentTypeSelectedStore = require(AvatarExperienceCommon.Stores.AdjustmentTypeSelectedStore.createAdjustmentTypeSelectedStore)

return Signals.createComputed(createAdjustmentTypeSelectedStore)
