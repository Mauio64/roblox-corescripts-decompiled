local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local Promise = require(parent.Promise)

local ConversationChannels = require(AppChat.Models.ConversationChannels)

local EventNames = require(AppChat.Analytics.EventNames)
local CreateConversationError = require(AppChat.Analytics.Enums.CreateConversationError)

return function(p, p2, value: string?)
	if not p then
		return Promise.reject("No conversation returned.")
	end

	if p.status == "failed" then
		return Promise.reject("Failed to create conversation.")
	end

	local v = ConversationChannels.fromChannelsApi(p)

	if not p2 then
		return v
	end

	local createConversationResult

	if v then
		createConversationResult = p.status
	else
		createConversationResult = CreateConversationError.InvalidResponse
	end

	p2.fireAnalyticsEvent(EventNames.NewConversationCreated, {
		conversationId = v.id,
		createConversationResult = createConversationResult,
		participantsCount = #v.participants,
		createdReason = value or "unknown"
	})

	return v
end
