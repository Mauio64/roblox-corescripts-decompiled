local constants = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Milestones/constants")

require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

local function hasNavigationCommitted(p2): boolean
	if p2 == nil or p2.milestones == nil then
		return false
	end

	for k, milestone in p2.milestones do
		if milestone.name == constants.NavigationCommitted then
			return true
		end
	end

	return false
end

return hasNavigationCommitted
