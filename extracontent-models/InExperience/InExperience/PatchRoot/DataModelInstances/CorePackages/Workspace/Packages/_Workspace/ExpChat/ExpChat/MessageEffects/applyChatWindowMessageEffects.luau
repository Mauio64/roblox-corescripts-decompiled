local ExpChat = script:FindFirstAncestor("ExpChat")

local MessageEffect = require(script.Parent.MessageEffect)

local FIntExpChatMessageEffectChatWindowEnlargeTextSize = require(ExpChat.Flags.FIntExpChatMessageEffectChatWindowEnlargeTextSize)

local function applyChatWindowMessageEffects(p: string, list)
	if list and table.find(list, MessageEffect.ChatWindowEnlarge) then
		return `<font size='{FIntExpChatMessageEffectChatWindowEnlargeTextSize}'>{p}</font>`
	end

	return p
end

return applyChatWindowMessageEffects
