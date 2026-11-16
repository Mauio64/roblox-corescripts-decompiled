local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(
	script.Name,
	function(textChatMessage, channelNameOverride: string?, isUniverseChat: boolean?)
		return {
			textChatMessage = textChatMessage,
			channelNameOverride = channelNameOverride,
			isUniverseChat = isUniverseChat
		}
	end
)
