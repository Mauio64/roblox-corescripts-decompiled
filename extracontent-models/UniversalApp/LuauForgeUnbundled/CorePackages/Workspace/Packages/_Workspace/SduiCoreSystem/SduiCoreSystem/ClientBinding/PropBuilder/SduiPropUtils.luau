local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiErrorPaths
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/DataHydration")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/ServiceContractsProto")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Cryo")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/tutils")
local SduiDataBinder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiDataBinder")
local tryGetPathFromData = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/tryGetPathFromData")
local splitDottedPath = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/splitDottedPath")
local buildDataBindingSourcesForTemplate = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/buildDataBindingSourcesForTemplate")
local SduiClientBindingTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes")
local SduiDataBindingContentType = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiDataBindingContentType")
local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local addSduiErrorContextFields = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/addSduiErrorContextFields")
local SduiLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiLogger")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
local getSduiTokensStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/getSduiTokensStore")
local SduiParseHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiParseHelpers")
local SduiParsers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiParsers")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")
local propResultCategory = SduiClientBindingTypes.PropResultCategory
local applyFormatArgFormatter = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/applyFormatArgFormatter").applyFormatArgFormatter

local dataStatus = DataHydration.DataHydrationTypes.DataStatus
local fFlagSduiDismissPromptPageScope = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiDismissPromptPageScope

local frozen = table.freeze({ status = dataStatus.Failed })

local frozen2 = table.freeze({})

local function resolveHydrationBinding(list, p2, p3, p4)
	local joined = table.concat(list, ".")
	local item = list[1]
	local v5 = p2 and p2[item]

	if v5 == nil then
		if SduiDataBindingContentType[item] ~= nil then
			error(`Could not find data bindingSource for key {item}, bindingPath: {joined}`)
		end

		return nil, nil
	else
		local contentType = v5.contentType
		local id = v5.id

		if #list < 2 then
			error(`Unsupported path for contentType {contentType}, bindingPath: {joined}`)
		end

		local fetchIfMissing = v5.fetchIfMissing or p4

		local fieldValue, v6 = SduiDataBinder.getFieldValue(contentType, list, id, p3, fetchIfMissing)
		return fieldValue, v6
	end
end

local function resolveBindingPathValue(p2, list, callback, callback2, callback3, p3, p4)
	local v5, v6 = tryGetPathFromData(callback2(p2), list)

	if v5 and v6 ~= nil then
		if callback3 then
			return callback3(v6, p2)
		end

		return v6
	else
		local v7 = list and list[1]

		if SduiDataBinder.isClientContentType(v7) then
			local fieldValueForClientContentType = SduiDataBinder.getFieldValueForClientContentType(v7, list, p2, p4)

			if callback3 and fieldValueForClientContentType ~= nil then
				return callback3(fieldValueForClientContentType, p2)
			end

			return fieldValueForClientContentType
		else
			local hydrationBinding, v9 = resolveHydrationBinding(list, callback(p2), p2, p3)

			if callback3 and hydrationBinding ~= nil then
				hydrationBinding = callback3(hydrationBinding, p2)
			end

			return hydrationBinding, v9
		end
	end
end

local function generateDynamicBindingPropValue(value, p2, data, p3, p4, p5)
	local currentComponentType = data.currentComponentType
	local currentParserName = data.currentParserName

	local v5 = splitDottedPath(value)

	if not v5 or #v5 == 0 then
		error(`Invalid bindingPath: {value}`)
	end

	return Signals.createComputed(function(p6)
		local success, result, v6 = pcall(function()
			local bindingPathValue, v7 = resolveBindingPathValue(p6, v5, p2, p3, p4, p5, data)

			return bindingPathValue, v7
		end)

		if success then
			return { data = result, status = v6 }
		end

		local v7 = {
			value = value,
			message = SduiParseHelpers.stringifyValue(result),
			name = data.debugName,
			componentType = currentComponentType,
			parserName = currentParserName
		}

		if fFlagSduiErrorPaths then
			addSduiErrorContextFields(v7, data.errorContext)
		end

		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToComputeDynamicBinding, v7, data.appPage)

		return frozen
	end, tutils.shallowEqual)
end

local function substituteFormatArg(value, p2, p3)
	return value:gsub("{" .. p2 .. "}", function()
		return p3
	end)
end

local function validateNumbers(op, result, value)
	if typeof(result) ~= "number" then
		result = tonumber(result)
	end

	if typeof(value) ~= "number" then
		value = tonumber(value)
	end

	if typeof(result) ~= "number" or typeof(value) ~= "number" then
		error(`{op} without numbers, {result}: {typeof(result)}, {value}: {typeof(value)}`)
	end

	return result, value
end

local function isEmpty(value): boolean
	if value == nil then
		return true
	end

	if type(value) == "string" then
		return value == ""
	end

	if type(value) == "table" then
		return next(value) == nil
	end

	return false
end

local function isSame(p2, value): boolean
	if p2 == value then
		return true
	end

	if p2 == nil then
		return false
	end

	local typeName = typeof(value)

	if typeof(p2) == typeName then
		return p2 == value
	end

	if typeName == "string" then
		p2 = tostring(p2)
	elseif typeName == "number" then
		p2 = tonumber(p2)
	elseif typeName == "boolean" then
		p2 = SduiParsers.parseBooleanProp_(p2, nil, nil)
	end

	return p2 == value
end

local fn

if fFlagSduiDismissPromptPageScope then
	local function contains(items, value): boolean
		if typeof(items) ~= "table" or typeof(value) ~= "string" then
			return false
		end

		if items[value] ~= nil then
			return true
		end

		for k, item in items do
			if typeof(k) == "number" and isSame(item, value) then
				return true
			end
		end

		return false
	end

	fn = function(p2, callback)
		local v5, v6 = callback(p2.field)

		if v6 and v6 ~= dataStatus.Ready then
			return nil, v6
		end

		local kind = p2.kind

		if kind == nil or kind.type == nil then
			error("nil target kind in ContainsCondition")
		end

		local v7 = nil

		if kind.type == "string_value" then
			v7 = kind.value

			return contains(v5, v7)
		end

		if kind.type ~= "binding_path_value" then
			error(`Unknown ContainsCondition target kind {kind.type}`)

			return contains(v5, v7)
		end

		local v8
		v7, v8 = callback(kind.value)

		if v8 and v8 ~= dataStatus.Ready then
			return nil, v8
		end

		if v7 == nil then
			return nil
		end

		return contains(v5, v7)
	end
else
	fn = nil
end

local function evaluateCondition(p2, condition, p3, p4, p5)
	if condition == nil then
		return true
	end

	local kind = condition and condition.kind and condition.kind.type
	local value = condition and condition.kind and condition.kind.value

	if kind == nil then
		error("nil conditionType in condition")
	end

	if value == nil then
		error("nil conditionValue in condition")
	end

	local function getFieldObject(p6)
		local v5 = splitDottedPath(p6)

		local success, result, v6 = pcall(function()
			return resolveBindingPathValue(p2, v5, p3, p5, nil, true, p4)
		end)

		if success then
			return result, v6
		end

		return nil, v6
	end

	if kind == "comparison" then
		local v5 = splitDottedPath(value.field)
		local success, result, v6 = pcall(function()
			return resolveBindingPathValue(p2, v5, p3, p5, nil, true, p4)
		end)

		if not success then
			result = nil
		end

		if result == nil or v6 and v6 ~= dataStatus.Ready then
			return nil, v6
		end

		local value2 = value.kind.value
		local op = value.op

		if op == "OP_LT" then
			local v7, v8 = validateNumbers("OP_LT", result, value2)
			return v7 < v8
		elseif op == "OP_LTE" then
			local v7, v8 = validateNumbers("OP_LTE", result, value2)
			return v7 <= v8
		elseif op == "OP_GT" then
			local v7, v8 = validateNumbers("OP_GT", result, value2)
			return v8 < v7
		elseif op == "OP_GTE" then
			local v7, v8 = validateNumbers("OP_GTE", result, value2)
			return v8 <= v7
		elseif op == "OP_E" then
			return isSame(result, value2)
		end

		if op == "OP_NE" then
			return not isSame(result, value2)
		end

		error(`Unknown operator for comparison {op}`)
	elseif kind == "is_null" then
		local v5 = splitDottedPath(value.field)
		local success, result, v6 = pcall(function()
			return resolveBindingPathValue(p2, v5, p3, p5, nil, true, p4)
		end)

		if not success then
			result = nil
		end

		if v6 and v6 ~= dataStatus.Ready then
			return nil, v6
		end

		return result == nil
	elseif kind == "is_not_null" then
		local v5 = splitDottedPath(value.field)
		local success, result, v6 = pcall(function()
			return resolveBindingPathValue(p2, v5, p3, p5, nil, true, p4)
		end)

		if not success then
			result = nil
		end

		if v6 and v6 ~= dataStatus.Ready then
			return nil, v6
		end

		return result ~= nil
	elseif kind == "is_empty" then
		local v5 = splitDottedPath(value.field)
		local success, result, v6 = pcall(function()
			return resolveBindingPathValue(p2, v5, p3, p5, nil, true, p4)
		end)

		if not success then
			result = nil
		end

		if v6 and v6 ~= dataStatus.Ready then
			return nil, v6
		end

		if result == nil then
			return true
		end

		if type(result) == "string" then
			return result == ""
		end

		if type(result) == "table" then
			return next(result) == nil
		end

		return false
	elseif kind == "is_not_empty" then
		local v5 = splitDottedPath(value.field)
		local success, result, v6 = pcall(function()
			return resolveBindingPathValue(p2, v5, p3, p5, nil, true, p4)
		end)

		if not success then
			result = nil
		end

		if v6 and v6 ~= dataStatus.Ready then
			return nil, v6
		end

		local v7

		if result == nil then
			v7 = true
		elseif type(result) == "string" then
			v7 = result == ""
		else
			v7 = type(result) == "table" and next(result) == nil
		end

		return not v7
	else
		if fFlagSduiDismissPromptPageScope and kind == "contains" then
			return fn(value, getFieldObject)
		end

		if kind == "and_condition" then
			for k, condition2 in value.conditions do
				local v5, v6 = evaluateCondition(p2, condition2, p3, p4, p5)

				if v6 and v6 ~= dataStatus.Ready then
					return v5, v6
				end

				if not v5 then
					return v5
				end
			end

			return true
		elseif kind == "or_condition" then
			for k, condition2 in value.conditions do
				local v5, v6 = evaluateCondition(p2, condition2, p3, p4, p5)

				if v6 and v6 ~= dataStatus.Ready or (v5 or v5 == nil) then
					return v5, v6
				end
			end

			return false
		end
	end

	return nil
end

local function selectConditionalOption(p2, options, p3, data, p4)
	for k, item in options do
		local v5, v6 = evaluateCondition(p2, item.condition, p3, data, p4)

		if v5 then
			return item, v6
		end

		if v6 and v6 ~= dataStatus.Ready then
			return v5, v6
		end
	end

	return nil
end

local function resolveTablePropValue(p2, p3, items, p4, p5, p6, p7, p8, p9)
	local joined = Cryo.Dictionary.join(p4 or frozen2, p3 or frozen2)
	local v5 = nil

	if not items then
		return joined, v5
	end

	for k, item in items do
		joined[k] = item(p2).data

		local status = item(p2).status

		if status and status ~= dataStatus.Ready then
			v5 = status
		end
	end

	return joined, v5
end

return {
	generateStaticPropValue = function(p2, callback)
		if callback then
			return callback(p2)
		end

		return p2
	end,
	generateDynamicBindingPropValue = generateDynamicBindingPropValue,
	generateTokenBindingPropValue = function(p2, data, callback)
		local currentComponentType = data.currentComponentType
		local currentParserName = data.currentParserName

		local v5 = splitDottedPath(p2)

		return Signals.createComputed(function(p3)
			local v6, v7 = tryGetPathFromData(getSduiTokensStore().getTokens(p3, data.appPage), v5)

			if v6 then
				if callback then
					v7 = callback(v7)
				end

				return { data = v7, status = dataStatus.Ready }
			else
				local v8 = {
					message = `Could not find token with tokenPath {table.concat(v5, ".")}`,
					name = data.debugName,
					componentType = currentComponentType,
					parserName = currentParserName
				}

				if fFlagSduiErrorPaths then
					addSduiErrorContextFields(v8, data.errorContext)
				end

				SduiLogger.reportError(SduiErrors.SduiErrorType.TokenBindingFailed, v8, data.appPage)

				return frozen
			end
		end, tutils.shallowEqual)
	end,
	generateFormatStringPropValue = function(data, p2, data2, p3, callback)
		local currentComponentType = data2.currentComponentType
		local currentParserName = data2.currentParserName

		if typeof(data) ~= "table" then
			error(`Unexpected type for stringFormat {typeof(data)}`)
		end

		local v5 = data.str

		if (not v5 or v5 == "") and data.translation then
			local resolveLocalizedLiteral = data2.resolveLocalizedLiteral
			local translation = data.translation
			local v6 = if fFlagSduiErrorPaths then data2.errorContext else nil
			v5 = resolveLocalizedLiteral(translation, v6)
		end

		if not v5 or v5 == "" then
			error("No format string for prop")
		end

		if not data.args then
			error(`No args found for format. If no args needed, use literal. {v5}`)
		end

		local v6 = {}
		local formatters = {}

		for k, arg in data.args do
			local kind = arg.kind.type
			local value = arg.kind.value

			if kind == "literal" then
				if arg.formatter then
					local formatter = arg.formatter
					local appPage = data2.appPage
					local v8 = if fFlagSduiErrorPaths then data2.errorContext else nil
					local v9 = applyFormatArgFormatter(value, formatter, appPage, v8)

					if v9 == nil then
						return function()
							return frozen
						end
					end

					v5 = v5:gsub("{" .. k .. "}", function()
						return v9
					end)
				else
					local v8 = tostring(value)
					v5 = v5:gsub("{" .. k .. "}", function()
						return v8
					end)
				end
			elseif kind == "binding_path" then
				v6[k] = generateDynamicBindingPropValue(value, p2, data2, p3)

				if arg.formatter then
					formatters[k] = arg.formatter
				end
			else
				warn(`Unrecognized argType in buildFormatString {kind}`)
			end
		end

		return Signals.createComputed(function(p4)
			local v7 = v5

			for k, v8 in v6 do
				local v9 = v8(p4)
				local data3 = v9.data
				local status = v9.status

				if data3 == nil then
					return { status = status }
				end

				local v10 = if formatters then formatters[k] else nil

				if v10 then
					local appPage = data2.appPage
					local v12 = if fFlagSduiErrorPaths then data2.errorContext else nil
					local v13 = applyFormatArgFormatter(data3, v10, appPage, v12)

					if v13 == nil then
						return frozen
					end

					v7 = v7 and v7:gsub("{" .. k .. "}", function()
						return v13
					end)
				else
					local v11 = v7

					if v11 then
						local v12 = tostring(data3)
						v11 = v7:gsub("{" .. k .. "}", function()
							return v12
						end)
					end

					v7 = v11
				end
			end

			if not callback then
				return { data = v7 }
			end

			local success, result = pcall(function()
				return callback(v7)
			end)

			if success then
				return { data = result }
			end

			local v8 = {
				value = v7,
				message = `Parser in formatString for str {v5}`,
				name = data2.debugName,
				componentType = currentComponentType,
				parserName = currentParserName
			}

			if fFlagSduiErrorPaths then
				addSduiErrorContextFields(v8, data2.errorContext)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v8, data2.appPage)

			return frozen
		end, tutils.shallowEqual)
	end,
	generateConditionalPropValue = function(p2, p3, data, p4, p5, callback, p6, p7)
		local currentComponentType = data.currentComponentType
		local currentParserName = data.currentParserName

		local options = p2.options

		return Signals.createComputed(function(p8)
			local success, result, v5 = pcall(function()
				local v6, v7 = selectConditionalOption(p8, options, p3, data, p5)

				if v6 == nil then
					return nil, v7
				end

				local kind = v6 and v6.kind and v6.kind.type
				local value = v6 and v6.kind and v6.kind.value
				local v8, v9 = callback(kind, value, p3, p5, data, p4, p6)

				if v9 ~= propResultCategory.PropSignal then
					return v8, v7
				end

				local v10 = v8(p8)
				v8 = v10.data

				if v10.status and v10.status ~= dataStatus.Ready then
					v7 = v10.status
				end

				return v8, v7
			end)

			if success then
				return { data = result, status = v5, isNestedComponentConfig = p7 }
			end

			local v6 = {
				message = SduiParseHelpers.stringifyValue(result),
				name = data.debugName,
				componentType = currentComponentType,
				parserName = currentParserName
			}

			if fFlagSduiErrorPaths then
				addSduiErrorContextFields(v6, data.errorContext)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToEvaluateConditionalProp, v6, data.appPage)

			return frozen
		end, tutils.shallowEqual)
	end,
	generateTablePropSignalValue = function(p2, p3, data, p4, p5, callback, callback2)
		local currentComponentType = data.currentComponentType
		local currentParserName = data.currentParserName

		local v5, v6, v7 = callback(p2, p3, p5, data, p4)

		return Signals.createComputed(function(p6)
			local success, result, v8 = pcall(function()
				local tablePropValue, v9 = resolveTablePropValue(p6, v5, v6, v7, p3, data, p4, p5, callback)

				return tablePropValue, v9
			end)

			if success then
				if not callback2 or result == nil then
					return { data = result, status = v8 }
				end

				local success2, result2 = pcall(function()
					return callback2(result)
				end)

				if success2 then
					result = result2

					return { data = result, status = v8 }
				end

				local stringifyValue = SduiParseHelpers.stringifyValue(result2)
				local v9 = {
					value = SduiParseHelpers.stringifyValue(result),
					message = `Failed to apply propParser to table prop {stringifyValue}`,
					name = data.debugName,
					componentType = currentComponentType,
					parserName = currentParserName
				}

				if fFlagSduiErrorPaths then
					addSduiErrorContextFields(v9, data.errorContext)
				end

				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v9, data.appPage)

				return frozen
			else
				local v9 = {
					message = SduiParseHelpers.stringifyValue(result),
					name = data.debugName,
					componentType = currentComponentType,
					parserName = currentParserName
				}

				if fFlagSduiErrorPaths then
					addSduiErrorContextFields(v9, data.errorContext)
				end

				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v9, data.appPage)
				return frozen
			end
		end, tutils.shallowEqual)
	end,
	selectConditionalOption = selectConditionalOption,
	evaluateCondition = evaluateCondition,
	resolveHydrationBinding = resolveHydrationBinding,
	resolveBindingPathValue = resolveBindingPathValue,
	resolveTablePropValue = resolveTablePropValue,
	resolveSourceArray = function(p2, p3, p4, p5, p6, p7)
		if p2 == "binding_path" then
			return resolveBindingPathValue(p4, splitDottedPath(p3), p5, p6, nil, nil, p7)
		elseif p2 == "literal" then
			return p3 and p3.items
		end

		return nil
	end,
	resolveFieldMap = function(p2, p3, p4, p5, p6, p7, callback)
		local v5, v6 = callback(p2, p3, p4, p5, p6)
		return resolveTablePropValue(p7, v5, v6, nil, p3, p5, p6, p4, nil)
	end,
	mapArrayWithFieldMap = function(items, p2, p3, p4, p5, p6, callback)
		local result = {}

		for k, item in items do
			local v5 = buildDataBindingSourcesForTemplate(item, p2)
			local function fn2()
				return v5
			end

			local function fn3()
				return item
			end

			local v6, v7 = callback(p3, fn2, fn3, p4, p5)
			table.insert(result, (resolveTablePropValue(p6, v6, v7, nil, fn2, p4, p5, fn3, nil)))
		end

		return result
	end,
	isComponentVisible = function(p2, p3): boolean
		if p2.isComponentFilteredSignal == nil then
			return true
		end

		return p2.isComponentFilteredSignal(p3).data ~= true
	end,
	resolveTemplate = function(p2, p3, p4)
		if p3 ~= nil then
			return p3
		end

		if p2 == nil or p2 == "" then
			error("Missing roblox_component")
		end

		local templateForRobloxComponent = p4.getTemplateForRobloxComponent(p2)

		if templateForRobloxComponent == nil then
			error(`Could not find template for roblox_component {p2}`)
		end

		return templateForRobloxComponent
	end,
	resolveTemplateFromData = function(p2, p3)
		local inline_component = p2.inline_component
		local roblox_component = p2.roblox_component

		if inline_component ~= nil then
			return inline_component
		end

		if roblox_component == nil or roblox_component == "" then
			error("Missing roblox_component")
		end

		local templateForRobloxComponent = p3.getTemplateForRobloxComponent(roblox_component)

		if templateForRobloxComponent == nil then
			error(`Could not find template for roblox_component {roblox_component}`)
		end

		return templateForRobloxComponent
	end
}
