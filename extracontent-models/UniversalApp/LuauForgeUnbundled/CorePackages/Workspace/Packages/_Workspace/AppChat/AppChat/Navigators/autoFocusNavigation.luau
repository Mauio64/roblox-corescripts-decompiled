local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation")

local function autoFocusNavigation(p2, p3)
	return function(p4)
		local ref = React.useRef(nil)
		local currents = {}
		local v5 = FocusNavigationUtils.useAutoFocus(currents, 0.1)
		local v6 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
		React.useEffect(function()
			currents[1] = ref.current

			local v7 = if v6 and v6.focusedGuiObject:getValue() ~= nil and v5 then v5() else nil

			return function()
				if v7 then
					v7.cancel()
				end
			end
		end, { v5 })
		return React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Selectable = false,
				ref = ref
			},
			{ content = React.createElement(p2, p4) }
		)
	end
end

return autoFocusNavigation
