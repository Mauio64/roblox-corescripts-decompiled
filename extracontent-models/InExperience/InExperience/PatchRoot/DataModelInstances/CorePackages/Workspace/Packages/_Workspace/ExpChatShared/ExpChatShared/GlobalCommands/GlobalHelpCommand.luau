require(script.Parent.types)

local v1 = game:DefineFastFlag("ExpChatEnableGlobalOnlineCommand", false)
local EngineFeature = game:GetEngineFeature("ExpChatGlobalUserCountEnabled")

return {
	name = script.Name,
	alias = { "/help" },
	clientRun = function() -- line: 9
		-- upvalues: EngineFeature (copy), v1 (copy)
		if EngineFeature and v1 then
			return {
				metadata = "Roblox.GlobalHelp.Info",
				args = nil,
				key = {
					"CoreScripts.TextChat.Help.FirstLine",
					"CoreScripts.TextChat.Clear.Help.Description",
					"CoreScripts.TextChat.ChatCommands.Mute.Description",
					"CoreScripts.TextChat.Online.Help.Description3",
					"CoreScripts.TextChat.ChatCommands.Unmute.Description"
				}
			}
		end

		return {
			metadata = "Roblox.GlobalHelp.Info",
			args = nil,
			key = {
				"CoreScripts.TextChat.Help.FirstLine",
				"CoreScripts.TextChat.ChatCommands.Mute.Description",
				"CoreScripts.TextChat.ChatCommands.Unmute.Description",
				"CoreScripts.TextChat.Clear.Help.Description"
			}
		}
	end
}
