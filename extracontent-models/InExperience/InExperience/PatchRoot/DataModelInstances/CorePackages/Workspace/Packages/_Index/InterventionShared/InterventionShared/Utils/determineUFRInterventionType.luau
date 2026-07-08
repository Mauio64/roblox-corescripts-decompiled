local InterventionShared = script:FindFirstAncestor("InterventionShared")
local InterventionTypes = require(InterventionShared.InterventionAnalytics).Constants.InterventionTypes

return function(s1: string?) -- line: 13
	-- upvalues: InterventionTypes (copy)
	local v4 = not s1 and "" or s1:lower()

	if string.find(v4, "nudge") then
		return InterventionTypes.UFRNudge
	end

	if string.find(v4, "timeout") then
		return InterventionTypes.UFRTimeout
	end

	return InterventionTypes.UFRTimeout
end
