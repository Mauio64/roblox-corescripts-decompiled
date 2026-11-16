local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/Rodux")

local ClientAppLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/ClientAppLoaded")
local LocalTeamChanged = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/LocalTeamChanged")

return Rodux.createReducer(nil, {
	[LocalTeamChanged.name] = function(p2, p3)
		return p3.team
	end,
	[ClientAppLoaded.name] = function(p2, p3)
		return p3.team
	end
})
