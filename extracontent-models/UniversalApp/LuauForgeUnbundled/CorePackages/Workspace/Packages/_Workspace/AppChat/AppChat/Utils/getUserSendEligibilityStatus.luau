local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local GetChatModerationStatusDataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetChatModerationStatusDataHydration")
local getEffectiveChatTimeoutDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getEffectiveChatTimeoutDetails")
local toTimeoutEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/toTimeoutEntry")

local function getUserSendEligibilityStatus(data): string
	if not data.isAvailable then
		return "ineligible"
	end

	local userStatus = GetChatModerationStatusDataHydration().getUserStatus()
	local status = userStatus.status(data.scope)

	if status == DataHydration.DataStatus.NotReady then
		return "loading"
	end

	if
		status == DataHydration.DataStatus.Failed
		or not getEffectiveChatTimeoutDetails(toTimeoutEntry(userStatus.data(data.scope)), nil, nil, data.currentTimestamp).isTimedOut
	then
		return "eligible"
	end

	return "ineligible"
end

return getUserSendEligibilityStatus
