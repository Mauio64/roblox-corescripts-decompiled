local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")

local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")

local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/EventNames")
local CreateConversationError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/Enums/CreateConversationError")

return function(p2, p3, value)
	if not p2 then
		return Promise.reject("No conversation returned.")
	end

	if p2.status == "failed" then
		return Promise.reject("Failed to create conversation.")
	end

	local v5 = ConversationChannels.fromChannelsApi(p2)

	if not p3 then
		return v5
	end

	local v6 = if v5 then p2.status else CreateConversationError.InvalidResponse
	p3.fireAnalyticsEvent(EventNames.NewConversationCreated, {
		conversationId = v5.id,
		createConversationResult = v6,
		participantsCount = #v5.participants,
		createdReason = value or "unknown"
	})

	return v5
end
