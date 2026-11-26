require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/AppChatData/Types")
local getMessageSentDateTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getMessageSentDateTime")
local getUnixTimestampMillis = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getUnixTimestampMillis")
local isMessagePreviewable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/isMessagePreviewable")

local function hasPreviewableMessageNewerThan(items, p2): boolean
	for k, item in items do
		if item ~= nil and isMessagePreviewable(item) and p2 < (getUnixTimestampMillis(getMessageSentDateTime(item)) or 0) then
			return true
		end
	end

	return false
end

return hasPreviewableMessageNewerThan
