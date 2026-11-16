local parent = script:FindFirstAncestor("RobloxAppNavigation").Parent

local React = require(parent.React)

local useIsRouteOnScreen = require(script.Parent.useIsRouteOnScreen)

local function useOnScreenNavigationListener(callback, callback2)
	local current = useIsRouteOnScreen()
	local ref = React.useRef(current)
	React.useEffect(function()
		if current == ref.current then
			return
		end

		ref.current = current

		if current then
			if callback ~= nil then
				callback()
			end
		elseif callback2 ~= nil then
			callback2()
		end
	end, { callback, callback2, current })
end

return useOnScreenNavigationListener
