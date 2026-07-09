local GlobalHelpCommand = require(script.GlobalHelpCommand)
local GlobalClearCommand = require(script.GlobalClearCommand)
local GlobalMuteCommand = require(script.GlobalMuteCommand)
local GlobalUnmuteCommand = require(script.GlobalUnmuteCommand)
local GlobalOnlineCommand = require(script.GlobalOnlineCommand)
local EngineFeature = game:GetEngineFeature("ExpChatGlobalUserCountEnabled")
local v7 = game:DefineFastFlag("ExpChatEnableGlobalOnlineCommand", false)

require(script.types)

return {
	getGlobalEnabledCommands = function() -- line: 13
		-- upvalues: GlobalClearCommand (copy), GlobalHelpCommand (copy), GlobalMuteCommand (copy), GlobalUnmuteCommand (copy), EngineFeature (copy), v7 (copy), GlobalOnlineCommand (copy)
		local t1 = {}

		table.insert(t1, GlobalClearCommand)
		table.insert(t1, GlobalHelpCommand)
		table.insert(t1, GlobalMuteCommand)
		table.insert(t1, GlobalUnmuteCommand)

		if EngineFeature and v7 then
			table.insert(t1, GlobalOnlineCommand)
		end

		return t1
	end,
	GlobalHelpCommand = GlobalHelpCommand,
	GlobalClearCommand = GlobalClearCommand,
	GlobalMuteCommand = GlobalMuteCommand,
	GlobalUnmuteCommand = GlobalUnmuteCommand,
	GlobalOnlineCommand = GlobalOnlineCommand
}
