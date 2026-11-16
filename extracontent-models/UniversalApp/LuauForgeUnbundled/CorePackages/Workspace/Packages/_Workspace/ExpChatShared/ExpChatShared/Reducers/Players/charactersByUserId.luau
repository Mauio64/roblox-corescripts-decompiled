local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/Rodux")
local dictionary = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/llama").Dictionary

local CharacterAdded = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/CharacterAdded")
local PlayerRemoved = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/PlayerRemoved")

return Rodux.createReducer({}, {
	[CharacterAdded.name] = function(p2, p3)
		return dictionary.join(p2, { [p3.userId] = p3.character })
	end,
	[PlayerRemoved.name] = function(p2, p3)
		return dictionary.removeKey(p2, p3.userId)
	end
})
