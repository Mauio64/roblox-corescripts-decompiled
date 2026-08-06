local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.Signals)

local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local getSduiActionHandlerRegistry = require(SduiCoreSystem.getSduiActionHandlerRegistry)
local getSduiServiceDependenciesStore = require(SduiCoreSystem.ClientBinding.getSduiServiceDependenciesStore)
local logActionTelemetry = require(SduiCoreSystem.Analytics.logActionTelemetry)
local reportUnifiedLoggingAction = require(SduiCoreSystem.Analytics.reportUnifiedLoggingAction)

require(SduiCoreSystem.SduiBuilderTypes)

local PropResultCategory = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes).PropResultCategory
local ProtoVariableMapper = require(SduiCoreSystem.ClientBinding.ProtoVariableMapper)
local SduiClientBindingBuilder = require(SduiCoreSystem.ClientBinding.SduiClientBindingBuilder)
local buildPropTable = SduiClientBindingBuilder.buildPropTable

require(SduiCoreSystem.SduiActionType)

local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)

require(SduiCoreSystem.SduiConfigTypes)
require(SduiCoreSystem.SduiComponentType)

local FFlagSduiActionsShouldTakeOverrides = require(SduiCoreSystemParent.SharedFlags).FFlagSduiActionsShouldTakeOverrides
local FFlagSduiChartsSupport = require(SduiCoreSystemParent.SharedFlags).FFlagSduiChartsSupport
local FFlagSduiActionTelemetryHandler = require(SduiCoreSystemParent.SharedFlags).FFlagSduiActionTelemetryHandler
local FFlagSduiActionSkipUnifiedLogging = require(SduiCoreSystemParent.SharedFlags).FFlagSduiActionSkipUnifiedLogging
local FFlagSduiImprovedErrorDimensions = require(SduiCoreSystemParent.SharedFlags).FFlagSduiImprovedErrorDimensions
local FFlagSduiExperienceDetailsSupport = require(SduiCoreSystemParent.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagSduiEventDetailsSupport = require(SduiCoreSystemParent.SharedFlags).FFlagSduiEventDetailsSupport
local FFlagSduiOptionSelectorCollection = require(SduiCoreSystemParent.SharedFlags).FFlagSduiOptionSelectorCollection

local function mergeTemplateParamsWithOverrides(t1: {[any]: any}?, p1) -- line: 46
	if typeof(p1) ~= "table" then
		return t1
	end

	local v26 = if not t1 then {} else table.clone(t1)

	for v27, v28 in p1 do
		v26[v27] = v28
	end

	return v26
end
local function buildActionProp(s1: string, p2, p3, p4, p5, p6) -- line: 60
	-- upvalues: FFlagSduiImprovedErrorDimensions (copy), ProtoVariableMapper (copy), getSduiActionHandlerRegistry (copy), getSduiServiceDependenciesStore (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy), FFlagSduiActionTelemetryHandler (copy), SduiClientBindingBuilder (copy), PropResultCategory (copy), FFlagSduiActionSkipUnifiedLogging (copy), buildPropTable (copy), FFlagSduiActionsShouldTakeOverrides (copy), mergeTemplateParamsWithOverrides (copy), logActionTelemetry (copy), SduiLogger (copy), SduiErrors (copy), reportUnifiedLoggingAction (copy), FFlagSduiChartsSupport (copy), FFlagSduiOptionSelectorCollection (copy), SduiPropUtils (copy), buildActionProp (copy)
	local currentComponentType = nil
	local currentParserName = nil

	if FFlagSduiImprovedErrorDimensions then
		currentComponentType = p5.currentComponentType
		currentParserName = p5.currentParserName
	end

	if s1 == "value" then
		local u37 = nil
		local ok, result = pcall(function() -- line: 77
			-- upvalues: p5 (copy), p2 (copy), u37 (ref), ProtoVariableMapper (copy), getSduiActionHandlerRegistry (copy), getSduiServiceDependenciesStore (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy), FFlagSduiActionTelemetryHandler (copy), SduiClientBindingBuilder (copy), p3 (copy), p4 (copy), p6 (copy), PropResultCategory (copy), FFlagSduiActionSkipUnifiedLogging (copy), buildPropTable (copy), FFlagSduiActionsShouldTakeOverrides (copy), mergeTemplateParamsWithOverrides (copy), logActionTelemetry (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref), reportUnifiedLoggingAction (copy), FFlagSduiChartsSupport (copy), FFlagSduiOptionSelectorCollection (copy)
			local appPage = p5.appPage
			local v41 = typeof(p2) == "table" and (not not p2.kind and p2.kind.value) or nil

			u37 = if not v41 or not v41.action_type then nil else ProtoVariableMapper.mapActionTypeToLua(v41.action_type)

			if not u37 then
				error(`Could not map actionType: { v41 and v41.action_type }`)
			end

			local v42 = getSduiActionHandlerRegistry().getActionHandlerConfig(u37)

			if not v42 then
				error(`Could not find action for actionType: { u37 }`)
			end

			return function(_, p8, p9) -- line: 100
				-- upvalues: getSduiServiceDependenciesStore (copy), appPage (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy), p5 (copy), FFlagSduiActionTelemetryHandler (copy), p2 (copy), SduiClientBindingBuilder (copy), p3 (copy), p4 (copy), p6 (copy), PropResultCategory (copy), FFlagSduiActionSkipUnifiedLogging (copy), v41 (copy), u37 (ref), buildPropTable (copy), FFlagSduiActionsShouldTakeOverrides (copy), mergeTemplateParamsWithOverrides (copy), logActionTelemetry (copy), v42 (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref), reportUnifiedLoggingAction (copy), FFlagSduiChartsSupport (copy), FFlagSduiOptionSelectorCollection (copy)
				local t2 = {
					dependencies = getSduiServiceDependenciesStore().getDependencies(appPage),
					appPage = appPage,
					configKey = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else p5.configKey
				}
				local v50 = nil

				if FFlagSduiActionTelemetryHandler and (p2 and p2.telemetry_handler) then
					local telemetry_handler = p2.telemetry_handler

					if telemetry_handler.kind and telemetry_handler.kind.type then
						local v52, v53 = SduiClientBindingBuilder.buildProp(telemetry_handler, p3, p4, p5, p6)

						v50 = if v53 ~= PropResultCategory.PropSignal then v52 else v52(false).data
					end
				end

				local v54 = nil

				if FFlagSduiActionSkipUnifiedLogging and p2 and p2.skip_unified_logging then
					local skip_unified_logging = p2.skip_unified_logging

					if skip_unified_logging.kind and skip_unified_logging.kind.type then
						local v56, v57 = SduiClientBindingBuilder.buildProp(skip_unified_logging, p3, p4, p5, p6)

						v54 = if v57 ~= PropResultCategory.PropSignal then v56 else v56(false).data
					end
				end

				local v58 = v41 and v41.action_params
				local t3 = {
					actionType = u37,
					telemetryHandler = v50,
					skipUnifiedLogging = v54
				}
				local v60 = nil

				if v58 and next(v58) then
					local v61, v62 = buildPropTable(v58, p3, p4, p5, p6)

					if v62 then
						for v63, v64 in v62 do
							v61[v63] = v64(false).data
						end
					end

					if FFlagSduiActionsShouldTakeOverrides then
						v60 = v61
					else
						t3.actionParams = v61
					end
				end

				if FFlagSduiActionsShouldTakeOverrides then
					t3.actionParams = mergeTemplateParamsWithOverrides(v60, p9)
				end

				if FFlagSduiActionTelemetryHandler then
					logActionTelemetry(v50, v42, t3, p6, t2)
				elseif not v42.skipUnifiedLogging then
					if p6 == nil then
						SduiLogger.reportError(SduiErrors.SduiErrorType.NilAnalyticsContext, {
							message = `Could not reportUnifiedLoggingAction. Missing analyticsContext { u37 }`,
							name = u37,
							componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
							parserName = if not FFlagSduiImprovedErrorDimensions then nil else currentParserName
						}, appPage)
					else
						reportUnifiedLoggingAction(t2, t3, p6)
					end
				end

				if v42.handler then
					if FFlagSduiChartsSupport or FFlagSduiOptionSelectorCollection then
						return v42.handler(t3, p6, t2, p8)
					end

					v42.handler(t3, p6, t2, p8)
				end
			end
		end)

		if ok then
			return result, PropResultCategory.Literal
		end

		return function(_, _, _) -- line: 222
			-- upvalues: SduiLogger (copy), SduiErrors (copy), u37 (ref), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref)
			SduiLogger.reportCounter(SduiErrors.SduiCounterName.ExecutedInvalidAction, {
				name = u37,
				componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
				parserName = not FFlagSduiImprovedErrorDimensions and "buildActionProp" or currentParserName
			})
		end, PropResultCategory.Failed, result
	end

	if s1 == "conditional" then
		return SduiPropUtils.generateConditionalPropValue(p2, p3, p5, p6, p4, buildActionProp), PropResultCategory.PropSignal
	end

	error(`Could not build prop. Unknown propDefinitionType: { s1 }`)
end

return buildActionProp
