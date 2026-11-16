local interventionTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/InterventionAnalytics").Constants.InterventionTypes

return function(value)
	local v5 = not value and "" or value:lower()

	if string.find(v5, "nudge") then
		return interventionTypes.UFRNudge
	end

	if string.find(v5, "timeout") then
	end

	return interventionTypes.UFRTimeout
end
