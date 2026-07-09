local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChatParent.AppChatNetworking)

local GetFFlagEnableSocialCards = require(AppChatParent.SharedFlags).GetFFlagEnableSocialCards

require(AppChat.MessageData.Types)

local function buildConversationMessageFromApi(p1, s1: string) -- line: 22
	-- upvalues: GetFFlagEnableSocialCards (copy)
	return {
		id = p1.id,
		type = p1.type,
		content = p1.content,
		created_at = p1.created_at,
		sender_user_id = p1.sender_user_id,
		moderation_type = p1.moderation_type,
		visibility = p1.visibility,
		preview_content = p1.preview_content,
		content_to_display = p1.content_to_display or p1.content,
		replies_to = p1.replies_to,
		cards = if not GetFFlagEnableSocialCards() then nil else p1.cards,
		filtered_for_receivers = p1.filtered_for_receivers,
		conversationId = s1,
		stableKey = p1.id
	}
end

return buildConversationMessageFromApi
