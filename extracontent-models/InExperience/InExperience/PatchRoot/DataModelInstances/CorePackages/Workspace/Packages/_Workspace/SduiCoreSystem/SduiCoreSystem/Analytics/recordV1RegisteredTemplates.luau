local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

local SduiUsageRecorder = require(SduiCoreSystem.Analytics.SduiUsageRecorder)
local recordV1ComponentUsage = require(SduiCoreSystem.Analytics.recordV1ComponentUsage)

local function recordV1RegisteredTemplates(p: string, items)
	if not items then
		return
	end

	if SduiUsageRecorder.isTypeSamplingEnabled() or SduiUsageRecorder.isParamSamplingEnabled() then
		for _, item in items do
			pcall(recordV1ComponentUsage, p, item)
		end
	end
end

return recordV1RegisteredTemplates
