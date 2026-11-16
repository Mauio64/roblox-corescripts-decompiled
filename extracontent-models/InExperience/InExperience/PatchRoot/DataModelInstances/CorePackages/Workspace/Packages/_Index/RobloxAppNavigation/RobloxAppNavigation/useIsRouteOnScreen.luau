local parent = script:FindFirstAncestor("RobloxAppNavigation").Parent

local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local Navigation2 = require(parent.Navigation)
local useEarlyIsFocused = Navigation2.useEarlyIsFocused
local Navigation3 = require(parent.Navigation)
local getCurrentNavigationState = Navigation3.getCurrentNavigationState
local OnScreenContext = require(script.Parent.OnScreenContext)

local defineFastFlag = game:DefineFastFlag("EnableOnScreenAPICheckDescendants", false)

local function useIsRouteOnScreen()
	local v = useNavigation()
	local key

	if v.state then
		key = v.state.key
	end

	local v2 = React.useContext(OnScreenContext)
	local v3 = useEarlyIsFocused()

	if v2 == nil or v2.isOnScreen == nil then
		return v3
	end

	if defineFastFlag then
		local v4 = v2.currentRouteKey == nil or v2.currentRouteKey == key

		if not v4 and v.state then
			v4 = v2.currentRouteKey == getCurrentNavigationState(v.state).key
		end

		return v2.isOnScreen == true and v4
	end

	return v2.isOnScreen == true and (v2.currentRouteKey == nil or v2.currentRouteKey == key)
end

return useIsRouteOnScreen
