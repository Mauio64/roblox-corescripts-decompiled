local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)

local getDeviceDisplayService = require(Moments.Utils.getDeviceDisplayService)
local isDisplayWakeLockSupported = require(Moments.Utils.isDisplayWakeLockSupported)

local function useDisplayWakeLock(flag: boolean)
	React.useEffect(function()
		if flag and isDisplayWakeLockSupported() then
			local wakeLock = getDeviceDisplayService():AcquireWakeLock("Moments.WatchFeed")
			return function()
				wakeLock:Destroy()
			end
		end
	end, { flag })
end

return useDisplayWakeLock
