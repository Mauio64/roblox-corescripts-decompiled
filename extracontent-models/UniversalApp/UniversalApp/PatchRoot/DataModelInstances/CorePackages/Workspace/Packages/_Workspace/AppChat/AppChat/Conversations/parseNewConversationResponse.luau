local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Promise = require(AppChatParent.Promise)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local EventNames = require(AppChat.Analytics.EventNames)
local CreateConversationError = require(AppChat.Analytics.Enums.CreateConversationError)

return function(p1, p2, s1: string?) -- line: 18
	-- upvalues: Promise (copy), ConversationChannels (copy), CreateConversationError (copy), EventNames (copy)
	if not p1 then
		return Promise.reject("No conversation returned.")
	end

	if p1.status == "failed" then
		return Promise.reject("Failed to create conversation.")
	end

	local v10 = ConversationChannels.fromChannelsApi(p1)

	if p2 then
		local v11 = if v10 then p1.status else CreateConversationError.InvalidResponse

		p2.fireAnalyticsEvent(EventNames.NewConversationCreated, {
			conversationId = v10.id,
			createConversationResult = v11,
			participantsCount = #v10.participants,
			createdReason = s1 or "unknown"
		})
	end

	return v10
end
