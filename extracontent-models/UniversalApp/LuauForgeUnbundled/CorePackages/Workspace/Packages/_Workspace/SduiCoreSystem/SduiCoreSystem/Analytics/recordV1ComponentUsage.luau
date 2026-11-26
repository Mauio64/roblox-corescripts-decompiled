local SduiUsageRecorder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/Analytics/SduiUsageRecorder")
local function recordV1ComponentUsage(p2, child)
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
		SduiUsageRecorder.recordComponentType(p2, "v1", componentType)
	end

	local recordActionConfig
	local function visitValueForActions(p3)
		if typeof(p3) ~= "table" then
			return
		end

		if typeof(p3.actionType) == "string" then
			recordActionConfig(p3)
			return
		end

		for k, v5 in p3 do
			if typeof(v5) == "table" then
				visitValueForActions(v5)
			end
		end
	end

	recordActionConfig = function(p3)
		local actionType = p3.actionType

		if typeof(actionType) ~= "string" then
			return
		end

		if typeSamplingEnabled then
			SduiUsageRecorder.recordActionType(p2, "v1", actionType)
		end

		local actionParams = p3.actionParams

		if typeof(actionParams) ~= "table" then
			return
		end

		for k, actionParam in actionParams do
			if typeof(k) == "string" and paramSamplingEnabled then
				SduiUsageRecorder.recordActionParam(p2, "v1", actionType, k)
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
				SduiUsageRecorder.recordProp(p2, "v1", componentType, k)
			end

			visitValueForActions(item)
		end
	end

	walkProps(child.props)

	if typeof(child.conditionalProps) == "table" then
		for k, conditionalProp in child.conditionalProps do
			if typeof(conditionalProp) == "table" then
				walkProps(conditionalProp.propOverrides)
			end
		end
	end

	if typeof(child.children) == "table" then
		for k, child2 in child.children do
			recordV1ComponentUsage(p2, child2)
		end
	end
end

return recordV1ComponentUsage
