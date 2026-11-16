local parent = script:FindFirstAncestor("SduiSharedUtilities").Parent

local React = require(parent.React)
local Responsive = require(parent.Responsive)
local useDeviceInsets = Responsive.useDeviceInsets

local AppNavBar = require(parent.AppNavBar)
local VisibilityControl = AppNavBar.VisibilityControl
local getScrollAwayEnabled = AppNavBar.getScrollAwayEnabled

local function useScrollAwayHeaderPosition(data)
	local headerHeightBinding = data.headerHeightBinding
	local v

	if data.enabled == true then
		v = getScrollAwayEnabled()

		if v then
			if data.scrollAwayHeight == nil then
				v = false
			else
				v = data.scrollAwayHeight > 0
			end
		end
	else
		v = false
	end

	local top = useDeviceInsets().top
	return React.useMemo(function()
		if not (v and data.scrollAwayHeight) then
			return UDim2.fromOffset(0, 0)
		end

		local scrollAwayHeight = data.scrollAwayHeight

		local v2 = not (top > 0 and top < scrollAwayHeight) and -1e999 or top - scrollAwayHeight
		local v3

		if headerHeightBinding == nil then
			v3 = VisibilityControl.getHeaderBinding():map(function(p: number)
				return p * scrollAwayHeight
			end)
		else
			v3 = headerHeightBinding
		end

		return v3:map(function(p: number)
			return UDim2.new(0, 0, 0, (math.max(p - scrollAwayHeight, v2)))
		end)
	end, { v, data.scrollAwayHeight, top, headerHeightBinding })
end

return useScrollAwayHeaderPosition
