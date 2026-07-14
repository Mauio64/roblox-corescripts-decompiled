local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.Signals)
require(SduiCoreSystemParent.Foundation)
require(SduiCoreSystemParent.ReactFocusNavigation)

local InputHandlers = require(SduiCoreSystemParent.InputHandlers)
local getSduiTokensStore = require(SduiCoreSystem.ClientBinding.getSduiTokensStore)
local ProtoVariableMapper = require(SduiCoreSystem.ClientBinding.ProtoVariableMapper)
local splitDottedPath = require(SduiCoreSystem.ClientBinding.splitDottedPath)
local FFlagSduiStringPropToString = require(SduiCoreSystemParent.SharedFlags).FFlagSduiStringPropToString
local FFlagSduiPropParsersShouldHandleTokens = require(SduiCoreSystemParent.SharedFlags).FFlagSduiPropParsersShouldHandleTokens
local FFlagSduiFocusNavActionsStructured = require(SduiCoreSystemParent.SharedFlags).FFlagSduiFocusNavActionsStructured
local FFlagSduiRenderPerf = require(SduiCoreSystemParent.SharedFlags).FFlagSduiRenderPerf

local function resolveTokenValueToNumber(p1, s1: string) -- line: 21
	-- upvalues: FFlagSduiRenderPerf (copy), splitDottedPath (copy)
	local v23 = string.sub(s1, 1, 1) == "-"
	local v24 = if not v23 then s1 else string.sub(s1, 2)
	local v25 = if not FFlagSduiRenderPerf then string.split(v24, ".") else splitDottedPath(v24)
	local v26 = #v25

	for v27, v28 in v25 do
		local v29 = p1[v28]

		if v27 ~= v26 and typeof(v29) ~= "table" then
			error(`Token path { v24 } invalid`)
		end

		p1 = p1[v28]
	end

	if typeof(p1) ~= "number" then
		error(`Token path { v24 } did not resolve to a number: { s1 }`)
	end

	if v23 then
		return p1 * -1
	end

	return p1
end
local function getTokenOrNumber(p2, p3, b1: boolean, s2: string) -- line: 47
	-- upvalues: getSduiTokensStore (copy), resolveTokenValueToNumber (copy)
	local num = tonumber(p2)

	if num then
		if b1 then
			local v35 = getSduiTokensStore().getTokens(p3, s2)

			return num * (v35 and v35.Config.UI.Scale or 1)
		end

		return num
	end

	if typeof(p2) == "string" then
		local ok, result = pcall(function() -- line: 62
			-- upvalues: resolveTokenValueToNumber (copy), getSduiTokensStore (copy), p3 (copy), s2 (copy), p2 (copy)
			return (resolveTokenValueToNumber(getSduiTokensStore().getTokens(p3, s2), p2))
		end)

		if ok and result then
			return result
		end

		error(if typeof(result) ~= "string" then nil else result)

		return
	end

	error("Expected number or token string, got " .. typeof(p2))
end

local v13 = not FFlagSduiPropParsersShouldHandleTokens and function(s3: string, p4, b2: boolean) -- line: 97
	-- upvalues: getSduiTokensStore (copy)
	local ok, result = pcall(function() -- line: 98
		-- upvalues: s3 (copy), b2 (copy), getSduiTokensStore (copy), p4 (copy)
		local parts = string.split(s3, ",")

		if #parts == 4 then
			local v92 = tonumber(parts[2]) or 0
			local v93 = tonumber(parts[4]) or 0

			if b2 then
				local v94 = getSduiTokensStore().getTokens(p4, "parseUDim2")

				v92 *= v94 and v94.Config.UI.Scale or 1
				v93 *= v94 and v94.Config.UI.Scale or 1
			end

			return UDim2.new(tonumber(parts[1]) or 0, v92, tonumber(parts[3]) or 0, v93)
		end

		error("Not enough components in string to parse UDim2")
	end)

	if ok and result then
		return result
	end

	error(if typeof(result) ~= "string" then nil else result)
end or function(s4: string, p5, b3: boolean) -- line: 79
	-- upvalues: getTokenOrNumber (copy)
	local ok, result = pcall(function() -- line: 80
		-- upvalues: s4 (copy), getTokenOrNumber (copy), p5 (copy), b3 (copy)
		local parts = string.split(s4, ",")

		if #parts == 4 then
			local v89 = getTokenOrNumber(parts[2], p5, b3, "parseUDim2")
			local v90 = getTokenOrNumber(parts[4], p5, b3, "parseUDim2")

			return UDim2.new(tonumber(parts[1]) or 0, v89, tonumber(parts[3]) or 0, v90)
		end

		error("Not enough components in string to parse UDim2")
	end)

	if ok and result then
		return result
	end

	error(if typeof(result) ~= "string" then nil else result)
end
local v14 = not FFlagSduiPropParsersShouldHandleTokens and function(s5: string, p6, b4: boolean) -- line: 142
	-- upvalues: getSduiTokensStore (copy)
	local ok, result = pcall(function() -- line: 143
		-- upvalues: s5 (copy), b4 (copy), getSduiTokensStore (copy), p6 (copy)
		local parts = string.split(s5, ",")

		if #parts == 2 then
			local v98 = tonumber(parts[2]) or 0

			if b4 then
				local v99 = getSduiTokensStore().getTokens(p6, "parseUDim2")

				v98 *= v99 and v99.Config.UI.Scale or 1
			end

			return UDim.new(tonumber(parts[1]) or 0, v98)
		end

		error("Not enough components in string to parse UDim")
	end)

	if ok and result then
		return result
	end

	error(if typeof(result) ~= "string" then nil else result)
end or function(s6: string, p7, b5: boolean) -- line: 125
	-- upvalues: getTokenOrNumber (copy)
	local ok, result = pcall(function() -- line: 126
		-- upvalues: s6 (copy), getTokenOrNumber (copy), p7 (copy), b5 (copy)
		local parts = string.split(s6, ",")

		if #parts == 2 then
			local v96 = getTokenOrNumber(parts[2], p7, b5, "parseUDim")

			return UDim.new(tonumber(parts[1]) or 0, v96)
		end

		error("Not enough components in string to parse UDim")
	end)

	if ok and result then
		return result
	end

	error(if typeof(result) ~= "string" then nil else result)
end

local function parseNumber(p8, p9, b6: boolean) -- line: 168
	-- upvalues: getSduiTokensStore (copy)
	local ok, result = pcall(function() -- line: 173
		-- upvalues: p8 (copy)
		return (tonumber(p8))
	end)

	if ok and result then
		if b6 then
			local v63 = getSduiTokensStore().getTokens(p9, "parseUDim2")

			return result * (v63 and v63.Config.UI.Scale or 1)
		end

		return result
	end

	error(if typeof(result) ~= "string" then nil else result)
end
local function parseStruct(p10) -- line: 201
	-- upvalues: ProtoVariableMapper (copy), parseStruct (copy)
	if typeof(p10) ~= "table" then
		return p10
	end

	local mapPropName = ProtoVariableMapper.mapPropName
	local t1 = {}

	for v73, v74 in p10 do
		t1[if typeof(v73) ~= "string" then v73 else mapPropName(v73)] = if typeof(v74) ~= "table" then v74 else parseStruct(v74)
	end

	return t1
end
local function parseToString(p11) -- line: 227
	if p11 == nil then
		return nil
	end

	return (tostring(p11))
end
local function parseFocusNavActions(p12) -- line: 247
	-- upvalues: InputHandlers (copy)
	if typeof(p12) ~= "table" then
		return nil
	end

	local t2 = {}

	if typeof(p12.keys) == "table" then
		for v83, v84 in p12.keys do
			if typeof(v84) == "EnumItem" and typeof(v83) == "string" then
				t2[v84] = v83
			end
		end
	end

	local t3 = {}

	if typeof(p12.events) == "table" then
		for v86, v87 in p12.events do
			if typeof(v86) == "string" and typeof(v87) == "function" then
				t3[v86] = {
					handler = InputHandlers.onRelease(v87)
				}
			end
		end
	end

	return {
		keys = t2,
		events = t3
	}
end

return {
	parseUDim = v14,
	parseUDim2 = v13,
	parseNumber = parseNumber,
	applyTokenScaling = function(n1: number, p13) -- line: 16
		return n1 * (p13 and p13.Config.UI.Scale or 1)
	end,
	parseUiScaledNumber = function(p14, p15) -- line: 187
		-- upvalues: parseNumber (copy)
		return parseNumber(p14, p15, true)
	end,
	parseUiScaledUDim = function(s7: string, p16) -- line: 191
		-- upvalues: v14 (copy)
		return v14(s7, p16, true)
	end,
	parseUiScaledUDim2 = function(s8: string, p17) -- line: 195
		-- upvalues: v13 (copy)
		return v13(s8, p17, true)
	end,
	parseStruct = parseStruct,
	parseArrayOfStruct = function(p18) -- line: 216
		-- upvalues: parseStruct (copy)
		if typeof(p18) ~= "table" then
			return p18
		end

		local t4 = {}

		for v77, v78 in p18 do
			t4[v77] = parseStruct(v78)
		end

		return t4
	end,
	parseStringArray = function(p19) -- line: 238
		if typeof(p19) ~= "table" then
			return nil
		end

		return p19.items or p19
	end,
	parseToString = if not FFlagSduiStringPropToString then nil else parseToString,
	parseFocusNavActions = if not FFlagSduiFocusNavActionsStructured then nil else parseFocusNavActions
}
