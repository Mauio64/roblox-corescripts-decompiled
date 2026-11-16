local RBXConsoleCommand = require(script.RBXConsoleCommand)
local RBXHelpCommand = require(script.RBXHelpCommand)
local RBXMuteCommand = require(script.RBXMuteCommand)
local RBXUnmuteCommand = require(script.RBXUnmuteCommand)
local RBXVersionCommand = require(script.RBXVersionCommand)
local RBXEmoteCommand = require(script.RBXEmoteCommand)
local RBXTeamCommand = require(script.RBXTeamCommand)
local Whisper = require(script.Whisper)
local RBXWhisperCommand = Whisper.RBXWhisperCommand
local RBXClearCommand = require(script.RBXClearCommand)
local RBXOnlineCommand = require(script.RBXOnlineCommand)

local engineFeature = game:GetEngineFeature("ExpChatLocalUserCountEnabled")
local defineFastFlag = game:DefineFastFlag("ExpChatEnableVirtualLocalOnlineCommand", false)

require(script.types)

return {
	enabledCommands = {
		RBXConsoleCommand,
		RBXHelpCommand,
		RBXMuteCommand,
		RBXUnmuteCommand,
		RBXVersionCommand,
		RBXEmoteCommand,
		RBXTeamCommand,
		RBXWhisperCommand,
		RBXClearCommand
	},
	getVirtualLocalEnabledCommands = function()
		local RBXOnlineCommands = {}

		if engineFeature and defineFastFlag then
			table.insert(RBXOnlineCommands, RBXOnlineCommand)
		end

		return RBXOnlineCommands
	end,
	autoCastCommand = require(script.autoCastCommand),
	RBXClearCommand = RBXClearCommand,
	RBXConsoleCommand = RBXConsoleCommand,
	RBXEmoteCommand = RBXEmoteCommand,
	RBXHelpCommand = RBXHelpCommand,
	RBXMuteCommand = RBXMuteCommand,
	RBXTeamCommand = RBXTeamCommand,
	RBXUnmuteCommand = RBXUnmuteCommand,
	RBXVersionCommand = RBXVersionCommand,
	Whisper = require(script.Whisper)
}
