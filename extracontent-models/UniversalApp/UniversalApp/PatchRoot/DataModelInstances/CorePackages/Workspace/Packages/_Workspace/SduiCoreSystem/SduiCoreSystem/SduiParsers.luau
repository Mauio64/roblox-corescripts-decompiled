local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local Cryo = require(SduiCoreSystemParent.Cryo)
local React = require(SduiCoreSystemParent.React)
local Images = require(SduiCoreSystemParent.FoundationImages).Images
local GetImageData = require(SduiCoreSystemParent.RobloxAppAssets).GetImageData
local FocusNavigationEventNameEnum = require(SduiCoreSystemParent.FocusNavigationUtils).FocusNavigationEventNameEnum
local InputHandlers = require(SduiCoreSystemParent.InputHandlers)
local executeAction = require(SduiCoreSystem.executeAction)

require(SduiCoreSystem.SduiActionType)

local SduiBuilder = require(SduiCoreSystem.SduiBuilder)
local SduiBuilderProcessingPhase = require(SduiCoreSystem.SduiBuilderTypes).SduiBuilderProcessingPhase

require(SduiCoreSystem.SduiComponentType)
require(SduiCoreSystem.SduiConfigTypes)

local SduiResponsiveHelpers = require(SduiCoreSystem.SduiResponsiveHelpers)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiErrorType = SduiErrors.SduiErrorType
local getSduiComponentWrapper = require(SduiCoreSystem.getSduiComponentWrapper)
local getSduiActionHandlerRegistry = require(SduiCoreSystem.getSduiActionHandlerRegistry)
local getSduiTokensStore = require(SduiCoreSystem.ClientBinding.getSduiTokensStore)
local FFlagSduiActionTelemetryHandler = require(SduiCoreSystemParent.SharedFlags).FFlagSduiActionTelemetryHandler

require(SduiCoreSystem.SduiContentTypes)

local SduiParseHelpers = require(SduiCoreSystem.SduiParseHelpers)

require(SduiCoreSystem.SduiFocusNavigationTypes)

local function withErrorHandling(p1) -- line: 45
	-- upvalues: Cryo (copy), SduiParseHelpers (copy), SduiErrorType (copy)
	return function(p2, p3, p4, p5) -- line: 46
		-- upvalues: p1 (copy), Cryo (copy), SduiParseHelpers (copy), SduiErrorType (copy)
		local ok, result = pcall(function() -- line: 47
			-- upvalues: p1 (copy), p2 (copy), p3 (copy), p4 (copy), p5 (copy)
			return p1(p2, p3, p4, p5)
		end)

		if ok then
			return result
		end

		local v396 = Cryo.Dictionary.join(if typeof(result) ~= "table" then if typeof(result) ~= "string" then {} else {
			message = result
		} else result, {
			value = SduiParseHelpers.stringifyValue(p2)
		})

		p3.dependencies.logger.reportError(SduiErrorType.FailedToParse, v396, p3.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end
end
local function parseFoundationTokenHelper(p6, s1: string, s2: string, p7) -- line: 81
	-- upvalues: getSduiTokensStore (copy)
	local v63 = typeof(p6)

	if v63 == s1 then
		return p6
	end

	if v63 ~= "string" then
		error({
			parserName = s2,
			message = `Invalid inputType. Expect string. { v63 }`
		})
	end

	local v64 = getSduiTokensStore().getTokens(false, p7.appPage)

	for _, v66 in (p6:split(".")) do
		if typeof(v64) == "table" then
			v64 = v64[v66]
		else
			error({
				parserName = s2,
				message = `Invalid path for token for input { p6 }`
			})
		end

		if v64 == nil then
			error({
				parserName = s2,
				message = `Nil tokens for input { p6 }`
			})
		end
	end

	if s1 ~= typeof(v64) then
		error({
			parserName = s2,
			message = `Unexpected token type for { p6 }. { typeof(v64) } ~= { s1 }`
		})
	end

	return v64
end
local function parseNumberToken(p8, p9, _, _) -- line: 122
	-- upvalues: parseFoundationTokenHelper (copy)
	return (parseFoundationTokenHelper(p8, "number", "parseNumberToken", p9))
end
local function parseTypographyToken(p12, p13, _, _) -- line: 131
	-- upvalues: parseFoundationTokenHelper (copy)
	return (parseFoundationTokenHelper(p12, "table", "parseTypographyToken", p13))
end
local function parseFontFromTypographyToken(p16, p17, _, _) -- line: 140
	-- upvalues: parseFoundationTokenHelper (copy)
	return (parseFoundationTokenHelper(p16, "EnumItem", "parseFontFromTypographyToken", p17))
end
local function parseColorToken(p20, p21, _, _) -- line: 149
	-- upvalues: parseFoundationTokenHelper (copy)
	return (parseFoundationTokenHelper(p20, "table", "parseColorToken", p21))
end
local function parseLuaTableEnumHelper(p24, s3: string, t1: {[any]: any}, t2: {[any]: any}) -- line: 158
	local v87 = typeof(p24)

	if v87 == s3 and t2[p24] then
		return p24
	end

	if v87 ~= "string" then
		error({
			parserName = "parseLuaTableEnumHelper",
			message = `Invalid input type to parser: { v87 }. Expected string.`
		})
	end

	local v88 = t1[p24]

	if v88 ~= nil then
		return v88
	end

	local s4 = ""

	for v90 in t2 do
		s4 ..= v90 .. ", "
	end

	error({
		parserName = "parseLuaTableEnumHelper",
		message = `Failed to parse lua table enum. input: { p24 } validValues: { s4 }`
	})
end

local t3 = {}

local function makeLuaTableEnumParser(t4: {[any]: any}, s5: string) -- line: 196
	-- upvalues: parseLuaTableEnumHelper (copy)
	local t5 = {}

	for _, v95 in t4 do
		t5[v95] = true
	end

	return function(p25, _, _, _) -- line: 201
		-- upvalues: parseLuaTableEnumHelper (copy), s5 (copy), t4 (copy), t5 (copy)
		return parseLuaTableEnumHelper(p25, s5, t4, t5)
	end
end
local function parseEngineEnumHelper(p29, p30) -- line: 218
	if typeof(p29) == "EnumItem" then
		return p29
	end

	if typeof(p29) ~= "string" then
		error({
			parserName = "parseEngineEnumHelper",
			message = `Invalid input type Engine Enum value. Expect string. received { p29 }`
		})
	end

	local ok, result = pcall(function() -- line: 229
		-- upvalues: p30 (copy), p29 (copy)
		return p30[p29]
	end)

	if ok then
		return result
	end

	error({
		parserName = "parseEngineEnumHelper",
		message = result
	})
end

local t6 = {}

local function makeEngineEnumParser(p31) -- line: 245
	-- upvalues: parseEngineEnumHelper (copy)
	return function(p32, _, _, _) -- line: 246
		-- upvalues: parseEngineEnumHelper (copy), p31 (copy)
		return parseEngineEnumHelper(p32, p31)
	end
end
local function parseUDim2(p36, _, _, _) -- line: 266
	local v112 = typeof(p36)

	if v112 == "UDim2" then
		return p36
	end

	local ok, result = pcall(function() -- line: 277
		-- upvalues: v112 (copy), p36 (copy)
		if v112 == "string" then
			local parts = string.split(p36, ",")

			if #parts == 4 then
				return UDim2.new(tonumber(parts[1]) or 0, tonumber(parts[2]) or 0, tonumber(parts[3]) or 0, tonumber(parts[4]) or 0)
			end

			error("Not enough components in string to parse UDim2")

			return
		end

		if v112 == "table" then
			if #p36 == 4 then
				return UDim2.new(tonumber(p36[1]) or 0, tonumber(p36[2]) or 0, tonumber(p36[3]) or 0, tonumber(p36[4]) or 0)
			end

			error("Not enough components in table to parse UDim2")

			return
		end

		error(`Invalid input type for parseUDim2: { v112 }`)
	end)

	if ok and result then
		return result
	end

	error({
		parserName = "parseUDim2",
		message = if typeof(result) ~= "string" then nil else result
	})
end
local function parseUDim(p40, _, _, _) -- line: 316
	local v119 = typeof(p40)

	if v119 == "UDim" then
		return p40
	end

	local ok, result = pcall(function() -- line: 327
		-- upvalues: v119 (copy), p40 (copy)
		if v119 == "string" then
			local parts = string.split(p40, ",")

			if #parts == 2 then
				return UDim.new(tonumber(parts[1]) or 0, tonumber(parts[2]) or 0)
			end

			error("Not enough components in string to parse UDim")

			return
		end

		if v119 == "table" then
			if #p40 == 2 then
				return UDim.new(tonumber(p40[1]) or 0, tonumber(p40[2]) or 0)
			end

			error("Not enough components in table to parse UDim")

			return
		end

		if v119 == "number" then
			return UDim.new(0, p40)
		end

		error(`Invalid input type for parseUDim: { v119 }`)
	end)

	if ok and result then
		return result
	end

	error({
		parserName = "parseUDim",
		message = if typeof(result) ~= "string" then nil else result
	})
end
local function parseColor3(p44, p45, p46, p47) -- line: 358
	-- upvalues: parseFoundationTokenHelper (copy)
	local v126 = typeof(p44)

	if v126 == "Color3" then
		return p44
	end

	local ok, result = pcall(function() -- line: 369
		-- upvalues: v126 (copy), p44 (copy), p45 (copy), p46 (copy), p47 (copy), parseFoundationTokenHelper (copy)
		if v126 == "string" then
			local ok, result = pcall(function() -- line: 372
				-- upvalues: p44 (copy)
				return Color3.fromHex(p44)
			end)

			if ok and result then
				return result
			end

			local ok2, result2 = pcall(function() -- line: 382
				-- upvalues: p44 (copy), p45 (copy), p46 (copy), p47 (copy), parseFoundationTokenHelper (copy)
				local v451 = p44
				local v452 = p45
				local _ = p46
				local _ = p47

				return (parseFoundationTokenHelper(v451, "table", "parseColorToken", v452))
			end)

			if ok2 and typeof(result2) == "table" and result2.Color3 ~= nil then
				return result2.Color3
			end

			error(`Invalid input for Color3: { p44 }`)

			return
		end

		if v126 == "table" then
			return Color3.fromRGB(p44.r, p44.g, p44.b)
		end

		error(`Invalid input type for parseColor3: { v126 }`)
	end)

	if ok and result then
		return result
	end

	error({
		parserName = "parseColor3",
		message = if typeof(result) ~= "string" then if typeof(result) ~= "table" then nil else result.message else result
	})
end

local color3 = Color3.new(0, 0, 0)
local t7 = {
	startOpacity = 0,
	endOpacity = 1,
	degree = 270,
	startColor = color3,
	endColor = color3
}

local function isValidGradient(p48) -- line: 420
	if typeof(p48) ~= "table" then
		return false
	end

	if typeof(p48.startColor) ~= "Color3" then
		return false
	end

	if typeof(p48.endColor) ~= "Color3" then
		return false
	end

	if typeof(p48.startOpacity) ~= "number" then
		return false
	end

	if typeof(p48.endOpacity) ~= "number" then
		return false
	end

	if typeof(p48.degree) ~= "number" then
		return false
	end

	return true
end
local function parseGradient(p49, p50, p51, p52) -- line: 444
	-- upvalues: isValidGradient (copy), parseColor3 (copy), t7 (copy)
	local v134 = typeof(p49)

	if v134 == "table" then
		if isValidGradient(p49) then
			return p49
		end
	else
		error({
			parserName = "parseGradient",
			message = `invalid input type for parseGradient: { v134 }`
		})
	end

	local result

	if p49.startColor then
		local ok

		ok, result = pcall(function() -- line: 464
			-- upvalues: parseColor3 (copy), p49 (copy), p50 (copy), p51 (copy), p52 (copy)
			return parseColor3(p49.startColor, p50, p51, p52)
		end)

		if not ok then
			error({
				parserName = "parseGradient",
				message = typeof(result) ~= "string" and "failed to parse startColor field" or result
			})
		end
	else
		result = t7.startColor
	end

	local result3

	if p49.endColor then
		local ok

		ok, result3 = pcall(function() -- line: 479
			-- upvalues: parseColor3 (copy), p49 (copy), p50 (copy), p51 (copy), p52 (copy)
			return parseColor3(p49.endColor, p50, p51, p52)
		end)

		if not ok then
			error({
				parserName = "parseGradient",
				message = typeof(result3) ~= "string" and "failed to parse endColor field" or result3
			})
		end
	else
		result3 = t7.endColor
	end

	local startOpacity = nil

	if typeof(p49.startOpacity) == "number" then
		startOpacity = p49.startOpacity
	elseif p49.startOpacity ~= nil then
		error({
			parserName = "parseGradient",
			message = `invalid input type for startOpacity: { typeof(p49.startOpacity) }`
		})
	end

	local endOpacity = nil

	if typeof(p49.endOpacity) == "number" then
		endOpacity = p49.endOpacity
	elseif p49.endOpacity ~= nil then
		error({
			parserName = "parseGradient",
			message = `invalid input type for endOpacity: { typeof(p49.endOpacity) }`
		})
	end

	local degree = nil

	if typeof(p49.degree) == "number" then
		degree = p49.degree
	elseif p49.degree ~= nil then
		error({
			parserName = "parseGradient",
			message = `invalid input type for degree: { typeof(p49.degree) }`
		})
	end

	return {
		startColor = result,
		endColor = result3,
		startOpacity = startOpacity or t7.startOpacity,
		endOpacity = endOpacity or t7.endOpacity,
		degree = degree or t7.degree
	}
end

local t8 = {
	truncate_arrows = true,
	squircles = true,
	gradient = true,
	component_assets = true,
	chat_bubble = true,
	icons = true
}

local function isValidIconString(s6: string) -- line: 553
	-- upvalues: t8 (copy)
	local parts = s6:split("/")

	if parts and (#parts > 1 and t8[parts[1]]) then
		return true
	end

	return false
end
local function parseIcon(p53, _, _, _) -- line: 566
	-- upvalues: GetImageData (copy), Images (copy)
	local result = nil

	if typeof(p53) == "table" and (typeof(p53.ImageRectOffset) == "Vector2" and (typeof(p53.Image) == "string" and typeof(p53.ImageRectSize) == "Vector2")) then
		return p53
	end

	if typeof(p53) == "string" then
		local ok

		ok, result = pcall(function() -- line: 576
			-- upvalues: GetImageData (copy), p53 (copy), Images (copy)
			return GetImageData(p53) or Images[p53]
		end)

		if not ok or not result then
			error({
				parserName = "parseIcon",
				message = `No icon found for { p53 }`
			})
		end
	end

	if not result then
		error({
			parserName = "parseIcon",
			message = `Bad input for icon: { p53 }`
		})
	end

	return result
end
local function isValidActionConfig(p57, _) -- line: 597
	-- upvalues: getSduiActionHandlerRegistry (copy), FFlagSduiActionTelemetryHandler (copy)
	if typeof(p57) == "table" and typeof(p57.actionType) == "string" then
		local v153 = getSduiActionHandlerRegistry().getActionHandlerConfig(p57.actionType)

		if FFlagSduiActionTelemetryHandler then
			return v153 ~= nil and (v153.handler ~= nil or v153.telemetryHandler ~= nil)
		end

		return v153 ~= nil and v153.handler ~= nil
	end

	return false
end
local function isCallableTable(p59) -- line: 613
	if typeof(p59) == "table" then
		local mt = getmetatable(p59)

		if mt and type(mt.__call) == "function" then
			return true
		end
	end

	return false
end
local function parseCallback(p60, p61, p62, _) -- line: 624
	-- upvalues: isValidActionConfig (copy), executeAction (copy), SduiErrors (copy)
	local v160 = typeof(p60)
	local u161 = nil

	if v160 == "function" then
		return p60
	end

	local g162 = nil
	local mt = nil
	local v164 = nil

	repeat
		if g162 or typeof(p60) == "table" then
			if not g162 then
				mt = getmetatable(p60)
			end

			if g162 or mt and type(mt.__call) == "function" then
				if not g162 then
					v164 = true
				end

				g162 = false

				if v164 then
					p60.analyticsContext = p62
					p60.sduiContext = p61

					return p60
				end

				if isValidActionConfig(p60, p61) then
					u161 = p60
				end

				if u161 then
					local t9 = {
						analyticsContext = p62,
						sduiContext = p61
					}

					setmetatable(t9, {
						__call = function(p64, p65) -- line: 649
							-- upvalues: executeAction (copy), u161 (ref)
							return executeAction(u161, p64.analyticsContext, p64.sduiContext, p65)
						end
					})

					return t9
				end

				local v166 = typeof(p60) == "table" and p60.actionType or "unknown"

				error({
					parserName = "parseCallback",
					message = `Could not find action for: { p60 } actionType: { v166 }`,
					overrideValue = function() -- line: 661
						-- upvalues: p61 (copy), SduiErrors (copy), v166 (copy)
						p61.dependencies.logger.reportCounter(SduiErrors.SduiCounterName.ExecutedInvalidAction, {
							name = v166
						})
					end
				})

				return
			end
		end

		v164 = false
		g162 = true
	until not g162
end
local function parseLazyCallback(p66, _, _, _) -- line: 671
	return p66
end
local function parseLazyUiComponent(p70, p71, p72, p73) -- line: 681
	-- upvalues: SduiBuilderProcessingPhase (copy), SduiBuilder (copy)
	if p73 == SduiBuilderProcessingPhase.Eager then
		local ok, result = pcall(function() -- line: 689
			-- upvalues: p70 (copy), SduiBuilder (copy), p71 (copy), p72 (copy)
			if typeof(p70) ~= "table" then
				error(`Invalid input type { typeof(p70) }`)
			end

			local v421, v422 = SduiBuilder.tryCreateEagerProcessedComponentConfig(p70, p71, "parseUiComponent", p72)

			if v421 then
				return v422
			end

			error("Unable to parse componentConfig during Eager phase")
		end)

		if ok and result then
			return result
		end

		error({
			parserName = "parseLazyUiComponent",
			message = if typeof(result) ~= "string" then nil else result
		})

		return
	end

	return p70
end
local function parseUiComponent(p74, p75, p76, p77) -- line: 720
	-- upvalues: SduiBuilderProcessingPhase (copy), SduiBuilder (copy), getSduiComponentWrapper (copy), React (copy)
	local ok, result

	if p77 == SduiBuilderProcessingPhase.Eager then
		ok, result = pcall(function() -- line: 730
			-- upvalues: p74 (copy), SduiBuilder (copy), p75 (copy), p76 (copy)
			if typeof(p74) ~= "table" then
				error(`Invalid input type { typeof(p74) }`)
			end

			local v423, v424 = SduiBuilder.tryCreateEagerProcessedComponentConfig(p74, p75, "parseUiComponent", p76)

			if v423 then
				return v424
			end

			error("Unable to parse componentConfig during Eager phase")
		end)
	else
		ok, result = pcall(function() -- line: 748
			-- upvalues: p74 (copy), getSduiComponentWrapper (copy), React (copy), p75 (copy), p76 (copy)
			if typeof(p74) == "table" then
				local v425 = getSduiComponentWrapper(p74)

				return React.createElement(v425, {
					componentConfig = p74,
					sduiContext = p75,
					parentAnalyticsContext = p76,
					debugName = `parsedUiComponent-{ p74.componentType }`
				})
			end

			error(`Invalid input type { typeof(p74) }`)
		end)
	end

	if ok and result then
		return result
	end

	error({
		parserName = "parseUiComponent",
		message = if typeof(result) ~= "string" then nil else result
	})
end
local function parseVector2(p78, _, _, _) -- line: 775
	local v187 = typeof(p78)

	if v187 == "Vector2" then
		return p78
	end

	local ok, result = pcall(function() -- line: 786
		-- upvalues: v187 (copy), p78 (copy)
		if v187 == "string" then
			local parts = string.split(p78, ",")

			if #parts == 2 then
				return Vector2.new(tonumber(parts[1]) or 0, tonumber(parts[2]) or 0)
			end

			error("Not enough components in string to parse Vector2")

			return
		end

		if v187 == "table" then
			if #p78 == 2 then
				return Vector2.new(tonumber(p78[1]) or 0, tonumber(p78[2]) or 0)
			end

			error("Not enough components in table to parse Vector2")

			return
		end

		error(`Invalid input type for parseVector2: { v187 }`)
	end)

	if ok and result then
		return result
	end

	error({
		parserName = "parseVector2",
		message = if typeof(result) ~= "string" then nil else result
	})
end
local function parseNumber(p82, p83, p84, p85) -- line: 814
	-- upvalues: parseFoundationTokenHelper (copy)
	local v194 = typeof(p82)

	if v194 == "number" then
		return p82
	end

	if v194 == "string" then
		local ok, result = pcall(function() -- line: 824
			-- upvalues: p82 (copy)
			return (tonumber(p82))
		end)

		if not ok or result == nil then
			ok, result = pcall(function() -- line: 830
				-- upvalues: p82 (copy), p83 (copy), p84 (copy), p85 (copy), parseFoundationTokenHelper (copy)
				local v427 = p82
				local v428 = p83
				local _ = p84
				local _ = p85

				return (parseFoundationTokenHelper(v427, "number", "parseNumberToken", v428))
			end)
		end

		if ok and result then
			return result
		end

		error({
			parserName = "parseNumber",
			message = if typeof(result) ~= "string" then `Failed to parse string { p82 } to number` else result
		})

		return
	end

	error({
		parserName = "parseNumber",
		message = `Invalid input type for parseNumber: { v194 }`
	})
end
local function parseInteger(p86, _, _, _) -- line: 850
	local v201 = typeof(p86)

	if v201 == "number" then
		return p86
	end

	if v201 == "string" then
		local ok, result = pcall(function() -- line: 860
			-- upvalues: p86 (copy)
			return (tonumber(p86))
		end)

		if ok and result then
			if p86 ~= tostring((math.round(result))) then
				error({
					parserName = "parseInteger",
					message = if typeof(result) ~= "string" then `Unexpected output { result } does not match input { p86 }.` else result
				})
			end

			return result
		end

		error({
			parserName = "parseInteger",
			message = if typeof(result) ~= "string" then `Failed to parse string { p86 } to number` else result
		})

		return
	end

	error({
		parserName = "parseInteger",
		message = `Invalid input type for parseInteger: { v201 }`
	})
end
local function parseBoolean(p90, _, _, _) -- line: 888
	local v208 = typeof(p90)

	if v208 == "boolean" then
		return p90
	end

	if v208 == "number" then
		if p90 == 1 then
			return true
		end

		if p90 == 0 then
			return false
		end

		error({
			parserName = "parseBoolean",
			message = `Failed to parse number { p90 } to boolean`
		})

		return
	end

	if v208 == "string" then
		local v209 = string.lower(p90)

		if v209 == "t" or v209 == "true" then
			return true
		end

		if v209 == "f" or v209 == "false" then
			return false
		end

		error({
			parserName = "parseBoolean",
			message = `Failed to parse string { p90 } to boolean`
		})

		return
	end

	error({
		parserName = "parseBoolean",
		message = `Invalid input type for parseBoolean: { v208 }`
	})
end
local function parseString(p94, _, _, _) -- line: 926
	local v214 = typeof(p94)

	if v214 == "string" then
		return p94
	end

	if v214 == "number" or v214 == "boolean" then
		return (tostring(p94))
	end

	error({
		parserName = "parseString",
		message = `Invalid input type for parseString: { v214 }`
	})
end
local function parseImageString(p98, _, _, _) -- line: 947
	-- upvalues: SduiResponsiveHelpers (copy)
	local v219 = typeof(p98)

	if v219 ~= "string" then
		error({
			parserName = "parseImageString",
			message = `Invalid input type for parseImageString: { v219 }`
		})
	end

	local parts = p98:split("://")

	if not (#parts > 1) or parts[1] ~= "rbxthumb" then
		return p98
	end

	local t10 = {}

	for _, v223 in (parts[2]:split("&")) do
		local parts2 = v223:split("=")

		if #parts2 == 2 then
			t10[parts2[1]] = parts2[2]
		end
	end

	if t10.mw == nil or t10.mh == nil then
		return p98
	end

	local num = tonumber(t10.w)
	local num2 = tonumber(t10.h)
	local num3 = tonumber(t10.mw)
	local num4 = tonumber(t10.mh)

	if num == nil or num2 == nil or num3 == nil or num4 == nil or t10.type == nil or t10.id == nil then
		error({
			parserName = "parseImageString",
			message = `Invalid params for rbxthumb in parseImageString: { p98 }`
		})
	end

	assert(num, "inputWidth must exist")
	assert(num2, "inputHeight must exist")
	assert(num3, "inputWidth must exist")
	assert(num4, "inputHeight must exist")

	local v229, v230 = SduiResponsiveHelpers.adaptThumbnailDimensions(num, num2, num3, num4, t10.type)
	local v231 = `rbxthumb://type={ t10.type }&id={ t10.id }&w={ v229 }&h={ v230 }`

	t10.w = nil
	t10.h = nil
	t10.mw = nil
	t10.mh = nil
	t10.id = nil
	t10.type = nil

	for v232, v233 in t10 do
		v231 ..= string.format("&%s=%s", v232, v233)
	end

	return v231
end
local function parseImageSetOrImage(p102, p103, p104, p105) -- line: 1023
	-- upvalues: t8 (copy), parseIcon (copy), parseImageString (copy)
	local v238 = typeof(p102)

	if v238 == "table" then
		return p102
	end

	if v238 ~= "string" then
		error({
			parserName = "parseImageSetOrImage",
			message = `Invalid input type for parseImageSetOrImage: { v238 }`
		})
	end

	local parts = p102:split("/")

	if not not parts and (#parts > 1 and not not t8[parts[1]]) then
		return (parseIcon(p102, p103, p104, p105))
	end

	return (parseImageString(p102, p103, p104, p105))
end
local function isValidFocusNavActions(p106) -- line: 1045
	-- upvalues: FocusNavigationEventNameEnum (copy)
	if typeof(p106) ~= "table" then
		return false
	end

	local v241 = nil
	local v242 = nil
	local keys = p106.keys

	if keys then
		if typeof(keys) ~= "table" then
			return false
		end

		for v244, v245 in keys do
			if typeof(v244) ~= "EnumItem" then
				return false
			end

			if FocusNavigationEventNameEnum[v245] == nil then
				return false
			end

			v241 = true
		end
	end

	local events = p106.events

	if events then
		if typeof(events) ~= "table" then
			return false
		end

		for v247, v248 in events do
			if FocusNavigationEventNameEnum[v247] == nil then
				return false
			end

			if typeof(v248) ~= "table" then
				return false
			end

			if typeof(v248.handler) ~= "function" then
				return false
			end

			v242 = true
		end
	end

	return v241 or (v242 or false)
end
local function parseFocusNavActions(p107, p108, p109, p110) -- line: 1103
	-- upvalues: isValidFocusNavActions (copy), FocusNavigationEventNameEnum (copy), t3 (copy), parseLuaTableEnumHelper (copy), t6 (copy), parseEngineEnumHelper (copy), InputHandlers (copy), parseCallback (copy)
	if isValidFocusNavActions(p107) then
		return p107
	end

	local v253 = typeof(p107)

	if v253 ~= "table" then
		error({
			parserName = "parseFocusNavActions",
			message = `Invalid input type for parseFocusNavActions: { v253 }`
		})
	end

	assert(typeof(p107) == "table", "input must be table")

	local ok, result = pcall(function() -- line: 1122
		-- upvalues: FocusNavigationEventNameEnum (copy), t3 (copy), parseLuaTableEnumHelper (copy), p107 (copy), v253 (copy), t6 (copy), parseEngineEnumHelper (copy), p108 (copy), p109 (copy), p110 (copy), InputHandlers (copy), parseCallback (copy)
		local v431 = FocusNavigationEventNameEnum

		if t3[v431] == nil then
			local v432 = t3
			local t11 = {}

			for _, v435 in v431 do
				t11[v435] = true
			end

			local s7 = "string"

			v432[v431] = function(p111, _, _, _) -- line: 201
				-- upvalues: parseLuaTableEnumHelper (copy), s7 (copy), v431 (copy), t11 (copy)
				return parseLuaTableEnumHelper(p111, s7, v431, t11)
			end
		end

		local v437 = t3[v431]
		local v438 = nil
		local v439 = nil
		local keys = p107.keys

		if keys then
			if typeof(keys) ~= "table" then
				error({
					parserName = "parseFocusNavActions",
					message = `Invalid input type for keys: { v253 }`
				})
			end

			assert(typeof(keys) == "table", "keys must be table")

			local KeyCode = Enum.KeyCode

			if t6[KeyCode] == nil then
				t6[KeyCode] = function(p115, _, _, _) -- line: 246
					-- upvalues: parseEngineEnumHelper (copy), KeyCode (copy)
					return parseEngineEnumHelper(p115, KeyCode)
				end
			end

			local v442 = t6[KeyCode]

			for v443, v444 in keys do
				local v445 = nil

				if typeof(v443) == "string" then
					keys[v443] = nil
					v445 = v442(v443, p108, p109, p110)
				end

				keys[v445] = v437(v444, p108, p109, p110)
				v438 = true
			end
		end

		local events = p107.events

		if events then
			if typeof(events) ~= "table" then
				error({
					parserName = "parseFocusNavActions",
					message = `Invalid input type for events: { v253 }`
				})
			end

			assert(typeof(events) == "table", "events must be table")

			for v447, v448 in events do
				if typeof(v448) == "table" and typeof(v448.handler) ~= "function" then
					events[v447] = nil
					events[v437(v447, p108, p109, p110)] = {
						handler = InputHandlers.onRelease(parseCallback(v448, p108, p109, p110))
					}
					v439 = true
				end
			end
		end

		if not v438 and not v439 then
			error("Invalid format. keys or events required")
		end

		return {
			keys = keys,
			events = events
		}
	end)

	if ok and result then
		return result
	end

	if typeof(result) == "table" then
		result.parserName = "parseFocusNavActions"
		result.overrideValue = nil
		error(result)

		return
	end

	error({
		parserName = "parseFocusNavActions",
		message = typeof(result) ~= "string" and "Failed to parse focus nav event" or result
	})
end

local t12 = {}

return {
	parseBooleanProp_ = parseBoolean,
	parseCallbackProp_ = parseCallback,
	parseColor3Prop_ = parseColor3,
	parseGradientProp_ = parseGradient,
	parseIconProp_ = parseIcon,
	parseImageStringProp_ = parseImageString,
	parseIntegerProp_ = parseInteger,
	parseLazyCallbackProp_ = parseLazyCallback,
	parseLazyUiComponentProp_ = parseLazyUiComponent,
	parseNumberProp_ = parseNumber,
	parseStringProp_ = parseString,
	parseUDimProp_ = parseUDim,
	parseUDim2Prop_ = parseUDim2,
	parseUiComponentProp_ = parseUiComponent,
	parseVector2Prop_ = parseVector2,
	parseNumberTokenProp_ = parseNumberToken,
	parseTypographyTokenProp_ = parseTypographyToken,
	parseColorTokenProp_ = parseColorToken,
	parseFontFromTypographyTokenProp_ = parseFontFromTypographyToken,
	parseFocusNavActionsProp_ = parseFocusNavActions,
	parseImageSetOrImageProp_ = parseImageSetOrImage,
	getArrayMetatableParser = function(p119) -- line: 1203
		-- upvalues: t12 (copy)
		if t12[p119] == nil then
			t12[p119] = setmetatable({}, {
				__index = function(_, p121) -- line: 1206
					-- upvalues: p119 (copy)
					if type(p121) == "number" then
						return p119
					end

					return nil
				end
			})
		end

		return t12[p119]
	end,
	getEngineEnumParser = function(p122) -- line: 256
		-- upvalues: t6 (copy), parseEngineEnumHelper (copy)
		if t6[p122] == nil then
			t6[p122] = function(p123, _, _, _) -- line: 246
				-- upvalues: parseEngineEnumHelper (copy), p122 (copy)
				return parseEngineEnumHelper(p123, p122)
			end
		end

		return t6[p122]
	end,
	getLuaTableEnumParser = function(t13: {[any]: any}, s8: string) -- line: 211
		-- upvalues: t3 (copy), parseLuaTableEnumHelper (copy)
		if t3[t13] == nil then
			local v98 = t3
			local t14 = {}

			for _, v101 in t13 do
				t14[v101] = true
			end

			v98[t13] = function(p127, _, _, _) -- line: 201
				-- upvalues: parseLuaTableEnumHelper (copy), s8 (copy), t13 (copy), t14 (copy)
				return parseLuaTableEnumHelper(p127, s8, t13, t14)
			end
		end

		return t3[t13]
	end,
	isValidActionConfig = isValidActionConfig,
	isValidImageSet = function(p131) -- line: 531
		if typeof(p131) == "table" and (typeof(p131.ImageRectOffset) == "Vector2" and typeof(p131.Image) == "string" and typeof(p131.ImageRectSize) == "Vector2") then
			return true
		end

		return false
	end,
	isValidGradient = isValidGradient,
	isValidFocusNavActions = isValidFocusNavActions,
	safeParseBoolean = function(p132, p133, p134, p135) -- line: 46
		-- upvalues: parseBoolean (copy), Cryo (copy), SduiParseHelpers (copy), SduiErrorType (copy)
		local ok, result = pcall(function() -- line: 47
			-- upvalues: parseBoolean (copy), p132 (copy), p133 (copy), p134 (copy), p135 (copy)
			return parseBoolean(p132, p133, p134, p135)
		end)

		if ok then
			return result
		end

		local v263 = Cryo.Dictionary.join(if typeof(result) ~= "table" then if typeof(result) ~= "string" then {} else {
			message = result
		} else result, {
			value = SduiParseHelpers.stringifyValue(p132)
		})

		p133.dependencies.logger.reportError(SduiErrorType.FailedToParse, v263, p133.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseCallback = function(p136, p137, p138, p139) -- line: 46
		-- upvalues: parseCallback (copy), Cryo (copy), SduiParseHelpers (copy), SduiErrorType (copy)
		local ok, result = pcall(function() -- line: 47
			-- upvalues: parseCallback (copy), p136 (copy), p137 (copy), p138 (copy), p139 (copy)
			return parseCallback(p136, p137, p138, p139)
		end)

		if ok then
			return result
		end

		local v270 = Cryo.Dictionary.join(if typeof(result) ~= "table" then if typeof(result) ~= "string" then {} else {
			message = result
		} else result, {
			value = SduiParseHelpers.stringifyValue(p136)
		})

		p137.dependencies.logger.reportError(SduiErrorType.FailedToParse, v270, p137.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseColor3 = function(p140, p141, p142, p143) -- line: 46
		-- upvalues: parseColor3 (copy), Cryo (copy), SduiParseHelpers (copy), SduiErrorType (copy)
		local ok, result = pcall(function() -- line: 47
			-- upvalues: parseColor3 (copy), p140 (copy), p141 (copy), p142 (copy), p143 (copy)
			return parseColor3(p140, p141, p142, p143)
		end)

		if ok then
			return result
		end

		local v277 = Cryo.Dictionary.join(if typeof(result) ~= "table" then if typeof(result) ~= "string" then {} else {
			message = result
		} else result, {
			value = SduiParseHelpers.stringifyValue(p140)
		})

		p141.dependencies.logger.reportError(SduiErrorType.FailedToParse, v277, p141.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseGradient = function(p144, p145, p146, p147) -- line: 46
		-- upvalues: parseGradient (copy), Cryo (copy), SduiParseHelpers (copy), SduiErrorType (copy)
		local ok, result = pcall(function() -- line: 47
			-- upvalues: parseGradient (copy), p144 (copy), p145 (copy), p146 (copy), p147 (copy)
			return parseGradient(p144, p145, p146, p147)
		end)

		if ok then
			return result
		end

		local v284 = Cryo.Dictionary.join(if typeof(result) ~= "table" then if typeof(result) ~= "string" then {} else {
			message = result
		} else result, {
			value = SduiParseHelpers.stringifyValue(p144)
		})

		p145.dependencies.logger.reportError(SduiErrorType.FailedToParse, v284, p145.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseIcon = function(p148, p149, p150, p151) -- line: 46
		-- upvalues: parseIcon (copy), Cryo (copy), SduiParseHelpers (copy), SduiErrorType (copy)
		local ok, result = pcall(function() -- line: 47
			-- upvalues: parseIcon (copy), p148 (copy), p149 (copy), p150 (copy), p151 (copy)
			return parseIcon(p148, p149, p150, p151)
		end)

		if ok then
			return result
		end

		local v291 = Cryo.Dictionary.join(if typeof(result) ~= "table" then if typeof(result) ~= "string" then {} else {
			message = result
		} else result, {
			value = SduiParseHelpers.stringifyValue(p148)
		})

		p149.dependencies.logger.reportError(SduiErrorType.FailedToParse, v291, p149.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseImageString = function(p152, p153, p154, p155) -- line: 46
		-- upvalues: parseImageString (copy), Cryo (copy), SduiParseHelpers (copy), SduiErrorType (copy)
		local ok, result = pcall(function() -- line: 47
			-- upvalues: parseImageString (copy), p152 (copy), p153 (copy), p154 (copy), p155 (copy)
			return parseImageString(p152, p153, p154, p155)
		end)

		if ok then
			return result
		end

		local v298 = Cryo.Dictionary.join(if typeof(result) ~= "table" then if typeof(result) ~= "string" then {} else {
			message = result
		} else result, {
			value = SduiParseHelpers.stringifyValue(p152)
		})

		p153.dependencies.logger.reportError(SduiErrorType.FailedToParse, v298, p153.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseInteger = function(p156, p157, p158, p159) -- line: 46
		-- upvalues: parseInteger (copy), Cryo (copy), SduiParseHelpers (copy), SduiErrorType (copy)
		local ok, result = pcall(function() -- line: 47
			-- upvalues: parseInteger (copy), p156 (copy), p157 (copy), p158 (copy), p159 (copy)
			return parseInteger(p156, p157, p158, p159)
		end)

		if ok then
			return result
		end

		local v305 = Cryo.Dictionary.join(if typeof(result) ~= "table" then if typeof(result) ~= "string" then {} else {
			message = result
		} else result, {
			value = SduiParseHelpers.stringifyValue(p156)
		})

		p157.dependencies.logger.reportError(SduiErrorType.FailedToParse, v305, p157.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseNumber = function(p160, p161, p162, p163) -- line: 46
		-- upvalues: parseNumber (copy), Cryo (copy), SduiParseHelpers (copy), SduiErrorType (copy)
		local ok, result = pcall(function() -- line: 47
			-- upvalues: parseNumber (copy), p160 (copy), p161 (copy), p162 (copy), p163 (copy)
			return parseNumber(p160, p161, p162, p163)
		end)

		if ok then
			return result
		end

		local v312 = Cryo.Dictionary.join(if typeof(result) ~= "table" then if typeof(result) ~= "string" then {} else {
			message = result
		} else result, {
			value = SduiParseHelpers.stringifyValue(p160)
		})

		p161.dependencies.logger.reportError(SduiErrorType.FailedToParse, v312, p161.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseString = function(p164, p165, p166, p167) -- line: 46
		-- upvalues: parseString (copy), Cryo (copy), SduiParseHelpers (copy), SduiErrorType (copy)
		local ok, result = pcall(function() -- line: 47
			-- upvalues: parseString (copy), p164 (copy), p165 (copy), p166 (copy), p167 (copy)
			return parseString(p164, p165, p166, p167)
		end)

		if ok then
			return result
		end

		local v319 = Cryo.Dictionary.join(if typeof(result) ~= "table" then if typeof(result) ~= "string" then {} else {
			message = result
		} else result, {
			value = SduiParseHelpers.stringifyValue(p164)
		})

		p165.dependencies.logger.reportError(SduiErrorType.FailedToParse, v319, p165.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseUDim = function(p168, p169, p170, p171) -- line: 46
		-- upvalues: parseUDim (copy), Cryo (copy), SduiParseHelpers (copy), SduiErrorType (copy)
		local ok, result = pcall(function() -- line: 47
			-- upvalues: parseUDim (copy), p168 (copy), p169 (copy), p170 (copy), p171 (copy)
			return parseUDim(p168, p169, p170, p171)
		end)

		if ok then
			return result
		end

		local v326 = Cryo.Dictionary.join(if typeof(result) ~= "table" then if typeof(result) ~= "string" then {} else {
			message = result
		} else result, {
			value = SduiParseHelpers.stringifyValue(p168)
		})

		p169.dependencies.logger.reportError(SduiErrorType.FailedToParse, v326, p169.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseUDim2 = function(p172, p173, p174, p175) -- line: 46
		-- upvalues: parseUDim2 (copy), Cryo (copy), SduiParseHelpers (copy), SduiErrorType (copy)
		local ok, result = pcall(function() -- line: 47
			-- upvalues: parseUDim2 (copy), p172 (copy), p173 (copy), p174 (copy), p175 (copy)
			return parseUDim2(p172, p173, p174, p175)
		end)

		if ok then
			return result
		end

		local v333 = Cryo.Dictionary.join(if typeof(result) ~= "table" then if typeof(result) ~= "string" then {} else {
			message = result
		} else result, {
			value = SduiParseHelpers.stringifyValue(p172)
		})

		p173.dependencies.logger.reportError(SduiErrorType.FailedToParse, v333, p173.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseUiComponent = function(p176, p177, p178, p179) -- line: 46
		-- upvalues: parseUiComponent (copy), Cryo (copy), SduiParseHelpers (copy), SduiErrorType (copy)
		local ok, result = pcall(function() -- line: 47
			-- upvalues: parseUiComponent (copy), p176 (copy), p177 (copy), p178 (copy), p179 (copy)
			return parseUiComponent(p176, p177, p178, p179)
		end)

		if ok then
			return result
		end

		local v340 = Cryo.Dictionary.join(if typeof(result) ~= "table" then if typeof(result) ~= "string" then {} else {
			message = result
		} else result, {
			value = SduiParseHelpers.stringifyValue(p176)
		})

		p177.dependencies.logger.reportError(SduiErrorType.FailedToParse, v340, p177.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseVector2 = function(p180, p181, p182, p183) -- line: 46
		-- upvalues: parseVector2 (copy), Cryo (copy), SduiParseHelpers (copy), SduiErrorType (copy)
		local ok, result = pcall(function() -- line: 47
			-- upvalues: parseVector2 (copy), p180 (copy), p181 (copy), p182 (copy), p183 (copy)
			return parseVector2(p180, p181, p182, p183)
		end)

		if ok then
			return result
		end

		local v347 = Cryo.Dictionary.join(if typeof(result) ~= "table" then if typeof(result) ~= "string" then {} else {
			message = result
		} else result, {
			value = SduiParseHelpers.stringifyValue(p180)
		})

		p181.dependencies.logger.reportError(SduiErrorType.FailedToParse, v347, p181.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseNumberToken = function(p184, p185, p186, p187) -- line: 46
		-- upvalues: parseNumberToken (copy), Cryo (copy), SduiParseHelpers (copy), SduiErrorType (copy)
		local ok, result = pcall(function() -- line: 47
			-- upvalues: parseNumberToken (copy), p184 (copy), p185 (copy), p186 (copy), p187 (copy)
			return parseNumberToken(p184, p185, p186, p187)
		end)

		if ok then
			return result
		end

		local v354 = Cryo.Dictionary.join(if typeof(result) ~= "table" then if typeof(result) ~= "string" then {} else {
			message = result
		} else result, {
			value = SduiParseHelpers.stringifyValue(p184)
		})

		p185.dependencies.logger.reportError(SduiErrorType.FailedToParse, v354, p185.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseTypographyToken = function(p188, p189, p190, p191) -- line: 46
		-- upvalues: parseTypographyToken (copy), Cryo (copy), SduiParseHelpers (copy), SduiErrorType (copy)
		local ok, result = pcall(function() -- line: 47
			-- upvalues: parseTypographyToken (copy), p188 (copy), p189 (copy), p190 (copy), p191 (copy)
			return parseTypographyToken(p188, p189, p190, p191)
		end)

		if ok then
			return result
		end

		local v361 = Cryo.Dictionary.join(if typeof(result) ~= "table" then if typeof(result) ~= "string" then {} else {
			message = result
		} else result, {
			value = SduiParseHelpers.stringifyValue(p188)
		})

		p189.dependencies.logger.reportError(SduiErrorType.FailedToParse, v361, p189.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseFontFromTypographyToken = function(p192, p193, p194, p195) -- line: 46
		-- upvalues: parseFontFromTypographyToken (copy), Cryo (copy), SduiParseHelpers (copy), SduiErrorType (copy)
		local ok, result = pcall(function() -- line: 47
			-- upvalues: parseFontFromTypographyToken (copy), p192 (copy), p193 (copy), p194 (copy), p195 (copy)
			return parseFontFromTypographyToken(p192, p193, p194, p195)
		end)

		if ok then
			return result
		end

		local v368 = Cryo.Dictionary.join(if typeof(result) ~= "table" then if typeof(result) ~= "string" then {} else {
			message = result
		} else result, {
			value = SduiParseHelpers.stringifyValue(p192)
		})

		p193.dependencies.logger.reportError(SduiErrorType.FailedToParse, v368, p193.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseColorToken = function(p196, p197, p198, p199) -- line: 46
		-- upvalues: parseColorToken (copy), Cryo (copy), SduiParseHelpers (copy), SduiErrorType (copy)
		local ok, result = pcall(function() -- line: 47
			-- upvalues: parseColorToken (copy), p196 (copy), p197 (copy), p198 (copy), p199 (copy)
			return parseColorToken(p196, p197, p198, p199)
		end)

		if ok then
			return result
		end

		local v375 = Cryo.Dictionary.join(if typeof(result) ~= "table" then if typeof(result) ~= "string" then {} else {
			message = result
		} else result, {
			value = SduiParseHelpers.stringifyValue(p196)
		})

		p197.dependencies.logger.reportError(SduiErrorType.FailedToParse, v375, p197.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseFocusNavActions = function(p200, p201, p202, p203) -- line: 46
		-- upvalues: parseFocusNavActions (copy), Cryo (copy), SduiParseHelpers (copy), SduiErrorType (copy)
		local ok, result = pcall(function() -- line: 47
			-- upvalues: parseFocusNavActions (copy), p200 (copy), p201 (copy), p202 (copy), p203 (copy)
			return parseFocusNavActions(p200, p201, p202, p203)
		end)

		if ok then
			return result
		end

		local v382 = Cryo.Dictionary.join(if typeof(result) ~= "table" then if typeof(result) ~= "string" then {} else {
			message = result
		} else result, {
			value = SduiParseHelpers.stringifyValue(p200)
		})

		p201.dependencies.logger.reportError(SduiErrorType.FailedToParse, v382, p201.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseImageSetOrImageProp_ = function(p204, p205, p206, p207) -- line: 46
		-- upvalues: parseImageSetOrImage (copy), Cryo (copy), SduiParseHelpers (copy), SduiErrorType (copy)
		local ok, result = pcall(function() -- line: 47
			-- upvalues: parseImageSetOrImage (copy), p204 (copy), p205 (copy), p206 (copy), p207 (copy)
			return parseImageSetOrImage(p204, p205, p206, p207)
		end)

		if ok then
			return result
		end

		local v389 = Cryo.Dictionary.join(if typeof(result) ~= "table" then if typeof(result) ~= "string" then {} else {
			message = result
		} else result, {
			value = SduiParseHelpers.stringifyValue(p204)
		})

		p205.dependencies.logger.reportError(SduiErrorType.FailedToParse, v389, p205.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end
}
