local FlyoutSidePanel = script:FindFirstAncestor("FlyoutSidePanel")
local parent = FlyoutSidePanel.Parent

local React = require(parent.React)
local Drawer = require(parent.Drawer)
local useDrawerVisible = Drawer.Hooks.useDrawerVisible
local logCTAChangeMorePageFlyoutButtonTextExposure = require(FlyoutSidePanel.Utils.logCTAChangeMorePageFlyoutButtonTextExposure)

local function useCTAChangeMorePageFlyoutButtonTextExposureLogging()
	local v = useDrawerVisible()
	React.useEffect(function()
		if v then
			logCTAChangeMorePageFlyoutButtonTextExposure()
		end
	end, { v })
end

return useCTAChangeMorePageFlyoutButtonTextExposureLogging
