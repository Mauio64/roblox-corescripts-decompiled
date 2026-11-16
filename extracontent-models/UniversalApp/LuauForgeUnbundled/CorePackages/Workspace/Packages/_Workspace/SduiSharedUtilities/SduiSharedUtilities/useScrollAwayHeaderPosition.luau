local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")
local useDeviceInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Responsive").useDeviceInsets

local AppNavBar = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/AppNavBar")
local visibilityControl = AppNavBar.VisibilityControl
local getScrollAwayEnabled = AppNavBar.getScrollAwayEnabled

local function useScrollAwayHeaderPosition(data)
	local headerHeightBinding = data.headerHeightBinding
	local v5

	if data.enabled == true then
		v5 = getScrollAwayEnabled()

		if v5 then
			v5 = not (data.scrollAwayHeight == nil) and data.scrollAwayHeight > 0
		end
	else
		v5 = false
	end

	local top = useDeviceInsets().top
	return React.useMemo(function()
		if not (v5 and data.scrollAwayHeight) then
			return UDim2.fromOffset(0, 0)
		end

		local scrollAwayHeight = data.scrollAwayHeight

		local v6 = not (top > 0 and top < scrollAwayHeight) and -1e999 or top - scrollAwayHeight
		local v7

		if headerHeightBinding == nil then
			v7 = visibilityControl.getHeaderBinding():map(function(p2)
				return p2 * scrollAwayHeight
			end)
		else
			v7 = headerHeightBinding
		end

		return v7:map(function(p2)
			return UDim2.new(0, 0, 0, (math.max(p2 - scrollAwayHeight, v6)))
		end)
	end, { v5, data.scrollAwayHeight, top, headerHeightBinding })
end

return useScrollAwayHeaderPosition
