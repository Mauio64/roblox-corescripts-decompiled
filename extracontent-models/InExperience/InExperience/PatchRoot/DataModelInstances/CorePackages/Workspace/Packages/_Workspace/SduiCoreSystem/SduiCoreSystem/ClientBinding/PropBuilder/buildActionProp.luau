local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

local parent = SduiCoreSystem.Parent
require(parent.Signals)

local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local createSduiErrorLogger = require(SduiCoreSystem.createSduiErrorLogger)
local getSduiActionHandlerRegistry = require(SduiCoreSystem.getSduiActionHandlerRegistry)

local getSduiServiceDependenciesStore = require(SduiCoreSystem.ClientBinding.getSduiServiceDependenciesStore)
local logActionTelemetry = require(SduiCoreSystem.Analytics.logActionTelemetry)
require(SduiCoreSystem.SduiBuilderTypes)
local SduiClientBindingTypes = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local PropResultCategory = SduiClientBindingTypes.PropResultCategory
local ProtoVariableMapper = require(SduiCoreSystem.ClientBinding.ProtoVariableMapper)
local SduiClientBindingBuilder = require(SduiCoreSystem.ClientBinding.SduiClientBindingBuilder)
local buildPropTable = SduiClientBindingBuilder.buildPropTable
local SduiActionType = require(SduiCoreSystem.SduiActionType)
local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)
require(SduiCoreSystem.SduiConfigTypes)
require(SduiCoreSystem.SduiComponentType)
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiExperimentalComponent = SharedFlags2.FFlagSduiExperimentalComponent

local function mergeTemplateParamsWithOverrides(data, items)
	if typeof(items) ~= "table" then
		return data
	end

	local result = not data and {} or table.clone(data)

	for k, item in items do
		result[k] = item
	end

	return result
end

local function buildActionProp(p: string, data, p2, p3, data2, p4)
	local currentComponentType = data2.currentComponentType
	local currentParserName = data2.currentParserName

	if p == "value" then
		local v = nil
		local success, result = pcall(function()
			local appPage = data2.appPage
			local value

			if typeof(data) == "table" and data.kind then
				value = data.kind.value or nil
			else
				value = nil
			end

			local experimental_type

			if FFlagSduiExperimentalComponent and value then
				experimental_type = value.experimental_type
			end

			local v2

			if experimental_type then
				v2 = SduiActionType[experimental_type]
			elseif value and value.action_type then
				v2 = ProtoVariableMapper.mapActionTypeToLua(value.action_type)
			end

			v = v2

			if not v then
				error(`Could not map actionType: {experimental_type or value and value.action_type}`)
			end

			local actionHandlerConfig = getSduiActionHandlerRegistry().getActionHandlerConfig(v)

			if not actionHandlerConfig then
				error(`Could not find action for actionType: {v}`)
			end

			return function(_, p5, p6)
				local dependencies = getSduiServiceDependenciesStore().getDependencies(appPage)

				if FFlagSduiErrorPaths and dependencies and dependencies.logger then
					local clone = table.clone(dependencies)
					clone.logger = createSduiErrorLogger(dependencies.logger, data2.errorContext, v)
					dependencies = clone
				end

				local v3 = {
					dependencies = dependencies,
					appPage = appPage,
					configKey = data2.configKey
				}

				local telemetryHandler = nil

				if data and data.telemetry_handler then
					local telemetry_handler = data.telemetry_handler

					if telemetry_handler.kind and telemetry_handler.kind.type then
						local v4
						telemetryHandler, v4 = SduiClientBindingBuilder.buildProp(telemetry_handler, p2, p3, data2, p4)

						if v4 == PropResultCategory.PropSignal then
							telemetryHandler = telemetryHandler(false).data
						end
					end
				end

				local skipUnifiedLogging = nil

				if data and data.skip_unified_logging then
					local skip_unified_logging = data.skip_unified_logging

					if skip_unified_logging.kind and skip_unified_logging.kind.type then
						local v4
						skipUnifiedLogging, v4 = SduiClientBindingBuilder.buildProp(
							skip_unified_logging,
							p2,
							p3,
							data2,
							p4
						)

						if v4 == PropResultCategory.PropSignal then
							skipUnifiedLogging = skipUnifiedLogging(false).data
						end
					end
				end

				local action_params = value and value.action_params
				local v4 = {
					actionType = v,
					telemetryHandler = telemetryHandler,
					skipUnifiedLogging = skipUnifiedLogging
				}
				local data3

				if action_params and next(action_params) then
					local v5
					data3, v5 = buildPropTable(action_params, p2, p3, data2, p4)

					if v5 then
						for k, v6 in v5 do
							data3[k] = v6(false).data
						end
					end
				end

				v4.actionParams = mergeTemplateParamsWithOverrides(data3, p6)

				logActionTelemetry(telemetryHandler, actionHandlerConfig, v4, p4, v3)

				if actionHandlerConfig.handler then
					return actionHandlerConfig.handler(v4, p4, v3, p5)
				end
			end
		end)

		if success then
			return result, PropResultCategory.Literal
		end

		return function(_, _, _)
			SduiLogger.reportCounter(SduiErrors.SduiCounterName.ExecutedInvalidAction, {
				name = v,
				componentType = currentComponentType,
				parserName = currentParserName
			})
		end, PropResultCategory.Failed, result
	end

	if p == "conditional" then
		return
			SduiPropUtils.generateConditionalPropValue(data, p2, data2, p4, p3, buildActionProp),
			PropResultCategory.PropSignal
	end

	error(`Could not build prop. Unknown propDefinitionType: {p}`)
end

return buildActionProp
