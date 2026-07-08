local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiUsageRecorder = require(SduiCoreSystem.Analytics.SduiUsageRecorder)

local function unwrapOneofProp(p1) -- line: 23
	if p1 and (p1.oneof_prop and p1.oneof_prop.value) then
		return p1.oneof_prop.value
	end

	return p1
end

local recordV2ActionPropDefinition = nil

local function unwrapInnerActionConfig(p2) -- line: 37
	if typeof(p2) ~= "table" then
		return nil
	end

	local kind = p2.kind

	if typeof(kind) == "table" and typeof(kind.value) == "table" then
		return kind.value
	end

	if typeof(p2.action_type) == "string" then
		return p2
	end

	return nil
end
local function recordV2ActionConfig(s1: string, p3) -- line: 56
	-- upvalues: SduiCoreSystem (copy), SduiUsageRecorder (copy), recordV2ActionPropDefinition (ref)
	if typeof(p3) ~= "table" then
		return
	end

	local action_type = p3.action_type

	if typeof(action_type) ~= "string" then
		return
	end

	local v14 = require(SduiCoreSystem.ClientBinding.ProtoVariableMapper).mapActionTypeToLua(action_type)

	if not v14 then
		return
	end

	if SduiUsageRecorder.isTypeSamplingEnabled() then
		SduiUsageRecorder.recordActionType(s1, "v2", v14)
	end

	local action_params = p3.action_params

	if typeof(action_params) ~= "table" then
		return
	end

	local v16 = SduiUsageRecorder.isParamSamplingEnabled()

	for v17, v18 in action_params do
		if typeof(v17) == "string" and v16 then
			SduiUsageRecorder.recordActionParam(s1, "v2", v14, v17)
		end

		local v19 = if not v18 or (not v18.oneof_prop or not v18.oneof_prop.value) then v18 else v18.oneof_prop.value
		local v20 = v19 and v19.descriptor

		if v20 and v20.name == "ActionProp" then
			recordV2ActionPropDefinition(s1, v19)
		end
	end
end

function recordV2ActionPropDefinition(p4, p5) -- line: 95
	-- upvalues: recordV2ActionConfig (copy)
	local v23 = p5 and p5.kind
	local v24 = v23 and v23.value

	if not v24 then
		return
	end

	if v23.type == "conditional" then
		local options = v24.options

		if typeof(options) ~= "table" then
			return
		end

		for _, v27 in options do
			local v28 = v27 and (v27.kind and v27.kind.value)
			local v29

			if typeof(v28) ~= "table" then
				v29 = nil
			else
				local kind = v28.kind

				v29 = if typeof(kind) ~= "table" or typeof(kind.value) ~= "table" then if typeof(v28.action_type) ~= "string" then nil else v28 else kind.value
			end

			if v29 then
				recordV2ActionConfig(p4, v29)
			end
		end

		return
	end

	local v31

	if typeof(v24) ~= "table" then
		v31 = nil
	else
		local kind = v24.kind

		v31 = if typeof(kind) ~= "table" or typeof(kind.value) ~= "table" then if typeof(v24.action_type) ~= "string" then nil else v24 else kind.value
	end

	if v31 then
		recordV2ActionConfig(p4, v31)
	end
end

local function recordTemplateUsage(s2: string, p6) -- line: 123
	-- upvalues: SduiUsageRecorder (copy), SduiCoreSystem (copy), recordV2ActionPropDefinition (ref)
	if not p6 then
		return
	end

	local v35 = SduiUsageRecorder.isTypeSamplingEnabled()
	local v36 = SduiUsageRecorder.isParamSamplingEnabled()

	if not v35 and not v36 then
		return
	end

	local v37 = p6.kind and p6.kind.value

	if not v37 then
		return
	end

	local v38 = v37.shared and v37.shared.component_type

	if not v38 then
		return
	end

	local v39 = require(SduiCoreSystem.ClientBinding.ProtoVariableMapper).mapUiComponentTypeToLua(v38)

	if not v39 then
		return
	end

	if v35 then
		SduiUsageRecorder.recordComponentType(s2, "v2", v39)
	end

	local props = v37.props

	if not props then
		return
	end

	for v41, v42 in props do
		if typeof(v41) == "string" then
			if v36 then
				SduiUsageRecorder.recordProp(s2, "v2", v39, v41)
			end

			local v43 = if not v42 or (not v42.oneof_prop or not v42.oneof_prop.value) then v42 else v42.oneof_prop.value
			local v44 = v43 and v43.descriptor

			if v44 and v44.name == "ActionProp" then
				recordV2ActionPropDefinition(s2, v43)
			end
		end
	end
end

return recordTemplateUsage
