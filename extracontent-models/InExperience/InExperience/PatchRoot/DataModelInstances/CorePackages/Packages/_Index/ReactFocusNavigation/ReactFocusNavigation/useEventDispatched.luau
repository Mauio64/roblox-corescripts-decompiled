local parent = script.Parent.Parent
local React = require(parent.React)
require(parent.FocusNavigation)

local FocusNavigationContext = require(script.Parent.FocusNavigationContext)

local function useEventDispatched(current)
	local v = React.useContext(FocusNavigationContext)
	local ref = React.useRef(current)
	ref.current = current

	React.useEffect(function()
		if not v then
			return nil
		end

		local v2 = v.eventDispatched:subscribe(function(p)
			if p then
				ref.current(p)
			end
		end)

		return function()
			v2:unsubscribe()
		end
	end, { v })
end

return useEventDispatched
