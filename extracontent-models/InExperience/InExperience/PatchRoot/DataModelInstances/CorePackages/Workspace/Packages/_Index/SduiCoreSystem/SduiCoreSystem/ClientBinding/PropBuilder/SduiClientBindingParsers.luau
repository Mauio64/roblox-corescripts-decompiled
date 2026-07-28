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
local FFlagLuaAppSduiColorPropMigration = require(SduiCoreSystemParent.SharedFlags).FFlagLuaAppSduiColorPropMigration
local FFlagSduiFocusNavActionsStructured = require(SduiCoreSystemParent.SharedFlags).FFlagSduiFocusNavActionsStructured
local FFlagSduiRenderPerf = require(SduiCoreSystemParent.SharedFlags).FFlagSduiRenderPerf

local function resolveTokenValueToNumber(p1, s1: string) -- line: 22
	-- upvalues: FFlagSduiRenderPerf (copy), splitDottedPath (copy)
	local v26 = string.sub(s1, 1, 1) == "-"
	local v27 = if not v26 then s1 else string.sub(s1, 2)
	local v28 = if not FFlagSduiRenderPerf then string.split(v27, ".") else splitDottedPath(v27)
	local v29 = #v28

	for v30, v31 in v28 do
		local v32 = p1[v31]

		if v30 ~= v29 and typeof(v32) ~= "table" then
			error(`Token path { v27 } invalid`)
		end

		p1 = p1[v31]
	end

	if typeof(p1) ~= "number" then
		error(`Token path { v27 } did not resolve to a number: { s1 }`)
	end

	if v26 then
		return p1 * -1
	end

	return p1
end
local function getTokenOrNumber(p2, p3, b1: boolean, s2: string) -- line: 48
	-- upvalues: getSduiTokensStore (copy), resolveTokenValueToNumber (copy)
	local num = tonumber(p2)

	if num then
		if b1 then
			local v38 = getSduiTokensStore().getTokens(p3, s2)

			return num * (v38 and v38.Config.UI.Scale or 1)
		end

		return num
	end

	if typeof(p2) == "string" then
		local ok, result = pcall(function() -- line: 63
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

local v14 = not FFlagSduiPropParsersShouldHandleTokens and function(s3: string, p4, b2: boolean) -- line: 98
	-- upvalues: getSduiTokensStore (copy)
	local ok, result = pcall(function() -- line: 99
		-- upvalues: s3 (copy), b2 (copy), getSduiTokensStore (copy), p4 (copy)
		local parts = string.split(s3, ",")

		if #parts == 4 then
			local v99 = tonumber(parts[2]) or 0
			local v100 = tonumber(parts[4]) or 0

			if b2 then
				local v101 = getSduiTokensStore().getTokens(p4, "parseUDim2")

				v99 *= v101 and v101.Config.UI.Scale or 1
				v100 *= v101 and v101.Config.UI.Scale or 1
			end

			return UDim2.new(tonumber(parts[1]) or 0, v99, tonumber(parts[3]) or 0, v100)
		end

		error("Not enough components in string to parse UDim2")
	end)

	if ok and result then
		return result
	end

	error(if typeof(result) ~= "string" then nil else result)
end or function(s4: string, p5, b3: boolean) -- line: 80
	-- upvalues: getTokenOrNumber (copy)
	local ok, result = pcall(function() -- line: 81
		-- upvalues: s4 (copy), getTokenOrNumber (copy), p5 (copy), b3 (copy)
		local parts = string.split(s4, ",")

		if #parts == 4 then
			local v96 = getTokenOrNumber(parts[2], p5, b3, "parseUDim2")
			local v97 = getTokenOrNumber(parts[4], p5, b3, "parseUDim2")

			return UDim2.new(tonumber(parts[1]) or 0, v96, tonumber(parts[3]) or 0, v97)
		end

		error("Not enough components in string to parse UDim2")
	end)

	if ok and result then
		return result
	end

	error(if typeof(result) ~= "string" then nil else result)
end
local v15 = not FFlagSduiPropParsersShouldHandleTokens and function(s5: string, p6, b4: boolean) -- line: 143
	-- upvalues: getSduiTokensStore (copy)
	local ok, result = pcall(function() -- line: 144
		-- upvalues: s5 (copy), b4 (copy), getSduiTokensStore (copy), p6 (copy)
		local parts = string.split(s5, ",")

		if #parts == 2 then
			local v105 = tonumber(parts[2]) or 0

			if b4 then
				local v106 = getSduiTokensStore().getTokens(p6, "parseUDim2")

				v105 *= v106 and v106.Config.UI.Scale or 1
			end

			return UDim.new(tonumber(parts[1]) or 0, v105)
		end

		error("Not enough components in string to parse UDim")
	end)

	if ok and result then
		return result
	end

	error(if typeof(result) ~= "string" then nil else result)
end or function(s6: string, p7, b5: boolean) -- line: 126
	-- upvalues: getTokenOrNumber (copy)
	local ok, result = pcall(function() -- line: 127
		-- upvalues: s6 (copy), getTokenOrNumber (copy), p7 (copy), b5 (copy)
		local parts = string.split(s6, ",")

		if #parts == 2 then
			local v103 = getTokenOrNumber(parts[2], p7, b5, "parseUDim")

			return UDim.new(tonumber(parts[1]) or 0, v103)
		end

		error("Not enough components in string to parse UDim")
	end)

	if ok and result then
		return result
	end

	error(if typeof(result) ~= "string" then nil else result)
end

local function parseNumber(p8, p9, b6: boolean) -- line: 169
	-- upvalues: getSduiTokensStore (copy)
	local ok, result = pcall(function() -- line: 174
		-- upvalues: p8 (copy)
		return (tonumber(p8))
	end)

	if ok and result then
		if b6 then
			local v66 = getSduiTokensStore().getTokens(p9, "parseUDim2")

			return result * (v66 and v66.Config.UI.Scale or 1)
		end

		return result
	end

	error(if typeof(result) ~= "string" then nil else result)
end
local function parseStruct(p10) -- line: 202
	-- upvalues: ProtoVariableMapper (copy), parseStruct (copy)
	if typeof(p10) ~= "table" then
		return p10
	end

	local mapPropName = ProtoVariableMapper.mapPropName
	local t1 = {}

	for v76, v77 in p10 do
		t1[if typeof(v76) ~= "string" then v76 else mapPropName(v76)] = if typeof(v77) ~= "table" then v77 else parseStruct(v77)
	end

	return t1
end
local function parseToString(p11) -- line: 228
	if p11 == nil then
		return nil
	end

	return (tostring(p11))
end
local function parseColor3(p12) -- line: 249
	if typeof(p12) == "Color3" then
		return p12
	end

	if typeof(p12) == "string" then
		local ok, result = pcall(function() -- line: 254
			-- upvalues: p12 (copy)
			return Color3.fromHex(p12)
		end)

		if ok then
			return result
		end

		return nil
	end

	if typeof(p12) == "table" and typeof(p12.Color3) == "Color3" then
		return p12.Color3
	end

	error(`Could not resolve Color3 from input: { p12 }`)
end
local function parseColorPropLegacy(p13) -- line: 271
	if typeof(p13) == "string" then
		return Color3.fromHex(p13)
	end

	return p13
end
local function parseFocusNavActions(p14) -- line: 281
	-- upvalues: InputHandlers (copy)
	if typeof(p14) ~= "table" then
		return nil
	end

	local t2 = {}

	if typeof(p14.keys) == "table" then
		for v90, v91 in p14.keys do
			if typeof(v91) == "EnumItem" and typeof(v90) == "string" then
				t2[v91] = v90
			end
		end
	end

	local t3 = {}

	if typeof(p14.events) == "table" then
		for v93, v94 in p14.events do
			if typeof(v93) == "string" and typeof(v94) == "function" then
				t3[v93] = {
					handler = InputHandlers.onRelease(v94)
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
	parseUDim = v15,
	parseUDim2 = v14,
	parseNumber = parseNumber,
	applyTokenScaling = function(n1: number, p15) -- line: 17
		return n1 * (p15 and p15.Config.UI.Scale or 1)
	end,
	parseUiScaledNumber = function(p16, p17) -- line: 188
		-- upvalues: parseNumber (copy)
		return parseNumber(p16, p17, true)
	end,
	parseUiScaledUDim = function(s7: string, p18) -- line: 192
		-- upvalues: v15 (copy)
		return v15(s7, p18, true)
	end,
	parseUiScaledUDim2 = function(s8: string, p19) -- line: 196
		-- upvalues: v14 (copy)
		return v14(s8, p19, true)
	end,
	parseStruct = parseStruct,
	parseArrayOfStruct = function(p20) -- line: 217
		-- upvalues: parseStruct (copy)
		if typeof(p20) ~= "table" then
			return p20
		end

		local t4 = {}

		for v80, v81 in p20 do
			t4[v80] = parseStruct(v81)
		end

		return t4
	end,
	parseStringArray = function(p21) -- line: 239
		if typeof(p21) ~= "table" then
			return nil
		end

		return p21.items or p21
	end,
	parseToString = if not FFlagSduiStringPropToString then nil else parseToString,
	parseColor3 = if not FFlagLuaAppSduiColorPropMigration then nil else parseColor3,
	parseColorPropLegacy = if not FFlagLuaAppSduiColorPropMigration then nil else parseColorPropLegacy,
	parseFocusNavActions = if not FFlagSduiFocusNavActionsStructured then nil else parseFocusNavActions
}
