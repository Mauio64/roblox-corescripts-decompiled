local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/Rodux")
local dictionary = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/llama").Dictionary

local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/Whisper/RBXWhisperCommand")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/RBXTeamCommand")

local CommandAliasChanged = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/CommandAliasChanged")

local v5 = {
	RBXWhisperCommand = {
		primaryAlias = module2.alias[1],
		secondaryAlias = module2.alias[2]
	},
	RBXTeamCommand = {
		primaryAlias = module3.alias[1],
		secondaryAlias = module3.alias[2]
	}
}

return Rodux.createReducer(v5, {
	[CommandAliasChanged.name] = function(p2, data)
		return dictionary.join(p2, {
			[data.name] = {
				primaryAlias = data.primaryAlias,
				secondaryAlias = data.secondaryAlias
			}
		})
	end
})
