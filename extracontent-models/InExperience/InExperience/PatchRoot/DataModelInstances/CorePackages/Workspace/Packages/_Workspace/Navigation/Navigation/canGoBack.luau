local parent = script:FindFirstAncestor("Navigation").Parent
local RoactNavigation = require(parent.RoactNavigation)
local Actions = RoactNavigation.Actions
require(script.Parent.types)
local getRootNavigation = require(script.Parent.getRootNavigation)

local function canGoBack(p): boolean
	local rootNavigation = getRootNavigation(p)
	local state = rootNavigation.state

	return state ~= rootNavigation.router.getStateForAction(Actions.back({ key = false }), state)
end

return canGoBack
