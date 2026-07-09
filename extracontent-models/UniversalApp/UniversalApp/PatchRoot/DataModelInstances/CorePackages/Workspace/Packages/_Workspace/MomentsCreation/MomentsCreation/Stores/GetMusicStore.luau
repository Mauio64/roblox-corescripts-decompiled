local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Signals = require(MomentsCreationParent.Signals)
local createMusicStore = require(MomentsCreation.Stores.createMusicStore)

return Signals.createComputed(function() -- line: 15
	-- upvalues: createMusicStore (copy)
	return createMusicStore()
end)
