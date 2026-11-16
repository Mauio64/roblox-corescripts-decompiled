local AvatarExperienceModel = script:FindFirstAncestor("AvatarExperienceModel")
local parent = AvatarExperienceModel.Parent

local Signals = require(parent.Signals)

local createLayeredClothingEntryPageStore = require(AvatarExperienceModel.Stores.LayeredClothingEntryPageStore.createLayeredClothingEntryPageStore)

return Signals.createComputed(createLayeredClothingEntryPageStore)
