local findAnalyticsFieldInAncestors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/findAnalyticsFieldInAncestors")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiConfigTypes")

local function getActionTelemetryFieldValue(p2, p3, p4, p5)
	local v5 = findAnalyticsFieldInAncestors(p4, p3)

	if v5 ~= nil then
		return v5
	end

	if p2 then
		local actionParams = p2.actionParams

		if actionParams and actionParams[p4] ~= nil then
			return actionParams[p4]
		end
	end

	return p5
end

return getActionTelemetryFieldValue
