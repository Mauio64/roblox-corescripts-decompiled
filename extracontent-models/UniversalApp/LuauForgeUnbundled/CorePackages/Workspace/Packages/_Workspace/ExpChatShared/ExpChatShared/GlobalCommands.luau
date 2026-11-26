local module = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/GlobalCommands/GlobalHelpCommand")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/GlobalCommands/GlobalClearCommand")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/GlobalCommands/GlobalMuteCommand")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/GlobalCommands/GlobalUnmuteCommand")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/GlobalCommands/GlobalOnlineCommand")

local engineFeature = game:GetEngineFeature("ExpChatGlobalUserCountEnabled")
local defineFastFlag = game:DefineFastFlag("ExpChatEnableGlobalOnlineCommand", false)

require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/GlobalCommands/types")

return {
	getGlobalEnabledCommands = function()
		local globalEnabledCommands = {}

		table.insert(globalEnabledCommands, module2)
		table.insert(globalEnabledCommands, module)
		table.insert(globalEnabledCommands, module3)
		table.insert(globalEnabledCommands, module4)

		if engineFeature and defineFastFlag then
			table.insert(globalEnabledCommands, module5)
		end

		return globalEnabledCommands
	end,
	GlobalHelpCommand = module,
	GlobalClearCommand = module2,
	GlobalMuteCommand = module3,
	GlobalUnmuteCommand = module4,
	GlobalOnlineCommand = module5
}
