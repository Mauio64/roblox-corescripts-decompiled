local ExpChat = script:FindFirstAncestor("ExpChat")

local getMessageText = require(ExpChat.ChatWindow.Helpers.getMessageText)

local getFFlagChatTranslationUIEnabledBubbleChat = require(ExpChat.Flags.getFFlagChatTranslationUIEnabledBubbleChat)

local applyBubbleChatMessagePropertiesText = require(script.Parent.applyBubbleChatMessagePropertiesText)

local function getBubbleChatDisplayText(data)
	local v, v2 = applyBubbleChatMessagePropertiesText(data.text, data.translation, data.bubbleChatMessageProperties)
	return getMessageText(getFFlagChatTranslationUIEnabledBubbleChat() and data.useTranslation, v2, v)
end

return getBubbleChatDisplayText
