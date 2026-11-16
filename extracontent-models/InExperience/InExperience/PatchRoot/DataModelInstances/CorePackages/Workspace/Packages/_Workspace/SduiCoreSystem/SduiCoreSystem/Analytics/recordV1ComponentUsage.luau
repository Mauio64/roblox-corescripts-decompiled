local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

local SduiUsageRecorder = require(SduiCoreSystem.Analytics.SduiUsageRecorder)
local function recordV1ComponentUsage(p: string, child)
	if not child then
		return
	end

	local typeSamplingEnabled = SduiUsageRecorder.isTypeSamplingEnabled()
	local paramSamplingEnabled = SduiUsageRecorder.isParamSamplingEnabled()

	if not (typeSamplingEnabled or paramSamplingEnabled) then
		return
	end

	local componentType = child.componentType

	if typeof(componentType) ~= "string" then
		return
	end

	if typeSamplingEnabled then
		SduiUsageRecorder.recordComponentType(p, "v1", componentType)
	end

	local recordActionConfig
	local function visitValueForActions(p2)
		if typeof(p2) ~= "table" then
			return
		end

		if typeof(p2.actionType) == "string" then
			recordActionConfig(p2)
			return
		end

		for _, v in p2 do
			if typeof(v) == "table" then
				visitValueForActions(v)
			end
		end
	end

	recordActionConfig = function(p2)
		local actionType = p2.actionType

		if typeof(actionType) ~= "string" then
			return
		end

		if typeSamplingEnabled then
			SduiUsageRecorder.recordActionType(p, "v1", actionType)
		end

		local actionParams = p2.actionParams

		if typeof(actionParams) ~= "table" then
			return
		end

		for k, actionParam in actionParams do
			if typeof(k) == "string" and paramSamplingEnabled then
				SduiUsageRecorder.recordActionParam(p, "v1", actionType, k)
			end

			visitValueForActions(actionParam)
		end
	end

	local function walkProps(items)
		if typeof(items) ~= "table" then
			return
		end

		for k, item in items do
			if typeof(k) == "string" and paramSamplingEnabled then
				SduiUsageRecorder.recordProp(p, "v1", componentType, k)
			end

			visitValueForActions(item)
		end
	end

	walkProps(child.props)

	if typeof(child.conditionalProps) == "table" then
		for _, conditionalProp in child.conditionalProps do
			if typeof(conditionalProp) == "table" then
				walkProps(conditionalProp.propOverrides)
			end
		end
	end

	if typeof(child.children) == "table" then
		for _, child2 in child.children do
			recordV1ComponentUsage(p, child2)
		end
	end
end

return recordV1ComponentUsage
