local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local ExpChatSharedParent = ExpChatShared.Parent
local Rodux = require(ExpChatSharedParent.Rodux)
local Dictionary = require(ExpChatSharedParent.llama).Dictionary
local Commands = ExpChatShared.Commands
local RBXWhisperCommand = require(Commands.Whisper.RBXWhisperCommand)
local RBXTeamCommand = require(Commands.RBXTeamCommand)
local Actions = ExpChatShared.Actions
local CommandAliasChanged = require(Actions.CommandAliasChanged)
local t1 = {
	RBXWhisperCommand = {
		primaryAlias = RBXWhisperCommand.alias[1],
		secondaryAlias = RBXWhisperCommand.alias[2]
	},
	RBXTeamCommand = {
		primaryAlias = RBXTeamCommand.alias[1],
		secondaryAlias = RBXTeamCommand.alias[2]
	}
}

return Rodux.createReducer(t1, {
	[CommandAliasChanged.name] = function(p1, p2) -- line: 25
		-- upvalues: Dictionary (copy)
		return Dictionary.join(p1, {
			[p2.name] = {
				primaryAlias = p2.primaryAlias,
				secondaryAlias = p2.secondaryAlias
			}
		})
	end
})
