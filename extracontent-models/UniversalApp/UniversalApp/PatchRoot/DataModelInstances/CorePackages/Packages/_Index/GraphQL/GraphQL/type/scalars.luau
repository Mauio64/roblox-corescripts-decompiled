local function parseInt(p1, p2) -- line: 8
	return (tonumber(p1, p2))
end
local function NumberisFinite(p3) -- line: 11
	return typeof(p3) == "number" and (p3 ~= 1e999 and p3 == p3)
end

local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Number = LuauPolyfill.Number
local Object = LuauPolyfill.Object

require(script.Parent.Parent.language.ast)

local inspect = require(script.Parent.Parent.jsutils.inspect).inspect
local isObjectLike = require(script.Parent.Parent.jsutils.isObjectLike).isObjectLike
local Kind = require(script.Parent.Parent.language.kinds).Kind
local print = require(script.Parent.Parent.language.printer).print
local GraphQLError = require(script.Parent.Parent.error.GraphQLError).GraphQLError
local GraphQLScalarType = require(script.Parent.definition).GraphQLScalarType
local serializeObject = nil

function serializeInt(p4) -- line: 55
	-- upvalues: serializeObject (ref), Number (copy), GraphQLError (copy), inspect (copy)
	local v29 = serializeObject(p4)

	if typeof(v29) == "boolean" then
		if v29 then
			return 1
		end

		return 0
	end

	local v30 = v29

	if typeof(v29) == "string" and v29 ~= "" then
		v30 = tonumber(v29)
	end

	if typeof(v30) ~= "number" or not Number.isInteger(v30) then
		error(GraphQLError.new(("Int cannot represent non-integer value: %s"):format(inspect(v29))))
	end

	if v30 > 2147483647 or v30 < -2147483648 then
		error(GraphQLError.new("Int cannot represent non 32-bit signed integer value: " .. inspect(v29)))
	end

	return v30
end
function coerceInt(p5) -- line: 84
	-- upvalues: Number (copy), GraphQLError (copy), inspect (copy)
	if typeof(p5) ~= "number" or not Number.isInteger(p5) then
		error(GraphQLError.new(("Int cannot represent non-integer value: %s"):format(inspect(p5))))
	end

	if p5 > 2147483647 or p5 < -2147483648 then
		error(GraphQLError.new(("Int cannot represent non 32-bit signed integer value: %s"):format(p5)))
	end

	return p5
end

local v15 = GraphQLScalarType.new({
	name = "Int",
	description = "The `Int` scalar type represents non-fractional signed whole numeric values. Int can represent values between -(2^31) and 2^31 - 1.",
	serialize = serializeInt,
	parseValue = coerceInt,
	parseLiteral = function(p6) -- line: 110
		-- upvalues: Kind (copy), GraphQLError (copy), print (copy)
		if p6.kind ~= Kind.INT then
			error(GraphQLError.new(("Int cannot represent non-integer value: %s"):format(print(p6)), p6))
		end

		local num = tonumber(p6.value, 10)

		if num > 2147483647 or num < -2147483648 then
			error(GraphQLError.new(("Int cannot represent non 32-bit signed integer value: %s"):format(p6.value), p6))
		end

		return num
	end
})

local function serializeFloat(p7) -- line: 139
	-- upvalues: serializeObject (ref), GraphQLError (copy), inspect (copy)
	local v35 = serializeObject(p7)

	if typeof(v35) == "boolean" then
		if v35 then
			return 1
		end

		return 0
	end

	local v36 = v35

	if typeof(v35) == "string" and v35 ~= "" then
		v36 = tonumber(v35)
	end

	if typeof(v36) == "number" then
		if typeof(v36) == "number" and (v36 ~= 1e999 and v36 == v36) then
			return v36
		end
	end

	error(GraphQLError.new(("Float cannot represent non numeric value: %s"):format(inspect(v35))))

	return v36
end

function coerceFloat(p8) -- line: 161
	-- upvalues: GraphQLError (copy), inspect (copy)
	if typeof(p8) ~= "number" or (typeof(p8) ~= "number" or (p8 == 1e999 or p8 ~= p8)) then
		error(GraphQLError.new(("Float cannot represent non numeric value: %s"):format(inspect(p8))))
	end

	return p8
end

local v17 = GraphQLScalarType.new({
	name = "Float",
	description = "The `Float` scalar type represents signed double-precision fractional values as specified by [IEEE 754](https://en.wikipedia.org/wiki/IEEE_floating_point).",
	serialize = serializeFloat,
	parseValue = coerceFloat,
	parseLiteral = function(p9) -- line: 178
		-- upvalues: Kind (copy), GraphQLError (copy), print (copy)
		if p9.kind ~= Kind.FLOAT and p9.kind ~= Kind.INT then
			error(GraphQLError.new(("Float cannot represent non numeric value: %s"):format(print(p9)), p9))
		end

		return (tonumber(p9.value, nil))
	end
})

function serializeObject(p10) -- line: 197
	-- upvalues: isObjectLike (copy)
	if isObjectLike(p10) then
		if typeof(p10.valueOf) == "function" then
			local v40 = p10:valueOf()

			if not isObjectLike(v40) then
				return v40
			end
		end

		if typeof(p10.toJSON) == "function" then
			return p10:toJSON()
		end
	end

	return p10
end

local function serializeString(p11) -- line: 214
	-- upvalues: serializeObject (ref), GraphQLError (copy), inspect (copy)
	local v42 = serializeObject(p11)

	if typeof(v42) == "string" then
		return v42
	end

	if typeof(v42) == "boolean" then
		if v42 then
			return "true"
		end

		return "false"
	end

	if typeof(v42) == "number" and (typeof(v42) == "number" and (v42 ~= 1e999 and v42 == v42)) then
		return (tostring(v42))
	end

	error(GraphQLError.new(("String cannot represent value: %s"):format(inspect(p11))))
end

function coerceString(p12) -- line: 231
	-- upvalues: GraphQLError (copy), inspect (copy)
	if typeof(p12) ~= "string" then
		error(GraphQLError.new(("String cannot represent a non string value: %s"):format(inspect(p12))))
	end

	return p12
end

local v19 = GraphQLScalarType.new({
	name = "String",
	description = "The `String` scalar type represents textual data, represented as UTF-8 character sequences. The String type is most often used by GraphQL to represent free-form human-readable text.",
	serialize = serializeString,
	parseValue = coerceString,
	parseLiteral = function(p13) -- line: 248
		-- upvalues: Kind (copy), GraphQLError (copy), print (copy)
		if p13.kind ~= Kind.STRING then
			error(GraphQLError.new(("String cannot represent a non string value: %s"):format(print(p13)), p13))
		end

		return p13.value
	end
})

local function serializeBoolean(p14) -- line: 263
	-- upvalues: serializeObject (ref), GraphQLError (copy), inspect (copy)
	local v46 = serializeObject(p14)

	if typeof(v46) == "boolean" then
		return v46
	end

	if typeof(v46) == "number" and (v46 ~= 1e999 and v46 == v46) then
		return v46 ~= 0
	end

	error(GraphQLError.new(("Boolean cannot represent a non boolean value: %s"):format(inspect(v46))))
end

function coerceBoolean(p15) -- line: 281
	-- upvalues: GraphQLError (copy), inspect (copy)
	if typeof(p15) ~= "boolean" then
		error(GraphQLError.new(("Boolean cannot represent a non boolean value: %s"):format(inspect(p15))))
	end

	return p15
end

local v21 = GraphQLScalarType.new({
	name = "Boolean",
	description = "The `Boolean` scalar type represents `true` or `false`.",
	serialize = serializeBoolean,
	parseValue = coerceBoolean,
	parseLiteral = function(p16) -- line: 298
		-- upvalues: Kind (copy), GraphQLError (copy), print (copy)
		if p16.kind ~= Kind.BOOLEAN then
			error(GraphQLError.new(("Boolean cannot represent a non boolean value: %s"):format(print(p16)), p16))
		end

		return p16.value
	end
})

local function serializeID(p17) -- line: 313
	-- upvalues: serializeObject (ref), Number (copy), GraphQLError (copy), inspect (copy)
	local v50 = serializeObject(p17)

	if typeof(v50) == "string" then
		return v50
	end

	if Number.isInteger(v50) then
		return (tostring(v50))
	end

	error(GraphQLError.new(("ID cannot represent value: %s"):format(inspect(p17))))
end

function coerceID(p18) -- line: 326
	-- upvalues: Number (copy), GraphQLError (copy), inspect (copy)
	if typeof(p18) == "string" then
		return p18
	end

	if typeof(p18) == "number" and Number.isInteger(p18) then
		return (tostring(p18))
	end

	error(GraphQLError.new(("ID cannot represent value: %s"):format(inspect(p18))))
end

local v23 = GraphQLScalarType.new({
	name = "ID",
	description = "The `ID` scalar type represents a unique identifier, often used to refetch an object or as key for a cache. The ID type appears in a JSON response as a String; however, it is not intended to be human-readable. When expected as an input type, any string (such as `\"4\"`) or integer (such as `4`) input value will be accepted as an ID.",
	serialize = serializeID,
	parseValue = coerceID,
	parseLiteral = function(p19) -- line: 342
		-- upvalues: Kind (copy), GraphQLError (copy), print (copy)
		if p19.kind ~= Kind.STRING and p19.kind ~= Kind.INT then
			error(GraphQLError.new("ID cannot represent a non-string and non-integer value: " .. print(p19), p19))
		end

		return p19.value
	end
})
local v24 = Object.freeze({
	v19,
	v15,
	v17,
	v21,
	v23
})

return {
	GraphQLInt = v15,
	GraphQLFloat = v17,
	GraphQLString = v19,
	GraphQLBoolean = v21,
	GraphQLID = v23,
	specifiedScalarTypes = v24,
	isSpecifiedScalarType = function(p20) -- line: 364
		-- upvalues: Array (copy), v24 (copy)
		return Array.some(v24, function(p21) -- line: 365
			-- upvalues: p20 (copy)
			return p21.name == p20.name
		end)
	end
}
