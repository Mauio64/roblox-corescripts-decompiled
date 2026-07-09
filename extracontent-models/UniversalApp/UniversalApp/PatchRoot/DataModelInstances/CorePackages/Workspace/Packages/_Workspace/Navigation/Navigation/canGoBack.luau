local Parent = script:FindFirstAncestor("Navigation").Parent
local Actions = require(Parent.RoactNavigation).Actions

require(script.Parent.types)

local getRootNavigation = require(script.Parent.getRootNavigation)

local function canGoBack(p1) -- line: 11
	-- upvalues: getRootNavigation (copy), Actions (copy)
	local v6 = getRootNavigation(p1)
	local state = v6.state

	return state ~= v6.router.getStateForAction(Actions.back({
		key = false
	}), state)
end

return canGoBack
