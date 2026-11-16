local AvatarExperienceModel = script:FindFirstAncestor("AvatarExperienceModel")
local parent = AvatarExperienceModel.Parent

local Signals = require(parent.Signals)

local createLayeredClothingLastSavedSortStore = require(AvatarExperienceModel.Stores.LayeredClothingLastSavedSortStore.createLayeredClothingLastSavedSortStore)

return Signals.createComputed(createLayeredClothingLastSavedSortStore)
