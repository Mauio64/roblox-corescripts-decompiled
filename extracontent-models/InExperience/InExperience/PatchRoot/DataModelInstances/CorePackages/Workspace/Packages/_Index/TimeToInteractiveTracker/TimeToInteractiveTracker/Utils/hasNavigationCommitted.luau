local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")

local constants = require(TimeToInteractiveTracker.Milestones.constants)

require(TimeToInteractiveTracker.Stores.types)

local function hasNavigationCommitted(p): boolean
	if p == nil or p.milestones == nil then
		return false
	end

	for _, milestone in p.milestones do
		if milestone.name == constants.NavigationCommitted then
			return true
		end
	end

	return false
end

return hasNavigationCommitted
