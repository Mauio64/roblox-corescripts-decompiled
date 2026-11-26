local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/RoactNavigation")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/tutils")

local v5 = { navigation = true }

local function arePropsEqualIgnoringNavigation(p2, p3)
	return tutils.shallowEqual(p2, p3, v5)
end

local function withNavigationFocusIgnoringNavigation(p2)
	return React.memo(RoactNavigation.withNavigationFocus(React.memo(function(p3)
		return React.createElement(p2, Cryo.Dictionary.join(p3, {
			navigation = Cryo.None
		}))
	end, arePropsEqualIgnoringNavigation)))
end

return withNavigationFocusIgnoringNavigation
