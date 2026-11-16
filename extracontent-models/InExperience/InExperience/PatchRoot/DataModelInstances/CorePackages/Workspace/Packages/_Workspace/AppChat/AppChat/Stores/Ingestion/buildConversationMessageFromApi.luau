local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(parent.AppChatNetworking)
local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableSocialCards = SharedFlags.GetFFlagEnableSocialCards

require(AppChat.MessageData.Types)

local function buildConversationMessageFromApi(data, conversationId: string)
	local conversationMessageFromApi = {
		id = data.id,
		type = data.type,
		content = data.content,
		created_at = data.created_at,
		sender_user_id = data.sender_user_id,
		moderation_type = data.moderation_type,
		visibility = data.visibility,
		preview_content = data.preview_content,
		content_to_display = data.content_to_display or data.content,
		replies_to = data.replies_to,
		cards = 0,
		filtered_for_receivers = 0,
		is_previewable = 0,
		conversationId = 0,
		stableKey = 0
	}
	local cards

	if GetFFlagEnableSocialCards() then
		cards = data.cards
	end

	conversationMessageFromApi.cards = cards
	conversationMessageFromApi.filtered_for_receivers = data.filtered_for_receivers
	conversationMessageFromApi.is_previewable = data.is_previewable

	conversationMessageFromApi.conversationId = conversationId
	conversationMessageFromApi.stableKey = data.id
	return conversationMessageFromApi
end

return buildConversationMessageFromApi
