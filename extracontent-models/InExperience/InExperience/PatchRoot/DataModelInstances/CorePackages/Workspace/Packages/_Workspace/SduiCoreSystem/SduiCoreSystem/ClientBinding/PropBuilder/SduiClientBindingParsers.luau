local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
require(parent.Signals)
require(parent.Foundation)
require(parent.ReactFocusNavigation)
local InputHandlers = require(parent.InputHandlers)

local getSduiTokensStore = require(SduiCoreSystem.ClientBinding.getSduiTokensStore)
local ProtoVariableMapper = require(SduiCoreSystem.ClientBinding.ProtoVariableMapper)
local splitDottedPath = require(SduiCoreSystem.ClientBinding.splitDottedPath)
local parsePymkItems = require(SduiCoreSystem.ClientBinding.PropBuilder.parsePymkItems)
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiPropParsersShouldHandleTokens = SharedFlags.FFlagSduiPropParsersShouldHandleTokens
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiUnwrapStructPropEnvelope = SharedFlags2.FFlagSduiUnwrapStructPropEnvelope
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSduiParseProtoGradientFields = SharedFlags3.FFlagSduiParseProtoGradientFields

local function applyTokenScaling(p: number, p2) -- 5 equivalent calls inferred from this helper
	return p * (p2 and p2.Config.UI.Scale or 1)
end

local function resolveTokenValueToNumber(value, value2: string)
	local v = string.sub(value2, 1, 1) == "-"
	local v2

	if v then
		v2 = string.sub(value2, 2)
	else
		v2 = value2
	end

	local v3 = splitDottedPath(v2)
	local v4 = #v3

	for k, v5 in v3 do
		local v6 = value[v5]

		if k ~= v4 and typeof(v6) ~= "table" then
			error(`Token path {v2} invalid`)
		end

		value = value[v5]
	end

	if typeof(value) ~= "number" then
		error(`Token path {v2} did not resolve to a number: {value2}`)
	end

	if v then
		return value * -1
	end

	return value
end

local function getTokenOrNumber(value, p, flag: boolean, p2: string)
	local v = tonumber(value)

	if v then
		if not flag then
			return v
		end

		return applyTokenScaling(v, getSduiTokensStore().getTokens(p, p2)) -- inferred equivalent call
	else
		if typeof(value) ~= "string" then
			error("Expected number or token string, got " .. typeof(value))

			return
		end

		local success, result = pcall(function()
			return resolveTokenValueToNumber(getSduiTokensStore().getTokens(p, p2), value)
		end)

		if success and result then
			return result
		end

		if typeof(result) ~= "string" then
			result = nil
		end

		error(result)
	end
end

local fn = FFlagSduiPropParsersShouldHandleTokens and function(value: string, p, flag: boolean)
	local success, result = pcall(function()
		local v = string.split(value, ",")

		if #v ~= 4 then
			error("Not enough components in string to parse UDim2")

			return
		end

		local tokenOrNumber = getTokenOrNumber(v[2], p, flag, "parseUDim2")
		local tokenOrNumber2 = getTokenOrNumber(v[4], p, flag, "parseUDim2")
		return UDim2.new(tonumber(v[1]) or 0, tokenOrNumber, tonumber(v[3]) or 0, tokenOrNumber2)
	end)

	if success and result then
		return result
	end

	if typeof(result) ~= "string" then
		result = nil
	end

	error(result)
end or function(value: string, p, flag: boolean)
	local success, result = pcall(function()
		local v = string.split(value, ",")

		if #v ~= 4 then
			error("Not enough components in string to parse UDim2")

			return
		end

		local v2 = tonumber(v[2]) or 0
		local v3 = tonumber(v[4]) or 0

		if flag then
			local tokens = getSduiTokensStore().getTokens(p, "parseUDim2")
			v2 = applyTokenScaling(v2, tokens) -- inferred equivalent call
			v3 = applyTokenScaling(v3, tokens) -- inferred equivalent call
		end

		return UDim2.new(tonumber(v[1]) or 0, v2, tonumber(v[3]) or 0, v3)
	end)

	if success and result then
		return result
	end

	if typeof(result) ~= "string" then
		result = nil
	end

	error(result)
end

local fn2 = FFlagSduiPropParsersShouldHandleTokens and function(value: string, p, flag: boolean)
	local success, result = pcall(function()
		local v = string.split(value, ",")

		if #v == 2 then
			local tokenOrNumber = getTokenOrNumber(v[2], p, flag, "parseUDim")
			return UDim.new(tonumber(v[1]) or 0, tokenOrNumber)
		end

		error("Not enough components in string to parse UDim")
	end)

	if success and result then
		return result
	end

	if typeof(result) ~= "string" then
		result = nil
	end

	error(result)
end or function(value: string, p, flag: boolean)
	local success, result = pcall(function()
		local v = string.split(value, ",")

		if #v ~= 2 then
			error("Not enough components in string to parse UDim")

			return
		end

		local v2 = tonumber(v[2]) or 0

		if flag then
			v2 = applyTokenScaling(v2, getSduiTokensStore().getTokens(p, "parseUDim2")) -- inferred equivalent call
		end

		return UDim.new(tonumber(v[1]) or 0, v2)
	end)

	if success and result then
		return result
	end

	if typeof(result) ~= "string" then
		result = nil
	end

	error(result)
end

local function parseNumber(p, p2, flag: boolean)
	local success, result = pcall(function()
		return (tonumber(p))
	end)

	if success and result then
		if not flag then
			return result
		end

		return applyTokenScaling(result, getSduiTokensStore().getTokens(p2, "parseUDim2")) -- inferred equivalent call
	else
		if typeof(result) ~= "string" then
			result = nil
		end

		error(result)
	end
end

local unwrapStruct

local function isStructEnvelope(items)
	local fields = items.fields

	if typeof(fields) ~= "table" then
		return false
	end

	for k in items do
		if k ~= "fields" then
			return false
		end
	end

	local v = false

	for _, field in fields do
		if typeof(field) ~= "table" then
			return false
		end

		if not (typeof(field.kind) == "table" and typeof(field.kind.type) == "string") then
			continue
		end

		v = true
	end

	return v or next(fields) == nil
end

local function parseStruct(items)
	if typeof(items) ~= "table" then
		return items
	end

	if FFlagSduiUnwrapStructPropEnvelope and isStructEnvelope(items) then
		return unwrapStruct(items)
	end

	local mapPropName = ProtoVariableMapper.mapPropName
	local result = {}

	for k, item in items do
		if typeof(k) == "string" then
			k = mapPropName(k)
		end

		if typeof(item) == "table" then
			item = parseStruct(item)
		end

		result[k] = item
	end

	return result
end

local unwrapStructValue

local function unwrapStructList(value)
	local result = {}
	local values

	if typeof(value) == "table" then
		values = value.values
	end

	if typeof(values) ~= "table" then
		return result
	end

	for k, value2 in values do
		result[k] = unwrapStructValue(value2)
	end

	return result
end

unwrapStructValue = function(p)
	if typeof(p) ~= "table" then
		return p
	end

	local kind = p.kind

	if typeof(kind) ~= "table" or typeof(kind.type) ~= "string" then
		return parseStruct(p)
	end

	if kind.type == "null_value" then
		return nil
	end

	if kind.type == "struct_value" then
		return parseStruct(kind.value)
	end

	if kind.type == "list_value" then
		return unwrapStructList(kind.value)
	end

	return kind.value
end

unwrapStruct = function(items)
	local mapPropName = ProtoVariableMapper.mapPropName
	local result = {}

	for k, field in items.fields do
		if typeof(k) == "string" then
			k = mapPropName(k)
		end

		result[k] = unwrapStructValue(field)
	end

	return result
end

local function parseColor3(value)
	if typeof(value) == "Color3" then
		return value
	end

	if typeof(value) == "string" then
		local success, result = pcall(function()
			return Color3.fromHex(value)
		end)
		return if success then result else nil
	end

	if typeof(value) == "table" and typeof(value.Color3) == "Color3" then
		return value.Color3
	end

	error(`Could not resolve Color3 from input: {value}`)
end

local v = {
	startColor = Color3.new(0, 0, 0),
	endColor = Color3.new(0, 0, 0),
	startOpacity = 0,
	endOpacity = 1,
	degree = 270
}

local function parseGradient(p)
	local v2 = parseStruct(p)

	if typeof(v2) ~= "table" then
		error(`Could not resolve gradient from input: {p}`)
	end

	local startColor

	if v2.startColor == nil then
		startColor = v.startColor
	else
		startColor = parseColor3(v2.startColor)
	end

	local endColor

	if v2.endColor == nil then
		endColor = v.endColor
	else
		endColor = parseColor3(v2.endColor)
	end

	if startColor == nil or endColor == nil then
		error(`Could not resolve gradient colors from input: {p}`)
	end

	if v2.startOpacity ~= nil and typeof(v2.startOpacity) ~= "number" then
		error(`Could not resolve gradient startOpacity from input: {p}`)
	end

	if v2.endOpacity ~= nil and typeof(v2.endOpacity) ~= "number" then
		error(`Could not resolve gradient endOpacity from input: {p}`)
	end

	if v2.degree ~= nil and typeof(v2.degree) ~= "number" then
		error(`Could not resolve gradient degree from input: {p}`)
	end

	local startOpacity

	if v2.startOpacity == nil then
		startOpacity = v.startOpacity
	else
		startOpacity = v2.startOpacity
	end

	local endOpacity

	if v2.endOpacity == nil then
		endOpacity = v.endOpacity
	else
		endOpacity = v2.endOpacity
	end

	local degree = if v2.degree == nil then v.degree else v2.degree
	return {
		startColor = startColor,
		endColor = endColor,
		startOpacity = startOpacity,
		endOpacity = endOpacity,
		degree = degree
	}
end

local SduiClientBindingParsers = {
	parseUDim = fn2,
	parseUDim2 = fn,
	parseNumber = parseNumber,
	applyTokenScaling = applyTokenScaling,
	parseUiScaledNumber = function(p, p2)
		return parseNumber(p, p2, true)
	end,
	parseUiScaledUDim = function(p: string, p2)
		return fn2(p, p2, true)
	end,
	parseUiScaledUDim2 = function(p: string, p2)
		return fn(p, p2, true)
	end,
	parseStruct = parseStruct,
	parseArrayOfStruct = function(items)
		if typeof(items) ~= "table" then
			return items
		end

		local result = {}

		for k, item in items do
			result[k] = parseStruct(item)
		end

		return result
	end,
	parsePymkItems = parsePymkItems,
	parseStringArray = function(p)
		if typeof(p) == "table" then
			return p.items or p
		end

		return nil
	end,
	parseToString = function(p)
		if p == nil then
			return nil
		end

		return (tostring(p))
	end,
	parseColor3 = parseColor3,
	parseGradient = 0,
	parseColorPropLegacy = 0,
	parseFocusNavActions = 0
}

if not FFlagSduiParseProtoGradientFields then
	parseGradient = nil
end

SduiClientBindingParsers.parseGradient = parseGradient

function SduiClientBindingParsers.parseColorPropLegacy(value)
	if typeof(value) == "string" then
		return Color3.fromHex(value)
	end

	return value
end

function SduiClientBindingParsers.parseFocusNavActions(p)
	if typeof(p) ~= "table" then
		return nil
	end

	local keys = {}

	if typeof(p.keys) == "table" then
		for k, key in p.keys do
			if not (typeof(key) == "EnumItem" and typeof(k) == "string") then
				continue
			end

			keys[key] = k
		end
	end

	local events = {}

	if typeof(p.events) == "table" then
		for k, event in p.events do
			if not (typeof(k) == "string" and typeof(event) == "function") then
				continue
			end

			events[k] = { handler = InputHandlers.onRelease(event) }
		end
	end

	return { keys = keys, events = events }
end
return SduiClientBindingParsers
