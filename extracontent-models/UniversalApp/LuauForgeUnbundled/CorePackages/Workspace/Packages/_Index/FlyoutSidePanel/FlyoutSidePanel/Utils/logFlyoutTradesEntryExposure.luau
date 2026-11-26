local FFlagFlyoutTradesEntryExposureLogging = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Flags/FFlagFlyoutTradesEntryExposureLogging")
local FStringFlyoutTradesEntryIxpLayer = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Flags/FStringFlyoutTradesEntryIxpLayer")

local function logFlyoutTradesEntryExposure(object)
	if not FFlagFlyoutTradesEntryExposureLogging then
		return
	end

	local v5 = FStringFlyoutTradesEntryIxpLayer

	if v5 == "" then
		return
	end

	if object == nil then
		if not game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure") then
			return
		end

		object = game:GetService("IXPService")
	end

	assert(object ~= nil, "IXPService is required to log layer exposure")

	pcall(function()
		object:LogFlagLinkedUserLayerExposure(v5)
	end)
end

return logFlyoutTradesEntryExposure
