local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local FoundationImages = require(parent.FoundationImages)
local Images = FoundationImages.Images
local RobloxAppAssets = require(parent.RobloxAppAssets)
local GetImageData = RobloxAppAssets.GetImageData
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require(parent.InputHandlers)

local executeAction = require(SduiCoreSystem.executeAction)
require(SduiCoreSystem.SduiActionType)
local SduiBuilder = require(SduiCoreSystem.SduiBuilder)
local SduiBuilderTypes = require(SduiCoreSystem.SduiBuilderTypes)
local SduiBuilderProcessingPhase = SduiBuilderTypes.SduiBuilderProcessingPhase
require(SduiCoreSystem.SduiComponentType)
require(SduiCoreSystem.SduiConfigTypes)
local SduiResponsiveHelpers = require(SduiCoreSystem.SduiResponsiveHelpers)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiErrorType = SduiErrors.SduiErrorType
local getSduiComponentWrapper = require(SduiCoreSystem.getSduiComponentWrapper)
local getSduiActionHandlerRegistry = require(SduiCoreSystem.getSduiActionHandlerRegistry)
local getSduiTokensStore = require(SduiCoreSystem.ClientBinding.getSduiTokensStore)

require(SduiCoreSystem.SduiContentTypes)
local SduiParseHelpers = require(SduiCoreSystem.SduiParseHelpers)
require(SduiCoreSystem.SduiFocusNavigationTypes)

local function withErrorHandling(callback)
	return function(p, p2, p3, p4)
		local success, result = pcall(function()
			return callback(p, p2, p3, p4)
		end)

		if success then
			return result
		end

		local joined = Cryo.Dictionary.join(
			typeof(result) ~= "table" and (typeof(result) == "string" and { message = result } or {}) or result,
			{
				value = SduiParseHelpers.stringifyValue(p)
			}
		)

		p2.dependencies.logger.reportError(SduiErrorType.FailedToParse, joined, p2.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end
end

local function parseFoundationTokenHelper(value, p: string, parserName: string, p2)
	local typeName = typeof(value)

	if typeName == p then
		return value
	end

	if typeName ~= "string" then
		error({
			parserName = parserName,
			message = `Invalid inputType. Expect string. {typeName}`
		})
	end

	local v = getSduiTokensStore().getTokens(false, p2.appPage)

	local parts = value:split(".")

	for _, part in parts do
		if typeof(v) == "table" then
			v = v[part]
		else
			error({
				parserName = parserName,
				message = `Invalid path for token for input {value}`
			})
		end

		if v == nil then
			error({ parserName = parserName, message = `Nil tokens for input {value}` })
		end
	end

	if typeof(v) ~= p then
		error({
			parserName = parserName,
			message = `Unexpected token type for {value}. {typeof(v)} ~= {p}`
		})
	end

	return v
end

local function parseNumberToken(p, p2, _, _) -- 1 equivalent call inferred from this helper
	return parseFoundationTokenHelper(p, "number", "parseNumberToken", p2)
end

local function parseTypographyToken(p, p2, _, _)
	return parseFoundationTokenHelper(p, "table", "parseTypographyToken", p2)
end

local function parseFontFromTypographyToken(p, p2, _, _)
	return parseFoundationTokenHelper(p, "EnumItem", "parseFontFromTypographyToken", p2)
end

local function parseColorToken(p, p2, _, _) -- 1 equivalent call inferred from this helper
	return parseFoundationTokenHelper(p, "table", "parseColorToken", p2)
end

local function parseLuaTableEnumHelper(p, p2: string, items, items2)
	local typeName = typeof(p)

	if typeName == p2 and items2[p] then
		return p
	end

	if typeName ~= "string" then
		error({
			parserName = "parseLuaTableEnumHelper",
			message = `Invalid input type to parser: {typeName}. Expected string.`
		})
	end

	local v = items[p]

	if v ~= nil then
		return v
	end

	local v2 = ""

	for k in items2 do
		v2 ..= k .. ", "
	end

	error({
		parserName = "parseLuaTableEnumHelper",
		message = `Failed to parse lua table enum. input: {p} validValues: {v2}`
	})
end

local v = {}

local function makeLuaTableEnumParser(items, p: string) -- 1 equivalent call inferred from this helper
	local set = {}

	for _, item in items do
		set[item] = true
	end

	return function(p2, _, _, _)
		return parseLuaTableEnumHelper(p2, p, items, set)
	end
end

local function getLuaTableEnumParser(focusNavigationEventNameEnum, p: string) -- 1 equivalent call inferred from this helper
	if v[focusNavigationEventNameEnum] == nil then
		v[focusNavigationEventNameEnum] = makeLuaTableEnumParser(focusNavigationEventNameEnum, p) -- inferred equivalent call
	end

	return v[focusNavigationEventNameEnum]
end

local function parseEngineEnumHelper(value, p)
	if typeof(value) == "EnumItem" then
		return value
	end

	if typeof(value) ~= "string" then
		error({
			parserName = "parseEngineEnumHelper",
			message = `Invalid input type Engine Enum value. Expect string. received {value}`
		})
	end

	local success, result = pcall(function()
		return p[value]
	end)

	if success then
		return result
	end

	error({ parserName = "parseEngineEnumHelper", message = result })
end

local v2 = {}

local function makeEngineEnumParser(p) -- 1 equivalent call inferred from this helper
	return function(p2, _, _, _)
		return parseEngineEnumHelper(p2, p)
	end
end

local function getEngineEnumParser(keyCode) -- 1 equivalent call inferred from this helper
	if v2[keyCode] == nil then
		v2[keyCode] = makeEngineEnumParser(keyCode) -- inferred equivalent call
	end

	return v2[keyCode]
end

local function parseUDim2(value, _, _, _)
	local typeName = typeof(value)

	if typeName == "UDim2" then
		return value
	end

	local success, result = pcall(function()
		if typeName == "string" then
			local v3 = string.split(value, ",")

			if #v3 == 4 then
				return UDim2.new(tonumber(v3[1]) or 0, tonumber(v3[2]) or 0, tonumber(v3[3]) or 0, tonumber(v3[4]) or 0)
			end

			error("Not enough components in string to parse UDim2")
		else
			if typeName ~= "table" then
				error(`Invalid input type for parseUDim2: {typeName}`)

				return
			end

			if #value == 4 then
				return UDim2.new(
					tonumber(value[1]) or 0,
					tonumber(value[2]) or 0,
					tonumber(value[3]) or 0,
					tonumber(value[4]) or 0
				)
			end

			error("Not enough components in table to parse UDim2")
		end
	end)

	if success and result then
		return result
	end

	if typeof(result) ~= "string" then
		result = nil
	end

	error({ parserName = "parseUDim2", message = result })
end

local function parseUDim(value, _, _, _)
	local typeName = typeof(value)

	if typeName == "UDim" then
		return value
	end

	local success, result = pcall(function()
		if typeName == "string" then
			local v3 = string.split(value, ",")

			if #v3 == 2 then
				return UDim.new(tonumber(v3[1]) or 0, tonumber(v3[2]) or 0)
			end

			error("Not enough components in string to parse UDim")
		elseif typeName == "table" then
			if #value == 2 then
				return UDim.new(tonumber(value[1]) or 0, tonumber(value[2]) or 0)
			end

			error("Not enough components in table to parse UDim")
		else
			if typeName == "number" then
				return UDim.new(0, value)
			end

			error(`Invalid input type for parseUDim: {typeName}`)
		end
	end)

	if success and result then
		return result
	end

	if typeof(result) ~= "string" then
		result = nil
	end

	error({ parserName = "parseUDim", message = result })
end

local function parseColor3(data, p, p2, p3)
	local typeName = typeof(data)

	if typeName == "Color3" then
		return data
	end

	local success, result = pcall(function()
		if typeName == "string" then
			local success, result = pcall(function()
				return Color3.fromHex(data)
			end)

			if success and result then
				return result
			end

			local success2, result2 = pcall(function()
				return parseColorToken(data, p) -- inferred equivalent call
			end)

			if success2 and typeof(result2) == "table" and result2.Color3 ~= nil then
				return result2.Color3
			end

			error(`Invalid input for Color3: {data}`)
		else
			if typeName == "table" then
				return Color3.fromRGB(data.r, data.g, data.b)
			end

			error(`Invalid input type for parseColor3: {typeName}`)
		end
	end)

	if success and result then
		return result
	end

	if typeof(result) ~= "string" then
		if typeof(result) == "table" then
			result = result.message
		else
			result = nil
		end
	end

	error({ parserName = "parseColor3", message = result })
end

local color = Color3.new(0, 0, 0)
local v3 = {
	startColor = color,
	endColor = color,
	startOpacity = 0,
	endOpacity = 1,
	degree = 270
}

local function isValidGradient(data): boolean
	if not (typeof(data) == "table" and typeof(data.startColor) == "Color3" and typeof(data.endColor) == "Color3") then
		return false
	end

	if typeof(data.startOpacity) ~= "number" then
		return false
	end

	return typeof(data.endOpacity) == "number" and typeof(data.degree) == "number"
end

local function parseGradient(data, p, p2, p3)
	local typeName = typeof(data)

	if typeName == "table" then
		if isValidGradient(data) then
			return data
		end
	else
		error({
			parserName = "parseGradient",
			message = `invalid input type for parseGradient: {typeName}`
		})
	end

	local result

	if data.startColor then
		local success
		success, result = pcall(function()
			return parseColor3(data.startColor, p, p2, p3)
		end)

		if not success then
			error({
				parserName = "parseGradient",
				message = typeof(result) ~= "string" and "failed to parse startColor field" or result
			})
		end
	else
		result = v3.startColor
	end

	local result2

	if data.endColor then
		local success
		success, result2 = pcall(function()
			return parseColor3(data.endColor, p, p2, p3)
		end)

		if not success then
			error({
				parserName = "parseGradient",
				message = typeof(result2) ~= "string" and "failed to parse endColor field" or result2
			})
		end
	else
		result2 = v3.endColor
	end

	local startOpacity = nil

	if typeof(data.startOpacity) == "number" then
		startOpacity = data.startOpacity
	elseif data.startOpacity ~= nil then
		error({
			parserName = "parseGradient",
			message = `invalid input type for startOpacity: {typeof(data.startOpacity)}`
		})
	end

	local endOpacity = nil

	if typeof(data.endOpacity) == "number" then
		endOpacity = data.endOpacity
	elseif data.endOpacity ~= nil then
		error({
			parserName = "parseGradient",
			message = `invalid input type for endOpacity: {typeof(data.endOpacity)}`
		})
	end

	local degree = nil

	if typeof(data.degree) == "number" then
		degree = data.degree
	elseif data.degree ~= nil then
		error({
			parserName = "parseGradient",
			message = `invalid input type for degree: {typeof(data.degree)}`
		})
	end

	return {
		startColor = result,
		endColor = result2,
		startOpacity = startOpacity or v3.startOpacity,
		endOpacity = endOpacity or v3.endOpacity,
		degree = degree or v3.degree
	}
end

local function isValidImageSet(value): boolean -- 1 equivalent call inferred from this helper
	return typeof(value) == "table"
		and typeof(value.ImageRectOffset) == "Vector2"
		and typeof(value.Image) == "string"
		and typeof(value.ImageRectSize) == "Vector2"
end

local v4 = {
	truncate_arrows = true,
	squircles = true,
	gradient = true,
	component_assets = true,
	chat_bubble = true,
	icons = true
}

local function isValidIconString(value: string): boolean -- 1 equivalent call inferred from this helper
	local parts = value:split("/")
	return if parts and #parts > 1 and v4[parts[1]] then true else false
end

local function parseIcon(value, _, _, _)
	local result = nil

	if isValidImageSet(value) then -- inferred equivalent call
		return value
	end

	if typeof(value) == "string" then
		local success
		success, result = pcall(function()
			return GetImageData(value) or Images[value]
		end)

		if not (success and result) then
			error({ parserName = "parseIcon", message = `No icon found for {value}` })
		end
	end

	if not result then
		error({ parserName = "parseIcon", message = `Bad input for icon: {value}` })
	end

	return result
end

local function isValidActionConfig(value, _): boolean -- 1 equivalent call inferred from this helper
	if typeof(value) ~= "table" or typeof(value.actionType) ~= "string" then
		return false
	end

	local actionHandlerConfig = getSduiActionHandlerRegistry().getActionHandlerConfig(value.actionType)

	return actionHandlerConfig ~= nil
		and (actionHandlerConfig.handler ~= nil or actionHandlerConfig.telemetryHandler ~= nil)
end

local function isCallableTable(value): boolean -- 1 equivalent call inferred from this helper
	if typeof(value) == "table" then
		local metatable = getmetatable(value)

		if metatable and type(metatable.__call) == "function" then
			return true
		end
	end

	return false
end

local function parseCallback(value, sduiContext, analyticsContext, _)
	local v5 = nil

	if typeof(value) == "function" then
		return value
	end

	if isCallableTable(value) then -- inferred equivalent call
		value.analyticsContext = analyticsContext
		value.sduiContext = sduiContext
		return value
	end

	if isValidActionConfig(value) then -- inferred equivalent call
		v5 = value
	end

	if v5 then
		local v6 = { analyticsContext = analyticsContext, sduiContext = sduiContext }

		setmetatable(v6, {
			__call = function(p, p2)
				return executeAction(v5, p.analyticsContext, p.sduiContext, p2)
			end
		})

		return v6
	else
		local actionType = typeof(value) == "table" and value.actionType or "unknown"

		error({
			parserName = "parseCallback",
			message = `Could not find action for: {value} actionType: {actionType}`,
			overrideValue = function()
				sduiContext.dependencies.logger.reportCounter(SduiErrors.SduiCounterName.ExecutedInvalidAction, {
					name = actionType
				})
			end
		})
	end
end

local function parseLazyCallback(p, _, _, _)
	return p
end

local function parseLazyUiComponent(p, p2, p3, p4)
	if p4 ~= SduiBuilderProcessingPhase.Eager then
		return p
	end

	local success, result = pcall(function()
		if typeof(p) ~= "table" then
			error(`Invalid input type {typeof(p)}`)
		end

		local v5, v6 = SduiBuilder.tryCreateEagerProcessedComponentConfig(p, p2, "parseUiComponent", p3)

		if v5 then
			return v6
		end

		error("Unable to parse componentConfig during Eager phase")
	end)

	if success and result then
		return result
	end

	if typeof(result) ~= "string" then
		result = nil
	end

	error({ parserName = "parseLazyUiComponent", message = result })
end

local function parseUiComponent(componentConfig, sduiContext, parentAnalyticsContext, p)
	local success, result

	if p == SduiBuilderProcessingPhase.Eager then
		success, result = pcall(function()
			if typeof(componentConfig) ~= "table" then
				error(`Invalid input type {typeof(componentConfig)}`)
			end

			local v5, v6 = SduiBuilder.tryCreateEagerProcessedComponentConfig(
				componentConfig,
				sduiContext,
				"parseUiComponent",
				parentAnalyticsContext
			)

			if v5 then
				return v6
			end

			error("Unable to parse componentConfig during Eager phase")
		end)
	else
		success, result = pcall(function()
			if typeof(componentConfig) == "table" then
				local sduiComponentWrapper = getSduiComponentWrapper(componentConfig)
				return React.createElement(sduiComponentWrapper, {
					componentConfig = componentConfig,
					sduiContext = sduiContext,
					parentAnalyticsContext = parentAnalyticsContext,
					debugName = `parsedUiComponent-{componentConfig.componentType}`
				})
			end

			error(`Invalid input type {typeof(componentConfig)}`)
		end)
	end

	if success and result then
		return result
	end

	if typeof(result) ~= "string" then
		result = nil
	end

	error({ parserName = "parseUiComponent", message = result })
end

local function parseVector2(value, _, _, _)
	local typeName = typeof(value)

	if typeName == "Vector2" then
		return value
	end

	local success, result = pcall(function()
		if typeName == "string" then
			local v5 = string.split(value, ",")

			if #v5 == 2 then
				return Vector2.new(tonumber(v5[1]) or 0, tonumber(v5[2]) or 0)
			end

			error("Not enough components in string to parse Vector2")
		else
			if typeName ~= "table" then
				error(`Invalid input type for parseVector2: {typeName}`)

				return
			end

			if #value == 2 then
				return Vector2.new(tonumber(value[1]) or 0, tonumber(value[2]) or 0)
			end

			error("Not enough components in table to parse Vector2")
		end
	end)

	if success and result then
		return result
	end

	if typeof(result) ~= "string" then
		result = nil
	end

	error({ parserName = "parseVector2", message = result })
end

local function parseNumber(p, p2, p3, p4)
	local typeName = typeof(p)

	if typeName == "number" then
		return p
	end

	if typeName ~= "string" then
		error({
			parserName = "parseNumber",
			message = `Invalid input type for parseNumber: {typeName}`
		})

		return
	end

	local success, result = pcall(function()
		return (tonumber(p))
	end)

	if not success or result == nil then
		success, result = pcall(function()
			return parseNumberToken(p, p2) -- inferred equivalent call
		end)
	end

	if success and result then
		return result
	end

	if typeof(result) ~= "string" then
		result = `Failed to parse string {p} to number`
	end

	error({ parserName = "parseNumber", message = result })
end

local function parseInteger(p, _, _, _)
	local typeName = typeof(p)

	if typeName == "number" then
		return p
	end

	if typeName ~= "string" then
		error({
			parserName = "parseInteger",
			message = `Invalid input type for parseInteger: {typeName}`
		})

		return
	end

	local success, result = pcall(function()
		return (tonumber(p))
	end)

	if success and result then
		if p == tostring((math.round(result))) then
			return result
		end

		local message

		if typeof(result) == "string" then
			message = result
		else
			message = `Unexpected output {result} does not match input {p}.`
		end

		error({ parserName = "parseInteger", message = message })

		return result
	else
		if typeof(result) ~= "string" then
			result = `Failed to parse string {p} to number`
		end

		error({ parserName = "parseInteger", message = result })
	end
end

local function parseBoolean(value, _, _, _)
	local typeName = typeof(value)

	if typeName == "boolean" then
		return value
	end

	if typeName == "number" then
		if value == 1 then
			return true
		elseif value == 0 then
			return false
		end

		error({
			parserName = "parseBoolean",
			message = `Failed to parse number {value} to boolean`
		})
	else
		if typeName ~= "string" then
			error({
				parserName = "parseBoolean",
				message = `Invalid input type for parseBoolean: {typeName}`
			})

			return
		end

		local v5 = string.lower(value)

		if v5 == "t" or v5 == "true" then
			return true
		end

		if v5 == "f" or v5 == "false" then
			return false
		end

		error({
			parserName = "parseBoolean",
			message = `Failed to parse string {value} to boolean`
		})
	end
end

local function parseString(p, _, _, _)
	local typeName = typeof(p)

	if typeName == "string" then
		return p
	end

	if typeName == "number" or typeName == "boolean" then
		return (tostring(p))
	end

	error({
		parserName = "parseString",
		message = `Invalid input type for parseString: {typeName}`
	})
end

local function parseImageString(value, _, _, _)
	local typeName = typeof(value)

	if typeName ~= "string" then
		error({
			parserName = "parseImageString",
			message = `Invalid input type for parseImageString: {typeName}`
		})
	end

	local parts = value:split("://")
	local v5

	if #parts > 1 then
		v5 = parts[1] == "rbxthumb"
	else
		v5 = false
	end

	if not v5 then
		return value
	end

	local parts2 = parts[2]:split("&")
	local v6 = {}

	for _, part in parts2 do
		local parts3 = part:split("=")

		if #parts3 == 2 then
			v6[parts3[1]] = parts3[2]
		end
	end

	if v6.mw == nil or v6.mh == nil then
		return value
	end

	local w = tonumber(v6.w)
	local h = tonumber(v6.h)
	local mw = tonumber(v6.mw)
	local mh = tonumber(v6.mh)

	if w == nil or h == nil or mw == nil or mh == nil or v6.type == nil or v6.id == nil then
		error({
			parserName = "parseImageString",
			message = `Invalid params for rbxthumb in parseImageString: {value}`
		})
	end

	assert(w, "inputWidth must exist")
	assert(h, "inputHeight must exist")
	assert(mw, "inputWidth must exist")
	assert(mh, "inputHeight must exist")

	local adaptThumbnailDimensions, v7 = SduiResponsiveHelpers.adaptThumbnailDimensions(w, h, mw, mh, v6.type)

	local v8 = `rbxthumb://type={v6.type}&id={v6.id}&w={adaptThumbnailDimensions}&h={v7}`

	v6.w = nil
	v6.h = nil
	v6.mw = nil
	v6.mh = nil
	v6.id = nil
	v6.type = nil

	for k, v9 in v6 do
		v8 ..= string.format("&%s=%s", k, v9)
	end

	return v8
end

local function parseImageSetOrImage(value, p, p2, p3)
	local typeName = typeof(value)

	if typeName == "table" then
		return value
	end

	if typeName ~= "string" then
		error({
			parserName = "parseImageSetOrImage",
			message = `Invalid input type for parseImageSetOrImage: {typeName}`
		})
	end

	if isValidIconString(value) then -- inferred equivalent call
		return parseIcon(value, p, p2, p3)
	end

	return parseImageString(value, p, p2, p3)
end

local function isValidFocusNavActions(p)
	if typeof(p) ~= "table" then
		return false
	end

	local v5 = nil
	local v6 = nil
	local keys = p.keys

	if keys then
		if typeof(keys) ~= "table" then
			return false
		end

		for k, key in keys do
			if typeof(k) ~= "EnumItem" then
				return false
			end

			if FocusNavigationEventNameEnum[key] == nil then
				return false
			end

			v5 = true
		end
	end

	local events = p.events

	if not events then
		return v5 or v6 or false
	end

	if typeof(events) ~= "table" then
		return false
	end

	for k, event in events do
		if not (FocusNavigationEventNameEnum[k] ~= nil and typeof(event) == "table" and typeof(event.handler) == "function") then
			return false
		end

		v6 = true
	end

	return v5 or v6 or false
end

local function parseFocusNavActions(p, sduiContext, analyticsContext, p2)
	if isValidFocusNavActions(p) then
		return p
	end

	local typeName = typeof(p)

	if typeName ~= "table" then
		error({
			parserName = "parseFocusNavActions",
			message = `Invalid input type for parseFocusNavActions: {typeName}`
		})
	end

	assert(typeof(p) == "table", "input must be table")

	local success, result = pcall(function()
		local luaTableEnumParser = getLuaTableEnumParser(FocusNavigationEventNameEnum, "string") -- inferred equivalent call
		local v5 = nil
		local v6 = nil
		local keys = p.keys

		if keys then
			if typeof(keys) ~= "table" then
				error({
					parserName = "parseFocusNavActions",
					message = `Invalid input type for keys: {typeName}`
				})
			end

			assert(typeof(keys) == "table", "keys must be table")

			local engineEnumParser = getEngineEnumParser(Enum.KeyCode) -- inferred equivalent call

			for k, key in keys do
				local v7

				if typeof(k) == "string" then
					keys[k] = nil
					v7 = engineEnumParser(k, sduiContext, analyticsContext, p2)
				end

				keys[v7] = luaTableEnumParser(key, sduiContext, analyticsContext, p2)
				v5 = true
			end
		end

		local events = p.events

		if events then
			if typeof(events) ~= "table" then
				error({
					parserName = "parseFocusNavActions",
					message = `Invalid input type for events: {typeName}`
				})
			end

			assert(typeof(events) == "table", "events must be table")

			for k, event in events do
				if not (typeof(event) == "table" and typeof(event.handler) ~= "function") then
					continue
				end

				events[k] = nil
				events[luaTableEnumParser(k, sduiContext, analyticsContext, p2)] = {
					handler = InputHandlers.onRelease(parseCallback(event, sduiContext, analyticsContext, p2))
				}
				v6 = true
			end
		end

		if not (v5 or v6) then
			error("Invalid format. keys or events required")
		end

		return { keys = keys, events = events }
	end)

	if success and result then
		return result
	end

	if typeof(result) ~= "table" then
		error({
			parserName = "parseFocusNavActions",
			message = typeof(result) ~= "string" and "Failed to parse focus nav event" or result
		})

		return
	end

	result.parserName = "parseFocusNavActions"
	result.overrideValue = nil
	error(result)
end

local v5 = {}
local SduiParsers = {}
SduiParsers.parseBooleanProp_ = parseBoolean
SduiParsers.parseCallbackProp_ = parseCallback
SduiParsers.parseColor3Prop_ = parseColor3
SduiParsers.parseGradientProp_ = parseGradient
SduiParsers.parseIconProp_ = parseIcon
SduiParsers.parseImageStringProp_ = parseImageString
SduiParsers.parseIntegerProp_ = parseInteger
SduiParsers.parseLazyCallbackProp_ = parseLazyCallback
SduiParsers.parseLazyUiComponentProp_ = parseLazyUiComponent
SduiParsers.parseNumberProp_ = parseNumber
SduiParsers.parseStringProp_ = parseString
SduiParsers.parseUDimProp_ = parseUDim
SduiParsers.parseUDim2Prop_ = parseUDim2
SduiParsers.parseUiComponentProp_ = parseUiComponent
SduiParsers.parseVector2Prop_ = parseVector2
SduiParsers.parseNumberTokenProp_ = parseNumberToken
SduiParsers.parseTypographyTokenProp_ = parseTypographyToken
SduiParsers.parseColorTokenProp_ = parseColorToken
SduiParsers.parseFontFromTypographyTokenProp_ = parseFontFromTypographyToken
SduiParsers.parseFocusNavActionsProp_ = parseFocusNavActions
SduiParsers.parseImageSetOrImageProp_ = parseImageSetOrImage

function SduiParsers.getArrayMetatableParser(p)
	if v5[p] == nil then
		v5[p] = setmetatable({}, {
			__index = function(_, value)
				return if type(value) == "number" then p else nil
			end
		})
	end

	return v5[p]
end

SduiParsers.getEngineEnumParser = getEngineEnumParser
SduiParsers.getLuaTableEnumParser = getLuaTableEnumParser
SduiParsers.isValidActionConfig = isValidActionConfig
SduiParsers.isValidImageSet = isValidImageSet
SduiParsers.isValidGradient = isValidGradient
SduiParsers.isValidFocusNavActions = isValidFocusNavActions

function SduiParsers.safeParseBoolean(p, p2, p3, p4)
	local success, result = pcall(function()
		return parseBoolean(p, p2, p3, p4)
	end)

	if success then
		return result
	end

	local joined = Cryo.Dictionary.join(
		typeof(result) ~= "table" and (typeof(result) == "string" and { message = result } or {}) or result,
		{
			value = SduiParseHelpers.stringifyValue(p)
		}
	)

	p2.dependencies.logger.reportError(SduiErrorType.FailedToParse, joined, p2.appPage)

	if typeof(result) == "table" then
		return result.overrideValue
	end

	return nil
end

function SduiParsers.safeParseCallback(p, sduiContext, analyticsContext, p2)
	local success, result = pcall(function()
		return parseCallback(p, sduiContext, analyticsContext, p2)
	end)

	if success then
		return result
	end

	local joined = Cryo.Dictionary.join(
		typeof(result) ~= "table" and (typeof(result) == "string" and { message = result } or {}) or result,
		{
			value = SduiParseHelpers.stringifyValue(p)
		}
	)

	sduiContext.dependencies.logger.reportError(SduiErrorType.FailedToParse, joined, sduiContext.appPage)

	if typeof(result) == "table" then
		return result.overrideValue
	end

	return nil
end

function SduiParsers.safeParseColor3(p, p2, p3, p4)
	local success, result = pcall(function()
		return parseColor3(p, p2, p3, p4)
	end)

	if success then
		return result
	end

	local joined = Cryo.Dictionary.join(
		typeof(result) ~= "table" and (typeof(result) == "string" and { message = result } or {}) or result,
		{
			value = SduiParseHelpers.stringifyValue(p)
		}
	)

	p2.dependencies.logger.reportError(SduiErrorType.FailedToParse, joined, p2.appPage)

	if typeof(result) == "table" then
		return result.overrideValue
	end

	return nil
end

function SduiParsers.safeParseGradient(p, p2, p3, p4)
	local success, result = pcall(function()
		return parseGradient(p, p2, p3, p4)
	end)

	if success then
		return result
	end

	local joined = Cryo.Dictionary.join(
		typeof(result) ~= "table" and (typeof(result) == "string" and { message = result } or {}) or result,
		{
			value = SduiParseHelpers.stringifyValue(p)
		}
	)

	p2.dependencies.logger.reportError(SduiErrorType.FailedToParse, joined, p2.appPage)

	if typeof(result) == "table" then
		return result.overrideValue
	end

	return nil
end

function SduiParsers.safeParseIcon(p, p2, p3, p4)
	local success, result = pcall(function()
		return parseIcon(p, p2, p3, p4)
	end)

	if success then
		return result
	end

	local joined = Cryo.Dictionary.join(
		typeof(result) ~= "table" and (typeof(result) == "string" and { message = result } or {}) or result,
		{
			value = SduiParseHelpers.stringifyValue(p)
		}
	)

	p2.dependencies.logger.reportError(SduiErrorType.FailedToParse, joined, p2.appPage)

	if typeof(result) == "table" then
		return result.overrideValue
	end

	return nil
end

function SduiParsers.safeParseImageString(p, p2, p3, p4)
	local success, result = pcall(function()
		return parseImageString(p, p2, p3, p4)
	end)

	if success then
		return result
	end

	local joined = Cryo.Dictionary.join(
		typeof(result) ~= "table" and (typeof(result) == "string" and { message = result } or {}) or result,
		{
			value = SduiParseHelpers.stringifyValue(p)
		}
	)

	p2.dependencies.logger.reportError(SduiErrorType.FailedToParse, joined, p2.appPage)

	if typeof(result) == "table" then
		return result.overrideValue
	end

	return nil
end

function SduiParsers.safeParseInteger(p, p2, p3, p4)
	local success, result = pcall(function()
		return parseInteger(p, p2, p3, p4)
	end)

	if success then
		return result
	end

	local joined = Cryo.Dictionary.join(
		typeof(result) ~= "table" and (typeof(result) == "string" and { message = result } or {}) or result,
		{
			value = SduiParseHelpers.stringifyValue(p)
		}
	)

	p2.dependencies.logger.reportError(SduiErrorType.FailedToParse, joined, p2.appPage)

	if typeof(result) == "table" then
		return result.overrideValue
	end

	return nil
end

function SduiParsers.safeParseNumber(p, p2, p3, p4)
	local success, result = pcall(function()
		return parseNumber(p, p2, p3, p4)
	end)

	if success then
		return result
	end

	local joined = Cryo.Dictionary.join(
		typeof(result) ~= "table" and (typeof(result) == "string" and { message = result } or {}) or result,
		{
			value = SduiParseHelpers.stringifyValue(p)
		}
	)

	p2.dependencies.logger.reportError(SduiErrorType.FailedToParse, joined, p2.appPage)

	if typeof(result) == "table" then
		return result.overrideValue
	end

	return nil
end

function SduiParsers.safeParseString(p, p2, p3, p4)
	local success, result = pcall(function()
		return parseString(p, p2, p3, p4)
	end)

	if success then
		return result
	end

	local joined = Cryo.Dictionary.join(
		typeof(result) ~= "table" and (typeof(result) == "string" and { message = result } or {}) or result,
		{
			value = SduiParseHelpers.stringifyValue(p)
		}
	)

	p2.dependencies.logger.reportError(SduiErrorType.FailedToParse, joined, p2.appPage)

	if typeof(result) == "table" then
		return result.overrideValue
	end

	return nil
end

function SduiParsers.safeParseUDim(p, p2, p3, p4)
	local success, result = pcall(function()
		return parseUDim(p, p2, p3, p4)
	end)

	if success then
		return result
	end

	local joined = Cryo.Dictionary.join(
		typeof(result) ~= "table" and (typeof(result) == "string" and { message = result } or {}) or result,
		{
			value = SduiParseHelpers.stringifyValue(p)
		}
	)

	p2.dependencies.logger.reportError(SduiErrorType.FailedToParse, joined, p2.appPage)

	if typeof(result) == "table" then
		return result.overrideValue
	end

	return nil
end

function SduiParsers.safeParseUDim2(p, p2, p3, p4)
	local success, result = pcall(function()
		return parseUDim2(p, p2, p3, p4)
	end)

	if success then
		return result
	end

	local joined = Cryo.Dictionary.join(
		typeof(result) ~= "table" and (typeof(result) == "string" and { message = result } or {}) or result,
		{
			value = SduiParseHelpers.stringifyValue(p)
		}
	)

	p2.dependencies.logger.reportError(SduiErrorType.FailedToParse, joined, p2.appPage)

	if typeof(result) == "table" then
		return result.overrideValue
	end

	return nil
end

function SduiParsers.safeParseUiComponent(componentConfig, sduiContext, parentAnalyticsContext, p)
	local success, result = pcall(function()
		return parseUiComponent(componentConfig, sduiContext, parentAnalyticsContext, p)
	end)

	if success then
		return result
	end

	local joined = Cryo.Dictionary.join(
		typeof(result) ~= "table" and (typeof(result) == "string" and { message = result } or {}) or result,
		{
			value = SduiParseHelpers.stringifyValue(componentConfig)
		}
	)

	sduiContext.dependencies.logger.reportError(SduiErrorType.FailedToParse, joined, sduiContext.appPage)

	if typeof(result) == "table" then
		return result.overrideValue
	end

	return nil
end

function SduiParsers.safeParseVector2(p, p2, p3, p4)
	local success, result = pcall(function()
		return parseVector2(p, p2, p3, p4)
	end)

	if success then
		return result
	end

	local joined = Cryo.Dictionary.join(
		typeof(result) ~= "table" and (typeof(result) == "string" and { message = result } or {}) or result,
		{
			value = SduiParseHelpers.stringifyValue(p)
		}
	)

	p2.dependencies.logger.reportError(SduiErrorType.FailedToParse, joined, p2.appPage)

	if typeof(result) == "table" then
		return result.overrideValue
	end

	return nil
end

function SduiParsers.safeParseNumberToken(p, p2, p3, p4)
	local success, result = pcall(function()
		return parseNumberToken(p, p2, p3, p4)
	end)

	if success then
		return result
	end

	local joined = Cryo.Dictionary.join(
		typeof(result) ~= "table" and (typeof(result) == "string" and { message = result } or {}) or result,
		{
			value = SduiParseHelpers.stringifyValue(p)
		}
	)

	p2.dependencies.logger.reportError(SduiErrorType.FailedToParse, joined, p2.appPage)

	if typeof(result) == "table" then
		return result.overrideValue
	end

	return nil
end

function SduiParsers.safeParseTypographyToken(p, p2, p3, p4)
	local success, result = pcall(function()
		return parseTypographyToken(p, p2, p3, p4)
	end)

	if success then
		return result
	end

	local joined = Cryo.Dictionary.join(
		typeof(result) ~= "table" and (typeof(result) == "string" and { message = result } or {}) or result,
		{
			value = SduiParseHelpers.stringifyValue(p)
		}
	)

	p2.dependencies.logger.reportError(SduiErrorType.FailedToParse, joined, p2.appPage)

	if typeof(result) == "table" then
		return result.overrideValue
	end

	return nil
end

function SduiParsers.safeParseFontFromTypographyToken(p, p2, p3, p4)
	local success, result = pcall(function()
		return parseFontFromTypographyToken(p, p2, p3, p4)
	end)

	if success then
		return result
	end

	local joined = Cryo.Dictionary.join(
		typeof(result) ~= "table" and (typeof(result) == "string" and { message = result } or {}) or result,
		{
			value = SduiParseHelpers.stringifyValue(p)
		}
	)

	p2.dependencies.logger.reportError(SduiErrorType.FailedToParse, joined, p2.appPage)

	if typeof(result) == "table" then
		return result.overrideValue
	end

	return nil
end

function SduiParsers.safeParseColorToken(p, p2, p3, p4)
	local success, result = pcall(function()
		return parseColorToken(p, p2, p3, p4)
	end)

	if success then
		return result
	end

	local joined = Cryo.Dictionary.join(
		typeof(result) ~= "table" and (typeof(result) == "string" and { message = result } or {}) or result,
		{
			value = SduiParseHelpers.stringifyValue(p)
		}
	)

	p2.dependencies.logger.reportError(SduiErrorType.FailedToParse, joined, p2.appPage)

	if typeof(result) == "table" then
		return result.overrideValue
	end

	return nil
end

function SduiParsers.safeParseFocusNavActions(p, sduiContext, analyticsContext, p2)
	local success, result = pcall(function()
		return parseFocusNavActions(p, sduiContext, analyticsContext, p2)
	end)

	if success then
		return result
	end

	local joined = Cryo.Dictionary.join(
		typeof(result) ~= "table" and (typeof(result) == "string" and { message = result } or {}) or result,
		{
			value = SduiParseHelpers.stringifyValue(p)
		}
	)

	sduiContext.dependencies.logger.reportError(SduiErrorType.FailedToParse, joined, sduiContext.appPage)

	if typeof(result) == "table" then
		return result.overrideValue
	end

	return nil
end

function SduiParsers.safeParseImageSetOrImageProp_(p, p2, p3, p4)
	local success, result = pcall(function()
		return parseImageSetOrImage(p, p2, p3, p4)
	end)

	if success then
		return result
	end

	local joined = Cryo.Dictionary.join(
		typeof(result) ~= "table" and (typeof(result) == "string" and { message = result } or {}) or result,
		{
			value = SduiParseHelpers.stringifyValue(p)
		}
	)

	p2.dependencies.logger.reportError(SduiErrorType.FailedToParse, joined, p2.appPage)

	if typeof(result) == "table" then
		return result.overrideValue
	end

	return nil
end

return SduiParsers
