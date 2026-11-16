local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

local SduiUsageRecorder = require(SduiCoreSystem.Analytics.SduiUsageRecorder)

local function unwrapOneofProp(p) -- 2 equivalent calls inferred from this helper
	if p and p.oneof_prop and p.oneof_prop.value then
		return p.oneof_prop.value
	end

	return p
end

local recordV2ActionPropDefinition

local function unwrapInnerActionConfig(value) -- 2 equivalent calls inferred from this helper
	if typeof(value) ~= "table" then
		return nil
	end

	local kind = value.kind

	if typeof(kind) == "table" and typeof(kind.value) == "table" then
		return kind.value
	end

	return if typeof(value.action_type) == "string" then value else nil
end

local function recordV2ActionConfig(p: string, value)
	if typeof(value) ~= "table" then
		return
	end

	local action_type = value.action_type

	if typeof(action_type) ~= "string" then
		return
	end

	local ProtoVariableMapper = require(SduiCoreSystem.ClientBinding.ProtoVariableMapper)
	local mapActionTypeToLua = ProtoVariableMapper.mapActionTypeToLua(action_type)

	if not mapActionTypeToLua then
		return
	end

	if SduiUsageRecorder.isTypeSamplingEnabled() then
		SduiUsageRecorder.recordActionType(p, "v2", mapActionTypeToLua)
	end

	local action_params = value.action_params

	if typeof(action_params) ~= "table" then
		return
	end

	local paramSamplingEnabled = SduiUsageRecorder.isParamSamplingEnabled()

	for k, action_param in action_params do
		if typeof(k) == "string" and paramSamplingEnabled then
			SduiUsageRecorder.recordActionParam(p, "v2", mapActionTypeToLua, k)
		end

		action_param = unwrapOneofProp(action_param) -- inferred equivalent call
		local descriptor = action_param and action_param.descriptor

		if descriptor and descriptor.name == "ActionProp" then
			recordV2ActionPropDefinition(p, action_param)
		end
	end
end

recordV2ActionPropDefinition = function(p, p2)
	local kind = p2 and p2.kind
	local value = kind and kind.value

	if not value then
		return
	end

	if kind.type == "conditional" then
		local options = value.options

		if typeof(options) ~= "table" then
			return
		end

		for _, option in options do
			local value2 = option and option.kind and option.kind.value
			value2 = unwrapInnerActionConfig(value2) -- inferred equivalent call

			if value2 then
				recordV2ActionConfig(p, value2)
			end
		end
	else
		value = unwrapInnerActionConfig(value) -- inferred equivalent call

		if value then
			recordV2ActionConfig(p, value)
		end
	end
end

local function recordTemplateUsage(p: string, p2)
	if not p2 then
		return
	end

	local typeSamplingEnabled = SduiUsageRecorder.isTypeSamplingEnabled()
	local paramSamplingEnabled = SduiUsageRecorder.isParamSamplingEnabled()

	if not (typeSamplingEnabled or paramSamplingEnabled) then
		return
	end

	local value = p2.kind and p2.kind.value

	if not value then
		return
	end

	local component_type = value.shared and value.shared.component_type

	if not component_type then
		return
	end

	local ProtoVariableMapper = require(SduiCoreSystem.ClientBinding.ProtoVariableMapper)
	local mapUiComponentTypeToLua = ProtoVariableMapper.mapUiComponentTypeToLua(component_type)

	if not mapUiComponentTypeToLua then
		return
	end

	if typeSamplingEnabled then
		SduiUsageRecorder.recordComponentType(p, "v2", mapUiComponentTypeToLua)
	end

	local props = value.props

	if not props then
		return
	end

	for k, v in props do
		if typeof(k) ~= "string" then
			continue
		end

		if paramSamplingEnabled then
			SduiUsageRecorder.recordProp(p, "v2", mapUiComponentTypeToLua, k)
		end

		v = unwrapOneofProp(v) -- inferred equivalent call
		local descriptor = v and v.descriptor

		if descriptor and descriptor.name == "ActionProp" then
			recordV2ActionPropDefinition(p, v)
		end
	end
end

return recordTemplateUsage
