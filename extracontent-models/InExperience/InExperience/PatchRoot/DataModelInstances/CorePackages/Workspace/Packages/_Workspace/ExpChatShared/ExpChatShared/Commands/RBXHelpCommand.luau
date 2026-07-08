require(script.Parent.types)

local EngineFeature = game:GetEngineFeature("ExpChatLocalUserCountEnabled")
local v2 = game:DefineFastFlag("ExpChatEnableVirtualLocalOnlineCommand", false)

return {
	name = script.Name,
	alias = {
		"/help",
		"/?"
	},
	clientRun = function() -- line: 9
		-- upvalues: EngineFeature (copy), v2 (copy)
		if EngineFeature and v2 then
			return {
				metadata = "Roblox.Help.Info",
				args = nil,
				key = {
					"CoreScripts.TextChat.Help.FirstLine",
					"CoreScripts.TextChat.Clear.Help.Description",
					"InGame.UnknownNamespace.GameChat_ChatCommandsTeller_MuteCommand",
					"CoreScripts.TextChat.Online.Help.Description3",
					"InGame.UnknownNamespace.GameChat_ChatCommandsTeller_TeamCommand",
					"InGame.UnknownNamespace.GameChat_ChatCommandsTeller_UnMuteCommand",
					"InGame.UnknownNamespace.GameChat_ChatCommandsTeller_WhisperCommand"
				}
			}
		end

		return {
			metadata = "Roblox.Help.Info",
			args = nil,
			key = {
				"CoreScripts.TextChat.Help.FirstLine",
				"InGame.UnknownNamespace.GameChat_ChatCommandsTeller_WhisperCommand",
				"InGame.UnknownNamespace.GameChat_ChatCommandsTeller_TeamCommand",
				"InGame.UnknownNamespace.GameChat_ChatCommandsTeller_MuteCommand",
				"InGame.UnknownNamespace.GameChat_ChatCommandsTeller_UnMuteCommand",
				"CoreScripts.TextChat.Clear.Help.Description"
			}
		}
	end
}
