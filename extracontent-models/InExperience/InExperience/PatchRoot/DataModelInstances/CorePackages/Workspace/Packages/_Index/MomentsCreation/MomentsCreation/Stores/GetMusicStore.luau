local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Signals = require(parent.Signals)

local createMusicStore = require(MomentsCreation.Stores.createMusicStore)

return Signals.createComputed(function()
	return createMusicStore()
end)
