local FlyoutSidePanel = script:FindFirstAncestor("FlyoutSidePanel")
local parent = FlyoutSidePanel.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagCTAChangeMorePageFlyoutButtonTextIxpEnabled = SharedFlags.FFlagCTAChangeMorePageFlyoutButtonTextIxpEnabled

local FStringCTAChangeMorePageFlyoutButtonTextIxpLayer = require(FlyoutSidePanel.Flags.FStringCTAChangeMorePageFlyoutButtonTextIxpLayer)

local function logCTAChangeMorePageFlyoutButtonTextExposure(object)
	if not FFlagCTAChangeMorePageFlyoutButtonTextIxpEnabled then
		return
	end

	local v = FStringCTAChangeMorePageFlyoutButtonTextIxpLayer

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

return logCTAChangeMorePageFlyoutButtonTextExposure
