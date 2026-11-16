local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/Rodux")
local dictionary = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/llama").Dictionary

local PlayerAdded = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/PlayerAdded")
local PlayerRemoved = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/PlayerRemoved")

return Rodux.createReducer({}, {
	[PlayerAdded.name] = function(p2, data)
		return dictionary.join(p2, {
			[data.userId] = {
				userId = data.userId,
				username = data.username,
				displayName = data.displayName
			}
		})
	end,
	[PlayerRemoved.name] = function(p2, p3)
		return dictionary.removeKey(p2, p3.userId)
	end
})
