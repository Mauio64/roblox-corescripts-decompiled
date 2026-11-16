local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/Rodux")
local dictionary = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/llama").Dictionary

local PlayerAdded = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/PlayerAdded")
local PlayerRemoved = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/PlayerRemoved")

return Rodux.createReducer({}, {
	[PlayerAdded.name] = function(p2, p3)
		local username = string.lower(p3.username)
		return dictionary.join(p2, { [username] = p3.userId })
	end,
	[PlayerRemoved.name] = function(p2, p3)
		return dictionary.filter(p2, function(p4): boolean
			return p4 ~= p3.userId
		end)
	end
})
