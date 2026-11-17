local AppChat = script:FindFirstAncestor("AppChat")

require(AppChat.AppChatData.Types)
local getMessageSentUnixSeconds = require(AppChat.Utils.getMessageSentUnixSeconds)

local function shouldMarkUnread(items, p: number, p2: string): boolean
	for _, item in items do
		local messageSentUnixSeconds = getMessageSentUnixSeconds(item)
		local sender_user_id = item.sender_user_id or item.senderTargetId

		if
			messageSentUnixSeconds ~= nil
			and p < messageSentUnixSeconds
			and sender_user_id ~= nil
			and tostring(sender_user_id) ~= p2
			and item.is_badgeable == true
		then
			return true
		end
	end

	return false
end

return shouldMarkUnread
