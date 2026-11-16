require(script.Parent.types)

local defineFastFlag = game:DefineFastFlag("ExpChatEnableGlobalOnlineCommand", false)
local engineFeature = game:GetEngineFeature("ExpChatGlobalUserCountEnabled")

return {
	name = script.Name,
	alias = { "/help" },
	clientRun = function()
		if engineFeature and defineFastFlag then
			return {
				key = {
					"CoreScripts.TextChat.Help.FirstLine",
					"CoreScripts.TextChat.Clear.Help.Description",
					"CoreScripts.TextChat.ChatCommands.Mute.Description",
					"CoreScripts.TextChat.Online.Help.Description3",
					"CoreScripts.TextChat.ChatCommands.Unmute.Description"
				},
				metadata = "Roblox.GlobalHelp.Info",
				args = nil
			}
		end

		return {
			key = {
				"CoreScripts.TextChat.Help.FirstLine",
				"CoreScripts.TextChat.ChatCommands.Mute.Description",
				"CoreScripts.TextChat.ChatCommands.Unmute.Description",
				"CoreScripts.TextChat.Clear.Help.Description"
			},
			metadata = "Roblox.GlobalHelp.Info",
			args = nil
		}
	end
}
