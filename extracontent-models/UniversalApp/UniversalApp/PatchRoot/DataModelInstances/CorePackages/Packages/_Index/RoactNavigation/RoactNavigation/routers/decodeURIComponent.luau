local parent = script.Parent.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local RegExp = require(parent.RegExp)

local function stringMatch(p, object)
	local v = object:exec(p)
	local result = {}

	while v do
		local v2 = v[1]
		table.insert(result, v2)
		v = object:exec((v.input:sub(v.index + v2:len())))
	end

	return result
end

local function TypeError(p)
	return p
end

local regExp = RegExp("(%[a-fA-F0-9]{2})+", "i")

local function decodeURIComponent(p)
	local v = regExp:exec(p)

	if not v then
		return p
	end

	local v2 = {}

	for k in v[1]:gmatch("%%(%x%x)") do
		local v3 = tonumber(k, 16)

		if v3 >= 128 then
			error("malformed URI sequence")
		end

		table.insert(v2, v3)
	end

	p = utf8.char(unpack(v2))

	return p
end

local regExp2 = RegExp("%[a-fA-F0-9]{2}", "i")
local regExp3 = RegExp("(%[a-fA-F0-9]{2})+", "i")
local function decodeComponents(list, value)
	local success, result = pcall(decodeURIComponent, table.concat(list, ""))

	if success then
		return result
	end

	if #list == 1 then
		return list
	end

	value = value or 1

	local slice = Array.slice(list, 1, value + 1)
	local slice2 = Array.slice(list, value + 1)

	return Array.concat(decodeComponents(slice), decodeComponents(slice2))
end

local function decode(p)
	local success, result = pcall(decodeURIComponent, p)

	if success then
		return result
	end

	local v = stringMatch(p, regExp2)
	local v2 = 2

	while v[v2] do
		p = table.concat(decodeComponents(v, v2), "")

		v = stringMatch(p, regExp2)
		v2 += 1
	end

	return p
end

local function escapePercent(value) -- 2 equivalent calls inferred from this helper
	return (value:gsub("%%", "%%%%"))
end

local function customDecodeURIComponent(value)
	local c2 = utf8.char(65533)
	local v = {
		["%FE%FF"] = c2 .. c2,
		["%FF%FE"] = c2 .. c2
	}

	local v2 = regExp3:exec(value)
	local v3 = { "%FE%FF", "%FF%FE" }

	while v2 do
		local v4 = v2[1]

		local success, result = xpcall(decodeURIComponent, function(_)
			local v5 = decode(v4)

			if v5 ~= v4 then
				if v[v4] == nil then
					table.insert(v3, v4)
				end

				v[v4] = v5
			end
		end, v4)

		if success then
			if v[v4] == nil then
				table.insert(v3, v4)
			end

			v[v4] = result
		end

		v2 = regExp3:exec((v2.input:sub(v2.index + v4:len())))
	end

	v["%C2"] = c2
	table.insert(v3, "%C2")

	for _, v4 in v3 do
		value = string.gsub(value, escapePercent(v4), escapePercent(v[v4])) -- inferred equivalent call
	end

	return value
end

local function decodeComponent(value)
	if type(value) ~= "string" then
		error("Expected `encodedURI` to be of type `string`, got `" .. typeof(value) .. "`")
	end

	return customDecodeURIComponent(value:gsub("%+", " "))
end

return decodeComponent
