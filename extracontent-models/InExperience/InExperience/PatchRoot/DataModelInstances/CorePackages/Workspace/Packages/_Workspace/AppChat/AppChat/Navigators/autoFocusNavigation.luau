local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)

local function autoFocusNavigation(p, _: number?)
	return function(p2)
		local ref = React.useRef(nil)
		local currents = {}
		local v = FocusNavigationUtils.useAutoFocus(currents, 0.1)
		local v2 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
		React.useEffect(function()
			currents[1] = ref.current
			local v3

			if v2 and v2.focusedGuiObject:getValue() ~= nil and v then
				v3 = v()
			else
				v3 = nil
			end

			return function()
				if v3 then
					v3.cancel()
				end
			end
		end, { v })
		return React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Selectable = false,
				ref = ref
			},
			{ content = React.createElement(p, p2) }
		)
	end
end

return autoFocusNavigation
