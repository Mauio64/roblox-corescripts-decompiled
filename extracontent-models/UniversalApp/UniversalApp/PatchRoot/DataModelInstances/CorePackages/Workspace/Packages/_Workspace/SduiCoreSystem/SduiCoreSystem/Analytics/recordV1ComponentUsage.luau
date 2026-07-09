local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiUsageRecorder = require(SduiCoreSystem.Analytics.SduiUsageRecorder)

local function recordV1ComponentUsage(s1: string, p1) -- line: 21
	-- upvalues: SduiUsageRecorder (copy), recordV1ComponentUsage (copy)
	if not p1 then
		return
	end

	local v6 = SduiUsageRecorder.isTypeSamplingEnabled()
	local v7 = SduiUsageRecorder.isParamSamplingEnabled()

	if not v6 and not v7 then
		return
	end

	local componentType = p1.componentType

	if typeof(componentType) ~= "string" then
		return
	end

	if v6 then
		SduiUsageRecorder.recordComponentType(s1, "v1", componentType)
	end

	local recordActionConfig = nil

	local function visitValueForActions(p2) -- line: 45
		-- upvalues: recordActionConfig (ref), visitValueForActions (copy)
		if typeof(p2) ~= "table" then
			return
		end

		if typeof(p2.actionType) == "string" then
			recordActionConfig(p2)

			return
		end

		for _, v18 in p2 do
			if typeof(v18) == "table" then
				visitValueForActions(v18)
			end
		end
	end

	function recordActionConfig(p3) -- line: 60
		-- upvalues: v6 (copy), SduiUsageRecorder (copy), s1 (copy), v7 (copy), visitValueForActions (copy)
		local actionType = p3.actionType

		if typeof(actionType) ~= "string" then
			return
		end

		if v6 then
			SduiUsageRecorder.recordActionType(s1, "v1", actionType)
		end

		local actionParams = p3.actionParams

		if typeof(actionParams) ~= "table" then
			return
		end

		for v22, v23 in actionParams do
			if typeof(v22) == "string" and v7 then
				SduiUsageRecorder.recordActionParam(s1, "v1", actionType, v22)
			end

			visitValueForActions(v23)
		end
	end

	local function walkProps(p4) -- line: 80
		-- upvalues: v7 (copy), SduiUsageRecorder (copy), s1 (copy), componentType (copy), visitValueForActions (copy)
		if typeof(p4) ~= "table" then
			return
		end

		for v25, v26 in p4 do
			if typeof(v25) == "string" and v7 then
				SduiUsageRecorder.recordProp(s1, "v1", componentType, v25)
			end

			visitValueForActions(v26)
		end
	end

	walkProps(p1.props)

	if typeof(p1.conditionalProps) == "table" then
		for _, v13 in p1.conditionalProps do
			if typeof(v13) == "table" then
				walkProps(v13.propOverrides)
			end
		end
	end

	if typeof(p1.children) == "table" then
		for _, v15 in p1.children do
			recordV1ComponentUsage(s1, v15)
		end
	end
end

return recordV1ComponentUsage
