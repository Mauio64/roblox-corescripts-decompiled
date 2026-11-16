local FlyoutSidePanel = script:FindFirstAncestor("FlyoutSidePanel")

local FFlagFlyoutTradesEntryExposureLogging = require(FlyoutSidePanel.Flags.FFlagFlyoutTradesEntryExposureLogging)
local FStringFlyoutTradesEntryIxpLayer = require(FlyoutSidePanel.Flags.FStringFlyoutTradesEntryIxpLayer)

local function logFlyoutTradesEntryExposure(object)
	if not FFlagFlyoutTradesEntryExposureLogging then
		return
	end

	local v = FStringFlyoutTradesEntryIxpLayer

	if v == "" then
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
		object:LogFlagLinkedUserLayerExposure(v)
	end)
end

return logFlyoutTradesEntryExposure
