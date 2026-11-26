local SduiUsageRecorder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/Analytics/SduiUsageRecorder")
local recordV1ComponentUsage = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/Analytics/recordV1ComponentUsage")

local function recordV1RegisteredTemplates(p2, items)
	if not items then
		return
	end

	if SduiUsageRecorder.isTypeSamplingEnabled() or SduiUsageRecorder.isParamSamplingEnabled() then
		for k, item in items do
			pcall(recordV1ComponentUsage, p2, item)
		end
	end
end

return recordV1RegisteredTemplates
