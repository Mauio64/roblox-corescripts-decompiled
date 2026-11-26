require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/AppChatData/Types")
local getMessageSentDateTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getMessageSentDateTime")
local getUnixTimestampSeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getUnixTimestampSeconds")
local isMessagePreviewable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/isMessagePreviewable")

local function findNewestPreviewableMessage(items, p2)
	local newestPreviewableMessage = nil

	for k, item in items do
		if not (item ~= nil and isMessagePreviewable(item)) then
			continue
		end

		local v5 = getMessageSentDateTime(item)
		local v6 = getUnixTimestampSeconds(v5)

		if not (v6 ~= nil and p2 < v6) then
			continue
		end

		newestPreviewableMessage = {
			messageId = item.id,
			sentDateTime = v5,
			sentUnixSeconds = v6
		}
		p2 = v6
	end

	return newestPreviewableMessage
end

return findNewestPreviewableMessage
