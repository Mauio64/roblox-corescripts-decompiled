local ExpChat = script:FindFirstAncestor("ExpChat")
local MessageEffect = require(ExpChat.MessageEffects.MessageEffect)
local getMessageEffects = require(ExpChat.MessageEffects.getMessageEffects)

local getBubbleChatDisplayText = require(script.Parent.getBubbleChatDisplayText)

local function isBorderlessBubbleChatMessage(p): boolean
	local messageEffects = getMessageEffects(getBubbleChatDisplayText(p))
	return table.find(messageEffects, MessageEffect.BorderlessBubbleChat) ~= nil
end

return isBorderlessBubbleChatMessage
