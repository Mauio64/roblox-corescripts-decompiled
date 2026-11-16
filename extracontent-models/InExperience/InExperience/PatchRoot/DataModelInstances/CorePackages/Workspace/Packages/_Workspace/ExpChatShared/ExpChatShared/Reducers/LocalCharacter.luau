local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local parent = ExpChatShared.Parent
local Rodux = require(parent.Rodux)

local LocalCharacterLoaded = require(ExpChatShared.Actions.LocalCharacterLoaded)

return Rodux.createReducer(nil, {
	[LocalCharacterLoaded.name] = function(_, p)
		return p.character
	end
})
