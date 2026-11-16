local FlyoutSidePanel = script:FindFirstAncestor("FlyoutSidePanel")
local parent = FlyoutSidePanel.Parent

local React = require(parent.React)
local Drawer = require(parent.Drawer)
local useDrawerVisible = Drawer.Hooks.useDrawerVisible
local logFlyoutTradesEntryExposure = require(FlyoutSidePanel.Utils.logFlyoutTradesEntryExposure)

local function useFlyoutTradesEntryExposureLogging()
	local v = useDrawerVisible()
	React.useEffect(function()
		if v then
			logFlyoutTradesEntryExposure()
		end
	end, { v })
end

return useFlyoutTradesEntryExposureLogging
