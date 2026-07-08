local Parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local React = require(Parent.React)
local AppNavBar = require(Parent.AppNavBar)
local VisibilityControl = AppNavBar.VisibilityControl
local getScrollAwayEnabled = AppNavBar.getScrollAwayEnabled

local function useScrollAwayHeaderPosition(t1: {[any]: any}) -- line: 31
	-- upvalues: getScrollAwayEnabled (copy), React (copy), VisibilityControl (copy)
	local v8 = t1.enabled == true and getScrollAwayEnabled()

	return React.useMemo(function() -- line: 33
		-- upvalues: v8 (copy), React (copy), t1 (copy), VisibilityControl (copy)
		if not v8 then
			return UDim2.fromOffset(0, 0)
		end

		return React.joinBindings({
			size = t1.sizeBinding,
			ratio = VisibilityControl.getHeaderBinding()
		}):map(function(p1) -- line: 40
			local YOffset = p1.size.Y.Offset
			local ratio = p1.ratio

			return UDim2.new(0, 0, 0, (ratio - 1) * YOffset)
		end)
	end, {
		t1.sizeBinding,
		v8
	})
end

return useScrollAwayHeaderPosition
