local HttpService = game:GetService("HttpService")

local parent = script.Parent
local parent2 = parent.Parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local String = LuauPolyfill.String
local Number = LuauPolyfill.Number
local RegExp = require(parent2.RegExp)

local function TypeError(p)
	return p
end

local function encodeURIComponent(p) -- 1 equivalent call inferred from this helper
	return HttpService:UrlEncode(p)
end

local function strictUriEncode(p: string)
	return encodeURIComponent(p):gsub("[!'%(%)%*]", function(value) -- inferred equivalent call
		return (("%%%x"):format(value:byte())):upper()
	end)
end

local decodeURIComponent = require(parent.decodeURIComponent)
local splitOnFirst = require(parent.splitOnFirst)

local encode
local decode

local QueryString = {}

local function newNumber(p) -- 4 equivalent calls inferred from this helper
	return tonumber(p) or (0 / 0)
end

local function encoderForArrayFormat(data)
	local arrayFormat = data.arrayFormat

	if arrayFormat == "index" then
		return function(p)
			return function(list, p2)
				local count = #list

				if data.skipNull and p2 == nil then
					return list
				end

				if p2 == nil then
					return Array.concat(list, { table.concat({ encode(p, data), "[", count, "]" }, "") })
				end

				return Array.concat(list, {
					table.concat({
						encode(p, data),
						"[",
						encode(count, data),
						"]=",
						encode(p2, data)
					}, "")
				})
			end
		end
	elseif arrayFormat == "bracket" then
		return function(p)
			return function(p2, p3)
				if data.skipNull and p3 == nil then
					return p2
				end

				if p3 == nil then
					return Array.concat(p2, { table.concat({ encode(p, data), "[]" }, "") })
				end

				return Array.concat(p2, { table.concat({ encode(p, data), "[]=", encode(p3, data) }, "") })
			end
		end
	end

	if arrayFormat == "comma" or arrayFormat == "separator" then
		return function(p)
			return function(list, list2)
				if list2 == nil or #list2 == 0 then
					return list
				end

				if #list == 0 then
					return { table.concat({ encode(p, data), "=", encode(p, data) }, "") }
				end

				return { table.concat({ list, encode(p, data) }, data.arrayFormatSeparator) }
			end
		end
	end

	return function(p)
		return function(p2, p3)
			if data.skipNull and p3 == nil then
				return p2
			end

			if p3 == nil then
				return Array.concat(p2, { encode(p, data) })
			end

			return Array.concat(p2, { table.concat({ encode(p, data), "=", encode(p3, data) }, "") })
		end
	end
end

local function parserForArrayFormat(p)
	local v = nil
	local arrayFormat = p.arrayFormat

	if arrayFormat == "index" then
		return function(value, p2, p3)
			v = RegExp("\\[(\\d*)\\]$"):exec(value)

			local v2 = value:gsub("%[%d*%]$", "")

			if not v then
				p3[v2] = p2
				return
			end

			if p3[v2] == nil then
				p3[v2] = {}
			end

			p3[v2][v[2]] = p2
		end
	elseif arrayFormat == "bracket" then
		return function(value, p2, p3)
			v = RegExp("(\\[\\])$"):exec(value)
			local v2 = value:gsub("%[%]$", "")

			if not v then
				p3[v2] = p2
			elseif p3[v2] == nil then
				p3[v2] = { p2 }
			else
				p3[v2] = Array.concat({}, p3[v2], p2)
			end
		end
	end

	if arrayFormat == "comma" or arrayFormat == "separator" then
		return function(p2, value, p3)
			local v2

			if type(value) == "string" then
				v2 = string.find(value, p.arrayFormatSeparator, 1, true) ~= nil
			else
				v2 = false
			end

			local v3 = nil

			if v2 then
				v3 = Array.map(value:split(p.arrayFormatSeparator), function(p4)
					return decode(p4, p)
				end)
			elseif value ~= nil then
				v3 = decode(value, p)
			end

			p3[p2] = v3
		end
	end

	return function(p2, p3, values)
		if values[p2] == nil then
			values[p2] = p3
		else
			values[p2] = Array.concat({}, values[p2], p3)
		end
	end
end

local function validateArrayFormatSeparator(arrayFormatSeparator) -- 2 equivalent calls inferred from this helper
	if type(arrayFormatSeparator) ~= "string" or #arrayFormatSeparator ~= 1 then
		error("arrayFormatSeparator must be single character string")
	end
end

encode = function(p, p2)
	if not p2.encode then
		return p
	end

	if p2.strict then
		return strictUriEncode(p)
	end

	return encodeURIComponent(p)
end

decode = function(p, p2)
	if p2.decode then
		return decodeURIComponent(p)
	end

	return p
end

local function keysSorter(p)
	if Array.isArray(p) then
		return Array.sort(p)
	end

	if type(p) == "table" then
		return Array.map(Array.sort(keysSorter(Object.keys(p)), function(p2, p3)
			return newNumber(p2) - newNumber(p3) -- inferred equivalent call
		end), function(p2)
			return p[p2]
		end)
	end

	return p
end

local function removeHash(url) -- 1 equivalent call inferred from this helper
	local v = url:find("#")

	if v ~= nil then
		url = url:sub(1, v - 1)
	end

	return url
end

local function getHash(url) -- 1 equivalent call inferred from this helper
	local v = url:find("#")
	return v == nil and "" or url:sub(v)
end

local function parseValue(value, p)
	if
		p.parseNumbers
		and not Number.isNaN(newNumber(value)) -- inferred equivalent call
		and type(value) == "string"
		and String.trim(value) ~= ""
	then
		return newNumber(value) -- inferred equivalent call
	end

	if p.parseBooleans and value ~= nil and (string.lower(value) == "true" or string.lower(value) == "false") then
		value = string.lower(value) == "true"
	end

	return value
end

local function parse(value, p)
	local v = Object.assign({
		decode = true,
		sort = true,
		arrayFormat = "none",
		arrayFormatSeparator = ",",
		parseNumbers = false,
		parseBooleans = false
	}, p)

	validateArrayFormatSeparator(v.arrayFormatSeparator) -- inferred equivalent call

	local v2 = parserForArrayFormat(v)

	local result = {}

	if type(value) ~= "string" then
		return result
	end

	local v3 = string.gsub(String.trim(value), "^[%?#&]", "")

	if v3 == "" then
		return result
	end

	for _, v4 in v3:split("&") do
		if v.decode then
			v4 = string.gsub(v4, "%+", " ")
		end

		local v5 = splitOnFirst(v4, "=")
		local v6 = v5[1]
		local v7 = v5[2]

		if v7 ~= nil and v.arrayFormat ~= "comma" then
			v7 = decode(v7, v)
		end

		v2(decode(v6, v), v7, result)
	end

	for k in result do
		local v4 = result[k]

		if type(v4) == "table" then
			for k2 in v4 do
				v4[k2] = parseValue(v4[k2], v)
			end
		else
			result[k] = parseValue(v4, v)
		end
	end

	if v.sort == false then
		return result
	end

	local v4

	if v.sort == true then
		v4 = Array.sort(Object.keys(result))
	else
		v4 = Array.sort(Object.keys(result), v.sort)
	end

	return Array.reduce(v4, function(p2, p3)
		local v5 = result[p3]

		if Boolean.toJSBoolean(v5) and type(v5) == "table" and not Array.isArray(v5) then
			p2[p3] = keysSorter(v5)
			return p2
		end

		p2[p3] = v5

		return p2
	end, {})
end

function QueryString.extract(value)
	local v = value:find("#")

	if v ~= nil then
		value = value:sub(1, v - 1)
	end

	local v2 = value:find("?", 1, true)

	if v2 == nil then
		return ""
	end

	return value:sub(v2 + 1)
end
QueryString.parse = parse

function QueryString.stringify(p, p2)
	if not p then
		return ""
	end

	local v = Object.assign({
		encode = true,
		strict = true,
		arrayFormat = "none",
		arrayFormatSeparator = ","
	}, p2)

	validateArrayFormatSeparator(v.arrayFormatSeparator) -- inferred equivalent call

	local v2 = encoderForArrayFormat(v)
	local clone = table.clone(p)

	local keys = Object.keys(clone)

	if v.sort ~= false then
		Array.sort(keys, v.sort)
	end

	return table.concat(Array.filter(Array.map(keys, function(p3)
		local v3 = p[p3]

		if v3 == nil then
			return encode(p3, v)
		end

		if Array.isArray(v3) then
			return table.concat(Array.reduce(v3, v2(p3), {}), "&")
		end

		return encode(p3, v) + "=" + encode(v3, v)
	end), function(p3): boolean
		return p3.length > 0
	end), "&")
end

function QueryString.parseUrl(value, p)
	local v = value:find("#")
	local v2

	if v == nil then
		v2 = value
	else
		v2 = value:sub(1, v - 1)
	end

	local url = {
		url = v2:split("?")[1] or "",
		query = 0
	}
	local v3 = value:find("#")

	if v3 ~= nil then
		value = value:sub(1, v3 - 1)
	end

	local v4 = value:find("?", 1, true)
	url.query = parse(v4 == nil and "" or value:sub(v4 + 1), p)
	return url
end

function QueryString.stringifyUrl(p, p2)
	local v = removeHash(p.url):split("?")[1] or "" -- inferred equivalent call
	local extract = QueryString.extract(p.url)
	local parsed = QueryString.parse(extract)
	local hash = getHash(p.url) -- inferred equivalent call
	local v2 = Object.assign(parsed, p.query)
	local stringify = QueryString.stringify(v2, p2)

	return ("%s%s%s"):format(v, stringify and ("?%s"):format(stringify), hash)
end

return QueryString
