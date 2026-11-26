require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")

local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local SduiLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiLogger")
local createSduiErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/createSduiErrorLogger")
local getSduiActionHandlerRegistry = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/getSduiActionHandlerRegistry")

local getSduiServiceDependenciesStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/getSduiServiceDependenciesStore")
local logActionTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/Analytics/logActionTelemetry")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
local propResultCategory = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes").PropResultCategory
local ProtoVariableMapper = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/ProtoVariableMapper")
local SduiClientBindingBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingBuilder")
local buildPropTable = SduiClientBindingBuilder.buildPropTable
local SduiActionType = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiActionType")
local SduiPropUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiPropUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiConfigTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")
local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiErrorPaths
local fFlagSduiExperimentalComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiExperimentalComponent

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

local function buildActionProp(p2, data, p3, p4, data2, p5)
	local currentComponentType = data2.currentComponentType
	local currentParserName = data2.currentParserName

	if p2 == "value" then
		local v5 = nil
		local success, result = pcall(function()
			local appPage = data2.appPage
			local value = if typeof(data) == "table" and data.kind then data.kind.value or nil else nil

			local experimental_type = if fFlagSduiExperimentalComponent and value then value.experimental_type else nil
			local v6

			if experimental_type then
				v6 = SduiActionType[experimental_type]
			elseif value and value.action_type then
				v6 = ProtoVariableMapper.mapActionTypeToLua(value.action_type)
			end

			v5 = v6

			if not v5 then
				error(`Could not map actionType: {experimental_type or value and value.action_type}`)
			end

			local actionHandlerConfig = getSduiActionHandlerRegistry().getActionHandlerConfig(v5)

			if not actionHandlerConfig then
				error(`Could not find action for actionType: {v5}`)
			end

			return function(p6, p7, p8)
				local v7 = getSduiServiceDependenciesStore().getDependencies(appPage)

				if fFlagSduiErrorPaths and v7 and v7.logger then
					local clone = table.clone(v7)
					clone.logger = createSduiErrorLogger(v7.logger, data2.errorContext, v5)
					v7 = clone
				end

				local v8 = {
					dependencies = v7,
					appPage = appPage,
					configKey = data2.configKey
				}

				local v9 = nil

				if data and data.telemetry_handler then
					local telemetry_handler = data.telemetry_handler

					if telemetry_handler.kind and telemetry_handler.kind.type then
						local v10
						v9, v10 = SduiClientBindingBuilder.buildProp(telemetry_handler, p3, p4, data2, p5)

						if v10 == propResultCategory.PropSignal then
							v9 = v9(false).data
						end
					end
				end

				local v10 = nil

				if data and data.skip_unified_logging then
					local skip_unified_logging = data.skip_unified_logging

					if skip_unified_logging.kind and skip_unified_logging.kind.type then
						local v11
						v10, v11 = SduiClientBindingBuilder.buildProp(skip_unified_logging, p3, p4, data2, p5)

						if v11 == propResultCategory.PropSignal then
							v10 = v10(false).data
						end
					end
				end

				local action_params = value and value.action_params
				local v11 = {
					actionType = v5,
					telemetryHandler = v9,
					skipUnifiedLogging = v10
				}
				local data3

				if action_params and next(action_params) then
					local v12
					data3, v12 = buildPropTable(action_params, p3, p4, data2, p5)

					if v12 then
						for k, v13 in v12 do
							data3[k] = v13(false).data
						end
					end
				end

				v11.actionParams = mergeTemplateParamsWithOverrides(data3, p8)

				logActionTelemetry(v9, actionHandlerConfig, v11, p5, v8)

				if actionHandlerConfig.handler then
					return actionHandlerConfig.handler(v11, p5, v8, p7)
				end
			end
		end)

		if success then
			return result, propResultCategory.Literal
		end

		return function(p6, p7, p8)
			SduiLogger.reportCounter(SduiErrors.SduiCounterName.ExecutedInvalidAction, {
				name = v5,
				componentType = currentComponentType,
				parserName = currentParserName
			})
		end, propResultCategory.Failed, result
	end

	if p2 == "conditional" then
		return
			SduiPropUtils.generateConditionalPropValue(data, p3, data2, p5, p4, buildActionProp),
			propResultCategory.PropSignal
	end

	error(`Could not build prop. Unknown propDefinitionType: {p2}`)
end

return buildActionProp
