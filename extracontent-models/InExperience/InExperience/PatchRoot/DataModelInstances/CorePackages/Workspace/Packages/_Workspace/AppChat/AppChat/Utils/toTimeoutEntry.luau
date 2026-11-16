local AppChat = script:FindFirstAncestor("AppChat")

require(AppChat.Stores.GetChatModerationStatusDataHydration)
require(AppChat.Utils.serializeChatTimeoutRange)

local function toTimeoutEntry(data)
	if data == nil or data.status ~= "active" then
		return nil
	end

	return {
		endTimestamp = data.endTimestamp,
		decisionEventId = data.decisionEventId,
		duration = data.duration,
		requiresAcknowledgement = data.requiresAcknowledgement
	}
end

return toTimeoutEntry
