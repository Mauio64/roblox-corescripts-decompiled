local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent

local Signals = require(parent.Signals)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local addSduiErrorContextFields = require(SduiCoreSystem.addSduiErrorContextFields)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local buildDataBindingSourcesForTemplate = require(SduiCoreSystem.ClientBinding.buildDataBindingSourcesForTemplate)

local buildAnalyticsContextForClientBinding = require(SduiCoreSystem.ClientBinding.buildAnalyticsContextForClientBinding)
require(SduiCoreSystem.SduiBuilderTypes)
local SduiComponentType = require(SduiCoreSystem.SduiComponentType)
local SduiClientBindingTypes = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local PropResultCategory = SduiClientBindingTypes.PropResultCategory
local ProtoVariableMapper = require(SduiCoreSystem.ClientBinding.ProtoVariableMapper)
local SduiParseHelpers = require(SduiCoreSystem.SduiParseHelpers)

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiExperimentalComponent = SharedFlags.FFlagSduiExperimentalComponent
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths
local function buildProp(data, p, p2, p3, p4, currentParserName: string?)
	if data.oneof_prop and data.oneof_prop.value then
		local v

		if FFlagSduiExperimentalComponent then
			v = data.prop_builder

			if v == nil then
				v = currentParserName
			end
		else
			v = currentParserName
		end

		return buildProp(data.oneof_prop.value, p, p2, p3, p4, v)
	else
		if typeof(data) == "table" and data.descriptor == nil then
			return p3.getPropBuilder("ContainerProp")(nil, data, p, p2, p3, p4)
		end

		local kind = data and data.kind and data.kind.type

		if kind == nil then
			error("No propDefinitionType provided")
		end

		if data.descriptor == nil then
			error(`No propDefinitionType descriptor provided for {kind}`)
		end

		local name = data.descriptor.name
		local v = FFlagSduiExperimentalComponent and currentParserName ~= nil

		if not v then
			currentParserName = name
		end

		p3.currentParserName = currentParserName

		local propBuilder = p3.getPropBuilder(currentParserName, v)

		local value = data.kind and data.kind.value

		if value == nil then
			error(`No propDefinitionValue provided for {kind}`)
		end

		local v2, v3, v4 = propBuilder(kind, value, p, p2, p3, p4)

		return v2, v3, v4
	end
end

local function buildPropTable(items, p, callback, data, p2)
	local propsByMapPropName = {}

	if items == nil then
		error("Attempt to buildPropTable with nil")
	end

	local currentComponentType = data.currentComponentType
	local propsByMapPropName2 = nil
	local propsByMapPropName3 = nil
	local mapPropNameSet = nil

	for k, item in items do
		local mapPropName = ProtoVariableMapper.mapPropName(k)
		local success, result = pcall(function()
			local prop, v, v2 = buildProp(item, p, callback, data, p2)

			if v == PropResultCategory.PropSignal then
				if propsByMapPropName2 == nil then
					propsByMapPropName2 = {}
				end

				propsByMapPropName2[mapPropName] = prop
			elseif v == PropResultCategory.NestedComponentConfig then
				if propsByMapPropName3 == nil then
					propsByMapPropName3 = {}
				end

				propsByMapPropName3[mapPropName] = prop
			elseif v == PropResultCategory.NestedComponentConfigListPropSignal then
				if propsByMapPropName2 == nil then
					propsByMapPropName2 = {}
				end

				propsByMapPropName2[mapPropName] = prop

				if mapPropNameSet == nil then
					mapPropNameSet = {}
				end

				mapPropNameSet[mapPropName] = true
			elseif v == PropResultCategory.Failed then
				propsByMapPropName[mapPropName] = prop

				local v3 = {
					message = `ClientBinding - failed to build prop {mapPropName}: {prop}, {v2}`,
					propName = `{mapPropName}`,
					name = data.debugName,
					componentType = currentComponentType,
					parserName = item.descriptor.name,
					value = item
				}

				if FFlagSduiErrorPaths then
					addSduiErrorContextFields(v3, data.errorContext)
				end

				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v3, data.appPage)
			else
				if v == PropResultCategory.Literal then
					propsByMapPropName[mapPropName] = prop
					return
				end

				local v3 = {
					message = `ClientBinding - unexpected propResultCategory: {v}. {mapPropName}: {prop}, {v2}`,
					propName = `{mapPropName}`,
					name = data.debugName,
					componentType = currentComponentType,
					parserName = item.descriptor.name,
					value = item
				}

				if FFlagSduiErrorPaths then
					addSduiErrorContextFields(v3, data.errorContext)
				end

				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v3, data.appPage)

				propsByMapPropName[mapPropName] = prop
			end
		end)

		if success then
			continue
		end

		local v = {
			message = `ClientBinding - failed to build prop {mapPropName}: {result}. {result}`,
			propName = `{mapPropName}`,
			name = data.debugName,
			componentType = currentComponentType,
			parserName = item.descriptor.name,
			value = item
		}

		if FFlagSduiErrorPaths then
			addSduiErrorContextFields(v, data.errorContext)
		end

		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v, data.appPage)
	end

	return propsByMapPropName, propsByMapPropName2, propsByMapPropName3, mapPropNameSet
end

local v = {
	__index = function(p, p2)
		if p2 == "analyticsData" then
			return p.analyticsContext and p.analyticsContext.analyticsData
		end

		return nil
	end
}

local function resolveComponentType(value)
	if FFlagSduiExperimentalComponent then
		local v2 = nil

		if value.experimental_type then
			v2 = SduiComponentType[value.experimental_type]
		else
			local component_type = value.shared and value.shared.component_type

			if component_type then
				v2 = ProtoVariableMapper.mapUiComponentTypeToLua(component_type)
			end
		end

		if not v2 then
			error("Could not determine ui component type")
		end

		return v2
	else
		local component_type = value.shared and value.shared.component_type

		if not component_type then
			error("Could not determine ui component type")
		end

		return (ProtoVariableMapper.mapUiComponentTypeToLua(component_type))
	end
end

return {
	buildPropTable = buildPropTable,
	buildProp = buildProp,
	buildConfigForComponent = function(p, callback, state, p2, _, p3, options, p4: string?, p5: string?)
		if not (p and next(p)) then
			error("Attempt to buildConfigForComponent with nil template")
		end

		local value = p.kind.value

		local componentType = resolveComponentType(value)
		local v2

		if FFlagSduiErrorPaths then
			v2 = options or {}
			local errorContext = state.errorContext
			local v3

			if errorContext then
				v3 = errorContext.fullName
			else
				v3 = state.appPage
			end

			local rctPath

			if errorContext then
				rctPath = errorContext.rctPath
			end

			local v4 = p4 or componentType or p.kind.type
			local fullName

			if p5 and p5 ~= "" then
				fullName = `{v3}.{v4}[{p5}]`
			else
				fullName = `{v3}.{v4}`
			end

			if p4 then
				if rctPath then
					rctPath = `{rctPath}.{p4}`
				else
					rctPath = p4
				end
			end

			local templateId

			if p4 then
				templateId = state.getTemplateIdForRCT and state.getTemplateIdForRCT(p4)
			else
				templateId = errorContext and errorContext.templateId
			end

			v2.errorContext = { fullName = fullName, rctPath = rctPath, templateId = templateId }

			state = table.clone(state)
			state.errorContext = v2.errorContext
		end

		state.currentComponentType = componentType

		if p3 == nil then
			local data = value.shared and value.shared.data or {}
			p3 = Signals.createComputed(function(p6)
				local success, result = pcall(function()
					return buildDataBindingSourcesForTemplate(callback(p6), data)
				end)

				if success then
					return result
				end

				local v3 = {
					name = state.debugName,
					componentType = componentType,
					message = SduiParseHelpers.stringifyValue(result)
				}

				if FFlagSduiErrorPaths then
					addSduiErrorContextFields(v3, state.errorContext)
				end

				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToBuildBindingSources, v3, state.appPage)

				return {}
			end)
		end

		local configForComponent = not FFlagSduiErrorPaths and (options or {}) or v2

		configForComponent.__processed = true
		configForComponent.__isClientBinding = true
		configForComponent.componentType = componentType
		setmetatable(configForComponent, v)
		local v3, v4

		if value.shared and value.shared.analytics_data then
			v3, v4 = buildPropTable(value.shared.analytics_data, p3, callback, state, nil)
		end

		configForComponent.analyticsContext = buildAnalyticsContextForClientBinding(v3, v4, p2, state)

		if value.props then
			local propTable, propSignals, nestedComponentConfigs, nestedComponentConfigListPropSignalNames = buildPropTable(
				value.props,
				p3,
				callback,
				state,
				configForComponent.analyticsContext
			)
			configForComponent.props = propTable

			if propSignals ~= nil and next(propSignals) then
				configForComponent.propSignals = propSignals
			end

			if nestedComponentConfigs ~= nil and next(nestedComponentConfigs) then
				configForComponent.nestedComponentConfigs = nestedComponentConfigs
			end

			if nestedComponentConfigListPropSignalNames ~= nil and next(nestedComponentConfigListPropSignalNames) then
				configForComponent.nestedComponentConfigListPropSignalNames = nestedComponentConfigListPropSignalNames
			end
		end

		if not (value.shared and value.shared.is_component_filtered) then
			return configForComponent
		end

		local is_component_filtered = value.shared.is_component_filtered
		local success, result, v5, v6 = pcall(function()
			return buildProp(is_component_filtered, p3, callback, state, configForComponent.analyticsContext)
		end)

		if success and not v6 and v5 ~= PropResultCategory.Failed then
			if v5 == PropResultCategory.PropSignal then
				configForComponent.isComponentFilteredSignal = result
			elseif v5 == PropResultCategory.Literal then
				function configForComponent.isComponentFilteredSignal()
					return { data = result }
				end
			end
		else
			local v7

			if v6 then
				v7 = SduiParseHelpers.stringifyValue(v6)
			else
				v7 = SduiParseHelpers.stringifyValue(result)
			end

			local stringifyValue = SduiParseHelpers.stringifyValue(is_component_filtered)
			local v8 = {
				message = `Failed to build is_component_filtered prop: {v7}`,
				name = state.debugName,
				componentType = componentType,
				value = stringifyValue
			}

			if FFlagSduiErrorPaths then
				addSduiErrorContextFields(v8, state.errorContext)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v8, state.appPage)
		end

		return configForComponent
	end
}
