local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local Signals = require(SduiCoreSystemParent.Signals)
local tutils = require(SduiCoreSystemParent.tutils)
local SduiClientBindingBuilder = require(SduiCoreSystem.ClientBinding.SduiClientBindingBuilder)
local PropResultCategory = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes).PropResultCategory

require(SduiCoreSystem.SduiBuilderTypes)

local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local SduiParseHelpers = require(SduiCoreSystem.SduiParseHelpers)

require(SduiCoreSystem.SduiComponentType)

local SharedFlags = require(SduiCoreSystemParent.SharedFlags)
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport
local FFlagSduiImprovedErrorDimensions = SharedFlags.FFlagSduiImprovedErrorDimensions
local FFlagSduiClientPageScope = SharedFlags.FFlagSduiClientPageScope
local v15 = game:DefineFastFlag("SduiArrayMapSupport", false)

local function buildRepeatedProp(s1: string, p1, p2, p3, p4, p5, p6: ((...any) -> ...any)?) -- line: 39
	-- upvalues: FFlagSduiImprovedErrorDimensions (copy), SduiPropUtils (copy), SduiClientBindingBuilder (copy), PropResultCategory (copy), FFlagSduiExperienceDetailsSupport (copy), v15 (copy), Signals (copy), FFlagSduiClientPageScope (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy), tutils (copy), buildRepeatedProp (copy)
	local currentComponentType = nil
	local currentParserName = nil

	if FFlagSduiImprovedErrorDimensions then
		currentComponentType = p4.currentComponentType
		currentParserName = p4.currentParserName
	end

	if s1 == "literal" then
		if typeof(p1) ~= "table" then
			error("buildRepeatedProp: propDefinitionValue must be a table for literal type")
		end

		local array = p1.array

		if array == nil then
			error("buildRepeatedProp: wrapper message must have 'array' field")
		end

		if typeof(array) ~= "table" then
			error("buildRepeatedProp: array field must be a table/array")
		end

		return SduiPropUtils.generateTablePropSignalValue(array, p2, p4, p5, p3, SduiClientBindingBuilder.buildPropTable, p6), PropResultCategory.PropSignal
	end

	if s1 == "binding_path" then
		local function evaluatePropArray(t1: {[any]: any}, p7) -- line: 83
			-- upvalues: SduiClientBindingBuilder (copy), p2 (copy), p3 (copy), p4 (copy), p5 (copy), SduiPropUtils (copy)
			local v34, v35, v36 = SduiClientBindingBuilder.buildPropTable(t1, p2, p3, p4, p5)

			return SduiPropUtils.resolveTablePropValue(p7, v34, v35, v36, p2, p4, p5, p3, SduiClientBindingBuilder.buildPropTable)
		end

		return SduiPropUtils.generateDynamicBindingPropValue(p1, p2, p4, p3, evaluatePropArray), PropResultCategory.PropSignal
	end

	if (FFlagSduiExperienceDetailsSupport or v15) and s1 == "array_map" then
		local v28 = p1.kind and p1.kind.type
		local v29 = p1.kind and p1.kind.value
		local item_hydration_specs = p1.item_hydration_specs
		local field_map = p1.field_map

		if field_map == nil then
			error("buildRepeatedProp array_map: missing field_map")
		end

		return Signals.createComputed(function(p8) -- line: 123
			-- upvalues: SduiPropUtils (copy), v28 (copy), v29 (copy), p2 (copy), p3 (copy), FFlagSduiClientPageScope (copy), p4 (copy), item_hydration_specs (copy), field_map (copy), p5 (copy), SduiClientBindingBuilder (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref)
			local ok, result = pcall(function() -- line: 124
				-- upvalues: SduiPropUtils (copy), v28 (copy), v29 (copy), p8 (copy), p2 (copy), p3 (copy), FFlagSduiClientPageScope (copy), p4 (copy), item_hydration_specs (copy), field_map (copy), p5 (copy), SduiClientBindingBuilder (copy)
				local v40 = SduiPropUtils.resolveSourceArray(v28, v29, p8, p2, p3, if not FFlagSduiClientPageScope then nil else p4)

				if v40 == nil then
					error("buildRepeatedProp array_map: source array resolved to nil")
				end

				return SduiPropUtils.mapArrayWithFieldMap(v40, item_hydration_specs or {}, field_map, p4, p5, p8, SduiClientBindingBuilder.buildPropTable)
			end)

			if ok then
				return {
					data = result
				}
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
				message = `Failed to build array_map: { SduiParseHelpers.stringifyValue(result) }`,
				name = p4.debugName,
				componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
				parserName = if not FFlagSduiImprovedErrorDimensions then nil else currentParserName
			}, p4.appPage)

			return {
				data = {}
			}
		end, tutils.shallowEqual), PropResultCategory.PropSignal
	end

	if s1 == "conditional" then
		return SduiPropUtils.generateConditionalPropValue(p1, p2, p4, p5, p3, buildRepeatedProp, p6), PropResultCategory.PropSignal
	end

	return nil, PropResultCategory.Failed
end

return buildRepeatedProp
