local AppChat = script:FindFirstAncestor("AppChat")

require(AppChat.AppChatData.Types)
local getMessageSentDateTime = require(AppChat.Utils.getMessageSentDateTime)
local getUnixTimestampSeconds = require(AppChat.Utils.getUnixTimestampSeconds)
local isMessagePreviewable = require(AppChat.Utils.isMessagePreviewable)

local function findNewestPreviewableMessage(items, p: number)
	local newestPreviewableMessage = nil

	for _, item in items do
		if not (item ~= nil and isMessagePreviewable(item)) then
			continue
		end

		local messageSentDateTime = getMessageSentDateTime(item)
		local unixTimestampSeconds = getUnixTimestampSeconds(messageSentDateTime)

		if not (unixTimestampSeconds ~= nil and p < unixTimestampSeconds) then
			continue
		end

		newestPreviewableMessage = {
			messageId = item.id,
			sentDateTime = messageSentDateTime,
			sentUnixSeconds = unixTimestampSeconds
		}
		p = unixTimestampSeconds
	end

	return newestPreviewableMessage
end

return findNewestPreviewableMessage
