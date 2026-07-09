local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local ExpChatSharedParent = ExpChatShared.Parent
local Rodux = require(ExpChatSharedParent.Rodux)
local ClientAppLoaded = require(ExpChatShared.Actions.ClientAppLoaded)
local LocalTeamChanged = require(ExpChatShared.Actions.LocalTeamChanged)

return Rodux.createReducer(nil, {
	[LocalTeamChanged.name] = function(_, p2) -- line: 9
		return p2.team
	end,
	[ClientAppLoaded.name] = function(_, p4) -- line: 13
		return p4.team
	end
})
