local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local useDrawerVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Drawer").Hooks.useDrawerVisible
local logFlyoutTradesEntryExposure = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Utils/logFlyoutTradesEntryExposure")

local function useFlyoutTradesEntryExposureLogging()
	local v5 = useDrawerVisible()
	React.useEffect(function()
		if v5 then
			logFlyoutTradesEntryExposure()
		end
	end, { v5 })
end

return useFlyoutTradesEntryExposureLogging
