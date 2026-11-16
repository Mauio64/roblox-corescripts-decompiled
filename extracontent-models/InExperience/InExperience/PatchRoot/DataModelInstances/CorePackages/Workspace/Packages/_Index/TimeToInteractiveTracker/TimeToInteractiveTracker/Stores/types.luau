local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")
local parent = TimeToInteractiveTracker.Parent

require(parent.Signals)

require(TimeToInteractiveTracker.Milestones.types)

return {}
