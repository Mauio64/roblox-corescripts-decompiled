local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")
local TimeToInteractiveTrackerParent = TimeToInteractiveTracker.Parent

require(TimeToInteractiveTrackerParent.Signals)
require(TimeToInteractiveTracker.Milestones.types)

return {}
