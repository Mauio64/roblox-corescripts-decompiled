local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local parent = ExpChatShared.Parent
local Rodux = require(parent.Rodux)

local ClientAppLoaded = require(ExpChatShared.Actions.ClientAppLoaded)
local LocalTeamChanged = require(ExpChatShared.Actions.LocalTeamChanged)

return Rodux.createReducer(nil, {
	[LocalTeamChanged.name] = function(_, p)
		return p.team
	end,
	[ClientAppLoaded.name] = function(_, p)
		return p.team
	end
})
