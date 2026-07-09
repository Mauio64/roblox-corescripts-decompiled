local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)

local function autoFocusNavigation(p1, _: number?) -- line: 9
	-- upvalues: React (copy), FocusNavigationUtils (copy), ReactFocusNavigation (copy)
	return function(p2) -- line: 10
		-- upvalues: React (copy), FocusNavigationUtils (copy), ReactFocusNavigation (copy), p1 (copy)
		local v9 = React.useRef(nil)
		local t1 = {}
		local v11 = FocusNavigationUtils.useAutoFocus(t1, 0.1)
		local v12 = React.useContext(ReactFocusNavigation.FocusNavigationContext)

		React.useEffect(function() -- line: 15
			-- upvalues: t1 (copy), v9 (copy), v12 (copy), v11 (copy)
			t1[1] = v9.current

			local u13 = nil

			if v12 and (v12.focusedGuiObject:getValue() ~= nil and v11) then
				u13 = v11()
			end

			return function() -- line: 21
				-- upvalues: u13 (ref)
				if u13 then
					u13.cancel()
				end
			end
		end, { v11 })

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Selectable = false,
			Size = UDim2.new(1, 0, 1, 0),
			ref = v9
		}, {
			content = React.createElement(p1, p2)
		})
	end
end

return autoFocusNavigation
