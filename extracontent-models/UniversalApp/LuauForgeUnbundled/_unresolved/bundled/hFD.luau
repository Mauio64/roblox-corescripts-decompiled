local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local useRouteName = require("@game/CorePackages/Workspace/Packages/Navigation").useRouteName
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local fFlagEnableOnScreenAPIIntegration = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableOnScreenAPIIntegration

local useIsRouteOnScreen = if fFlagEnableOnScreenAPIIntegration then require("@luauforge/bundled/dCu").useIsRouteOnScreen else nil

return function(data): nil
	local ref = React.useRef(false)
	local ref2 = React.useRef(nil)
	local v5 = useRouteName()
	local v6 = if fFlagEnableOnScreenAPIIntegration then useIsRouteOnScreen() else nil
	local v7 = useSelector(function(p2)
		return p2.Personalization.PageSessionTimestamp[data.appPage]
	end)

	local function fn()
		if v5 ~= data.appPage or fFlagEnableOnScreenAPIIntegration and not v6 or v7 == nil then
			return
		end

		if ref2.current == nil then
			ref2.current = v7
		end

		if not ref.current or v7 ~= nil and v7 > ref2.current then
			ref.current = true

			if data.setPageSession then
				data.setPageSession()
			end

			ref2.current = v7
		end

		return function()
			if data.clearPageSession then
				data.clearPageSession()
			end
		end
	end

	React.useEffect(fn, {
		v5,
		data.appPage,
		v7,
		data.setPageSession,
		data.clearPageSession,
		if fFlagEnableOnScreenAPIIntegration then v6 else nil
	})

	return nil
end
