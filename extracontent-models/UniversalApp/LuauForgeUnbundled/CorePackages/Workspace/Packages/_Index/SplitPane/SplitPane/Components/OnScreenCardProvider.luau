local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/React")
local RobloxAppNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/RobloxAppNavigation")

local fFlagNavigationCommandHandle = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SharedFlags").FFlagNavigationCommandHandle

local OnScreenStore = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/OnScreenStore")

local onScreenContext = RobloxAppNavigation.OnScreenContext

local function OnScreenCardProvider(p2)
	local v5 = p2.value

	local ref = React.useRef(nil)
	local current = ref.current

	if
		v5 == nil
		or current == nil
		or current.isOnScreen ~= v5.isOnScreen
		or current.currentRouteKey ~= v5.currentRouteKey
	then
		if v5 ~= nil then
			ref.current = v5
		end
	else
		v5 = current
	end

	if fFlagNavigationCommandHandle then
		React.useEffect(function()
			if v5 == nil or v5.isOnScreen ~= true or v5.currentRouteKey == nil then
				return function() end
			end

			local currentRouteKey = v5.currentRouteKey
			OnScreenStore.setRouteOnScreen(currentRouteKey, v5)
			return function()
				OnScreenStore.setRouteOnScreen(currentRouteKey, nil)
			end
		end, { v5 })
	end

	return React.createElement(onScreenContext.Provider, { value = v5 }, p2.children)
end

return OnScreenCardProvider
