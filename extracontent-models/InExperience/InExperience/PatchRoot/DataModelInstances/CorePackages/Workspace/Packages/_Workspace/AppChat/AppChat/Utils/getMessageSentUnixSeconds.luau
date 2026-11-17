local AppChat = script:FindFirstAncestor("AppChat")

local getMessageSentDateTime = require(AppChat.Utils.getMessageSentDateTime)
local getUnixTimestampSeconds = require(AppChat.Utils.getUnixTimestampSeconds)

local function getMessageSentUnixSeconds(p)
	return getUnixTimestampSeconds(getMessageSentDateTime(p))
end

return getMessageSentUnixSeconds
