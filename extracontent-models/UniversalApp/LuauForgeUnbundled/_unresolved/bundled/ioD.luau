require("@game/CorePackages/Workspace/Packages/Navigation")
local timeToInteractiveTracker = require("@luauforge/bundled/fCP").TimeToInteractiveTracker
local resolveNavigationTarget = require("@luauforge/bundled/dFz").resolveNavigationTarget

local function hasCommitted(p2): boolean
	for k, v5 in p2.milestones or {} do
		if v5.name == timeToInteractiveTracker.Milestone.NavigationCommitted then
			return true
		end
	end

	return false
end

local function stampCommit(p2)
	local navigationTarget = resolveNavigationTarget(p2)

	if navigationTarget == nil then
		return
	end

	local v5 = timeToInteractiveTracker.NAVIGATION_EVENT_PREFIX .. navigationTarget
	local v6 = timeToInteractiveTracker.getEvents(false)[v5]

	if not v6 or not v6.startTime or v6.sent or hasCommitted(v6) then
		return
	end

	timeToInteractiveTracker.trackMilestone(v5, timeToInteractiveTracker.Milestone.NavigationCommitted)
end

return {
	markCommitted = function(p2)
		local success, result = xpcall(stampCommit, debug.traceback, p2)

		if not success then
			task.spawn(error, result, 0)
		end
	end
}
