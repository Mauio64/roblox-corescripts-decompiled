local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local Signals = require(parent.Signals)

local createEquippedAvatarOutfitIdStore = require(AvatarExperienceCommon.Stores.EquippedAvatarOutfitIdStore.createEquippedAvatarOutfitIdStore)

return Signals.createComputed(createEquippedAvatarOutfitIdStore)
