local parent = script.Parent.Parent

local Cryo = require(parent.Cryo)
local StringUtilities = require(parent.StringUtilities)
local StringTrim = StringUtilities.StringTrim
local StringSplit = StringUtilities.StringSplit
local encodeURIComponent = require(script.Parent.encodeURIComponent)
local UrlBase = require(script.Parent.UrlBase)

local GameUrlPatterns = require(script.Parent.UrlPatterns.GameUrlPatterns)
local UserUrlPatterns = require(script.Parent.UrlPatterns.UserUrlPatterns)
local StaticUrlPatterns = require(script.Parent.UrlPatterns.StaticUrlPatterns)
local CatalogUrlPatterns = require(script.Parent.UrlPatterns.CatalogUrlPatterns)
local EconomyUrlPatterns = require(script.Parent.UrlPatterns.EconomyUrlPatterns)
local ShareLinksUrlPatterns = require(script.Parent.UrlPatterns.ShareLinksUrlPatterns)
local UserModerationPatterns = require(script.Parent.UrlPatterns.UserModerationPatterns)
local AccountInformationPatterns = require(script.Parent.UrlPatterns.AccountInformationPatterns)
local VirtualEventsUrlPatterns = require(script.Parent.UrlPatterns.VirtualEventsUrlPatterns)
local PlatformAuthPatterns = require(script.Parent.UrlPatterns.PlatformAuthPatterns)

local UrlBuilder = {}

local function splitAndTrim(p, p2, p3)
	local stringSplit = StringSplit(p, p2, p3)
	local mapped = Cryo.List.map(stringSplit, function(p4)
		return StringTrim(p4)
	end)

	return (Cryo.List.filter(mapped, function(list): boolean
		return #list > 0
	end))
end

local function validateValueType(list): boolean
	local typeName = type(list)

	if typeName == "string" then
		return true
	elseif typeName == "number" then
		return true
	end

	if typeName ~= "table" then
		return false
	end

	for _, item in ipairs(list) do
		local typeName2 = type(item)

		if typeName2 ~= "string" and typeName2 ~= "number" then
			return false
		end
	end

	return true
end

local function assertPlaceholder(value) -- 1 equivalent call inferred from this helper
	if string.sub(value, 1, 1) == "{" then
		assert(string.sub(value, -1, -1) == "}", "invalid pattern: placeholder items should end with `}`")
	end
end

local function assertElementIsValid(data, p)
	assert(type(data) == "table", "invalid pattern: elements should all be tables")

	if p then
		assert(type(data.name) == "string", "invalid pattern: element name should be a string")
		assert(#data.name > 0, "invalid pattern: element name should not be empty")
	end

	assert(
		type(data.value) == "string" or type(data.value) == "number",
		"invalid pattern: element value should be a string or number"
	)

	if type(data.value) == "string" then
		assertPlaceholder(data.value) -- inferred equivalent call
	end

	if data.optional ~= nil then
		assert(type(data.optional) == "boolean", "invalid pattern: element optional should be a boolean")
	end

	if data.default ~= nil then
		assert(
			validateValueType(data.default),
			"invalid pattern: element default should be a string, number, or a table of strings and numbers only"
		)
	end

	if data.collect ~= nil then
		assert(
			data.collect == "multi" or data.collect == "csv",
			"invalid pattern: element optional should be one of `multi`, `csv`"
		)
	end
end

local function assertPatternIsValid(data)
	assert(type(data.base) == "string", "invalid pattern: base should be a string")
	assert(#data.base > 0, "invalid pattern: base should not be empty")
	assert(type(data.path) == "table", "invalid pattern: path should be a table")

	for _, v in ipairs(data.path) do
		assertElementIsValid(v, false)
	end

	if data.query ~= nil then
		assert(type(data.query) == "table", "invalid pattern: query should be a table")
	end

	if type(data.query) == "table" then
		for _, v in ipairs(data.query) do
			assertElementIsValid(v, true)
		end
	end

	if data.hash ~= nil then
		assert(type(data.hash) == "table", "invalid pattern: hash should be a table")
	end
end

local function buildElementsFromString(p, p2)
	local v = splitAndTrim(p, p2 and "&" or "/")
	return (Cryo.List.map(v, function(p3)
		local stringTrim = StringTrim(p3)
		local optional = nil
		local default = nil
		local name, collect

		if p2 then
			local stringSplit = StringSplit(stringTrim, "=", 2)
			name = StringTrim(stringSplit[1])
			stringTrim = stringSplit[2]

			if string.sub(name, 1, 1) == "{" then
				local v2 = StringSplit(StringTrim(name, "{}"), "|", 2)[1]

				if stringTrim == nil then
					stringTrim = stringSplit[1]
				end

				name = StringTrim(v2)
			end

			collect = "multi"
		end

		if stringTrim ~= nil and string.find(stringTrim, "^{.*}$") then
			local stringSplit = StringSplit(StringTrim(stringTrim, "{}"), "|", 2)
			local stringTrim2 = StringTrim(stringSplit[1])

			if #stringSplit > 1 then
				optional = true

				if #stringSplit[2] > 1 then
					default = stringSplit[2]
				end
			end

			stringTrim = "{" .. stringTrim2 .. "}"
		end

		return {
			name = name,
			value = stringTrim,
			optional = optional,
			default = default,
			collect = collect
		}
	end))
end

local function buildQueryStringFromTable(items)
	local v = {}

	for k, item in pairs(items) do
		table.insert(v, k .. "=" .. item)
	end

	return table.concat(v, "&")
end

local function simplifyPattern(data)
	local base = data.base
	local path = data.path
	local query = data.query
	local hash = data.hash

	if base ~= nil and UrlBase[string.upper(base)] ~= nil then
		base = UrlBase[string.upper(base)]
	end

	if type(path) == "string" then
		local v = splitAndTrim(path, "/")
		local flag
		flag = false
		path = Cryo.List.map(v, function(p)
			local stringTrim = StringTrim(p)
			local optional = nil
			local default = nil
			local name, collect

			if flag then
				local stringSplit = StringSplit(stringTrim, "=", 2)
				name = StringTrim(stringSplit[1])
				stringTrim = stringSplit[2]

				if string.sub(name, 1, 1) == "{" then
					local v2 = StringSplit(StringTrim(name, "{}"), "|", 2)[1]

					if stringTrim == nil then
						stringTrim = stringSplit[1]
					end

					name = StringTrim(v2)
				end

				collect = "multi"
			end

			if stringTrim ~= nil and string.find(stringTrim, "^{.*}$") then
				local stringSplit = StringSplit(StringTrim(stringTrim, "{}"), "|", 2)
				local stringTrim2 = StringTrim(stringSplit[1])

				if #stringSplit > 1 then
					optional = true

					if #stringSplit[2] > 1 then
						default = stringSplit[2]
					end
				end

				stringTrim = "{" .. stringTrim2 .. "}"
			end

			return {
				name = name,
				value = stringTrim,
				optional = optional,
				default = default,
				collect = collect
			}
		end)
	end

	if type(query) == "table" and query[1] == nil then
		query = buildQueryStringFromTable(query)
	end

	if type(query) == "string" then
		local v = splitAndTrim(query, "&")
		local flag
		flag = true
		query = Cryo.List.map(v, function(p)
			local stringTrim = StringTrim(p)
			local optional = nil
			local default = nil
			local name, collect

			if flag then
				local stringSplit = StringSplit(stringTrim, "=", 2)
				name = StringTrim(stringSplit[1])
				stringTrim = stringSplit[2]

				if string.sub(name, 1, 1) == "{" then
					local v2 = StringSplit(StringTrim(name, "{}"), "|", 2)[1]

					if stringTrim == nil then
						stringTrim = stringSplit[1]
					end

					name = StringTrim(v2)
				end

				collect = "multi"
			end

			if stringTrim ~= nil and string.find(stringTrim, "^{.*}$") then
				local stringSplit = StringSplit(StringTrim(stringTrim, "{}"), "|", 2)
				local stringTrim2 = StringTrim(stringSplit[1])

				if #stringSplit > 1 then
					optional = true

					if #stringSplit[2] > 1 then
						default = stringSplit[2]
					end
				end

				stringTrim = "{" .. stringTrim2 .. "}"
			end

			return {
				name = name,
				value = stringTrim,
				optional = optional,
				default = default,
				collect = collect
			}
		end)
	end

	if type(hash) == "string" then
		local v = splitAndTrim(hash, "/")
		local flag
		flag = false
		hash = Cryo.List.map(v, function(p)
			local stringTrim = StringTrim(p)
			local optional = nil
			local default = nil
			local name, collect

			if flag then
				local stringSplit = StringSplit(stringTrim, "=", 2)
				name = StringTrim(stringSplit[1])
				stringTrim = stringSplit[2]

				if string.sub(name, 1, 1) == "{" then
					local v2 = StringSplit(StringTrim(name, "{}"), "|", 2)[1]

					if stringTrim == nil then
						stringTrim = stringSplit[1]
					end

					name = StringTrim(v2)
				end

				collect = "multi"
			end

			if stringTrim ~= nil and string.find(stringTrim, "^{.*}$") then
				local stringSplit = StringSplit(StringTrim(stringTrim, "{}"), "|", 2)
				local stringTrim2 = StringTrim(stringSplit[1])

				if #stringSplit > 1 then
					optional = true

					if #stringSplit[2] > 1 then
						default = stringSplit[2]
					end
				end

				stringTrim = "{" .. stringTrim2 .. "}"
			end

			return {
				name = name,
				value = stringTrim,
				optional = optional,
				default = default,
				collect = collect
			}
		end)
	end

	return { base = base, path = path, query = query, hash = hash }
end

local function concatValues(mapped, p)
	local filtered = Cryo.List.filter(mapped, function(list): boolean
		if p then
			return #splitAndTrim(list, "=") > 1
		end

		return #list > 0
	end)

	return table.concat(filtered, p and "&" or "/")
end

local function resolveElement(data, p, p2)
	local v = p == nil and {} or p
	local v2

	if type(data.value) == "string" and string.sub(data.value, 1, 1) == "{" then
		local v3 = v[string.sub(data.value, 2, -2)]

		if v3 == nil then
			v3 = data.default
		end

		if not data.optional then
			assert(v3 ~= nil, "UrlBuilder: missing parameter: `" .. data.value .. "`")
		end

		v2 = v3 == nil and {} or v3

		assert(
			validateValueType(v2),
			"UrlBuilder: invalid parameter: `" .. data.value .. "`, should be a string, number, or a table of strings and numbers only"
		)
	else
		v2 = data.value
	end

	local v3 = type(v2) ~= "table" and { v2 } or v2

	local mapped = Cryo.List.map(v3, function(p3)
		return encodeURIComponent((tostring(p3)))
	end)

	if p2 then
		local v4 = data.collect == "csv" and { table.concat(mapped, "%2C") } or mapped

		mapped = Cryo.List.map(v4, function(p3)
			return encodeURIComponent(data.name) .. "=" .. p3
		end)
	end

	return concatValues(mapped, p2)
end

local function resolveElementList(options, p, p2)
	return concatValues(Cryo.List.map(options or {}, function(p3)
		return resolveElement(p3, p, p2)
	end), p2)
end

function UrlBuilder.new(p)
	local v = simplifyPattern(p)
	assertPatternIsValid(v)
	return function(p2, p3)
		local stringTrim = StringTrim(v.base, "/", { right = true })
		local elementList = resolveElementList(v.path, p2, false)

		if #elementList > 0 then
			stringTrim ..= "/" .. elementList
		end

		if string.match(stringTrim, "[^/]/[^/]") == nil then
			stringTrim ..= "/"
		end

		local elementList2 = resolveElementList(v.query, p2, true)

		if #elementList2 > 0 then
			stringTrim ..= "?" .. elementList2
		end

		local elementList3 = resolveElementList(v.hash, p2, false)

		if #elementList3 > 0 then
			stringTrim ..= "#" .. elementList3
		end

		if not p3 then
			return stringTrim
		end

		if stringTrim ~= p3 then
			warn("UrlBuilder: unexpected output for pattern:")
			warn("UrlBuilder: expected `" .. p3 .. "`")
			warn("UrlBuilder: actual `" .. stringTrim .. "`")
		end

		return p3
	end
end

function UrlBuilder.fromString(p)
	local stringSplit = StringSplit(p, ":", 2)
	local v = #stringSplit < 2 and { "", stringSplit[1] } or stringSplit

	local v2 = v[1]
	local stringSplit2 = StringSplit(v[2], "%#", 2)
	local v3 = stringSplit2[2] or ""
	local stringSplit3 = StringSplit(stringSplit2[1], "%?", 2)
	local v4 = stringSplit3[1] or ""
	local v5 = stringSplit3[2] or ""

	if string.sub(v4, 1, 2) == "//" then
		local stringSplit4 = StringSplit(string.sub(v4, 3), "/", 2)
		v2 ..= "://" .. stringSplit4[1]
		v4 = stringSplit4[2] or "/"
	end

	return UrlBuilder.new({
		base = StringTrim(v2),
		path = StringTrim(v4),
		query = StringTrim(v5),
		hash = StringTrim(v3)
	})
end

function UrlBuilder.addQueryString(p, p2)
	local stringTrim = StringTrim(p)
	local v = string.find(stringTrim, "%?")

	if v == nil then
		stringTrim ..= "?"
	elseif v < #stringTrim then
		stringTrim ..= "&"
	end

	local keys = Cryo.Dictionary.keys(p2)
	local mapped = Cryo.List.map(keys, function(p3)
		return "{" .. p3 .. "}"
	end)

	local v2 = stringTrim .. table.concat(mapped, "&")
	return UrlBuilder.fromString(v2)(p2)
end

UrlBuilder.game = GameUrlPatterns(UrlBuilder)
UrlBuilder.user = UserUrlPatterns(UrlBuilder)
UrlBuilder.catalog = CatalogUrlPatterns(UrlBuilder)
UrlBuilder.static = StaticUrlPatterns(UrlBuilder)
UrlBuilder.usermoderation = UserModerationPatterns(UrlBuilder)
UrlBuilder.accountinformation = AccountInformationPatterns(UrlBuilder)
UrlBuilder.sharelinks = ShareLinksUrlPatterns(UrlBuilder)
UrlBuilder.economy = EconomyUrlPatterns(UrlBuilder)
UrlBuilder.virtualevents = VirtualEventsUrlPatterns(UrlBuilder)
UrlBuilder.PlatformAuth = PlatformAuthPatterns(UrlBuilder)

return UrlBuilder
