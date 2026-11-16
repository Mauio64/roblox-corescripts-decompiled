local AvatarWorkshop = script:FindFirstAncestor("AvatarWorkshop")
local parent = AvatarWorkshop.Parent

local Signals = require(parent.Signals)

local createUiStateStore = require(AvatarWorkshop.Stores.Creators.createUiStateStore)

return Signals.createComputed(createUiStateStore)
