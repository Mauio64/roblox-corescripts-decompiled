local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")

local FFlagProfileTradeItemsExposureLogging = require(ProfilePlatform.Flags.FFlagProfileTradeItemsExposureLogging)
local FStringProfileTradeItemsIxpLayer = require(ProfilePlatform.Flags.FStringProfileTradeItemsIxpLayer)

local function logTradeItemsExposureIfEligible(data)
	if not (FFlagProfileTradeItemsExposureLogging and tostring(data.profileId) ~= tostring(data.localUserId) and (data.localHasPaidTradingAccess and data.otherHasPaidTradingAccess)) then
		return
	end

	local v = FStringProfileTradeItemsIxpLayer

	if v == "" then
		return
	end

	local v2 = data.ixpService

	if v2 == nil then
		if not game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure") then
			return
		end

		v2 = game:GetService("IXPService")
	end

	assert(v2 ~= nil, "IXPService is required to log layer exposure")

	pcall(function()
		v2:LogFlagLinkedUserLayerExposure(v)
	end)
end

return logTradeItemsExposureIfEligible
