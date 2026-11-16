local ExpChat = script:FindFirstAncestor("ExpChat")

local MessageEffect = require(script.Parent.MessageEffect)

local FIntExpChatMessageEffectChatWindowEnlargeTextSize = require(ExpChat.Flags.FIntExpChatMessageEffectChatWindowEnlargeTextSize)

local function getChatWindowPrefixOffset(list, p: number)
	if list and table.find(list, MessageEffect.ChatWindowEnlarge) then
		return (math.max(0, (math.round(FIntExpChatMessageEffectChatWindowEnlargeTextSize * 0.44 - p / 2))))
	end

	return 0
end

return getChatWindowPrefixOffset
