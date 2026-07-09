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
local FFlagSduiImprovedErrorDimensions = require(SduiCoreSystemParent.SharedFlags).FFlagSduiImprovedErrorDimensions
local FFlagSduiExperienceDetailsSupport = require(SduiCoreSystemParent.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagSduiEventDetailsSupport = require(SduiCoreSystemParent.SharedFlags).FFlagSduiEventDetailsSupport
local FFlagSduiOptionSelectorCollection = require(SduiCoreSystemParent.SharedFlags).FFlagSduiOptionSelectorCollection

local function mergeTemplateParamsWithOverrides(t1: {[any]: any}?, p1) -- line: 45
	if typeof(p1) ~= "table" then
		return t1
	end

	local v25 = if not t1 then {} else table.clone(t1)

	for v26, v27 in p1 do
		v25[v26] = v27
	end

	return v25
end
local function buildActionProp(s1: string, p2, p3, p4, p5, p6) -- line: 59
	-- upvalues: FFlagSduiImprovedErrorDimensions (copy), ProtoVariableMapper (copy), getSduiActionHandlerRegistry (copy), getSduiServiceDependenciesStore (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy), FFlagSduiActionTelemetryHandler (copy), SduiClientBindingBuilder (copy), PropResultCategory (copy), buildPropTable (copy), FFlagSduiActionsShouldTakeOverrides (copy), mergeTemplateParamsWithOverrides (copy), logActionTelemetry (copy), SduiLogger (copy), SduiErrors (copy), reportUnifiedLoggingAction (copy), FFlagSduiChartsSupport (copy), FFlagSduiOptionSelectorCollection (copy), SduiPropUtils (copy), buildActionProp (copy)
	local currentComponentType = nil
	local currentParserName = nil

	if FFlagSduiImprovedErrorDimensions then
		currentComponentType = p5.currentComponentType
		currentParserName = p5.currentParserName
	end

	if s1 == "value" then
		local u36 = nil
		local ok, result = pcall(function() -- line: 76
			-- upvalues: p5 (copy), p2 (copy), u36 (ref), ProtoVariableMapper (copy), getSduiActionHandlerRegistry (copy), getSduiServiceDependenciesStore (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy), FFlagSduiActionTelemetryHandler (copy), SduiClientBindingBuilder (copy), p3 (copy), p4 (copy), p6 (copy), PropResultCategory (copy), buildPropTable (copy), FFlagSduiActionsShouldTakeOverrides (copy), mergeTemplateParamsWithOverrides (copy), logActionTelemetry (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref), reportUnifiedLoggingAction (copy), FFlagSduiChartsSupport (copy), FFlagSduiOptionSelectorCollection (copy)
			local appPage = p5.appPage
			local v40 = typeof(p2) == "table" and (not not p2.kind and p2.kind.value) or nil

			u36 = if not v40 or not v40.action_type then nil else ProtoVariableMapper.mapActionTypeToLua(v40.action_type)

			if not u36 then
				error(`Could not map actionType: { v40 and v40.action_type }`)
			end

			local v41 = getSduiActionHandlerRegistry().getActionHandlerConfig(u36)

			if not v41 then
				error(`Could not find action for actionType: { u36 }`)
			end

			return function(_, p8, p9) -- line: 99
				-- upvalues: getSduiServiceDependenciesStore (copy), appPage (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy), p5 (copy), FFlagSduiActionTelemetryHandler (copy), p2 (copy), SduiClientBindingBuilder (copy), p3 (copy), p4 (copy), p6 (copy), PropResultCategory (copy), v40 (copy), u36 (ref), buildPropTable (copy), FFlagSduiActionsShouldTakeOverrides (copy), mergeTemplateParamsWithOverrides (copy), logActionTelemetry (copy), v41 (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref), reportUnifiedLoggingAction (copy), FFlagSduiChartsSupport (copy), FFlagSduiOptionSelectorCollection (copy)
				local t2 = {
					dependencies = getSduiServiceDependenciesStore().getDependencies(appPage),
					appPage = appPage,
					configKey = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else p5.configKey
				}
				local v49 = nil

				if FFlagSduiActionTelemetryHandler and (p2 and p2.telemetry_handler) then
					local telemetry_handler = p2.telemetry_handler

					if telemetry_handler.kind and telemetry_handler.kind.type then
						local v51, v52 = SduiClientBindingBuilder.buildProp(telemetry_handler, p3, p4, p5, p6)

						v49 = if v52 ~= PropResultCategory.PropSignal then v51 else v51(false).data
					end
				end

				local v53 = v40 and v40.action_params
				local t3 = {
					actionType = u36,
					telemetryHandler = v49
				}
				local v55 = nil

				if v53 and next(v53) then
					local v56, v57 = buildPropTable(v53, p3, p4, p5, p6)

					if v57 then
						for v58, v59 in v57 do
							v56[v58] = v59(false).data
						end
					end

					if FFlagSduiActionsShouldTakeOverrides then
						v55 = v56
					else
						t3.actionParams = v56
					end
				end

				if FFlagSduiActionsShouldTakeOverrides then
					t3.actionParams = mergeTemplateParamsWithOverrides(v55, p9)
				end

				if FFlagSduiActionTelemetryHandler then
					logActionTelemetry(v49, v41, t3, p6, t2)
				elseif not v41.skipUnifiedLogging then
					if p6 == nil then
						SduiLogger.reportError(SduiErrors.SduiErrorType.NilAnalyticsContext, {
							message = `Could not reportUnifiedLoggingAction. Missing analyticsContext { u36 }`,
							name = u36,
							componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
							parserName = if not FFlagSduiImprovedErrorDimensions then nil else currentParserName
						}, appPage)
					else
						reportUnifiedLoggingAction(t2, t3, p6)
					end
				end

				if v41.handler then
					if FFlagSduiChartsSupport or FFlagSduiOptionSelectorCollection then
						return v41.handler(t3, p6, t2, p8)
					end

					v41.handler(t3, p6, t2, p8)
				end
			end
		end)

		if ok then
			return result, PropResultCategory.Literal
		end

		return function(_, _, _) -- line: 199
			-- upvalues: SduiLogger (copy), SduiErrors (copy), u36 (ref), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref)
			SduiLogger.reportCounter(SduiErrors.SduiCounterName.ExecutedInvalidAction, {
				name = u36,
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
