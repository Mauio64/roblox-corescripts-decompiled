local FFlagProfileTradeItemsExposureLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileTradeItemsExposureLogging")
local FStringProfileTradeItemsIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FStringProfileTradeItemsIxpLayer")

local function logTradeItemsExposureIfEligible(data)
	if not (FFlagProfileTradeItemsExposureLogging and tostring(data.profileId) ~= tostring(data.localUserId) and (data.localHasPaidTradingAccess and data.otherHasPaidTradingAccess)) then
		return
	end

	local v5 = FStringProfileTradeItemsIxpLayer

	if v5 == "" then
		return
	end

	local v6 = data.ixpService

	if v6 == nil then
		if not game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure") then
			return
		end

		v6 = game:GetService("IXPService")
	end

	assert(v6 ~= nil, "IXPService is required to log layer exposure")

	pcall(function()
		v6:LogFlagLinkedUserLayerExposure(v5)
	end)
end

return logTradeItemsExposureIfEligible
