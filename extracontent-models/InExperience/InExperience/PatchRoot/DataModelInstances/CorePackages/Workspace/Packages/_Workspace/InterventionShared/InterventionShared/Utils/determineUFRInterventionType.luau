local InterventionShared = script:FindFirstAncestor("InterventionShared")
local InterventionAnalytics = require(InterventionShared.InterventionAnalytics)

local InterventionTypes = InterventionAnalytics.Constants.InterventionTypes

return function(value: string?)
	local v = not value and "" or value:lower()

	if string.find(v, "nudge") then
		return InterventionTypes.UFRNudge
	end

	if string.find(v, "timeout") then
	end

	return InterventionTypes.UFRTimeout
end
