local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths
local Signals = require(parent.Signals)
local tutils = require(parent.tutils)
local DataHydration = require(parent.DataHydration)
local DataStatus = DataHydration.DataHydrationTypes.DataStatus

local SduiClientBindingBuilder = require(SduiCoreSystem.ClientBinding.SduiClientBindingBuilder)
local SduiClientBindingTypes = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local PropResultCategory = SduiClientBindingTypes.PropResultCategory
require(SduiCoreSystem.SduiBuilderTypes)
local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local addSduiErrorContextFields = require(SduiCoreSystem.addSduiErrorContextFields)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local SduiParseHelpers = require(SduiCoreSystem.SduiParseHelpers)
require(SduiCoreSystem.SduiComponentType)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiArrayMapEmptyWhileHydrationNotReady = SharedFlags2.FFlagSduiArrayMapEmptyWhileHydrationNotReady
local function buildRepeatedProp(p: string, data, p2, p3, data2, p4, callback)
	local currentComponentType = data2.currentComponentType
	local currentParserName = data2.currentParserName

	if p == "literal" then
		if typeof(data) ~= "table" then
			error("buildRepeatedProp: propDefinitionValue must be a table for literal type")
		end

		local array = data.array

		if array == nil then
			error("buildRepeatedProp: wrapper message must have 'array' field")
		end

		if typeof(array) ~= "table" then
			error("buildRepeatedProp: array field must be a table/array")
		end

		return
			SduiPropUtils.generateTablePropSignalValue(
				array,
				p2,
				data2,
				p4,
				p3,
				SduiClientBindingBuilder.buildPropTable,
				callback
			),
			PropResultCategory.PropSignal
	end

	if p == "binding_path" then
		local function evaluatePropArray(p5, p6)
			local propTable, v, v2 = SduiClientBindingBuilder.buildPropTable(p5, p2, p3, data2, p4)

			return SduiPropUtils.resolveTablePropValue(
				p6,
				propTable,
				v,
				v2,
				p2,
				data2,
				p4,
				p3,
				SduiClientBindingBuilder.buildPropTable
			)
		end

		return
			SduiPropUtils.generateDynamicBindingPropValue(data, p2, data2, p3, evaluatePropArray),
			PropResultCategory.PropSignal
	end

	if p == "array_map" then
		local kind = data.kind and data.kind.type
		local value = data.kind and data.kind.value
		local item_hydration_specs = data.item_hydration_specs
		local field_map = data.field_map

		if field_map == nil then
			error("buildRepeatedProp array_map: missing field_map")
		end

		return Signals.createComputed(function(p5)
			local success, result = pcall(function()
				local sourceArray, v = SduiPropUtils.resolveSourceArray(kind, value, p5, p2, p3, data2)

				if FFlagSduiArrayMapEmptyWhileHydrationNotReady and sourceArray == nil and v == DataStatus.NotReady then
					return {}
				end

				if sourceArray == nil then
					error("buildRepeatedProp array_map: source array resolved to nil")
				end

				return SduiPropUtils.mapArrayWithFieldMap(
					sourceArray,
					item_hydration_specs or {},
					field_map,
					data2,
					p4,
					p5,
					SduiClientBindingBuilder.buildPropTable
				)
			end)

			if success then
				return { data = result }
			end

			local v = {
				message = `Failed to build array_map: {SduiParseHelpers.stringifyValue(result)}`,
				name = data2.debugName,
				componentType = currentComponentType,
				parserName = currentParserName
			}

			if FFlagSduiErrorPaths then
				addSduiErrorContextFields(v, data2.errorContext)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v, data2.appPage)

			return { data = {} }
		end, tutils.shallowEqual), PropResultCategory.PropSignal
	elseif p == "conditional" then
		return
			SduiPropUtils.generateConditionalPropValue(data, p2, data2, p4, p3, buildRepeatedProp, callback),
			PropResultCategory.PropSignal
	else
		return nil, PropResultCategory.Failed
	end
end

return buildRepeatedProp
