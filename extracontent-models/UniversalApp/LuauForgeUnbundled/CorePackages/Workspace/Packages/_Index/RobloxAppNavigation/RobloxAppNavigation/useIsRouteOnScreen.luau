local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/React")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/Navigation").useNavigation
local useEarlyIsFocused = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/Navigation").useEarlyIsFocused
local getCurrentNavigationState = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/Navigation").getCurrentNavigationState
local OnScreenContext = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/OnScreenContext")

local defineFastFlag = game:DefineFastFlag("EnableOnScreenAPICheckDescendants", false)

local function useIsRouteOnScreen()
	local v5 = useNavigation()
	local key = if v5.state then v5.state.key else nil
	local v6 = React.useContext(OnScreenContext)
	local v7 = useEarlyIsFocused()

	if v6 == nil or v6.isOnScreen == nil then
		return v7
	end

	if defineFastFlag then
		local v8 = v6.currentRouteKey == nil or v6.currentRouteKey == key

		if not v8 and v5.state then
			v8 = v6.currentRouteKey == getCurrentNavigationState(v5.state).key
		end

		if v6.isOnScreen ~= true then
			v8 = false
		end

		return v8
	end

	return v6.isOnScreen == true and (v6.currentRouteKey == nil or v6.currentRouteKey == key)
end

return useIsRouteOnScreen
