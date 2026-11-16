local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local parent = ExpChatShared.Parent
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local Commands = ExpChatShared.Commands
local RBXWhisperCommand = require(Commands.Whisper.RBXWhisperCommand)
local RBXTeamCommand = require(Commands.RBXTeamCommand)

local Actions = ExpChatShared.Actions
local CommandAliasChanged = require(Actions.CommandAliasChanged)

local v = {
	RBXWhisperCommand = {
		primaryAlias = RBXWhisperCommand.alias[1],
		secondaryAlias = RBXWhisperCommand.alias[2]
	},
	RBXTeamCommand = {
		primaryAlias = RBXTeamCommand.alias[1],
		secondaryAlias = RBXTeamCommand.alias[2]
	}
}

return Rodux.createReducer(v, {
	[CommandAliasChanged.name] = function(p, data)
		return dictionary.join(p, {
			[data.name] = { primaryAlias = data.primaryAlias, secondaryAlias = data.secondaryAlias }
		})
	end
})
