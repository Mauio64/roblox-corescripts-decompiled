require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/ReactFocusNavigation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/InputHandlers")

local getSduiTokensStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/getSduiTokensStore")
local ProtoVariableMapper = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/ProtoVariableMapper")
local splitDottedPath = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/splitDottedPath")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/parsePymkItems")
local fFlagSduiPropParsersShouldHandleTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiPropParsersShouldHandleTokens
local fFlagSduiUnwrapStructPropEnvelope = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiUnwrapStructPropEnvelope

local function resolveTokenValueToNumber(value, value2)
	local v5 = string.sub(value2, 1, 1) == "-"
	local v6 = if v5 then string.sub(value2, 2) else value2

	local v7 = splitDottedPath(v6)
	local v8 = #v7

	for k, v9 in v7 do
		local v10 = value[v9]

		if k ~= v8 and typeof(v10) ~= "table" then
			error(`Token path {v6} invalid`)
		end

		value = value[v9]
	end

	if typeof(value) ~= "number" then
		error(`Token path {v6} did not resolve to a number: {value2}`)
	end

	if v5 then
		return value * -1
	end

	return value
end

local function getTokenOrNumber(value, p2, p3, p4)
	local v5 = tonumber(value)

	if v5 then
		if not p3 then
			return v5
		end

		local tokens = getSduiTokensStore().getTokens(p2, p4)
		return v5 * (tokens and tokens.Config.UI.Scale or 1)
	else
		if typeof(value) ~= "string" then
			error("Expected number or token string, got " .. typeof(value))

			return
		end

		local success, result = pcall(function()
			return resolveTokenValueToNumber(getSduiTokensStore().getTokens(p2, p4), value)
		end)

		if success and result then
			return result
		end

		local error2 = error

		if typeof(result) ~= "string" then
			result = nil
		end

		error2(result)
	end
end

local fn = fFlagSduiPropParsersShouldHandleTokens and function(value, p2, p3)
	local success, result = pcall(function()
		local v5 = string.split(value, ",")

		if #v5 ~= 4 then
			error("Not enough components in string to parse UDim2")

			return
		end

		local tokenOrNumber = getTokenOrNumber(v5[2], p2, p3, "parseUDim2")
		local tokenOrNumber2 = getTokenOrNumber(v5[4], p2, p3, "parseUDim2")
		return UDim2.new(tonumber(v5[1]) or 0, tokenOrNumber, tonumber(v5[3]) or 0, tokenOrNumber2)
	end)

	if success and result then
		return result
	end

	local error2 = error

	if typeof(result) ~= "string" then
		result = nil
	end

	error2(result)
end or function(value, p2, p3)
	local success, result = pcall(function()
		local v5 = string.split(value, ",")

		if #v5 ~= 4 then
			error("Not enough components in string to parse UDim2")

			return
		end

		local v6 = tonumber(v5[2]) or 0
		local v7 = tonumber(v5[4]) or 0

		if p3 then
			local tokens = getSduiTokensStore().getTokens(p2, "parseUDim2")
			v6 *= tokens and tokens.Config.UI.Scale or 1
			v7 *= tokens and tokens.Config.UI.Scale or 1
		end

		return UDim2.new(tonumber(v5[1]) or 0, v6, tonumber(v5[3]) or 0, v7)
	end)

	if success and result then
		return result
	end

	local error2 = error

	if typeof(result) ~= "string" then
		result = nil
	end

	error2(result)
end

local fn2 = fFlagSduiPropParsersShouldHandleTokens and function(value, p2, p3)
	local success, result = pcall(function()
		local v5 = string.split(value, ",")

		if #v5 == 2 then
			local tokenOrNumber = getTokenOrNumber(v5[2], p2, p3, "parseUDim")
			return UDim.new(tonumber(v5[1]) or 0, tokenOrNumber)
		end

		error("Not enough components in string to parse UDim")
	end)

	if success and result then
		return result
	end

	local error2 = error

	if typeof(result) ~= "string" then
		result = nil
	end

	error2(result)
end or function(value, p2, p3)
	local success, result = pcall(function()
		local v5 = string.split(value, ",")

		if #v5 ~= 2 then
			error("Not enough components in string to parse UDim")

			return
		end

		local v6 = tonumber(v5[2]) or 0

		if p3 then
			local tokens = getSduiTokensStore().getTokens(p2, "parseUDim2")
			v6 *= tokens and tokens.Config.UI.Scale or 1
		end

		return UDim.new(tonumber(v5[1]) or 0, v6)
	end)

	if success and result then
		return result
	end

	local error2 = error

	if typeof(result) ~= "string" then
		result = nil
	end

	error2(result)
end

local function parseNumber(p2, p3, p4)
	local success, result = pcall(function()
		return (tonumber(p2))
	end)

	if success and result then
		if not p4 then
			return result
		end

		local tokens = getSduiTokensStore().getTokens(p3, "parseUDim2")
		return result * (tokens and tokens.Config.UI.Scale or 1)
	else
		local error2 = error

		if typeof(result) ~= "string" then
			result = nil
		end

		error2(result)
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

	local v5 = false

	for k, field in fields do
		if typeof(field) ~= "table" then
			return false
		end

		if not (typeof(field.kind) == "table" and typeof(field.kind.type) == "string") then
			continue
		end

		v5 = true
	end

	return v5 or next(fields) == nil
end

local function parseStruct(items)
	if typeof(items) ~= "table" then
		return items
	end

	if fFlagSduiUnwrapStructPropEnvelope and isStructEnvelope(items) then
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
	local values = if typeof(value) == "table" then value.values else nil

	if typeof(values) ~= "table" then
		return result
	end

	for k, value2 in values do
		result[k] = unwrapStructValue(value2)
	end

	return result
end

unwrapStructValue = function(p2)
	if typeof(p2) ~= "table" then
		return p2
	end

	local kind = p2.kind

	if typeof(kind) ~= "table" or typeof(kind.type) ~= "string" then
		return parseStruct(p2)
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

		if success then
			return result
		end

		return nil
	end

	if typeof(value) == "table" and typeof(value.Color3) == "Color3" then
		return value.Color3
	end

	error(`Could not resolve Color3 from input: {value}`)
end

local v5 = {
	startColor = Color3.new(0, 0, 0),
	endColor = Color3.new(0, 0, 0),
	startOpacity = 0,
	endOpacity = 1,
	degree = 270
}
return {
	parseUDim = fn2,
	parseUDim2 = fn,
	parseNumber = parseNumber,
	applyTokenScaling = function(p2, p3)
		return p2 * (p3 and p3.Config.UI.Scale or 1)
	end,
	parseUiScaledNumber = function(p2, p3)
		return parseNumber(p2, p3, true)
	end,
	parseUiScaledUDim = function(p2, p3)
		return fn2(p2, p3, true)
	end,
	parseUiScaledUDim2 = function(p2, p3)
		return fn(p2, p3, true)
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
	parsePymkItems = module5,
	parseStringArray = function(p2)
		if typeof(p2) == "table" then
			return p2.items or p2
		end

		return nil
	end,
	parseToString = function(p2)
		if p2 == nil then
			return nil
		end

		return (tostring(p2))
	end,
	parseColor3 = parseColor3,
	parseGradient = function(p2)
		local v6 = parseStruct(p2)

		if typeof(v6) ~= "table" then
			error(`Could not resolve gradient from input: {p2}`)
		end

		local v7 = if v6.startColor == nil then v5.startColor else parseColor3(v6.startColor)
		local v8 = if v6.endColor == nil then v5.endColor else parseColor3(v6.endColor)

		if v7 == nil or v8 == nil then
			error(`Could not resolve gradient colors from input: {p2}`)
		end

		if v6.startOpacity ~= nil and typeof(v6.startOpacity) ~= "number" then
			error(`Could not resolve gradient startOpacity from input: {p2}`)
		end

		if v6.endOpacity ~= nil and typeof(v6.endOpacity) ~= "number" then
			error(`Could not resolve gradient endOpacity from input: {p2}`)
		end

		if v6.degree ~= nil and typeof(v6.degree) ~= "number" then
			error(`Could not resolve gradient degree from input: {p2}`)
		end

		local v9 = if v6.startOpacity == nil then v5.startOpacity else v6.startOpacity
		local v10 = if v6.endOpacity == nil then v5.endOpacity else v6.endOpacity
		local v11 = if v6.degree == nil then v5.degree else v6.degree
		return {
			startColor = v7,
			endColor = v8,
			startOpacity = v9,
			endOpacity = v10,
			degree = v11
		}
	end,
	parseColorPropLegacy = function(value)
		if typeof(value) == "string" then
			return Color3.fromHex(value)
		end

		return value
	end,
	parseFocusNavActions = function(p2)
		if typeof(p2) ~= "table" then
			return nil
		end

		local v6 = {}

		if typeof(p2.keys) == "table" then
			for k, key in p2.keys do
				if not (typeof(key) == "EnumItem" and typeof(k) == "string") then
					continue
				end

				v6[key] = k
			end
		end

		local v7 = {}

		if typeof(p2.events) == "table" then
			for k, event in p2.events do
				if not (typeof(k) == "string" and typeof(event) == "function") then
					continue
				end

				v7[k] = { handler = InputHandlers.onRelease(event) }
			end
		end

		return { keys = v6, events = v7 }
	end
}
