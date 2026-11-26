local fFlagCTAChangeMorePageFlyoutButtonTextIxpEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags").FFlagCTAChangeMorePageFlyoutButtonTextIxpEnabled

local FStringCTAChangeMorePageFlyoutButtonTextIxpLayer = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Flags/FStringCTAChangeMorePageFlyoutButtonTextIxpLayer")

local function logCTAChangeMorePageFlyoutButtonTextExposure(object)
	if not fFlagCTAChangeMorePageFlyoutButtonTextIxpEnabled then
		return
	end

	local v5 = FStringCTAChangeMorePageFlyoutButtonTextIxpLayer

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

return logCTAChangeMorePageFlyoutButtonTextExposure
