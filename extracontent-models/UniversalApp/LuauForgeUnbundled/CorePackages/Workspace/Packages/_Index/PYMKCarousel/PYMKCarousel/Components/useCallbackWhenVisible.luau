local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/React")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/RoactUtils").Hooks.RoactRodux.useSelector
local useNavigationFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/Navigation").useNavigationFocus
local fFlagEnableOnScreenAPIIntegration = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SharedFlags").FFlagEnableOnScreenAPIIntegration

local useIsRouteOnScreen = if fFlagEnableOnScreenAPIIntegration then require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/RobloxAppNavigation").useIsRouteOnScreen else nil

local defineFastInt = game:DefineFastInt("HomePagePYMKPercentageOfViewPortToStartFetch", 25)

local function fn()
	local v5 = useSelector(function(p2)
		return p2.ScreenSize
	end)

	local v6 = useSelector(function(p2)
		return p2.TopBar.topBarHeight
	end)

	local v7 = useSelector(function(p2)
		return p2.GlobalGuiInset
	end)

	return (React.useMemo(function()
		return {
			min = Vector2.new(0, v6),
			max = Vector2.new(v5.X, v5.Y - v7.bottom)
		}
	end, { v6, v5, v7 }))
end

return function(data)
	local elementRef = data.elementRef
	local scrollViewPositionChangedSignal = data.scrollViewPositionChangedSignal
	local callback = data.callback

	local v5 = if fFlagEnableOnScreenAPIIntegration then useIsRouteOnScreen() else useNavigationFocus()
	local v6 = fn()

	React.useEffect(function()
		local v7 = v6
		local current = elementRef and elementRef.current
		local v9

		if current then
			local y = current.AbsolutePosition.Y
			local v10 = current.AbsolutePosition.Y + current.AbsoluteSize.Y

			local y2 = v7.min.Y
			local y3 = v7.max.Y
			local v11 = (y3 - y2) / 100 * defineFastInt

			v9 = y2 - v11 < y and v10 < y3 + v11
		else
			v9 = false
		end

		if v9 and v5 then
			callback()
		end

		if scrollViewPositionChangedSignal then
			scrollViewPositionChangedSignal:connect(function()
				local v10 = v6
				local current2 = elementRef and elementRef.current
				local v12

				if current2 then
					local y = current2.AbsolutePosition.Y
					local v13 = current2.AbsolutePosition.Y + current2.AbsoluteSize.Y

					local y2 = v10.min.Y
					local y3 = v10.max.Y
					local v14 = (y3 - y2) / 100 * defineFastInt

					v12 = y2 - v14 < y and v13 < y3 + v14
				else
					v12 = false
				end

				if v12 and v5 then
					callback()
				end
			end)
		end
	end, { elementRef, scrollViewPositionChangedSignal, v5, v6 })
end
