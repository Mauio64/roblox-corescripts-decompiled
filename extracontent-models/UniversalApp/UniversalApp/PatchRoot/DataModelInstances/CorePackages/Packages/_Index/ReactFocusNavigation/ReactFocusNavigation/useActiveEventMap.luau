local parent = script.Parent.Parent
local React = require(parent.React)
require(parent.FocusNavigation)

local FocusNavigationContext = require(script.Parent.FocusNavigationContext)

local function useActiveEventMap()
	local v = React.useContext(FocusNavigationContext)

	local v2 = not v and {} or v.activeEventMap:getValue()
	local state, setState = React.useState(v2)
	React.useEffect(function()
		if state ~= v2 then
			setState(v2)
		end

		if not v then
			return nil
		end

		local v3 = v.activeEventMap:subscribe(setState)

		return function()
			v3:unsubscribe()
		end
	end, { v })

	return state
end

return useActiveEventMap
