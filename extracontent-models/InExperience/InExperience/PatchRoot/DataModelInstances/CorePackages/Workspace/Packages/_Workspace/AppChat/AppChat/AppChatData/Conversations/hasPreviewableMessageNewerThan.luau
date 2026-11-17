local AppChat = script:FindFirstAncestor("AppChat")

require(AppChat.AppChatData.Types)
local getMessageSentDateTime = require(AppChat.Utils.getMessageSentDateTime)
local getUnixTimestampMillis = require(AppChat.Utils.getUnixTimestampMillis)
local isMessagePreviewable = require(AppChat.Utils.isMessagePreviewable)

local function hasPreviewableMessageNewerThan(items, p: number): boolean
	for _, item in items do
		if
			item ~= nil
			and isMessagePreviewable(item)
			and p < (getUnixTimestampMillis(getMessageSentDateTime(item)) or 0)
		then
			return true
		end
	end

	return false
end

return hasPreviewableMessageNewerThan
