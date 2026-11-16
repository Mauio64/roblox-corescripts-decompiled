local parent = script:FindFirstAncestor("GraphQLServer").Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error

local GraphQL = require(parent.GraphQL)
local GraphQLScalarType = GraphQL.GraphQLScalarType

local Kind = GraphQL.Kind
local Print = GraphQL.print

local parseLiteral

local function parseFloat(value, p) -- 1 equivalent call inferred from this helper
	return (tonumber(value, p))
end

local function identity(p)
	return p
end

local function ensureObject(p)
	if Boolean.toJSBoolean(typeof(p) ~= "table" or p == nil or Array.isArray(p)) then
		error(Error.new(("JSONObject cannot represent non-object value: %s"):format((tostring(p)))))
	end

	return p
end

local function parseObject(p, p2, p3) -- 2 equivalent calls inferred from this helper
	local object = {}
	Array.forEach(p2.fields, function(p4)
		object[p4.name.value] = parseLiteral(p, p4.value, p3)
	end)
	return object
end

parseLiteral = function(p, data, p2)
	local kind = data.kind

	if kind == Kind.STRING or kind == Kind.BOOLEAN then
		return data.value
	end

	if kind == Kind.INT or kind == Kind.FLOAT then
		return parseFloat(data.value) -- inferred equivalent call
	end

	if kind == Kind.OBJECT then
		return parseObject(p, data, p2) -- inferred equivalent call
	end

	if kind == Kind.LIST then
		return Array.map(data.values, function(p3)
			return parseLiteral(p, p3, p2)
		end)
	end

	if kind == Kind.NULL then
		return nil
	end

	if kind ~= Kind.VARIABLE then
		error(Error.new(("%s cannot represent value: %s"):format(p, Print(data))))
		return nil
	end

	if Boolean.toJSBoolean(p2) then
		return p2[data.name.value]
	end

	return nil
end

local v = GraphQLScalarType.new({
	name = "JSON",
	description = "The `JSON` scalar type represents JSON values as specified by [ECMA-404](http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-404.pdf).",
	specifiedByUrl = "http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-404.pdf",
	serialize = identity,
	parseValue = identity,
	parseLiteral = function(p, p2)
		return parseLiteral("JSON", p, p2)
	end
})
return {
	["GraphQLJSON"] = v,
	default = v,
	GraphQLJSONObject = GraphQLScalarType.new({
		name = "JSONObject",
		description = "The `JSONObject` scalar type represents JSON objects as specified by [ECMA-404](http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-404.pdf).",
		specifiedByUrl = "http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-404.pdf",
		serialize = ensureObject,
		parseValue = ensureObject,
		parseLiteral = function(p, p2)
			if p.kind ~= Kind.OBJECT then
				error(Error.new(("JSONObject cannot represent non-object value: %s"):format(Print(p))))
			end

			return parseObject("JSONObject", p, p2) -- inferred equivalent call
		end
	})
}
