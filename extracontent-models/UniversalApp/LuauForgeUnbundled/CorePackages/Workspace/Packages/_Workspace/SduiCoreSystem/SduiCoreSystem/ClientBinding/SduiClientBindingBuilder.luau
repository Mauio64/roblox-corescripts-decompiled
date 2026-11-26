local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")
local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local addSduiErrorContextFields = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/addSduiErrorContextFields")
local SduiLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiLogger")
local buildDataBindingSourcesForTemplate = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/buildDataBindingSourcesForTemplate")

local buildAnalyticsContextForClientBinding = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/buildAnalyticsContextForClientBinding")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
local SduiComponentType = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")
local propResultCategory = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes").PropResultCategory
local ProtoVariableMapper = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/ProtoVariableMapper")
local SduiParseHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiParseHelpers")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags")
local fFlagSduiExperimentalComponent = SharedFlags.FFlagSduiExperimentalComponent
local fFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths
local function buildProp(data, p2, p3, p4, p5, currentParserName)
	if data.oneof_prop and data.oneof_prop.value then
		local v5

		if fFlagSduiExperimentalComponent then
			v5 = data.prop_builder

			if v5 == nil then
				v5 = currentParserName
			end
		else
			v5 = currentParserName
		end

		return buildProp(data.oneof_prop.value, p2, p3, p4, p5, v5)
	else
		if typeof(data) == "table" and data.descriptor == nil then
			return p4.getPropBuilder("ContainerProp")(nil, data, p2, p3, p4, p5)
		end

		local kind = data and data.kind and data.kind.type

		if kind == nil then
			error("No propDefinitionType provided")
		end

		if data.descriptor == nil then
			error(`No propDefinitionType descriptor provided for {kind}`)
		end

		local name = data.descriptor.name
		local v5 = fFlagSduiExperimentalComponent and currentParserName ~= nil

		if not v5 then
			currentParserName = name
		end

		p4.currentParserName = currentParserName

		local propBuilder = p4.getPropBuilder(currentParserName, v5)

		local value = data.kind and data.kind.value

		if value == nil then
			error(`No propDefinitionValue provided for {kind}`)
		end

		local v6, v7, v8 = propBuilder(kind, value, p2, p3, p4, p5)

		return v6, v7, v8
	end
end

local function buildPropTable(analytics_data, p2, callback, data, p3)
	local propsByMapPropName = {}

	if analytics_data == nil then
		error("Attempt to buildPropTable with nil")
	end

	local currentComponentType = data.currentComponentType
	local propsByMapPropName2 = nil
	local propsByMapPropName3 = nil
	local mapPropNameSet = nil

	for k, item in analytics_data do
		local mapPropName = ProtoVariableMapper.mapPropName(k)
		local success, result = pcall(function()
			local prop, v5, v6 = buildProp(item, p2, callback, data, p3)

			if v5 == propResultCategory.PropSignal then
				if propsByMapPropName2 == nil then
					propsByMapPropName2 = {}
				end

				propsByMapPropName2[mapPropName] = prop
			elseif v5 == propResultCategory.NestedComponentConfig then
				if propsByMapPropName3 == nil then
					propsByMapPropName3 = {}
				end

				propsByMapPropName3[mapPropName] = prop
			elseif v5 == propResultCategory.NestedComponentConfigListPropSignal then
				if propsByMapPropName2 == nil then
					propsByMapPropName2 = {}
				end

				propsByMapPropName2[mapPropName] = prop

				if mapPropNameSet == nil then
					mapPropNameSet = {}
				end

				mapPropNameSet[mapPropName] = true
			elseif v5 == propResultCategory.Failed then
				propsByMapPropName[mapPropName] = prop

				local v7 = {
					message = `ClientBinding - failed to build prop {mapPropName}: {prop}, {v6}`,
					propName = `{mapPropName}`,
					name = data.debugName,
					componentType = currentComponentType,
					parserName = item.descriptor.name,
					value = item
				}

				if fFlagSduiErrorPaths then
					addSduiErrorContextFields(v7, data.errorContext)
				end

				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v7, data.appPage)
			else
				if v5 == propResultCategory.Literal then
					propsByMapPropName[mapPropName] = prop
					return
				end

				local v7 = {
					message = `ClientBinding - unexpected propResultCategory: {v5}. {mapPropName}: {prop}, {v6}`,
					propName = `{mapPropName}`,
					name = data.debugName,
					componentType = currentComponentType,
					parserName = item.descriptor.name,
					value = item
				}

				if fFlagSduiErrorPaths then
					addSduiErrorContextFields(v7, data.errorContext)
				end

				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v7, data.appPage)

				propsByMapPropName[mapPropName] = prop
			end
		end)

		if success then
			continue
		end

		local v5 = {
			message = `ClientBinding - failed to build prop {mapPropName}: {result}. {result}`,
			propName = `{mapPropName}`,
			name = data.debugName,
			componentType = currentComponentType,
			parserName = item.descriptor.name,
			value = item
		}

		if fFlagSduiErrorPaths then
			addSduiErrorContextFields(v5, data.errorContext)
		end

		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v5, data.appPage)
	end

	return propsByMapPropName, propsByMapPropName2, propsByMapPropName3, mapPropNameSet
end

local v5 = {
	__index = function(p2, p3)
		if p3 == "analyticsData" then
			return p2.analyticsContext and p2.analyticsContext.analyticsData
		end

		return nil
	end
}

local function resolveComponentType(value)
	if fFlagSduiExperimentalComponent then
		local v6 = nil

		if value.experimental_type then
			v6 = SduiComponentType[value.experimental_type]
		else
			local component_type = value.shared and value.shared.component_type

			if component_type then
				v6 = ProtoVariableMapper.mapUiComponentTypeToLua(component_type)
			end
		end

		if not v6 then
			error("Could not determine ui component type")
		end

		return v6
	else
		local component_type = value.shared and value.shared.component_type

		if not component_type then
			error("Could not determine ui component type")
		end

		return ProtoVariableMapper.mapUiComponentTypeToLua(component_type)
	end
end

return {
	buildPropTable = buildPropTable,
	buildProp = buildProp,
	buildConfigForComponent = function(p2, callback, state, p3, p4, p5, options, p6, p7)
		if not (p2 and next(p2)) then
			error("Attempt to buildConfigForComponent with nil template")
		end

		local value = p2.kind.value

		local componentType = resolveComponentType(value)
		local v6

		if fFlagSduiErrorPaths then
			v6 = options or {}
			local errorContext = state.errorContext
			local v7 = if errorContext then errorContext.fullName else state.appPage
			local v8 = if errorContext then errorContext.rctPath else nil
			local v9 = p6 or componentType or p2.kind.type

			local v11 = if p7 and p7 ~= "" then `{v7}.{v9}[{p7}]` else `{v7}.{v9}`

			if p6 then
				v8 = if v8 then `{v8}.{p6}` else p6
			end

			local v12 = if p6 then state.getTemplateIdForRCT and state.getTemplateIdForRCT(p6) else errorContext and errorContext.templateId
			v6.errorContext = { fullName = v11, rctPath = v8, templateId = v12 }

			state = table.clone(state)
			state.errorContext = v6.errorContext
		end

		state.currentComponentType = componentType

		if p5 == nil then
			local data = value.shared and value.shared.data or {}
			p5 = Signals.createComputed(function(p8)
				local success, result = pcall(function()
					return buildDataBindingSourcesForTemplate(callback(p8), data)
				end)

				if success then
					return result
				end

				local v7 = {
					name = state.debugName,
					componentType = componentType,
					message = SduiParseHelpers.stringifyValue(result)
				}

				if fFlagSduiErrorPaths then
					addSduiErrorContextFields(v7, state.errorContext)
				end

				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToBuildBindingSources, v7, state.appPage)

				return {}
			end)
		end

		local configForComponent = not fFlagSduiErrorPaths and (options or {}) or v6

		configForComponent.__processed = true
		configForComponent.__isClientBinding = true
		configForComponent.componentType = componentType
		setmetatable(configForComponent, v5)
		local v7, v8

		if value.shared and value.shared.analytics_data then
			v7, v8 = buildPropTable(value.shared.analytics_data, p5, callback, state, nil)
		end

		configForComponent.analyticsContext = buildAnalyticsContextForClientBinding(v7, v8, p3, state)

		if value.props then
			local v11, v12, v13, v14 = buildPropTable(
				value.props,
				p5,
				callback,
				state,
				configForComponent.analyticsContext
			)
			configForComponent.props = v11

			if v12 ~= nil and next(v12) then
				configForComponent.propSignals = v12
			end

			if v13 ~= nil and next(v13) then
				configForComponent.nestedComponentConfigs = v13
			end

			if v14 ~= nil and next(v14) then
				configForComponent.nestedComponentConfigListPropSignalNames = v14
			end
		end

		if not (value.shared and value.shared.is_component_filtered) then
			return configForComponent
		end

		local is_component_filtered = value.shared.is_component_filtered
		local success, result, v9, v10 = pcall(function()
			return buildProp(
				is_component_filtered,
				p5,
				callback,
				state,
				configForComponent.analyticsContext
			)
		end)

		if success and not v10 and v9 ~= propResultCategory.Failed then
			if v9 == propResultCategory.PropSignal then
				configForComponent.isComponentFilteredSignal = result
			elseif v9 == propResultCategory.Literal then
				function configForComponent.isComponentFilteredSignal()
					return { data = result }
				end
			end
		else
			local v11 = if v10 then SduiParseHelpers.stringifyValue(v10) else SduiParseHelpers.stringifyValue(result)
			local stringifyValue = SduiParseHelpers.stringifyValue(is_component_filtered)
			local v12 = {
				message = `Failed to build is_component_filtered prop: {v11}`,
				name = state.debugName,
				componentType = componentType,
				value = stringifyValue
			}

			if fFlagSduiErrorPaths then
				addSduiErrorContextFields(v12, state.errorContext)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v12, state.appPage)
		end

		return configForComponent
	end
}
