local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local findAnalyticsFieldInAncestors = require(SduiCoreSystem.findAnalyticsFieldInAncestors)

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiConfigTypes)

local function getActionTelemetryFieldValue(p1, p2, s1: string, p3) -- line: 12
	-- upvalues: findAnalyticsFieldInAncestors (copy)
	local v8 = findAnalyticsFieldInAncestors(s1, p2)

	if v8 ~= nil then
		return v8
	end

	if p1 then
		local actionParams = p1.actionParams

		if actionParams and actionParams[s1] ~= nil then
			return actionParams[s1]
		end
	end

	return p3
end

return getActionTelemetryFieldValue
