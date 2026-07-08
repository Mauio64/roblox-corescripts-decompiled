local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local ExpChatSharedParent = ExpChatShared.Parent
local Rodux = require(ExpChatSharedParent.Rodux)
local LocalCharacterLoaded = require(ExpChatShared.Actions.LocalCharacterLoaded)

return Rodux.createReducer(nil, {
	[LocalCharacterLoaded.name] = function(_, p2) -- line: 8
		return p2.character
	end
})
