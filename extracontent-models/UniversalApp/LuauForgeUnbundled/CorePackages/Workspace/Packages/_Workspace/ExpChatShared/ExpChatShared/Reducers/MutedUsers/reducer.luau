local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/Rodux")
local set = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/llama").Set

local UserMuted = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/UserMuted")
local UserUnmuted = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/UserUnmuted")

return Rodux.createReducer({}, {
	[UserMuted.name] = function(p2, p3)
		return set.add(p2, p3.userId)
	end,
	[UserUnmuted.name] = function(p2, p3)
		return set.subtract(p2, p3.userId)
	end
})
