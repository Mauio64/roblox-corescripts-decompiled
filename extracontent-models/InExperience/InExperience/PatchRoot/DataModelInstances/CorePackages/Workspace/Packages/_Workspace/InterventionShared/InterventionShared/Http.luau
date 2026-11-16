local parent = script:FindFirstAncestor("InterventionShared").Parent

return {
	GetModerationDetail = require(parent.UniversalFeatureRestrictions.GetModerationDetail),
	PostDismissIntervention = require(script.PostDismissIntervention)
}
