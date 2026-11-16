local Foundation = script:FindFirstAncestor("Foundation")
local Logger = require(Foundation.Utility.Logger)
require(Foundation.Components.Types)

local function isColorStyle(p): boolean -- 4 equivalent calls inferred from this helper
	return type(p) == "table"
		and p.Color3 ~= nil
		and typeof(p.Color3) == "Color3"
		and p.Transparency ~= nil
		and typeof(p.Transparency) == "number"
end

local function getRoundedNumber(p: number) -- 6 equivalent calls inferred from this helper
	return math.round(p * 1000) / 1000
end

local function getRGBAValues(color: Color3, p: number?)
	local v = math.round(color.R * 255)
	local v2 = math.round(color.G * 255)
	local v3 = math.round(color.B * 255)

	if p then
		return v, v2, v3, getRoundedNumber(1 - p) -- inferred equivalent call
	end

	return v, v2, v3
end

local function formatColorPreviewHTML(color3: Color3, transparency: number?) -- 1 equivalent call inferred from this helper
	local v = math.round(color3.R * 255)
	local v2 = math.round(color3.G * 255)
	local v3 = math.round(color3.B * 255)
	local v4

	if transparency then
		v4 = getRoundedNumber(1 - transparency) -- inferred equivalent call
	end

	return `<span class="color-preview" style="background-color: rgba({v},{v2},{v3},{v4 or 1});"></span>`
end

local function collectTokens(item, category: string, p: string?, flag: boolean?)
	local tokens = {}

	for k, item2 in item do
		local fullPath

		if p then
			fullPath = `{p}.{k}`
		else
			fullPath = k
		end

		if type(item2) == "table" and not getmetatable(item2) then
			if flag and isColorStyle(item2) then -- inferred equivalent call
				table.insert(tokens, {
					key = k,
					value = item2,
					category = category,
					fullPath = fullPath
				})
				continue
			end

			local v = collectTokens(item2, category, fullPath, flag)

			for _, v2 in v do
				table.insert(tokens, v2)
			end
		else
			table.insert(tokens, {
				key = k,
				value = item2,
				category = category,
				fullPath = fullPath
			})
		end
	end

	return tokens
end

local function getTokenValue(p, value: string)
	for _, v in string.split(value, ".") do
		if p == nil or type(p) ~= "table" then
			return nil
		end

		p = p[v]
	end

	return p
end

local function tokenOverrideValuesCompatible(tokenValue, tokenOverrideSource): boolean
	if tokenValue == nil or tokenOverrideSource == nil then
		return false
	end

	if type(tokenValue) ~= "table" or type(tokenOverrideSource) ~= "table" then
		return typeof(tokenValue) == typeof(tokenOverrideSource)
	end

	for k, item in tokenValue do
		if not tokenOverrideValuesCompatible(item, tokenOverrideSource[k]) then
			return false
		end
	end

	for k in tokenOverrideSource do
		if tokenValue[k] == nil then
			return false
		end
	end

	return true
end

local function resolveTokenOverrideSource(p, value) -- 1 equivalent call inferred from this helper
	if type(value) ~= "string" then
		return value
	end

	local tokenValue = getTokenValue(p, value)

	if tokenValue ~= nil then
		return tokenValue
	end

	Logger:warning(`Token override skipped: unknown source token path "{value}"`)
	return nil
end

local TokenProcessingUtilities = {}
TokenProcessingUtilities.isColorStyle = isColorStyle
TokenProcessingUtilities.formatColorPreviewHTML = formatColorPreviewHTML

function TokenProcessingUtilities.formatTokenValue(value)
	if typeof(value) == "Color3" then
		return `rgb({math.round(value.R * 255)}, {math.round(value.G * 255)}, {math.round(value.B * 255)})`
	end

	if typeof(value) == "number" then
		return (tostring(getRoundedNumber(value))) -- inferred equivalent call
	end

	if not isColorStyle(value) then -- inferred equivalent call
		return (tostring(value))
	end

	local color3 = value.Color3
	local transparency = value.Transparency
	local v = math.round(color3.R * 255)
	local v2 = math.round(color3.G * 255)
	local v3 = math.round(color3.B * 255)
	local v4

	if transparency then
		v4 = getRoundedNumber(1 - transparency) -- inferred equivalent call
	end

	return `rgba({v}, {v2}, {v3}, {v4})`
end

function TokenProcessingUtilities.formatTokenValueHTML(value)
	if typeof(value) == "Color3" then
		local v = math.round(value.R * 255)
		local v2 = math.round(value.G * 255)
		local v3 = math.round(value.B * 255)
		return `<span class="color">{`<span class="color-preview" style="background-color: rgba({math.round(value.R * 255)},{math.round(value.G * 255)},{math.round(value.B * 255)},{nil or 1});"></span>`} rgb({v}, {v2}, {v3})</span>`
	else
		if typeof(value) == "number" then
			return (tostring(getRoundedNumber(value))) -- inferred equivalent call
		end

		if not isColorStyle(value) then -- inferred equivalent call
			return (tostring(value))
		end

		local color3 = value.Color3
		local transparency = value.Transparency
		local v = math.round(color3.R * 255)
		local v2 = math.round(color3.G * 255)
		local v3 = math.round(color3.B * 255)
		local v4

		if transparency then
			v4 = getRoundedNumber(1 - transparency) -- inferred equivalent call
		end

		return `<span class="color">{formatColorPreviewHTML(value.Color3, value.Transparency)} rgba({v}, {v2}, {v3}, {v4})</span>` -- inferred equivalent call
	end
end

TokenProcessingUtilities.collectTokens = collectTokens

function TokenProcessingUtilities.collectTokensWithSubcategories(items, category: string, value: string?, flag: boolean?)
	local tokensWithSubcategories = {}

	for k, item in items do
		local fullPath

		if value then
			fullPath = `{value}.{k}`
		else
			fullPath = k
		end

		if type(item) == "table" then
			if flag and isColorStyle(item) then -- inferred equivalent call
				local v = not value and "Default" or value:split(".")[1]

				if not tokensWithSubcategories[v] then
					tokensWithSubcategories[v] = {}
				end

				table.insert(tokensWithSubcategories[v], {
					key = k,
					value = item,
					category = category,
					fullPath = fullPath
				})
				continue
			end

			if value then
				local v = collectTokens(item, category, fullPath, flag)
				local v2 = value:split(".")[1]

				if not tokensWithSubcategories[v2] then
					tokensWithSubcategories[v2] = {}
				end

				for _, v3 in v do
					table.insert(tokensWithSubcategories[v2], v3)
				end
			else
				local v = collectTokens(item, category, k, flag)

				if #v > 0 then
					tokensWithSubcategories[k] = v
				end
			end
		else
			local v = not value and "Default" or value:split(".")[1]

			if not tokensWithSubcategories[v] then
				tokensWithSubcategories[v] = {}
			end

			table.insert(tokensWithSubcategories[v], {
				key = k,
				value = item,
				category = category,
				fullPath = fullPath
			})
		end
	end

	return tokensWithSubcategories
end

function TokenProcessingUtilities.hasSubcategories(items): boolean
	for _, item in items do
		if type(item) ~= "table" then
			continue
		end

		local flag = false

		for _, v in item do
			if type(v) == "table" or typeof(v) == "Color3" or typeof(v) == "number" then
				flag = true
				break
			end
		end

		if flag then
			return true
		end
	end

	return false
end

function TokenProcessingUtilities.sortTokens(value: string, value2: string, flag: boolean?): boolean
	if value:find("(%u%a+)_(%d+)%.?(%u?%w*)") and value2:find("(%u%a+)_(%d+)%.?(%u?%w*)") then
		local match, v, v2 = value:match("(%u%a+)_(%d+)%.?(%u?%w*)")
		local match2, v3, v4 = value2:match("(%u%a+)_(%d+)%.?(%u?%w*)")

		if match ~= match2 then
			return value < value2
		end

		if v == v3 then
			return v2 < v4
		end

		return tonumber(v) < tonumber(v3)
	else
		if not flag then
			return value < value2
		end

		local match = value:match("| (%-?[%d.]+) |$")
		local match2 = value2:match("| (%-?[%d.]+) |$")
		return tonumber(match) < tonumber(match2)
	end
end

TokenProcessingUtilities.orderedTokenCategories = {
	"Color",
	"Stroke",
	"Size",
	"Radius",
	"Padding",
	"Margin",
	"Gap",
	"Typography",
	"FontSize",
	"FontWeight",
	"LineHeight",
	"Ease",
	"Time",
	"Inverse",
	"DarkMode",
	"LightMode",
	"Config"
}
TokenProcessingUtilities.getTokenValue = getTokenValue

function TokenProcessingUtilities.setTokenValue(p, value: string, p2)
	local v = string.split(value, ".")

	for i = 1, #v - 1 do
		local v2 = v[i]

		if p[v2] == nil then
			return
		end

		p = p[v2]
	end

	local v2 = v[#v]

	if p and v2 then
		p[v2] = p2
	end
end

function TokenProcessingUtilities.resolveTokenOverride(p, p2: string, value)
	local tokenOverrideSource = resolveTokenOverrideSource(p, value) -- inferred equivalent call

	if tokenOverrideSource == nil then
		return nil
	end

	local tokenValue = getTokenValue(p, p2)

	if tokenValue == nil then
		Logger:warning(`Token override skipped: unknown target token path "{p2}"`)
		return nil
	end

	if tokenOverrideValuesCompatible(tokenValue, tokenOverrideSource) then
		return tokenOverrideSource
	end

	Logger:warning(`Token override skipped: type or shape mismatch for "{p2}"`)
	return nil
end

TokenProcessingUtilities._resolveTokenOverrideSource = resolveTokenOverrideSource
return TokenProcessingUtilities
