local RBXConsoleCommand = require(script.RBXConsoleCommand)
local RBXHelpCommand = require(script.RBXHelpCommand)
local RBXMuteCommand = require(script.RBXMuteCommand)
local RBXUnmuteCommand = require(script.RBXUnmuteCommand)
local RBXVersionCommand = require(script.RBXVersionCommand)
local RBXEmoteCommand = require(script.RBXEmoteCommand)
local RBXTeamCommand = require(script.RBXTeamCommand)
local RBXWhisperCommand = require(script.Whisper).RBXWhisperCommand
local RBXClearCommand = require(script.RBXClearCommand)
local RBXOnlineCommand = require(script.RBXOnlineCommand)
local EngineFeature = game:GetEngineFeature("ExpChatLocalUserCountEnabled")
local v12 = game:DefineFastFlag("ExpChatEnableVirtualLocalOnlineCommand", false)

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
	getVirtualLocalEnabledCommands = function() -- line: 33
		-- upvalues: EngineFeature (copy), v12 (copy), RBXOnlineCommand (copy)
		local t1 = {}

		if EngineFeature and v12 then
			table.insert(t1, RBXOnlineCommand)
		end

		return t1
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
