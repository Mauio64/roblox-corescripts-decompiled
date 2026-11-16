local HttpService = game:GetService("HttpService")

local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent.Parent.Parent
local LuauPolyfill = require(parent3.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local null = require(parent2.luaUtils.null)

local formatValue
local formatObjectValue
local formatArray
local formatObject
local getObjectTag

local function inspect(p)
	return formatValue(p, {})
end

formatValue = function(p, p2)
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
	end

	if typeName == "function" then
		return "[function]"
	end

	if typeName ~= "table" then
		return (tostring(p))
	end

	if p == null then
		return "null"
	end

	return formatObjectValue(p, p2)
end

formatObjectValue = function(object, list)
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

			return formatValue(json, v)
		end
	elseif Array.isArray(object) then
		return formatArray(object, v)
	end

	return formatObject(object, v)
end

formatObject = function(object, list)
	local keys = Object.keys(object)

	if #keys == 0 then
		return "{}"
	end

	if #list > 2 then
		return "[" .. getObjectTag(object) .. "]"
	end

	local v = {}

	for i = 1, #keys do
		local key = keys[i]
		v[i] = key .. ": " .. formatValue(object[key], list)
	end

	return "{ " .. table.concat(v, ", ") .. " }"
end

formatArray = function(list, list2)
	local count = #list

	if count == 0 then
		return "[]"
	end

	if #list2 > 2 then
		return "[Array]"
	end

	local v = math.min(10, count)
	local v2 = count - v
	local v3 = {}

	for i = 1, v do
		v3[i] = formatValue(list[i], list2)
	end

	if v2 == 1 then
		table.insert(v3, "... 1 more item")
	elseif v2 > 1 then
		table.insert(v3, ("... %d more items"):format(v2))
	end

	return "[" .. table.concat(v3, ", ") .. "]"
end

getObjectTag = function(_): string
	return "Object"
end

return { inspect = inspect }
