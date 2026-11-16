local function parseInt(value, p) -- 2 equivalent calls inferred from this helper
	return (tonumber(value, p))
end

local function NumberisFinite(value): boolean -- 4 equivalent calls inferred from this helper
	return typeof(value) == "number" and value ~= 1e999 and value == value
end

local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

local Number = LuauPolyfill.Number
local Object = LuauPolyfill.Object

require(script.Parent.Parent.language.ast)

local inspect = require(script.Parent.Parent.jsutils.inspect)
local inspect2 = inspect.inspect
local isObjectLike = require(script.Parent.Parent.jsutils.isObjectLike)
local isObjectLike2 = isObjectLike.isObjectLike
local kinds = require(script.Parent.Parent.language.kinds)
local kind = kinds.Kind
local printer = require(script.Parent.Parent.language.printer)
local Print = printer.print
local GraphQLError = require(script.Parent.Parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

local definition = require(script.Parent.definition)

local graphQLScalarType = definition.GraphQLScalarType

local serializeObject

function serializeInt(p)
	local v = serializeObject(p)

	if typeof(v) == "boolean" then
		return if v then 1 else 0
	else
		local v2

		if typeof(v) == "string" and v ~= "" then
			v2 = tonumber(v)
		else
			v2 = v
		end

		if typeof(v2) ~= "number" or not Number.isInteger(v2) then
			error(graphQLError.new(("Int cannot represent non-integer value: %s"):format(inspect2(v))))
		end

		if v2 > 2147483647 or v2 < -2147483648 then
			error(graphQLError.new("Int cannot represent non 32-bit signed integer value: " .. inspect2(v)))
		end

		return v2
	end
end

function coerceInt(value)
	if typeof(value) ~= "number" or not Number.isInteger(value) then
		error(graphQLError.new(("Int cannot represent non-integer value: %s"):format(inspect2(value))))
	end

	if value > 2147483647 or value < -2147483648 then
		error(graphQLError.new(("Int cannot represent non 32-bit signed integer value: %s"):format(value)))
	end

	return value
end

local graphQLInt = graphQLScalarType.new({
	name = "Int",
	description = "The `Int` scalar type represents non-fractional signed whole numeric values. Int can represent values between -(2^31) and 2^31 - 1.",
	serialize = serializeInt,
	parseValue = coerceInt,
	parseLiteral = function(p)
		if p.kind ~= kind.INT then
			error(graphQLError.new(("Int cannot represent non-integer value: %s"):format(Print(p)), p))
		end

		local literal = parseInt(p.value, 10) -- inferred equivalent call

		if literal > 2147483647 or literal < -2147483648 then
			error(graphQLError.new(("Int cannot represent non 32-bit signed integer value: %s"):format(p.value), p))
		end

		return literal
	end
})

local function serializeFloat(p)
	local v = serializeObject(p)

	if typeof(v) == "boolean" then
		return if v then 1 else 0
	else
		local v2

		if typeof(v) == "string" and v ~= "" then
			v2 = tonumber(v)
		else
			v2 = v
		end

		if typeof(v2) == "number" then
			if not NumberisFinite(v2) then -- inferred equivalent call
				error(graphQLError.new(("Float cannot represent non numeric value: %s"):format(inspect2(v))))
			end
		else
			error(graphQLError.new(("Float cannot represent non numeric value: %s"):format(inspect2(v))))
		end

		return v2
	end
end

function coerceFloat(value)
	if typeof(value) == "number" then
		if not NumberisFinite(value) then -- inferred equivalent call
			error(graphQLError.new(("Float cannot represent non numeric value: %s"):format(inspect2(value))))
		end
	else
		error(graphQLError.new(("Float cannot represent non numeric value: %s"):format(inspect2(value))))
	end

	return value
end

local graphQLFloat = graphQLScalarType.new({
	name = "Float",
	description = "The `Float` scalar type represents signed double-precision fractional values as specified by [IEEE 754](https://en.wikipedia.org/wiki/IEEE_floating_point).",
	serialize = serializeFloat,
	parseValue = coerceFloat,
	parseLiteral = function(p)
		if p.kind ~= kind.FLOAT and p.kind ~= kind.INT then
			error(graphQLError.new(("Float cannot represent non numeric value: %s"):format(Print(p)), p))
		end

		return parseInt(p.value) -- inferred equivalent call
	end
})

serializeObject = function(object)
	if not isObjectLike2(object) then
		return object
	end

	if typeof(object.valueOf) == "function" then
		local value = object:valueOf()

		if not isObjectLike2(value) then
			return value
		end
	end

	if typeof(object.toJSON) == "function" then
		return object:toJSON()
	end

	return object
end

local function serializeString(p)
	local v = serializeObject(p)

	if typeof(v) == "string" then
		return v
	end

	if typeof(v) == "boolean" then
		return if v then "true" else "false"
	end

	if typeof(v) == "number" and NumberisFinite(v) then -- inferred equivalent call
		return (tostring(v))
	end

	error(graphQLError.new(("String cannot represent value: %s"):format(inspect2(p))))
end
function coerceString(value)
	if typeof(value) ~= "string" then
		error(graphQLError.new(("String cannot represent a non string value: %s"):format(inspect2(value))))
	end

	return value
end

local graphQLString = graphQLScalarType.new({
	name = "String",
	description = "The `String` scalar type represents textual data, represented as UTF-8 character sequences. The String type is most often used by GraphQL to represent free-form human-readable text.",
	serialize = serializeString,
	parseValue = coerceString,
	parseLiteral = function(p)
		if p.kind ~= kind.STRING then
			error(graphQLError.new(("String cannot represent a non string value: %s"):format(Print(p)), p))
		end

		return p.value
	end
})

local function serializeBoolean(p)
	local v = serializeObject(p)

	if typeof(v) == "boolean" then
		return v
	end

	if NumberisFinite(v) then -- inferred equivalent call
		return v ~= 0
	end

	error(graphQLError.new(("Boolean cannot represent a non boolean value: %s"):format(inspect2(v))))
end

function coerceBoolean(p)
	if typeof(p) ~= "boolean" then
		error(graphQLError.new(("Boolean cannot represent a non boolean value: %s"):format(inspect2(p))))
	end

	return p
end

local graphQLBoolean = graphQLScalarType.new({
	name = "Boolean",
	description = "The `Boolean` scalar type represents `true` or `false`.",
	serialize = serializeBoolean,
	parseValue = coerceBoolean,
	parseLiteral = function(p)
		if p.kind ~= kind.BOOLEAN then
			error(graphQLError.new(("Boolean cannot represent a non boolean value: %s"):format(Print(p)), p))
		end

		return p.value
	end
})

local function serializeID(p)
	local v = serializeObject(p)

	if typeof(v) == "string" then
		return v
	end

	if Number.isInteger(v) then
		return (tostring(v))
	end

	error(graphQLError.new(("ID cannot represent value: %s"):format(inspect2(p))))
end

function coerceID(value)
	if typeof(value) == "string" then
		return value
	end

	if typeof(value) == "number" and Number.isInteger(value) then
		return (tostring(value))
	end

	error(graphQLError.new(("ID cannot represent value: %s"):format(inspect2(value))))
end

local graphQLID = graphQLScalarType.new({
	name = "ID",
	description = "The `ID` scalar type represents a unique identifier, often used to refetch an object or as key for a cache. The ID type appears in a JSON response as a String; however, it is not intended to be human-readable. When expected as an input type, any string (such as `\"4\"`) or integer (such as `4`) input value will be accepted as an ID.",
	serialize = serializeID,
	parseValue = coerceID,
	parseLiteral = function(p)
		if p.kind ~= kind.STRING and p.kind ~= kind.INT then
			error(graphQLError.new("ID cannot represent a non-string and non-integer value: " .. Print(p), p))
		end

		return p.value
	end
})

local frozen = Object.freeze({ graphQLString, graphQLInt, graphQLFloat, graphQLBoolean, graphQLID })

return {
	GraphQLInt = graphQLInt,
	GraphQLFloat = graphQLFloat,
	GraphQLString = graphQLString,
	GraphQLBoolean = graphQLBoolean,
	GraphQLID = graphQLID,
	specifiedScalarTypes = frozen,
	isSpecifiedScalarType = function(p)
		return Array.some(frozen, function(p2): boolean
			local name = p2.name
			return p.name == name
		end)
	end
}
