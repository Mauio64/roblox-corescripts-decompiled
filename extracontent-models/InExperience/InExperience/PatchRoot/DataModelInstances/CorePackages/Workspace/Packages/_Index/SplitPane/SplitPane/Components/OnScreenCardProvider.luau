local parent = script:FindFirstAncestor("SplitPane").Parent

local React = require(parent.React)
local RobloxAppNavigation = require(parent.RobloxAppNavigation)

local SharedFlags = require(parent.SharedFlags)
local FFlagNavigationCommandHandle = SharedFlags.FFlagNavigationCommandHandle

local OnScreenStore = require(script.Parent.Parent.Stores.OnScreenStore)

local OnScreenContext = RobloxAppNavigation.OnScreenContext

local function OnScreenCardProvider(p)
	local current2 = p.value

	local ref = React.useRef(nil)
	local current = ref.current

	if
		current2 == nil
		or current == nil
		or current.isOnScreen ~= current2.isOnScreen
		or current.currentRouteKey ~= current2.currentRouteKey
	then
		if current2 ~= nil then
			ref.current = current2
		end
	else
		current2 = current
	end

	if FFlagNavigationCommandHandle then
		React.useEffect(function()
			if current2 == nil or current2.isOnScreen ~= true or current2.currentRouteKey == nil then
				return function() end
			end

			local currentRouteKey = current2.currentRouteKey
			OnScreenStore.setRouteOnScreen(currentRouteKey, current2)
			return function()
				OnScreenStore.setRouteOnScreen(currentRouteKey, nil)
			end
		end, { current2 })
	end

	return React.createElement(OnScreenContext.Provider, { value = current2 }, p.children)
end

return OnScreenCardProvider
