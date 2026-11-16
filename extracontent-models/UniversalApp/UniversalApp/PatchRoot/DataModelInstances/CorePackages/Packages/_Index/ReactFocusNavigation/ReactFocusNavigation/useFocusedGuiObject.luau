local parent = script.Parent.Parent
local React = require(parent.React)

local FocusNavigationContext = require(script.Parent.FocusNavigationContext)

local function useCurrentFocus()
	local v = React.useContext(FocusNavigationContext)
	local v2

	if v then
		v2 = v.focusedGuiObject:getValue()
	else
		v2 = nil
	end

	local state, setState = React.useState(v2)
	React.useEffect(function()
		if state ~= v2 then
			setState(v2)
		end

		if not v then
			return nil
		end

		local v3 = v.focusedGuiObject:subscribe(setState)

		return function()
			v3:unsubscribe()
		end
	end, { v })

	return state
end

return useCurrentFocus
