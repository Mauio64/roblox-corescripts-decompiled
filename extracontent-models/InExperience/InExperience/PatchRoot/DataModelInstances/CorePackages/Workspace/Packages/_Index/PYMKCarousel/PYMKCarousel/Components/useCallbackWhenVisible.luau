local parent = script:FindFirstAncestor("PYMKCarousel").Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Navigation = require(parent.Navigation)
local useNavigationFocus = Navigation.useNavigationFocus
local SharedFlags = require(parent.SharedFlags)

local FFlagEnableOnScreenAPIIntegration = SharedFlags.FFlagEnableOnScreenAPIIntegration
local useIsRouteOnScreen

if FFlagEnableOnScreenAPIIntegration then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	useIsRouteOnScreen = RobloxAppNavigation.useIsRouteOnScreen
else
	useIsRouteOnScreen = nil
end

local defineFastInt = game:DefineFastInt("HomePagePYMKPercentageOfViewPortToStartFetch", 25)

local function fn()
	local v = useSelector(function(p)
		return p.ScreenSize
	end)

	local v2 = useSelector(function(p)
		return p.TopBar.topBarHeight
	end)

	local v3 = useSelector(function(p)
		return p.GlobalGuiInset
	end)

	return (React.useMemo(function()
		return {
			min = Vector2.new(0, v2),
			max = Vector2.new(v.X, v.Y - v3.bottom)
		}
	end, { v2, v, v3 }))
end

local function fn2(p, elementRef): boolean -- 2 equivalent calls inferred from this helper
	local current = elementRef and elementRef.current

	if not current then
		return false
	end

	local y = current.AbsolutePosition.Y
	local v = current.AbsolutePosition.Y + current.AbsoluteSize.Y

	local y2 = p.min.Y
	local y3 = p.max.Y
	local v2 = (y3 - y2) / 100 * defineFastInt

	return y2 - v2 < y and v < y3 + v2
end

return function(data)
	local elementRef = data.elementRef
	local scrollViewPositionChangedSignal = data.scrollViewPositionChangedSignal
	local callback = data.callback
	local v

	if FFlagEnableOnScreenAPIIntegration then
		v = useIsRouteOnScreen()
	else
		v = useNavigationFocus()
	end

	local v2 = fn()

	React.useEffect(function()
		if fn2(v2, elementRef) and v then -- inferred equivalent call
			callback()
		end

		if scrollViewPositionChangedSignal then
			scrollViewPositionChangedSignal:connect(function()
				if fn2(v2, elementRef) and v then -- inferred equivalent call
					callback()
				end
			end)
		end
	end, { elementRef, scrollViewPositionChangedSignal, v, v2 })
end
