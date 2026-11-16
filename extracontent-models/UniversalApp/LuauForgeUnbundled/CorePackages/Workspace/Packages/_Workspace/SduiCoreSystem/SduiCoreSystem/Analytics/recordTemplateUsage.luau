local SduiUsageRecorder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/Analytics/SduiUsageRecorder")

local function unwrapOneofProp(p2)
	if p2 and p2.oneof_prop and p2.oneof_prop.value then
		return p2.oneof_prop.value
	end

	return p2
end

local recordV2ActionPropDefinition

local function unwrapInnerActionConfig(p2)
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

local function recordV2ActionConfig(p2, value)
	if typeof(value) ~= "table" then
		return
	end

	local action_type = value.action_type

	if typeof(action_type) ~= "string" then
		return
	end

	local mapActionTypeToLua = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/ProtoVariableMapper").mapActionTypeToLua(action_type)

	if not mapActionTypeToLua then
		return
	end

	if SduiUsageRecorder.isTypeSamplingEnabled() then
		SduiUsageRecorder.recordActionType(p2, "v2", mapActionTypeToLua)
	end

	local action_params = value.action_params

	if typeof(action_params) ~= "table" then
		return
	end

	local paramSamplingEnabled = SduiUsageRecorder.isParamSamplingEnabled()

	for k, value2 in action_params do
		if typeof(k) == "string" and paramSamplingEnabled then
			SduiUsageRecorder.recordActionParam(p2, "v2", mapActionTypeToLua, k)
		end

		if value2 and value2.oneof_prop and value2.oneof_prop.value then
			value2 = value2.oneof_prop.value
		end

		local descriptor = value2 and value2.descriptor

		if descriptor and descriptor.name == "ActionProp" then
			recordV2ActionPropDefinition(p2, value2)
		end
	end
end

recordV2ActionPropDefinition = function(p2, value)
	local kind = value and value.kind
	local value2 = kind and kind.value

	if not value2 then
		return
	end

	if kind.type == "conditional" then
		local options = value2.options

		if typeof(options) ~= "table" then
			return
		end

		for k, option in options do
			local value3 = option and option.kind and option.kind.value

			if typeof(value3) == "table" then
				local kind2 = value3.kind

				if typeof(kind2) == "table" and typeof(kind2.value) == "table" then
					value3 = kind2.value
				elseif typeof(value3.action_type) ~= "string" then
					value3 = nil
				end
			else
				value3 = nil
			end

			if value3 then
				recordV2ActionConfig(p2, value3)
			end
		end
	else
		if typeof(value2) == "table" then
			local kind2 = value2.kind

			if typeof(kind2) == "table" and typeof(kind2.value) == "table" then
				value2 = kind2.value
			elseif typeof(value2.action_type) ~= "string" then
				value2 = nil
			end
		else
			value2 = nil
		end

		if value2 then
			recordV2ActionConfig(p2, value2)
		end
	end
end

local function recordTemplateUsage(p2, p3)
	if not p3 then
		return
	end

	local typeSamplingEnabled = SduiUsageRecorder.isTypeSamplingEnabled()
	local paramSamplingEnabled = SduiUsageRecorder.isParamSamplingEnabled()

	if not (typeSamplingEnabled or paramSamplingEnabled) then
		return
	end

	local value = p3.kind and p3.kind.value

	if not value then
		return
	end

	local component_type = value.shared and value.shared.component_type

	if not component_type then
		return
	end

	local mapUiComponentTypeToLua = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/ProtoVariableMapper").mapUiComponentTypeToLua(component_type)

	if not mapUiComponentTypeToLua then
		return
	end

	if typeSamplingEnabled then
		SduiUsageRecorder.recordComponentType(p2, "v2", mapUiComponentTypeToLua)
	end

	local props = value.props

	if not props then
		return
	end

	for k, value2 in props do
		if typeof(k) ~= "string" then
			continue
		end

		if paramSamplingEnabled then
			SduiUsageRecorder.recordProp(p2, "v2", mapUiComponentTypeToLua, k)
		end

		if value2 and value2.oneof_prop and value2.oneof_prop.value then
			value2 = value2.oneof_prop.value
		end

		local descriptor = value2 and value2.descriptor

		if descriptor and descriptor.name == "ActionProp" then
			recordV2ActionPropDefinition(p2, value2)
		end
	end
end

return recordTemplateUsage
