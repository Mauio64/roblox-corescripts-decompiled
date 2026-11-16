local HttpService = game:GetService("HttpService")

local parent = script.Parent
local parent2 = parent.Parent

local isArray = require(parent.Array.isArray)
require(parent2.ES7Types)

local formatValue
local formatObjectValue
local formatArray
local formatObject
local getObjectTag

local function inspect(p, p2)
	local v = p2 or { depth = 2 }
	local depth = v.depth or 2
	v.depth = not (depth >= 0) and 2 or depth
	return formatValue(p, {}, v)
end

local function isIndexKey(value, p): boolean
	return type(value) == "number" and value <= p and value >= 1 and math.floor(value) == value
end

local function getTableLength(p)
	local v = 1
	local v2 = rawget(p, v)

	while v2 ~= nil do
		v += 1
		v2 = rawget(p, v)
	end

	return v - 1
end

local function sortKeysForPrinting(p, p2): boolean
	local typeName = type(p)
	local typeName2 = type(p2)

	if typeName == typeName2 and (typeName == "number" or typeName == "string") then
		return p < p2
	end

	return typeName < typeName2
end

local function rawpairs(p)
	return next, p, nil
end

local function getFragmentedKeys(items)
	local v = 1
	local v2 = rawget(items, v)
	local count = 0
	local result = {}

	while v2 ~= nil do
		v += 1
		v2 = rawget(items, v)
	end

	local v3 = v - 1

	for k, _ in next, items do
		local v4

		if type(k) == "number" and k <= v3 and k >= 1 then
			v4 = math.floor(k) == k
		else
			v4 = false
		end

		if v4 then
			continue
		end

		count += 1
		result[count] = k
	end

	table.sort(result, sortKeysForPrinting)
	return result, count, v3
end

formatValue = function(p, p2, p3)
	local typeName = typeof(p)

	if typeName == "string" then
		return HttpService:JSONEncode(p)
	end

	if typeName == "number" then
		if p ~= p then
			return "NaN"
		end

		if p == 1e999 then
			return "Infinity"
		elseif p == -1e999 then
			return "-Infinity"
		end

		return (tostring(p))
	elseif typeName == "function" then
		local v = "[function"
		local v2 = debug.info(p, "n")

		if v2 ~= nil and v2 ~= "" then
			v ..= " " .. v2
		end

		return v .. "]"
	elseif typeName == "table" then
		return formatObjectValue(p, p2, p3)
	else
		return (tostring(p))
	end
end

formatObjectValue = function(object, list, p)
	if table.find(list, object) ~= nil then
		return "[Circular]"
	end

	local v = { unpack(list) }
	table.insert(v, object)

	if typeof(object.toJSON) == "function" then
		local json = object:toJSON(object)

		if json ~= object then
			if typeof(json) == "string" then
				return json
			end

			return formatValue(json, v, p)
		end
	elseif isArray(object) then
		return formatArray(object, v, p)
	end

	return formatObject(object, v, p)
end

formatObject = function(list, list2, p)
	local v = ""
	local metatable = getmetatable(list)

	if metatable and rawget(metatable, "__tostring") then
		return (tostring(list))
	end

	local fragmentedKeys, v2, v3 = getFragmentedKeys(list)

	if v3 == 0 and v2 == 0 then
		return v .. "{}"
	end

	if #list2 > p.depth then
		return v .. "[" .. getObjectTag(list) .. "]"
	end

	local v4 = {}

	for i = 1, v3 do
		table.insert(v4, (formatValue(list[i], list2, p)))
	end

	for i = 1, v2 do
		local fragmentedKey = fragmentedKeys[i]
		table.insert(v4, fragmentedKey .. ": " .. formatValue(list[fragmentedKey], list2, p))
	end

	return v .. "{ " .. table.concat(v4, ", ") .. " }"
end

formatArray = function(list, list2, p)
	local count = #list

	if count == 0 then
		return "[]"
	end

	if #list2 > p.depth then
		return "[Array]"
	end

	local v = math.min(10, count)
	local v2 = count - v
	local v3 = {}

	for i = 1, v do
		v3[i] = formatValue(list[i], list2, p)
	end

	if v2 == 1 then
		table.insert(v3, "... 1 more item")
	elseif v2 > 1 then
		table.insert(v3, ("... %s more items"):format((tostring(v2))))
	end

	return "[" .. table.concat(v3, ", ") .. "]"
end

getObjectTag = function(_): string
	return "Object"
end

return inspect
