local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/hWZ")
local module2 = require("@luauforge/bundled/hXa")

local formatValue
local formatObjectValue
local formatArray
local formatObject
local getObjectTag

local function find(list, p2)
	for i = 1, #list do
		if list[i] == p2 then
			return i
		end
	end

	return nil
end

local function inspect(p2)
	return formatValue(p2, {})
end

formatValue = function(p2, p3)
	local typeName = typeof(p2)

	if typeName == "string" then
		return HttpService:JSONEncode(p2)
	end

	if typeName == "number" then
		if p2 ~= p2 then
			return "NaN"
		end

		if p2 == 1e999 then
			return "Infinity"
		elseif p2 == -1e999 then
			return "-Infinity"
		end
	elseif typeName == "function" then
		return "[function]"
	elseif typeName == "table" then
		return formatObjectValue(p2, p3)
	end

	return (tostring(p2))
end

formatObjectValue = function(object, list)
	local v5 = nil

	for i = 1, #list do
		if list[i] == object then
			v5 = i
			break
		end
	end

	if v5 ~= nil then
		return "[Circular]"
	end

	local v7 = { unpack(list) }
	table.insert(v7, object)

	if typeof(object.toJSON) == "function" then
		local json = object:toJSON(object)

		if json ~= object then
			if typeof(json) == "string" then
				return json
			end

			return formatValue(json, v7)
		end
	elseif module(object) then
		return formatArray(object, v7)
	end

	return formatObject(object, v7)
end

formatObject = function(object, list)
	local v5 = module2(object)

	if #v5 == 0 then
		return "{}"
	end

	if #list > 3 then
		return "[" .. getObjectTag(object) .. "]"
	end

	local v6 = {}

	for i = 1, #v5 do
		local v7 = v5[i]
		v6[i] = v7 .. ": " .. formatValue(object[v7], list)
	end

	return "{ " .. table.concat(v6, ", ") .. " }"
end

formatArray = function(list, list2)
	local count = #list

	if count == 0 then
		return "[]"
	end

	if #list2 > 3 then
		return "[Array]"
	end

	local v5 = math.min(3, count)
	local v6 = count - v5
	local v7 = {}

	for i = 1, v5 do
		v7[i] = formatValue(list[i], list2)
	end

	if v6 == 1 then
		table.insert(v7, "... 1 more item")
	elseif v6 > 1 then
		table.insert(v7, ("... %s more items"):format(v6))
	end

	return "[" .. table.concat(v7, ", ") .. "]"
end

getObjectTag = function(p2): string
	return "Object"
end

return { inspect = inspect }
