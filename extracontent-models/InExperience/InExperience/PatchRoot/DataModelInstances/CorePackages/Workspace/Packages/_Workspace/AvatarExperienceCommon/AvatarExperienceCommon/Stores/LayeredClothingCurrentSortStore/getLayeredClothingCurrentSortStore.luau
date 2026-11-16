local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local Signals = require(parent.Signals)

local createLayeredClothingCurrentSortStore = require(AvatarExperienceCommon.Stores.LayeredClothingCurrentSortStore.createLayeredClothingCurrentSortStore)

return Signals.createComputed(createLayeredClothingCurrentSortStore)
