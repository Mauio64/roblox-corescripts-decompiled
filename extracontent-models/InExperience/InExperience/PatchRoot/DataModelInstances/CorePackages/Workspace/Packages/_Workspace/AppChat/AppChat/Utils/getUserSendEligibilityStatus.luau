local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local DataHydration = require(parent.DataHydration)
require(parent.Signals)

local GetChatModerationStatusDataHydration = require(AppChat.Stores.GetChatModerationStatusDataHydration)
local getEffectiveChatTimeoutDetails = require(AppChat.Utils.getEffectiveChatTimeoutDetails)
local toTimeoutEntry = require(AppChat.Utils.toTimeoutEntry)

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
		or not getEffectiveChatTimeoutDetails(
			toTimeoutEntry(userStatus.data(data.scope)),
			nil,
			nil,
			data.currentTimestamp
		).isTimedOut
	then
		return "eligible"
	end

	return "ineligible"
end

return getUserSendEligibilityStatus
