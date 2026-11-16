local ExpChat = script:FindFirstAncestor("ExpChat")
local MessageEffect = require(script.Parent.MessageEffect)

local FIntExpChatMessageEffectChatWindowEnlargeTextSize = require(ExpChat.Flags.FIntExpChatMessageEffectChatWindowEnlargeTextSize)

local function getChatWindowMessageLineHeight(list, p: number, p2: number)
	if list and table.find(list, MessageEffect.ChatWindowEnlarge) then
		return (math.clamp(FIntExpChatMessageEffectChatWindowEnlargeTextSize / math.min(p, p2), 1, 3))
	end

	return 1
end

return getChatWindowMessageLineHeight
