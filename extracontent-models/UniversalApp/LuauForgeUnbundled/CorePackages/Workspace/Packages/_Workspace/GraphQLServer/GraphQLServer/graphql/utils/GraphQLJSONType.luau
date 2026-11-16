local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill")
local array = LuauPolyfill.Array
local boolean = LuauPolyfill.Boolean
local err = LuauPolyfill.Error

local GraphQL = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQL")
local graphQLScalarType = GraphQL.GraphQLScalarType

local kind = GraphQL.Kind
local Print = GraphQL.print

local parseLiteral

local function parseFloat(p2, p3)
	return (tonumber(p2, p3))
end

local function identity(p2)
	return p2
end

local function ensureObject(p2)
	if boolean.toJSBoolean(typeof(p2) ~= "table" or p2 == nil or array.isArray(p2)) then
		error(err.new(("JSONObject cannot represent non-object value: %s"):format((tostring(p2)))))
	end

	return p2
end

local function parseObject(p2, p3, p4)
	local object = {}
	array.forEach(p3.fields, function(p5)
		object[p5.name.value] = parseLiteral(p2, p5.value, p4)
	end)
	return object
end

parseLiteral = function(p2, data, p3)
	local kind2 = data.kind

	if kind2 == kind.STRING or kind2 == kind.BOOLEAN then
		return data.value
	end

	if kind2 == kind.INT or kind2 == kind.FLOAT then
		return (tonumber(data.value, nil))
	end

	if kind2 == kind.OBJECT then
		local v6 = {}
		array.forEach(data.fields, function(p4)
			v6[p4.name.value] = parseLiteral(p2, p4.value, p3)
		end)
		return v6
	end

	if kind2 == kind.LIST then
		return array.map(data.values, function(p4)
			return parseLiteral(p2, p4, p3)
		end)
	end

	if kind2 == kind.NULL then
		return nil
	end

	if kind2 ~= kind.VARIABLE then
		error(err.new(("%s cannot represent value: %s"):format(p2, Print(data))))
		return nil
	end

	if boolean.toJSBoolean(p3) then
		return p3[data.name.value]
	end

	return nil
end

local v6 = graphQLScalarType.new({
	name = "JSON",
	description = "The `JSON` scalar type represents JSON values as specified by [ECMA-404](http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-404.pdf).",
	specifiedByUrl = "http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-404.pdf",
	serialize = identity,
	parseValue = identity,
	parseLiteral = function(p2, p3)
		return parseLiteral("JSON", p2, p3)
	end
})
return {
	["GraphQLJSON"] = v6,
	default = v6,
	GraphQLJSONObject = graphQLScalarType.new({
		name = "JSONObject",
		description = "The `JSONObject` scalar type represents JSON objects as specified by [ECMA-404](http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-404.pdf).",
		specifiedByUrl = "http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-404.pdf",
		serialize = ensureObject,
		parseValue = ensureObject,
		parseLiteral = function(p2, p3)
			if p2.kind ~= kind.OBJECT then
				error(err.new(("JSONObject cannot represent non-object value: %s"):format(Print(p2))))
			end

			local literal = {}
			local v7 = "JSONObject"
			array.forEach(p2.fields, function(p4)
				literal[p4.name.value] = parseLiteral(v7, p4.value, p3)
			end)
			return literal
		end
	})
}
