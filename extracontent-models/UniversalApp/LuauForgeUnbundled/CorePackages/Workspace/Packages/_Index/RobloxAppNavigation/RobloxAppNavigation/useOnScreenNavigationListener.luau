local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/React")

local useIsRouteOnScreen = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/useIsRouteOnScreen")

local function useOnScreenNavigationListener(callback, callback2)
	local v5 = useIsRouteOnScreen()
	local ref = React.useRef(v5)
	React.useEffect(function()
		if v5 == ref.current then
			return
		end

		ref.current = v5

		if v5 then
			if callback ~= nil then
				callback()
			end
		elseif callback2 ~= nil then
			callback2()
		end
	end, { callback, callback2, v5 })
end

return useOnScreenNavigationListener
