local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(
	script.Name,
	function(textChatMessage, isSenderLocalPlayer: boolean, channelNameOverride: string?, isUniverseChat: boolean?)
		return {
			textChatMessage = textChatMessage,
			isSenderLocalPlayer = isSenderLocalPlayer,
			channelNameOverride = channelNameOverride,
			isUniverseChat = isUniverseChat
		}
	end
)
