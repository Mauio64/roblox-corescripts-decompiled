require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/types")

local engineFeature = game:GetEngineFeature("ExpChatLocalUserCountEnabled")
local defineFastFlag = game:DefineFastFlag("ExpChatEnableVirtualLocalOnlineCommand", false)

return {
	name = "RBXHelpCommand",
	alias = { "/help", "/?" },
	clientRun = function()
		if engineFeature and defineFastFlag then
			return {
				key = {
					"CoreScripts.TextChat.Help.FirstLine",
					"CoreScripts.TextChat.Clear.Help.Description",
					"InGame.UnknownNamespace.GameChat_ChatCommandsTeller_MuteCommand",
					"CoreScripts.TextChat.Online.Help.Description3",
					"InGame.UnknownNamespace.GameChat_ChatCommandsTeller_TeamCommand",
					"InGame.UnknownNamespace.GameChat_ChatCommandsTeller_UnMuteCommand",
					"InGame.UnknownNamespace.GameChat_ChatCommandsTeller_WhisperCommand"
				},
				metadata = "Roblox.Help.Info",
				args = nil
			}
		end

		return {
			key = {
				"CoreScripts.TextChat.Help.FirstLine",
				"InGame.UnknownNamespace.GameChat_ChatCommandsTeller_WhisperCommand",
				"InGame.UnknownNamespace.GameChat_ChatCommandsTeller_TeamCommand",
				"InGame.UnknownNamespace.GameChat_ChatCommandsTeller_MuteCommand",
				"InGame.UnknownNamespace.GameChat_ChatCommandsTeller_UnMuteCommand",
				"CoreScripts.TextChat.Clear.Help.Description"
			},
			metadata = "Roblox.Help.Info",
			args = nil
		}
	end
}
