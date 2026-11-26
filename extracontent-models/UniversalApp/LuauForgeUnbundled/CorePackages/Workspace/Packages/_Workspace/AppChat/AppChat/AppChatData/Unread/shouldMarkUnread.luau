require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/AppChatData/Types")
local getMessageSentUnixSeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getMessageSentUnixSeconds")

local function shouldMarkUnread(items, p2, p3): boolean
	for k, item in items do
		local v5 = getMessageSentUnixSeconds(item)
		local sender_user_id = item.sender_user_id or item.senderTargetId

		if
			v5 ~= nil
			and p2 < v5
			and sender_user_id ~= nil
			and tostring(sender_user_id) ~= p3
			and item.is_badgeable == true
		then
			return true
		end
	end

	return false
end

return shouldMarkUnread
