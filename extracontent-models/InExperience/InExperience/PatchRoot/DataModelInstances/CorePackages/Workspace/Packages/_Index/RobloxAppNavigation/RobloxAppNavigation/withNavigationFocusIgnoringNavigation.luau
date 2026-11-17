local parent = script:FindFirstAncestor("RobloxAppNavigation").Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)
local tutils = require(parent.tutils)

local v = { navigation = true }

local function arePropsEqualIgnoringNavigation(p, p2)
	return tutils.shallowEqual(p, p2, v)
end

local function withNavigationFocusIgnoringNavigation(p)
	return React.memo(RoactNavigation.withNavigationFocus(React.memo(function(p2)
		return React.createElement(p, Cryo.Dictionary.join(p2, { navigation = Cryo.None }))
	end, arePropsEqualIgnoringNavigation)))
end

return withNavigationFocusIgnoringNavigation
