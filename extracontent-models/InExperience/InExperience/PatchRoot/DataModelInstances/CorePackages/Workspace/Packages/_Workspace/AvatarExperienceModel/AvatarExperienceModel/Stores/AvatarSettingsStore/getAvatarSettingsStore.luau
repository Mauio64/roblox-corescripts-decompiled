local AvatarExperienceModel = script:FindFirstAncestor("AvatarExperienceModel")
local parent = AvatarExperienceModel.Parent

local Signals = require(parent.Signals)

local createAvatarSettingsStore = require(AvatarExperienceModel.Stores.AvatarSettingsStore.createAvatarSettingsStore)

return Signals.createComputed(createAvatarSettingsStore)
