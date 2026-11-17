local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

local parent = SduiCoreSystem.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths
local DataHydration = require(parent.DataHydration)
require(parent.ServiceContractsProto)
local Signals = require(parent.Signals)
local Cryo = require(parent.Cryo)
local tutils = require(parent.tutils)
local SduiDataBinder = require(SduiCoreSystem.ClientBinding.SduiDataBinder)
local tryGetPathFromData = require(SduiCoreSystem.ClientBinding.tryGetPathFromData)
local splitDottedPath = require(SduiCoreSystem.ClientBinding.splitDottedPath)
local buildDataBindingSourcesForTemplate = require(SduiCoreSystem.ClientBinding.buildDataBindingSourcesForTemplate)
local SduiClientBindingTypes = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local SduiDataBindingContentType = require(SduiCoreSystem.ClientBinding.SduiDataBindingContentType)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local addSduiErrorContextFields = require(SduiCoreSystem.addSduiErrorContextFields)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
require(SduiCoreSystem.SduiBuilderTypes)
local getSduiTokensStore = require(SduiCoreSystem.ClientBinding.getSduiTokensStore)
local SduiParseHelpers = require(SduiCoreSystem.SduiParseHelpers)
local SduiParsers = require(SduiCoreSystem.SduiParsers)
require(SduiCoreSystem.SduiComponentType)
local PropResultCategory = SduiClientBindingTypes.PropResultCategory
local applyFormatArgFormatter = require(SduiCoreSystem.ClientBinding.PropBuilder.applyFormatArgFormatter)
local applyFormatArgFormatter2 = applyFormatArgFormatter.applyFormatArgFormatter

local DataStatus = DataHydration.DataHydrationTypes.DataStatus
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiDismissPromptPageScope = SharedFlags2.FFlagSduiDismissPromptPageScope

local frozen = table.freeze({ status = DataStatus.Failed })

local frozen2 = table.freeze({})

local function resolveHydrationBinding(list, p, p2, flag: boolean?)
	local joined = table.concat(list, ".")
	local item = list[1]
	local v = p and p[item]

	if v == nil then
		if SduiDataBindingContentType[item] ~= nil then
			error(`Could not find data bindingSource for key {item}, bindingPath: {joined}`)
		end

		return nil, nil
	else
		local contentType = v.contentType
		local id = v.id

		if #list < 2 then
			error(`Unsupported path for contentType {contentType}, bindingPath: {joined}`)
		end

		local fetchIfMissing = v.fetchIfMissing or flag

		local fieldValue, v2 = SduiDataBinder.getFieldValue(contentType, list, id, p2, fetchIfMissing)
		return fieldValue, v2
	end
end

local function resolveBindingPathValue(p, list, callback, callback2, callback3, flag: boolean?, p2)
	local v, v2 = tryGetPathFromData(callback2(p), list)

	if v and v2 ~= nil then
		if callback3 then
			return callback3(v2, p)
		end

		return v2
	else
		local v3 = list and list[1]

		if SduiDataBinder.isClientContentType(v3) then
			local fieldValueForClientContentType = SduiDataBinder.getFieldValueForClientContentType(v3, list, p, p2)

			if callback3 and fieldValueForClientContentType ~= nil then
				return callback3(fieldValueForClientContentType, p)
			end

			return fieldValueForClientContentType
		else
			local hydrationBinding, v4 = resolveHydrationBinding(list, callback(p), p, flag)

			if callback3 and hydrationBinding ~= nil then
				hydrationBinding = callback3(hydrationBinding, p)
			end

			return hydrationBinding, v4
		end
	end
end

local function generateDynamicBindingPropValue(value: string, p, data, p2, callback, flag: boolean?)
	local currentComponentType = data.currentComponentType
	local currentParserName = data.currentParserName

	local v = splitDottedPath(value)

	if not v or #v == 0 then
		error(`Invalid bindingPath: {value}`)
	end

	return Signals.createComputed(function(p3)
		local success, result, status = pcall(function()
			local bindingPathValue, v2 = resolveBindingPathValue(p3, v, p, p2, callback, flag, data)

			return bindingPathValue, v2
		end)

		if success then
			return { data = result, status = status }
		end

		local v2 = {
			value = value,
			message = SduiParseHelpers.stringifyValue(result),
			name = data.debugName,
			componentType = currentComponentType,
			parserName = currentParserName
		}

		if FFlagSduiErrorPaths then
			addSduiErrorContextFields(v2, data.errorContext)
		end

		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToComputeDynamicBinding, v2, data.appPage)

		return frozen
	end, tutils.shallowEqual)
end

local function substituteFormatArg(value: string, k: string, p: string) -- 4 equivalent calls inferred from this helper
	return value:gsub("{" .. k .. "}", function()
		return p
	end)
end

local function validateNumbers(op, fieldObject, value)
	if typeof(fieldObject) ~= "number" then
		fieldObject = tonumber(fieldObject)
	end

	if typeof(value) ~= "number" then
		value = tonumber(value)
	end

	if typeof(fieldObject) ~= "number" or typeof(value) ~= "number" then
		error(`{op} without numbers, {fieldObject}: {typeof(fieldObject)}, {value}: {typeof(value)}`)
	end

	return fieldObject, value
end

local function isEmpty(fieldObject): boolean -- 2 equivalent calls inferred from this helper
	if fieldObject == nil then
		return true
	end

	if type(fieldObject) == "string" then
		return fieldObject == ""
	end

	return type(fieldObject) == "table" and next(fieldObject) == nil
end

local function isSame(p, value): boolean
	if p == value then
		return true
	end

	if p == nil then
		return false
	end

	local typeName = typeof(value)

	if typeof(p) == typeName then
		return p == value
	end

	if typeName == "string" then
		p = tostring(p)
	elseif typeName == "number" then
		p = tonumber(p)
	elseif typeName == "boolean" then
		p = SduiParsers.parseBooleanProp_(p, nil, nil)
	end

	return p == value
end

local fn

if FFlagSduiDismissPromptPageScope then
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

	fn = function(p, callback)
		local v, v2 = callback(p.field)

		if v2 and v2 ~= DataStatus.Ready then
			return nil, v2
		end

		local kind = p.kind

		if kind == nil or kind.type == nil then
			error("nil target kind in ContainsCondition")
		end

		local v3 = nil

		if kind.type == "string_value" then
			v3 = kind.value

			return contains(v, v3)
		end

		if kind.type ~= "binding_path_value" then
			error(`Unknown ContainsCondition target kind {kind.type}`)

			return contains(v, v3)
		end

		local v4
		v3, v4 = callback(kind.value)

		if v4 and v4 ~= DataStatus.Ready then
			return nil, v4
		end

		if v3 == nil then
			return nil
		end

		return contains(v, v3)
	end
else
	fn = nil
end

local function evaluateCondition(p, condition, p2, p3, p4)
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

	local function getFieldObject(field: string) -- 5 equivalent calls inferred from this helper
		local v = splitDottedPath(field)

		local success, result, v2 = pcall(function()
			return resolveBindingPathValue(p, v, p2, p4, nil, true, p3)
		end)

		if success then
			return result, v2
		end

		return nil, v2
	end

	if kind == "comparison" then
		local fieldObject, v = getFieldObject(value.field) -- inferred equivalent call

		if fieldObject == nil or v and v ~= DataStatus.Ready then
			return nil, v
		end

		local value2 = value.kind.value
		local op = value.op

		if op == "OP_LT" then
			local v2, v3 = validateNumbers("OP_LT", fieldObject, value2)
			return v2 < v3
		elseif op == "OP_LTE" then
			local v2, v3 = validateNumbers("OP_LTE", fieldObject, value2)
			return v2 <= v3
		elseif op == "OP_GT" then
			local v2, v3 = validateNumbers("OP_GT", fieldObject, value2)
			return v3 < v2
		elseif op == "OP_GTE" then
			local v2, v3 = validateNumbers("OP_GTE", fieldObject, value2)
			return v3 <= v2
		elseif op == "OP_E" then
			return isSame(fieldObject, value2)
		end

		if op == "OP_NE" then
			return not isSame(fieldObject, value2)
		end

		error(`Unknown operator for comparison {op}`)
	elseif kind == "is_null" then
		local fieldObject, v = getFieldObject(value.field) -- inferred equivalent call

		if v and v ~= DataStatus.Ready then
			return nil, v
		end

		return fieldObject == nil
	elseif kind == "is_not_null" then
		local fieldObject, v = getFieldObject(value.field) -- inferred equivalent call

		if v and v ~= DataStatus.Ready then
			return nil, v
		end

		return fieldObject ~= nil
	elseif kind == "is_empty" then
		local fieldObject, v = getFieldObject(value.field) -- inferred equivalent call

		if v and v ~= DataStatus.Ready then
			return nil, v
		end

		return isEmpty(fieldObject) -- inferred equivalent call
	elseif kind == "is_not_empty" then
		local fieldObject, v = getFieldObject(value.field) -- inferred equivalent call

		if v and v ~= DataStatus.Ready then
			return nil, v
		end

		return not isEmpty(fieldObject) -- inferred equivalent call
	else
		if FFlagSduiDismissPromptPageScope and kind == "contains" then
			return fn(value, getFieldObject)
		end

		if kind == "and_condition" then
			for _, condition2 in value.conditions do
				local v, v2 = evaluateCondition(p, condition2, p2, p3, p4)

				if v2 and v2 ~= DataStatus.Ready then
					return v, v2
				end

				if not v then
					return v
				end
			end

			return true
		elseif kind == "or_condition" then
			for _, condition2 in value.conditions do
				local v, v2 = evaluateCondition(p, condition2, p2, p3, p4)

				if v2 and v2 ~= DataStatus.Ready or (v or v == nil) then
					return v, v2
				end
			end

			return false
		end
	end

	return nil
end

local function selectConditionalOption(p, options, p2, data, p3)
	for _, item in options do
		local v, v2 = evaluateCondition(p, item.condition, p2, data, p3)

		if v then
			return item, v2
		end

		if v2 and v2 ~= DataStatus.Ready then
			return v, v2
		end
	end

	return nil
end

local function resolveTablePropValue(p, p2, items, p3, _, _, _, _, _)
	local joined = Cryo.Dictionary.join(p3 or frozen2, p2 or frozen2)
	local v = nil

	if not items then
		return joined, v
	end

	for k, item in items do
		joined[k] = item(p).data

		local status = item(p).status

		if status and status ~= DataStatus.Ready then
			v = status
		end
	end

	return joined, v
end

local function resolveTemplate(roblox_component: string?, inline_component, p) -- 1 equivalent call inferred from this helper
	if inline_component ~= nil then
		return inline_component
	end

	if roblox_component == nil or roblox_component == "" then
		error("Missing roblox_component")
	end

	local templateForRobloxComponent = p.getTemplateForRobloxComponent(roblox_component)

	if templateForRobloxComponent == nil then
		error(`Could not find template for roblox_component {roblox_component}`)
	end

	return templateForRobloxComponent
end

local SduiPropUtils = {}

function SduiPropUtils.generateStaticPropValue(p, callback)
	if callback then
		return callback(p)
	end

	return p
end

SduiPropUtils.generateDynamicBindingPropValue = generateDynamicBindingPropValue

function SduiPropUtils.generateTokenBindingPropValue(p: string, data, callback)
	local currentComponentType = data.currentComponentType
	local currentParserName = data.currentParserName

	local v = splitDottedPath(p)

	return Signals.createComputed(function(p2)
		local v2, v3 = tryGetPathFromData(getSduiTokensStore().getTokens(p2, data.appPage), v)

		if v2 then
			if callback then
				v3 = callback(v3)
			end

			return { data = v3, status = DataStatus.Ready }
		else
			local v4 = {
				message = `Could not find token with tokenPath {table.concat(v, ".")}`,
				name = data.debugName,
				componentType = currentComponentType,
				parserName = currentParserName
			}

			if FFlagSduiErrorPaths then
				addSduiErrorContextFields(v4, data.errorContext)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.TokenBindingFailed, v4, data.appPage)

			return frozen
		end
	end, tutils.shallowEqual)
end

function SduiPropUtils.generateFormatStringPropValue(data, p, data2, p2, callback)
	local currentComponentType = data2.currentComponentType
	local currentParserName = data2.currentParserName

	if typeof(data) ~= "table" then
		error(`Unexpected type for stringFormat {typeof(data)}`)
	end

	local v = data.str

	if (not v or v == "") and data.translation then
		local resolveLocalizedLiteral = data2.resolveLocalizedLiteral
		local translation = data.translation
		local v2

		if FFlagSduiErrorPaths then
			v2 = data2.errorContext
		end

		v = resolveLocalizedLiteral(translation, v2)
	end

	if not v or v == "" then
		error("No format string for prop")
	end

	if not data.args then
		error(`No args found for format. If no args needed, use literal. {v}`)
	end

	local v2 = {}
	local formatters = {}

	for k, arg in data.args do
		local kind = arg.kind.type
		local value = arg.kind.value

		if kind == "literal" then
			if arg.formatter then
				local formatter = arg.formatter
				local appPage = data2.appPage
				local v3

				if FFlagSduiErrorPaths then
					v3 = data2.errorContext
				end

				local v4 = applyFormatArgFormatter2(value, formatter, appPage, v3)

				if v4 == nil then
					return function()
						return frozen
					end
				end

				v = substituteFormatArg(v, k, v4) -- inferred equivalent call
			else
				v = substituteFormatArg(v, k, tostring(value)) -- inferred equivalent call
			end
		elseif kind == "binding_path" then
			v2[k] = generateDynamicBindingPropValue(value, p, data2, p2)

			if arg.formatter then
				formatters[k] = arg.formatter
			end
		else
			warn(`Unrecognized argType in buildFormatString {kind}`)
		end
	end

	return Signals.createComputed(function(p3)
		local v3 = v

		for k, v4 in v2 do
			local v5 = v4(p3)
			local data3 = v5.data
			local status = v5.status

			if data3 == nil then
				return { status = status }
			end

			local v6

			if formatters then
				v6 = formatters[k]
			end

			if v6 then
				local appPage = data2.appPage
				local v7

				if FFlagSduiErrorPaths then
					v7 = data2.errorContext
				end

				local v8 = applyFormatArgFormatter2(data3, v6, appPage, v7)

				if v8 == nil then
					return frozen
				end

				v3 = v3 and substituteFormatArg(v3, k, v8) -- inferred equivalent call
			else
				v3 = v3 and substituteFormatArg(v3, k, tostring(data3)) -- inferred equivalent call
			end
		end

		if not callback then
			return { data = v3 }
		end

		local success, result = pcall(function()
			return callback(v3)
		end)

		if success then
			return { data = result }
		end

		local v4 = {
			value = v3,
			message = `Parser in formatString for str {v}`,
			name = data2.debugName,
			componentType = currentComponentType,
			parserName = currentParserName
		}

		if FFlagSduiErrorPaths then
			addSduiErrorContextFields(v4, data2.errorContext)
		end

		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v4, data2.appPage)

		return frozen
	end, tutils.shallowEqual)
end

function SduiPropUtils.generateConditionalPropValue(p, p2, data, p3, p4, callback, callback2, isNestedComponentConfig: boolean?)
	local currentComponentType = data.currentComponentType
	local currentParserName = data.currentParserName

	local options = p.options

	return Signals.createComputed(function(p5)
		local success, result, status = pcall(function()
			local v, v2 = selectConditionalOption(p5, options, p2, data, p4)

			if v == nil then
				return nil, v2
			end

			local kind = v and v.kind and v.kind.type
			local value = v and v.kind and v.kind.value
			local v3, v4 = callback(kind, value, p2, p4, data, p3, callback2)

			if v4 ~= PropResultCategory.PropSignal then
				return v3, v2
			end

			local v5 = v3(p5)
			v3 = v5.data

			if v5.status and v5.status ~= DataStatus.Ready then
				v2 = v5.status
			end

			return v3, v2
		end)

		if success then
			return {
				data = result,
				status = status,
				isNestedComponentConfig = isNestedComponentConfig
			}
		end

		local v = {
			message = SduiParseHelpers.stringifyValue(result),
			name = data.debugName,
			componentType = currentComponentType,
			parserName = currentParserName
		}

		if FFlagSduiErrorPaths then
			addSduiErrorContextFields(v, data.errorContext)
		end

		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToEvaluateConditionalProp, v, data.appPage)

		return frozen
	end, tutils.shallowEqual)
end

function SduiPropUtils.generateTablePropSignalValue(p, p2, data, p3, p4, callback, callback2)
	local currentComponentType = data.currentComponentType
	local currentParserName = data.currentParserName

	local v, v2, v3 = callback(p, p2, p4, data, p3)

	return Signals.createComputed(function(p5)
		local success, result, status = pcall(function()
			local tablePropValue, v4 = resolveTablePropValue(p5, v, v2, v3, p2, data, p3, p4, callback)

			return tablePropValue, v4
		end)

		if success then
			if not callback2 or result == nil then
				return { data = result, status = status }
			end

			local success2, result2 = pcall(function()
				return callback2(result)
			end)

			if success2 then
				result = result2

				return { data = result, status = status }
			end

			local stringifyValue = SduiParseHelpers.stringifyValue(result2)
			local v4 = {
				value = SduiParseHelpers.stringifyValue(result),
				message = `Failed to apply propParser to table prop {stringifyValue}`,
				name = data.debugName,
				componentType = currentComponentType,
				parserName = currentParserName
			}

			if FFlagSduiErrorPaths then
				addSduiErrorContextFields(v4, data.errorContext)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v4, data.appPage)

			return frozen
		else
			local v4 = {
				message = SduiParseHelpers.stringifyValue(result),
				name = data.debugName,
				componentType = currentComponentType,
				parserName = currentParserName
			}

			if FFlagSduiErrorPaths then
				addSduiErrorContextFields(v4, data.errorContext)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v4, data.appPage)
			return frozen
		end
	end, tutils.shallowEqual)
end

SduiPropUtils.selectConditionalOption = selectConditionalOption
SduiPropUtils.evaluateCondition = evaluateCondition
SduiPropUtils.resolveHydrationBinding = resolveHydrationBinding
SduiPropUtils.resolveBindingPathValue = resolveBindingPathValue
SduiPropUtils.resolveTablePropValue = resolveTablePropValue

function SduiPropUtils.resolveSourceArray(p: string?, p2, p3, p4, p5, p6)
	if p == "binding_path" then
		return resolveBindingPathValue(p3, splitDottedPath(p2), p4, p5, nil, nil, p6)
	elseif p == "literal" then
		return p2 and p2.items
	end

	return nil
end

function SduiPropUtils.resolveFieldMap(p, p2, p3, p4, p5, p6, callback)
	local v, v2 = callback(p, p2, p3, p4, p5)
	return resolveTablePropValue(p6, v, v2, nil, p2, p4, p5, p3, nil)
end

function SduiPropUtils.mapArrayWithFieldMap(items, p, p2, p3, p4, p5, callback)
	local result = {}

	for _, item in items do
		local dataBindingSourcesForTemplate = buildDataBindingSourcesForTemplate(item, p)
		local function fn2()
			return dataBindingSourcesForTemplate
		end

		local function fn3()
			return item
		end

		local v, v2 = callback(p2, fn2, fn3, p3, p4)
		table.insert(result, (resolveTablePropValue(p5, v, v2, nil, fn2, p3, p4, fn3, nil)))
	end

	return result
end

function SduiPropUtils.isComponentVisible(p, p2): boolean
	return p.isComponentFilteredSignal == nil or p.isComponentFilteredSignal(p2).data ~= true
end

SduiPropUtils.resolveTemplate = resolveTemplate

function SduiPropUtils.resolveTemplateFromData(p, p2)
	local inline_component = p.inline_component
	return resolveTemplate(p.roblox_component, inline_component, p2) -- inferred equivalent call
end

return SduiPropUtils
