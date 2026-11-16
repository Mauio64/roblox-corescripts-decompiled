local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local useDrawerVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Drawer").Hooks.useDrawerVisible
local logCTAChangeMorePageFlyoutButtonTextExposure = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Utils/logCTAChangeMorePageFlyoutButtonTextExposure")

local function useCTAChangeMorePageFlyoutButtonTextExposureLogging()
	local v5 = useDrawerVisible()
	React.useEffect(function()
		if v5 then
			logCTAChangeMorePageFlyoutButtonTextExposure()
		end
	end, { v5 })
end

return useCTAChangeMorePageFlyoutButtonTextExposureLogging
