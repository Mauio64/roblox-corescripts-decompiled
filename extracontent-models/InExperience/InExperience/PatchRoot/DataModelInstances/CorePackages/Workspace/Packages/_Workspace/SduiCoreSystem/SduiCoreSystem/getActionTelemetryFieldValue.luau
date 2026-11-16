local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

local findAnalyticsFieldInAncestors = require(SduiCoreSystem.findAnalyticsFieldInAncestors)
require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiConfigTypes)

local function getActionTelemetryFieldValue(p, p2, p3: string, p4)
	local analyticsFieldInAncestors = findAnalyticsFieldInAncestors(p3, p2)

	if analyticsFieldInAncestors ~= nil then
		return analyticsFieldInAncestors
	end

	if p then
		local actionParams = p.actionParams

		if actionParams and actionParams[p3] ~= nil then
			return actionParams[p3]
		end
	end

	return p4
end

return getActionTelemetryFieldValue
