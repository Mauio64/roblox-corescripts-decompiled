local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local instanceof = LuauPolyfill.instanceof

local Error = LuauPolyfill.Error

local formatValue
local formatObjectValue
local formatArray
local isJSONable
local formatObject
local getObjectTag

local GraphQL = require(parent.GraphQL)
local GraphQLError = GraphQL.GraphQLError

local AggregateError = require(script.Parent.AggregateError)
local isAggregateError = AggregateError.isAggregateError
local Inspect = {
	inspect = function(p)
		return formatValue(p, {})
	end
}

formatValue = function(p, p2)
	local typeName = typeof(p)

	if typeName == "string" then
		return "\"" .. p .. "\""
	end

	if typeName == "function" then
		local v = debug.info(p, "n")

		if Boolean.toJSBoolean(v) then
			return (("[function %s]"):format(v))
		end

		return "[function]"
	elseif typeName == "table" then
		return formatObjectValue(p, p2)
	else
		return (tostring(p))
	end
end

local function formatError(object)
	if instanceof(object, GraphQLError) then
		return (tostring(object))
	end

	return ("%s: %s;\n %s"):format(tostring(object.name), tostring(object.message), (tostring(object.stack)))
end

formatObjectValue = function(object, p)
	if object == nil then
		return "null"
	end

	if instanceof(object, Error) then
		if not isAggregateError(object) then
			return formatError(object)
		end

		local v

		if instanceof(object, GraphQLError) then
			v = tostring(object)
		else
			v = ("%s: %s;\n %s"):format(tostring(object.name), tostring(object.message), (tostring(object.stack)))
		end

		return v .. "\n" .. formatArray(object.errors, p)
	else
		if Boolean.toJSBoolean(Array.includes(p, object)) then
			return "[Circular]"
		end

		local joined = Array.concat({}, p, { object })

		if Boolean.toJSBoolean(isJSONable(object)) then
			local json = object:toJSON()

			if json ~= object then
				if typeof(json) == "string" then
					return json
				end

				return (formatValue(json, joined))
			end
		elseif Boolean.toJSBoolean(Array.isArray(object)) then
			return formatArray(object, joined)
		end

		return formatObject(object, joined)
	end
end

isJSONable = function(object): boolean
	return typeof(object.toJSON) == "function"
end

formatObject = function(object, joined)
	local entries = Object.entries(object)

	if #entries == 0 then
		return "{}"
	end

	if #joined > 3 then
		return "[" .. tostring(getObjectTag(object)) .. "]"
	end

	local mapped = Array.map(entries, function(list)
		local v, v2 = table.unpack(list, 1, 2)
		return tostring(v) .. ": " .. tostring(formatValue(v2, joined))
	end)

	return "{ " .. tostring(Array.join(mapped, ", ")) .. " }"
end

formatArray = function(list, list2)
	if #list == 0 then
		return "[]"
	end

	if #list2 > 3 then
		return "[Array]"
	end

	local v = #list
	local count = #list
	local v2 = 1
	local v3 = {}

	while v2 <= v do
		table.insert(v3, formatValue(list[v2], list2))

		v2 += 1
	end

	if count == 1 then
		table.insert(v3, "... 1 more item")
	elseif count > 1 then
		table.insert(v3, ("... %s more items"):format((tostring(count))))
	end

	return "[" .. tostring(Array.join(v3, ", ")) .. "]"
end

getObjectTag = function(_): string
	return "Object"
end

return Inspect
