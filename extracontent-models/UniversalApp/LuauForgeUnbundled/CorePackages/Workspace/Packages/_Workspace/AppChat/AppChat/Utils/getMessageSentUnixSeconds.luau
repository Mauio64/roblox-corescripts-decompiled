local getMessageSentDateTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getMessageSentDateTime")
local getUnixTimestampSeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getUnixTimestampSeconds")

local function getMessageSentUnixSeconds(p2)
	return getUnixTimestampSeconds(getMessageSentDateTime(p2))
end

return getMessageSentUnixSeconds
