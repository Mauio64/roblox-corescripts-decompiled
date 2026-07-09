local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local Signals = require(Parent.Signals)
local createStaleInventoryGrantStore = require(script.Parent.createStaleInventoryGrantStore)

return Signals.createComputed(createStaleInventoryGrantStore)
