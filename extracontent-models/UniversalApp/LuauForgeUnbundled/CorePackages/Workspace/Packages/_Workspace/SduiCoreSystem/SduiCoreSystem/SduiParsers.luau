local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/React")
local images = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/FoundationImages").Images
local getImageData = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/RobloxAppAssets").GetImageData
local focusNavigationEventNameEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/FocusNavigationUtils").FocusNavigationEventNameEnum
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/InputHandlers")

local executeAction = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/executeAction")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiActionType")
local SduiBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilder")
local sduiBuilderProcessingPhase = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes").SduiBuilderProcessingPhase
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiConfigTypes")
local SduiResponsiveHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiResponsiveHelpers")
local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local sduiErrorType = SduiErrors.SduiErrorType
local getSduiComponentWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/getSduiComponentWrapper")
local getSduiActionHandlerRegistry = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/getSduiActionHandlerRegistry")
local getSduiTokensStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/getSduiTokensStore")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiContentTypes")
local SduiParseHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiParseHelpers")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiFocusNavigationTypes")

local function withErrorHandling(callback)
	return function(p2, p3, p4, p5)
		local success, result = pcall(function()
			return callback(p2, p3, p4, p5)
		end)

		if success then
			return result
		end

		local joined = Cryo.Dictionary.join(
			typeof(result) ~= "table" and (typeof(result) == "string" and {
				message = result
			} or {}) or result,
			{ value = SduiParseHelpers.stringifyValue(p2) }
		)

		p3.dependencies.logger.reportError(sduiErrorType.FailedToParse, joined, p3.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end
end

local function parseFoundationTokenHelper(value, p2, p3, p4)
	local typeName = typeof(value)

	if typeName == p2 then
		return value
	end

	if typeName ~= "string" then
		error({
			parserName = p3,
			message = `Invalid inputType. Expect string. {typeName}`
		})
	end

	local v5 = getSduiTokensStore().getTokens(false, p4.appPage)

	local parts = value:split(".")

	for k, part in parts do
		if typeof(v5) == "table" then
			v5 = v5[part]
		else
			error({
				parserName = p3,
				message = `Invalid path for token for input {value}`
			})
		end

		if v5 == nil then
			error({ parserName = p3, message = `Nil tokens for input {value}` })
		end
	end

	if typeof(v5) ~= p2 then
		error({
			parserName = p3,
			message = `Unexpected token type for {value}. {typeof(v5)} ~= {p2}`
		})
	end

	return v5
end

local function parseNumberToken(p2, p3, p4, p5)
	return parseFoundationTokenHelper(p2, "number", "parseNumberToken", p3)
end

local function parseTypographyToken(p2, p3, p4, p5)
	return parseFoundationTokenHelper(p2, "table", "parseTypographyToken", p3)
end

local function parseFontFromTypographyToken(p2, p3, p4, p5)
	return parseFoundationTokenHelper(p2, "EnumItem", "parseFontFromTypographyToken", p3)
end

local function parseColorToken(p2, p3, p4, p5)
	return parseFoundationTokenHelper(p2, "table", "parseColorToken", p3)
end

local function parseLuaTableEnumHelper(p2, p3, p4, items)
	local typeName = typeof(p2)

	if typeName == p3 and items[p2] then
		return p2
	end

	if typeName ~= "string" then
		error({
			parserName = "parseLuaTableEnumHelper",
			message = `Invalid input type to parser: {typeName}. Expected string.`
		})
	end

	local v5 = p4[p2]

	if v5 ~= nil then
		return v5
	end

	local v6 = ""

	for k in items do
		v6 ..= k .. ", "
	end

	error({
		parserName = "parseLuaTableEnumHelper",
		message = `Failed to parse lua table enum. input: {p2} validValues: {v6}`
	})
end

local v5 = {}

local function makeLuaTableEnumParser(items, p2)
	local set = {}

	for k, item in items do
		set[item] = true
	end

	return function(p3, p4, p5, p6)
		return parseLuaTableEnumHelper(p3, p2, items, set)
	end
end

local function parseEngineEnumHelper(value, p2)
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
		return p2[value]
	end)

	if success then
		return result
	end

	error({ parserName = "parseEngineEnumHelper", message = result })
end

local v6 = {}

local function makeEngineEnumParser(p2)
	return function(p3, p4, p5, p6)
		return parseEngineEnumHelper(p3, p2)
	end
end

local function parseUDim2(value, p2, p3, p4)
	local typeName = typeof(value)

	if typeName == "UDim2" then
		return value
	end

	local success, result = pcall(function()
		if typeName == "string" then
			local v7 = string.split(value, ",")

			if #v7 == 4 then
				return UDim2.new(
					tonumber(v7[1]) or 0,
					tonumber(v7[2]) or 0,
					tonumber(v7[3]) or 0,
					tonumber(v7[4]) or 0
				)
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

	local error2 = error

	if typeof(result) ~= "string" then
		result = nil
	end

	error2({ parserName = "parseUDim2", message = result })
end

local function parseUDim(value, p2, p3, p4)
	local typeName = typeof(value)

	if typeName == "UDim" then
		return value
	end

	local success, result = pcall(function()
		if typeName == "string" then
			local v7 = string.split(value, ",")

			if #v7 == 2 then
				return UDim.new(tonumber(v7[1]) or 0, tonumber(v7[2]) or 0)
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

	local error2 = error

	if typeof(result) ~= "string" then
		result = nil
	end

	error2({ parserName = "parseUDim", message = result })
end

local function parseColor3(data, p2, p3, p4)
	local typeName = typeof(data)

	if typeName == "Color3" then
		return data
	end

	local success, result = pcall(function()
		if typeName == "string" then
			local success2, result2 = pcall(function()
				return Color3.fromHex(data)
			end)

			if success2 and result2 then
				return result2
			end

			local success3, result3 = pcall(function()
				return parseFoundationTokenHelper(data, "table", "parseColorToken", p2)
			end)

			if success3 and typeof(result3) == "table" and result3.Color3 ~= nil then
				return result3.Color3
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

	local error2 = error

	if typeof(result) ~= "string" then
		result = if typeof(result) == "table" then result.message else nil
	end

	error2({ parserName = "parseColor3", message = result })
end

local color = Color3.new(0, 0, 0)
local v7 = {
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

	if typeof(data.endOpacity) == "number" then
		return typeof(data.degree) == "number"
	end

	return false
end

local function parseGradient(data, p2, p3, p4)
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
			return parseColor3(data.startColor, p2, p3, p4)
		end)

		if not success then
			error({
				parserName = "parseGradient",
				message = typeof(result) ~= "string" and "failed to parse startColor field" or result
			})
		end
	else
		result = v7.startColor
	end

	local result2

	if data.endColor then
		local success
		success, result2 = pcall(function()
			return parseColor3(data.endColor, p2, p3, p4)
		end)

		if not success then
			error({
				parserName = "parseGradient",
				message = typeof(result2) ~= "string" and "failed to parse endColor field" or result2
			})
		end
	else
		result2 = v7.endColor
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
		startOpacity = startOpacity or v7.startOpacity,
		endOpacity = endOpacity or v7.endOpacity,
		degree = degree or v7.degree
	}
end

local v8 = {
	truncate_arrows = true,
	squircles = true,
	gradient = true,
	component_assets = true,
	chat_bubble = true,
	icons = true
}

local function isValidIconString(value): boolean
	local parts = value:split("/")

	if parts and #parts > 1 and v8[parts[1]] then
		return true
	end

	return false
end

local function parseIcon(value, p2, p3, p4)
	local result = nil

	if
		typeof(value) == "table"
		and typeof(value.ImageRectOffset) == "Vector2"
		and typeof(value.Image) == "string"
		and typeof(value.ImageRectSize) == "Vector2"
	then
		return value
	end

	if typeof(value) == "string" then
		local success
		success, result = pcall(function()
			return getImageData(value) or images[value]
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

local function isCallableTable(p2): boolean
	if typeof(p2) == "table" then
		local metatable = getmetatable(p2)

		if metatable and type(metatable.__call) == "function" then
			return true
		end
	end

	return false
end

local function parseCallback(value, sduiContext, analyticsContext, p2)
	local v9 = nil

	if typeof(value) == "function" then
		return value
	end

	local v10

	if typeof(value) == "table" then
		local metatable = getmetatable(value)
		v10 = metatable and type(metatable.__call) == "function" and true or false
	else
		v10 = false
	end

	if v10 then
		value.analyticsContext = analyticsContext
		value.sduiContext = sduiContext
		return value
	else
		local v11

		if typeof(value) == "table" and typeof(value.actionType) == "string" then
			local actionHandlerConfig = getSduiActionHandlerRegistry().getActionHandlerConfig(value.actionType)

			if actionHandlerConfig == nil then
				v11 = false
			else
				v11 = actionHandlerConfig.handler ~= nil or actionHandlerConfig.telemetryHandler ~= nil
			end
		else
			v11 = false
		end

		if v11 then
			v9 = value
		end

		if v9 then
			local v12 = {
				analyticsContext = analyticsContext,
				sduiContext = sduiContext
			}

			setmetatable(v12, {
				__call = function(p3, p4)
					return executeAction(v9, p3.analyticsContext, p3.sduiContext, p4)
				end
			})

			return v12
		else
			local actionType = typeof(value) == "table" and value.actionType or "unknown"

			error({
				parserName = "parseCallback",
				message = `Could not find action for: {value} actionType: {actionType}`,
				overrideValue = function()
					sduiContext.dependencies.logger.reportCounter(
						SduiErrors.SduiCounterName.ExecutedInvalidAction,
						{ name = actionType }
					)
				end
			})
		end
	end
end

local function parseLazyCallback(p2, p3, p4, p5)
	return p2
end

local function parseLazyUiComponent(p2, p3, p4, p5)
	if p5 ~= sduiBuilderProcessingPhase.Eager then
		return p2
	end

	local success, result = pcall(function()
		if typeof(p2) ~= "table" then
			error(`Invalid input type {typeof(p2)}`)
		end

		local v9, v10 = SduiBuilder.tryCreateEagerProcessedComponentConfig(p2, p3, "parseUiComponent", p4)

		if v9 then
			return v10
		end

		error("Unable to parse componentConfig during Eager phase")
	end)

	if success and result then
		return result
	end

	local error2 = error

	if typeof(result) ~= "string" then
		result = nil
	end

	error2({ parserName = "parseLazyUiComponent", message = result })
end

local function parseUiComponent(p2, p3, p4, p5)
	local success, result

	if p5 == sduiBuilderProcessingPhase.Eager then
		success, result = pcall(function()
			if typeof(p2) ~= "table" then
				error(`Invalid input type {typeof(p2)}`)
			end

			local v9, v10 = SduiBuilder.tryCreateEagerProcessedComponentConfig(p2, p3, "parseUiComponent", p4)

			if v9 then
				return v10
			end

			error("Unable to parse componentConfig during Eager phase")
		end)
	else
		success, result = pcall(function()
			if typeof(p2) == "table" then
				local v9 = getSduiComponentWrapper(p2)
				return React.createElement(v9, {
					componentConfig = p2,
					sduiContext = p3,
					parentAnalyticsContext = p4,
					debugName = `parsedUiComponent-{p2.componentType}`
				})
			end

			error(`Invalid input type {typeof(p2)}`)
		end)
	end

	if success and result then
		return result
	end

	local error2 = error

	if typeof(result) ~= "string" then
		result = nil
	end

	error2({ parserName = "parseUiComponent", message = result })
end

local function parseVector2(value, p2, p3, p4)
	local typeName = typeof(value)

	if typeName == "Vector2" then
		return value
	end

	local success, result = pcall(function()
		if typeName == "string" then
			local v9 = string.split(value, ",")

			if #v9 == 2 then
				return Vector2.new(tonumber(v9[1]) or 0, tonumber(v9[2]) or 0)
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

	local error2 = error

	if typeof(result) ~= "string" then
		result = nil
	end

	error2({ parserName = "parseVector2", message = result })
end

local function parseNumber(p2, p3, p4, p5)
	local typeName = typeof(p2)

	if typeName == "number" then
		return p2
	end

	if typeName ~= "string" then
		error({
			parserName = "parseNumber",
			message = `Invalid input type for parseNumber: {typeName}`
		})

		return
	end

	local success, result = pcall(function()
		return (tonumber(p2))
	end)

	if not success or result == nil then
		success, result = pcall(function()
			return parseFoundationTokenHelper(p2, "number", "parseNumberToken", p3)
		end)
	end

	if success and result then
		return result
	end

	local error2 = error

	if typeof(result) ~= "string" then
		result = `Failed to parse string {p2} to number`
	end

	error2({ parserName = "parseNumber", message = result })
end

local function parseInteger(p2, p3, p4, p5)
	local typeName = typeof(p2)

	if typeName == "number" then
		return p2
	end

	if typeName ~= "string" then
		error({
			parserName = "parseInteger",
			message = `Invalid input type for parseInteger: {typeName}`
		})

		return
	end

	local success, result = pcall(function()
		return (tonumber(p2))
	end)

	if success and result then
		if p2 == tostring((math.round(result))) then
			return result
		end

		local error2 = error

		local v10 = if typeof(result) == "string" then result else `Unexpected output {result} does not match input {p2}.`
		error2({ parserName = "parseInteger", message = v10 })

		return result
	else
		local error2 = error

		if typeof(result) ~= "string" then
			result = `Failed to parse string {p2} to number`
		end

		error2({ parserName = "parseInteger", message = result })
	end
end

local function parseBoolean(value, p2, p3, p4)
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

		local v9 = string.lower(value)

		if v9 == "t" or v9 == "true" then
			return true
		end

		if v9 == "f" or v9 == "false" then
			return false
		end

		error({
			parserName = "parseBoolean",
			message = `Failed to parse string {value} to boolean`
		})
	end
end

local function parseString(p2, p3, p4, p5)
	local typeName = typeof(p2)

	if typeName == "string" then
		return p2
	end

	if typeName == "number" or typeName == "boolean" then
		return (tostring(p2))
	end

	error({
		parserName = "parseString",
		message = `Invalid input type for parseString: {typeName}`
	})
end

local function parseImageString(value, p2, p3, p4)
	local typeName = typeof(value)

	if typeName ~= "string" then
		error({
			parserName = "parseImageString",
			message = `Invalid input type for parseImageString: {typeName}`
		})
	end

	local parts = value:split("://")
	local v9 = #parts > 1 and parts[1] == "rbxthumb"

	if not v9 then
		return value
	end

	local parts2 = parts[2]:split("&")
	local v10 = {}

	for k, part in parts2 do
		local parts3 = part:split("=")

		if #parts3 == 2 then
			v10[parts3[1]] = parts3[2]
		end
	end

	if v10.mw == nil or v10.mh == nil then
		return value
	end

	local w = tonumber(v10.w)
	local h = tonumber(v10.h)
	local mw = tonumber(v10.mw)
	local mh = tonumber(v10.mh)

	if w == nil or h == nil or mw == nil or mh == nil or v10.type == nil or v10.id == nil then
		error({
			parserName = "parseImageString",
			message = `Invalid params for rbxthumb in parseImageString: {value}`
		})
	end

	assert(w, "inputWidth must exist")
	assert(h, "inputHeight must exist")
	assert(mw, "inputWidth must exist")
	assert(mh, "inputHeight must exist")

	local adaptThumbnailDimensions, v11 = SduiResponsiveHelpers.adaptThumbnailDimensions(w, h, mw, mh, v10.type)

	local v12 = `rbxthumb://type={v10.type}&id={v10.id}&w={adaptThumbnailDimensions}&h={v11}`

	v10.w = nil
	v10.h = nil
	v10.mw = nil
	v10.mh = nil
	v10.id = nil
	v10.type = nil

	for k, v13 in v10 do
		v12 ..= string.format("&%s=%s", k, v13)
	end

	return v12
end

local function parseImageSetOrImage(value, p2, p3, p4)
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

	local parts = value:split("/")

	if parts and #parts > 1 and v8[parts[1]] then
		return parseIcon(value, p2, p3, p4)
	end

	return parseImageString(value, p2, p3, p4)
end

local function isValidFocusNavActions(p2)
	if typeof(p2) ~= "table" then
		return false
	end

	local v9 = nil
	local v10 = nil
	local keys = p2.keys

	if keys then
		if typeof(keys) ~= "table" then
			return false
		end

		for k, key in keys do
			if typeof(k) ~= "EnumItem" then
				return false
			end

			if focusNavigationEventNameEnum[key] == nil then
				return false
			end

			v9 = true
		end
	end

	local events = p2.events

	if not events then
		return v9 or v10 or false
	end

	if typeof(events) ~= "table" then
		return false
	end

	for k, event in events do
		if not (focusNavigationEventNameEnum[k] ~= nil and typeof(event) == "table" and typeof(event.handler) == "function") then
			return false
		end

		v10 = true
	end

	return v9 or v10 or false
end

local function parseFocusNavActions(p2, p3, p4, p5)
	if isValidFocusNavActions(p2) then
		return p2
	end

	local typeName = typeof(p2)

	if typeName ~= "table" then
		error({
			parserName = "parseFocusNavActions",
			message = `Invalid input type for parseFocusNavActions: {typeName}`
		})
	end

	assert(typeof(p2) == "table", "input must be table")

	local success, result = pcall(function()
		local v9 = focusNavigationEventNameEnum

		if v5[v9] == nil then
			local v10 = v5
			local set = {}

			for k, v11 in v9 do
				set[v11] = true
			end

			local v11 = "string"
			v10[v9] = function(p6, p7, p8, p9)
				return parseLuaTableEnumHelper(p6, v11, v9, set)
			end
		end

		local v10 = v5[v9]

		local v11 = nil
		local v12 = nil
		local keys = p2.keys

		if keys then
			if typeof(keys) ~= "table" then
				error({
					parserName = "parseFocusNavActions",
					message = `Invalid input type for keys: {typeName}`
				})
			end

			assert(typeof(keys) == "table", "keys must be table")

			local keyCode = Enum.KeyCode

			if v6[keyCode] == nil then
				v6[keyCode] = function(p6, p7, p8, p9)
					return parseEngineEnumHelper(p6, keyCode)
				end
			end

			local v13 = v6[keyCode]

			for k, key in keys do
				local v14

				if typeof(k) == "string" then
					keys[k] = nil
					v14 = v13(k, p3, p4, p5)
				end

				keys[v14] = v10(key, p3, p4, p5)
				v11 = true
			end
		end

		local events = p2.events

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
				events[v10(k, p3, p4, p5)] = {
					handler = InputHandlers.onRelease(parseCallback(event, p3, p4, p5))
				}
				v12 = true
			end
		end

		if not (v11 or v12) then
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

local v9 = {}
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
	getArrayMetatableParser = function(p2)
		if v9[p2] == nil then
			v9[p2] = setmetatable({}, {
				__index = function(p3, value)
					if type(value) == "number" then
						return p2
					end

					return nil
				end
			})
		end

		return v9[p2]
	end,
	getEngineEnumParser = function(p2)
		if v6[p2] == nil then
			v6[p2] = function(p3, p4, p5, p6)
				return parseEngineEnumHelper(p3, p2)
			end
		end

		return v6[p2]
	end,
	getLuaTableEnumParser = function(items, p2)
		if v5[items] ~= nil then
			return v5[items]
		end

		local v10 = v5
		local set = {}

		for k, item in items do
			set[item] = true
		end

		v10[items] = function(p3, p4, p5, p6)
			return parseLuaTableEnumHelper(p3, p2, items, set)
		end

		return v5[items]
	end,
	isValidActionConfig = function(p2, p3): boolean
		if typeof(p2) ~= "table" or typeof(p2.actionType) ~= "string" then
			return false
		end

		local actionHandlerConfig = getSduiActionHandlerRegistry().getActionHandlerConfig(p2.actionType)

		return actionHandlerConfig ~= nil
			and (actionHandlerConfig.handler ~= nil or actionHandlerConfig.telemetryHandler ~= nil)
	end,
	isValidImageSet = function(data): boolean
		return typeof(data) == "table"
			and typeof(data.ImageRectOffset) == "Vector2"
			and typeof(data.Image) == "string"
			and typeof(data.ImageRectSize) == "Vector2"
	end,
	isValidGradient = isValidGradient,
	isValidFocusNavActions = isValidFocusNavActions,
	safeParseBoolean = function(p2, p3, p4, p5)
		local success, result = pcall(function()
			return parseBoolean(p2, p3, p4, p5)
		end)

		if success then
			return result
		end

		local joined = Cryo.Dictionary.join(
			typeof(result) ~= "table" and (typeof(result) == "string" and {
				message = result
			} or {}) or result,
			{ value = SduiParseHelpers.stringifyValue(p2) }
		)

		p3.dependencies.logger.reportError(sduiErrorType.FailedToParse, joined, p3.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseCallback = function(p2, p3, p4, p5)
		local success, result = pcall(function()
			return parseCallback(p2, p3, p4, p5)
		end)

		if success then
			return result
		end

		local joined = Cryo.Dictionary.join(
			typeof(result) ~= "table" and (typeof(result) == "string" and {
				message = result
			} or {}) or result,
			{ value = SduiParseHelpers.stringifyValue(p2) }
		)

		p3.dependencies.logger.reportError(sduiErrorType.FailedToParse, joined, p3.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseColor3 = function(p2, p3, p4, p5)
		local success, result = pcall(function()
			return parseColor3(p2, p3, p4, p5)
		end)

		if success then
			return result
		end

		local joined = Cryo.Dictionary.join(
			typeof(result) ~= "table" and (typeof(result) == "string" and {
				message = result
			} or {}) or result,
			{ value = SduiParseHelpers.stringifyValue(p2) }
		)

		p3.dependencies.logger.reportError(sduiErrorType.FailedToParse, joined, p3.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseGradient = function(p2, p3, p4, p5)
		local success, result = pcall(function()
			return parseGradient(p2, p3, p4, p5)
		end)

		if success then
			return result
		end

		local joined = Cryo.Dictionary.join(
			typeof(result) ~= "table" and (typeof(result) == "string" and {
				message = result
			} or {}) or result,
			{ value = SduiParseHelpers.stringifyValue(p2) }
		)

		p3.dependencies.logger.reportError(sduiErrorType.FailedToParse, joined, p3.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseIcon = function(p2, p3, p4, p5)
		local success, result = pcall(function()
			return parseIcon(p2, p3, p4, p5)
		end)

		if success then
			return result
		end

		local joined = Cryo.Dictionary.join(
			typeof(result) ~= "table" and (typeof(result) == "string" and {
				message = result
			} or {}) or result,
			{ value = SduiParseHelpers.stringifyValue(p2) }
		)

		p3.dependencies.logger.reportError(sduiErrorType.FailedToParse, joined, p3.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseImageString = function(p2, p3, p4, p5)
		local success, result = pcall(function()
			return parseImageString(p2, p3, p4, p5)
		end)

		if success then
			return result
		end

		local joined = Cryo.Dictionary.join(
			typeof(result) ~= "table" and (typeof(result) == "string" and {
				message = result
			} or {}) or result,
			{ value = SduiParseHelpers.stringifyValue(p2) }
		)

		p3.dependencies.logger.reportError(sduiErrorType.FailedToParse, joined, p3.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseInteger = function(p2, p3, p4, p5)
		local success, result = pcall(function()
			return parseInteger(p2, p3, p4, p5)
		end)

		if success then
			return result
		end

		local joined = Cryo.Dictionary.join(
			typeof(result) ~= "table" and (typeof(result) == "string" and {
				message = result
			} or {}) or result,
			{ value = SduiParseHelpers.stringifyValue(p2) }
		)

		p3.dependencies.logger.reportError(sduiErrorType.FailedToParse, joined, p3.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseNumber = function(p2, p3, p4, p5)
		local success, result = pcall(function()
			return parseNumber(p2, p3, p4, p5)
		end)

		if success then
			return result
		end

		local joined = Cryo.Dictionary.join(
			typeof(result) ~= "table" and (typeof(result) == "string" and {
				message = result
			} or {}) or result,
			{ value = SduiParseHelpers.stringifyValue(p2) }
		)

		p3.dependencies.logger.reportError(sduiErrorType.FailedToParse, joined, p3.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseString = function(p2, p3, p4, p5)
		local success, result = pcall(function()
			return parseString(p2, p3, p4, p5)
		end)

		if success then
			return result
		end

		local joined = Cryo.Dictionary.join(
			typeof(result) ~= "table" and (typeof(result) == "string" and {
				message = result
			} or {}) or result,
			{ value = SduiParseHelpers.stringifyValue(p2) }
		)

		p3.dependencies.logger.reportError(sduiErrorType.FailedToParse, joined, p3.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseUDim = function(p2, p3, p4, p5)
		local success, result = pcall(function()
			return parseUDim(p2, p3, p4, p5)
		end)

		if success then
			return result
		end

		local joined = Cryo.Dictionary.join(
			typeof(result) ~= "table" and (typeof(result) == "string" and {
				message = result
			} or {}) or result,
			{ value = SduiParseHelpers.stringifyValue(p2) }
		)

		p3.dependencies.logger.reportError(sduiErrorType.FailedToParse, joined, p3.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseUDim2 = function(p2, p3, p4, p5)
		local success, result = pcall(function()
			return parseUDim2(p2, p3, p4, p5)
		end)

		if success then
			return result
		end

		local joined = Cryo.Dictionary.join(
			typeof(result) ~= "table" and (typeof(result) == "string" and {
				message = result
			} or {}) or result,
			{ value = SduiParseHelpers.stringifyValue(p2) }
		)

		p3.dependencies.logger.reportError(sduiErrorType.FailedToParse, joined, p3.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseUiComponent = function(p2, p3, p4, p5)
		local success, result = pcall(function()
			return parseUiComponent(p2, p3, p4, p5)
		end)

		if success then
			return result
		end

		local joined = Cryo.Dictionary.join(
			typeof(result) ~= "table" and (typeof(result) == "string" and {
				message = result
			} or {}) or result,
			{ value = SduiParseHelpers.stringifyValue(p2) }
		)

		p3.dependencies.logger.reportError(sduiErrorType.FailedToParse, joined, p3.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseVector2 = function(p2, p3, p4, p5)
		local success, result = pcall(function()
			return parseVector2(p2, p3, p4, p5)
		end)

		if success then
			return result
		end

		local joined = Cryo.Dictionary.join(
			typeof(result) ~= "table" and (typeof(result) == "string" and {
				message = result
			} or {}) or result,
			{ value = SduiParseHelpers.stringifyValue(p2) }
		)

		p3.dependencies.logger.reportError(sduiErrorType.FailedToParse, joined, p3.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseNumberToken = function(p2, p3, p4, p5)
		local success, result = pcall(function()
			return parseNumberToken(p2, p3, p4, p5)
		end)

		if success then
			return result
		end

		local joined = Cryo.Dictionary.join(
			typeof(result) ~= "table" and (typeof(result) == "string" and {
				message = result
			} or {}) or result,
			{ value = SduiParseHelpers.stringifyValue(p2) }
		)

		p3.dependencies.logger.reportError(sduiErrorType.FailedToParse, joined, p3.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseTypographyToken = function(p2, p3, p4, p5)
		local success, result = pcall(function()
			return parseTypographyToken(p2, p3, p4, p5)
		end)

		if success then
			return result
		end

		local joined = Cryo.Dictionary.join(
			typeof(result) ~= "table" and (typeof(result) == "string" and {
				message = result
			} or {}) or result,
			{ value = SduiParseHelpers.stringifyValue(p2) }
		)

		p3.dependencies.logger.reportError(sduiErrorType.FailedToParse, joined, p3.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseFontFromTypographyToken = function(p2, p3, p4, p5)
		local success, result = pcall(function()
			return parseFontFromTypographyToken(p2, p3, p4, p5)
		end)

		if success then
			return result
		end

		local joined = Cryo.Dictionary.join(
			typeof(result) ~= "table" and (typeof(result) == "string" and {
				message = result
			} or {}) or result,
			{ value = SduiParseHelpers.stringifyValue(p2) }
		)

		p3.dependencies.logger.reportError(sduiErrorType.FailedToParse, joined, p3.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseColorToken = function(p2, p3, p4, p5)
		local success, result = pcall(function()
			return parseColorToken(p2, p3, p4, p5)
		end)

		if success then
			return result
		end

		local joined = Cryo.Dictionary.join(
			typeof(result) ~= "table" and (typeof(result) == "string" and {
				message = result
			} or {}) or result,
			{ value = SduiParseHelpers.stringifyValue(p2) }
		)

		p3.dependencies.logger.reportError(sduiErrorType.FailedToParse, joined, p3.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseFocusNavActions = function(p2, p3, p4, p5)
		local success, result = pcall(function()
			return parseFocusNavActions(p2, p3, p4, p5)
		end)

		if success then
			return result
		end

		local joined = Cryo.Dictionary.join(
			typeof(result) ~= "table" and (typeof(result) == "string" and {
				message = result
			} or {}) or result,
			{ value = SduiParseHelpers.stringifyValue(p2) }
		)

		p3.dependencies.logger.reportError(sduiErrorType.FailedToParse, joined, p3.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end,
	safeParseImageSetOrImageProp_ = function(p2, p3, p4, p5)
		local success, result = pcall(function()
			return parseImageSetOrImage(p2, p3, p4, p5)
		end)

		if success then
			return result
		end

		local joined = Cryo.Dictionary.join(
			typeof(result) ~= "table" and (typeof(result) == "string" and {
				message = result
			} or {}) or result,
			{ value = SduiParseHelpers.stringifyValue(p2) }
		)

		p3.dependencies.logger.reportError(sduiErrorType.FailedToParse, joined, p3.appPage)

		if typeof(result) == "table" then
			return result.overrideValue
		end

		return nil
	end
}
