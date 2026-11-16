local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local Signals = require(parent.Signals)

local createApplyingLayeredClothingStore = require(AvatarExperienceCommon.Stores.ApplyingLayeredClothingStore.createApplyingLayeredClothingStore)

return Signals.createComputed(createApplyingLayeredClothingStore)
