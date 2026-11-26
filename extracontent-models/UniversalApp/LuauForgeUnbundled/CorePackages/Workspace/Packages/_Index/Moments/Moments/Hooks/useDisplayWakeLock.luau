local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local getDeviceDisplayService = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/getDeviceDisplayService")
local isDisplayWakeLockSupported = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/isDisplayWakeLockSupported")

local function useDisplayWakeLock(p2)
	React.useEffect(function()
		if p2 and isDisplayWakeLockSupported() then
			local wakeLock = getDeviceDisplayService():AcquireWakeLock("Moments.WatchFeed")
			return function()
				wakeLock:Destroy()
			end
		end
	end, { p2 })
end

return useDisplayWakeLock
