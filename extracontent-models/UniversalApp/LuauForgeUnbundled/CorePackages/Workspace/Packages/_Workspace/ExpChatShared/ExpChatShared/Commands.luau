local module = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/RBXConsoleCommand")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/RBXHelpCommand")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/RBXMuteCommand")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/RBXUnmuteCommand")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/RBXVersionCommand")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/RBXEmoteCommand")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/RBXTeamCommand")
local rbxWhisperCommand = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/Whisper").RBXWhisperCommand
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/RBXClearCommand")
local RBXOnlineCommand = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/RBXOnlineCommand")

local engineFeature = game:GetEngineFeature("ExpChatLocalUserCountEnabled")
local defineFastFlag = game:DefineFastFlag("ExpChatEnableVirtualLocalOnlineCommand", false)

require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/types")

return {
	enabledCommands = {
		module,
		module2,
		module3,
		module4,
		module5,
		module6,
		module7,
		rbxWhisperCommand,
		module8
	},
	getVirtualLocalEnabledCommands = function()
		local virtualLocalEnabledCommands = {}

		if engineFeature and defineFastFlag then
			table.insert(virtualLocalEnabledCommands, RBXOnlineCommand)
		end

		return virtualLocalEnabledCommands
	end,
	autoCastCommand = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/autoCastCommand"),
	RBXClearCommand = module8,
	RBXConsoleCommand = module,
	RBXEmoteCommand = module6,
	RBXHelpCommand = module2,
	RBXMuteCommand = module3,
	RBXTeamCommand = module7,
	RBXUnmuteCommand = module4,
	RBXVersionCommand = module5,
	Whisper = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/Whisper")
}
