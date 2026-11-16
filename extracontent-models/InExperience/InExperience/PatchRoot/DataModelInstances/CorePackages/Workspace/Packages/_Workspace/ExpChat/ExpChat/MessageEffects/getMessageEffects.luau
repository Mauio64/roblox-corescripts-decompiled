local MessageEffect = require(script.Parent.MessageEffect)
local isSingleSupportedEmoji = require(script.Parent.isSingleSupportedEmoji)

local function getMessageEffects(p: string)
	local messageEffects = {}

	if isSingleSupportedEmoji(p) then
		table.insert(messageEffects, MessageEffect.BorderlessBubbleChat)
		table.insert(messageEffects, MessageEffect.ChatWindowEnlarge)
	end

	return messageEffects
end

return getMessageEffects
