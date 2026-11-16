local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent

local Signals = require(parent.Signals)

local createStaleInventoryGrantStore = require(script.Parent.createStaleInventoryGrantStore)

return Signals.createComputed(createStaleInventoryGrantStore)
