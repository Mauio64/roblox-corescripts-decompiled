local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.Signals)
require(SduiCoreSystemParent.Foundation)
require(SduiCoreSystemParent.ReactFocusNavigation)

local InputHandlers = require(SduiCoreSystemParent.InputHandlers)
local getSduiTokensStore = require(SduiCoreSystem.ClientBinding.getSduiTokensStore)
local ProtoVariableMapper = require(SduiCoreSystem.ClientBinding.ProtoVariableMapper)
local splitDottedPath = require(SduiCoreSystem.ClientBinding.splitDottedPath)
local FFlagSduiStructPropParsers = require(SduiCoreSystemParent.SharedFlags).FFlagSduiStructPropParsers
local FFlagSduiStringPropToString = require(SduiCoreSystemParent.SharedFlags).FFlagSduiStringPropToString
local FFlagSduiPropParsersShouldHandleTokens = require(SduiCoreSystemParent.SharedFlags).FFlagSduiPropParsersShouldHandleTokens
local FFlagSduiFocusNavActionsStructured = require(SduiCoreSystemParent.SharedFlags).FFlagSduiFocusNavActionsStructured
local FFlagSduiRenderPerf = require(SduiCoreSystemParent.SharedFlags).FFlagSduiRenderPerf

local function resolveTokenValueToNumber(p1, s1: string) -- line: 23
	-- upvalues: FFlagSduiRenderPerf (copy), splitDottedPath (copy)
	local v25 = string.sub(s1, 1, 1) == "-"
	local v26 = if not v25 then s1 else string.sub(s1, 2)
	local v27 = if not FFlagSduiRenderPerf then string.split(v26, ".") else splitDottedPath(v26)
	local v28 = #v27

	for v29, v30 in v27 do
		local v31 = p1[v30]

		if v29 ~= v28 and typeof(v31) ~= "table" then
			error(`Token path { v26 } invalid`)
		end

		p1 = p1[v30]
	end

	if typeof(p1) ~= "number" then
		error(`Token path { v26 } did not resolve to a number: { s1 }`)
	end

	if v25 then
		return p1 * -1
	end

	return p1
end
local function getTokenOrNumber(p2, p3, b1: boolean, s2: string) -- line: 49
	-- upvalues: getSduiTokensStore (copy), resolveTokenValueToNumber (copy)
	local num = tonumber(p2)

	if num then
		if b1 then
			local v37 = getSduiTokensStore().getTokens(p3, s2)

			return num * (v37 and v37.Config.UI.Scale or 1)
		end

		return num
	end

	if typeof(p2) == "string" then
		local ok, result = pcall(function() -- line: 64
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

local v14 = not FFlagSduiPropParsersShouldHandleTokens and function(s3: string, p4, b2: boolean) -- line: 99
	-- upvalues: getSduiTokensStore (copy)
	local ok, result = pcall(function() -- line: 100
		-- upvalues: s3 (copy), b2 (copy), getSduiTokensStore (copy), p4 (copy)
		local parts = string.split(s3, ",")

		if #parts == 4 then
			local v94 = tonumber(parts[2]) or 0
			local v95 = tonumber(parts[4]) or 0

			if b2 then
				local v96 = getSduiTokensStore().getTokens(p4, "parseUDim2")

				v94 *= v96 and v96.Config.UI.Scale or 1
				v95 *= v96 and v96.Config.UI.Scale or 1
			end

			return UDim2.new(tonumber(parts[1]) or 0, v94, tonumber(parts[3]) or 0, v95)
		end

		error("Not enough components in string to parse UDim2")
	end)

	if ok and result then
		return result
	end

	error(if typeof(result) ~= "string" then nil else result)
end or function(s4: string, p5, b3: boolean) -- line: 81
	-- upvalues: getTokenOrNumber (copy)
	local ok, result = pcall(function() -- line: 82
		-- upvalues: s4 (copy), getTokenOrNumber (copy), p5 (copy), b3 (copy)
		local parts = string.split(s4, ",")

		if #parts == 4 then
			local v91 = getTokenOrNumber(parts[2], p5, b3, "parseUDim2")
			local v92 = getTokenOrNumber(parts[4], p5, b3, "parseUDim2")

			return UDim2.new(tonumber(parts[1]) or 0, v91, tonumber(parts[3]) or 0, v92)
		end

		error("Not enough components in string to parse UDim2")
	end)

	if ok and result then
		return result
	end

	error(if typeof(result) ~= "string" then nil else result)
end
local v15 = not FFlagSduiPropParsersShouldHandleTokens and function(s5: string, p6, b4: boolean) -- line: 144
	-- upvalues: getSduiTokensStore (copy)
	local ok, result = pcall(function() -- line: 145
		-- upvalues: s5 (copy), b4 (copy), getSduiTokensStore (copy), p6 (copy)
		local parts = string.split(s5, ",")

		if #parts == 2 then
			local v100 = tonumber(parts[2]) or 0

			if b4 then
				local v101 = getSduiTokensStore().getTokens(p6, "parseUDim2")

				v100 *= v101 and v101.Config.UI.Scale or 1
			end

			return UDim.new(tonumber(parts[1]) or 0, v100)
		end

		error("Not enough components in string to parse UDim")
	end)

	if ok and result then
		return result
	end

	error(if typeof(result) ~= "string" then nil else result)
end or function(s6: string, p7, b5: boolean) -- line: 127
	-- upvalues: getTokenOrNumber (copy)
	local ok, result = pcall(function() -- line: 128
		-- upvalues: s6 (copy), getTokenOrNumber (copy), p7 (copy), b5 (copy)
		local parts = string.split(s6, ",")

		if #parts == 2 then
			local v98 = getTokenOrNumber(parts[2], p7, b5, "parseUDim")

			return UDim.new(tonumber(parts[1]) or 0, v98)
		end

		error("Not enough components in string to parse UDim")
	end)

	if ok and result then
		return result
	end

	error(if typeof(result) ~= "string" then nil else result)
end

local function parseNumber(p8, p9, b6: boolean) -- line: 170
	-- upvalues: getSduiTokensStore (copy)
	local ok, result = pcall(function() -- line: 175
		-- upvalues: p8 (copy)
		return (tonumber(p8))
	end)

	if ok and result then
		if b6 then
			local v65 = getSduiTokensStore().getTokens(p9, "parseUDim2")

			return result * (v65 and v65.Config.UI.Scale or 1)
		end

		return result
	end

	error(if typeof(result) ~= "string" then nil else result)
end
local function parseStruct(p10) -- line: 203
	-- upvalues: ProtoVariableMapper (copy), parseStruct (copy)
	if typeof(p10) ~= "table" then
		return p10
	end

	local mapPropName = ProtoVariableMapper.mapPropName
	local t1 = {}

	for v75, v76 in p10 do
		t1[if typeof(v75) ~= "string" then v75 else mapPropName(v75)] = if typeof(v76) ~= "table" then v76 else parseStruct(v76)
	end

	return t1
end
local function parseArrayOfStruct(p11) -- line: 218
	-- upvalues: parseStruct (copy)
	if typeof(p11) ~= "table" then
		return p11
	end

	local t2 = {}

	for v79, v80 in p11 do
		t2[v79] = parseStruct(v80)
	end

	return t2
end
local function parseToString(p12) -- line: 229
	if p12 == nil then
		return nil
	end

	return (tostring(p12))
end
local function parseFocusNavActions(p13) -- line: 249
	-- upvalues: InputHandlers (copy)
	if typeof(p13) ~= "table" then
		return nil
	end

	local t3 = {}

	if typeof(p13.keys) == "table" then
		for v85, v86 in p13.keys do
			if typeof(v86) == "EnumItem" and typeof(v85) == "string" then
				t3[v86] = v85
			end
		end
	end

	local t4 = {}

	if typeof(p13.events) == "table" then
		for v88, v89 in p13.events do
			if typeof(v88) == "string" and typeof(v89) == "function" then
				t4[v88] = {
					handler = InputHandlers.onRelease(v89)
				}
			end
		end
	end

	return {
		keys = t3,
		events = t4
	}
end

return {
	parseUDim = v15,
	parseUDim2 = v14,
	parseNumber = parseNumber,
	applyTokenScaling = function(n1: number, p14) -- line: 18
		return n1 * (p14 and p14.Config.UI.Scale or 1)
	end,
	parseUiScaledNumber = function(p15, p16) -- line: 189
		-- upvalues: parseNumber (copy)
		return parseNumber(p15, p16, true)
	end,
	parseUiScaledUDim = function(s7: string, p17) -- line: 193
		-- upvalues: v15 (copy)
		return v15(s7, p17, true)
	end,
	parseUiScaledUDim2 = function(s8: string, p18) -- line: 197
		-- upvalues: v14 (copy)
		return v14(s8, p18, true)
	end,
	parseStruct = if not FFlagSduiStructPropParsers then nil else parseStruct,
	parseArrayOfStruct = if not FFlagSduiStructPropParsers then nil else parseArrayOfStruct,
	parseStringArray = function(p19) -- line: 240
		if typeof(p19) ~= "table" then
			return nil
		end

		return p19.items or p19
	end,
	parseToString = if not FFlagSduiStringPropToString then nil else parseToString,
	parseFocusNavActions = if not FFlagSduiFocusNavActionsStructured then nil else parseFocusNavActions
}
