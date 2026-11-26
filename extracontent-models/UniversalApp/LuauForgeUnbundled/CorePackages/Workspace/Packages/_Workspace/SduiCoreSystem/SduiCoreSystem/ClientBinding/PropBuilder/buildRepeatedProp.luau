local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiErrorPaths
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/tutils")
local dataStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/DataHydration").DataHydrationTypes.DataStatus

local SduiClientBindingBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingBuilder")
local propResultCategory = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes").PropResultCategory
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
local SduiPropUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiPropUtils")
local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local addSduiErrorContextFields = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/addSduiErrorContextFields")
local SduiLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiLogger")
local SduiParseHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiParseHelpers")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")

local fFlagSduiArrayMapEmptyWhileHydrationNotReady = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiArrayMapEmptyWhileHydrationNotReady
local function buildRepeatedProp(p2, data, p3, p4, data2, p5, p6)
	local currentComponentType = data2.currentComponentType
	local currentParserName = data2.currentParserName

	if p2 == "literal" then
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
			SduiPropUtils.generateTablePropSignalValue(array, p3, data2, p5, p4, SduiClientBindingBuilder.buildPropTable, p6),
			propResultCategory.PropSignal
	end

	if p2 == "binding_path" then
		local function evaluatePropArray(p7, p8)
			local propTable, v5, v6 = SduiClientBindingBuilder.buildPropTable(p7, p3, p4, data2, p5)

			return SduiPropUtils.resolveTablePropValue(
				p8,
				propTable,
				v5,
				v6,
				p3,
				data2,
				p5,
				p4,
				SduiClientBindingBuilder.buildPropTable
			)
		end

		return
			SduiPropUtils.generateDynamicBindingPropValue(data, p3, data2, p4, evaluatePropArray),
			propResultCategory.PropSignal
	end

	if p2 == "array_map" then
		local kind = data.kind and data.kind.type
		local value = data.kind and data.kind.value
		local item_hydration_specs = data.item_hydration_specs
		local field_map = data.field_map

		if field_map == nil then
			error("buildRepeatedProp array_map: missing field_map")
		end

		return Signals.createComputed(function(p7)
			local success, result = pcall(function()
				local sourceArray, v5 = SduiPropUtils.resolveSourceArray(kind, value, p7, p3, p4, data2)

				if
					fFlagSduiArrayMapEmptyWhileHydrationNotReady
					and sourceArray == nil
					and v5 == dataStatus.NotReady
				then
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
					p5,
					p7,
					SduiClientBindingBuilder.buildPropTable
				)
			end)

			if success then
				return { data = result }
			end

			local v5 = {
				message = `Failed to build array_map: {module8.stringifyValue(result)}`,
				name = data2.debugName,
				componentType = currentComponentType,
				parserName = currentParserName
			}

			if fFlagSduiErrorPaths then
				addSduiErrorContextFields(v5, data2.errorContext)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v5, data2.appPage)

			return { data = {} }
		end, tutils.shallowEqual), propResultCategory.PropSignal
	elseif p2 == "conditional" then
		return
			SduiPropUtils.generateConditionalPropValue(data, p3, data2, p5, p4, buildRepeatedProp, p6),
			propResultCategory.PropSignal
	else
		return nil, propResultCategory.Failed
	end
end

return buildRepeatedProp
