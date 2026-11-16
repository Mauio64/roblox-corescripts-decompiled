local GlobalHelpCommand = require(script.GlobalHelpCommand)
local GlobalClearCommand = require(script.GlobalClearCommand)
local GlobalMuteCommand = require(script.GlobalMuteCommand)
local GlobalUnmuteCommand = require(script.GlobalUnmuteCommand)
local GlobalOnlineCommand = require(script.GlobalOnlineCommand)

local engineFeature = game:GetEngineFeature("ExpChatGlobalUserCountEnabled")
local defineFastFlag = game:DefineFastFlag("ExpChatEnableGlobalOnlineCommand", false)

require(script.types)

return {
	getGlobalEnabledCommands = function()
		local globalEnabledCommands = {}

		table.insert(globalEnabledCommands, GlobalClearCommand)
		table.insert(globalEnabledCommands, GlobalHelpCommand)
		table.insert(globalEnabledCommands, GlobalMuteCommand)
		table.insert(globalEnabledCommands, GlobalUnmuteCommand)

		if engineFeature and defineFastFlag then
			table.insert(globalEnabledCommands, GlobalOnlineCommand)
		end

		return globalEnabledCommands
	end,
	GlobalHelpCommand = GlobalHelpCommand,
	GlobalClearCommand = GlobalClearCommand,
	GlobalMuteCommand = GlobalMuteCommand,
	GlobalUnmuteCommand = GlobalUnmuteCommand,
	GlobalOnlineCommand = GlobalOnlineCommand
}
