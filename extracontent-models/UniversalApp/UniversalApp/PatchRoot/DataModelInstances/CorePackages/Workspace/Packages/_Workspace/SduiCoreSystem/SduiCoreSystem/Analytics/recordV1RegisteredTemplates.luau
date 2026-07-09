local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiUsageRecorder = require(SduiCoreSystem.Analytics.SduiUsageRecorder)
local recordV1ComponentUsage = require(SduiCoreSystem.Analytics.recordV1ComponentUsage)

local function recordV1RegisteredTemplates(s1: string, t1: {[any]: any}?) -- line: 18
	-- upvalues: SduiUsageRecorder (copy), recordV1ComponentUsage (copy)
	if not t1 then
		return
	end

	if not SduiUsageRecorder.isTypeSamplingEnabled() and not SduiUsageRecorder.isParamSamplingEnabled() then
		return
	end

	for _, v8 in t1 do
		pcall(recordV1ComponentUsage, s1, v8)
	end
end

return recordV1RegisteredTemplates
