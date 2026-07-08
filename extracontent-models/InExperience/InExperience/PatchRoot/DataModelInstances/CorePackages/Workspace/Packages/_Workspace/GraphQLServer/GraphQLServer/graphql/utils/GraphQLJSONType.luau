local Parent = script:FindFirstAncestor("GraphQLServer").Parent
local LuauPolyfill = require(Parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local t1 = {}
local GraphQL = require(Parent.GraphQL)
local GraphQLScalarType = GraphQL.GraphQLScalarType
local Kind = GraphQL.Kind
local print = GraphQL.print
local parseLiteral = nil

local function parseFloat(p1, p2) -- line: 32
	return (tonumber(p1, p2))
end
local function identity(p3) -- line: 36
	return p3
end
local function ensureObject(p4) -- line: 40
	-- upvalues: Boolean (copy), Array (copy), Error (copy)
	if Boolean.toJSBoolean(typeof(p4) ~= "table" or (p4 == nil or Array.isArray(p4))) then
		error(Error.new(("JSONObject cannot represent non-object value: %s"):format((tostring(p4)))))
	end

	return p4
end
local function parseObject(p5, p6, p7) -- line: 47
	-- upvalues: Array (copy), parseLiteral (ref)
	local t2 = {}

	Array.forEach(p6.fields, function(p8) -- line: 49
		-- upvalues: t2 (copy), parseLiteral (ref), p5 (copy), p7 (copy)
		t2[p8.name.value] = parseLiteral(p5, p8.value, p7)
	end)

	return t2
end

function parseLiteral(p9, p10, p11) -- line: 56
	-- upvalues: Kind (copy), Array (copy), parseLiteral (ref), Boolean (copy), Error (copy), print (copy)
	local kind = p10.kind

	if kind == Kind.STRING or kind == Kind.BOOLEAN then
		return p10.value
	end

	if kind == Kind.INT or kind == Kind.FLOAT then
		return (tonumber(p10.value, nil))
	end

	if kind == Kind.OBJECT then
		local t3 = {}

		Array.forEach(p10.fields, function(p12) -- line: 49
			-- upvalues: t3 (copy), parseLiteral (ref), p9 (copy), p11 (copy)
			t3[p12.name.value] = parseLiteral(p9, p12.value, p11)
		end)

		return t3
	end

	if kind == Kind.LIST then
		return Array.map(p10.values, function(p13) -- line: 65
			-- upvalues: parseLiteral (ref), p9 (copy), p11 (copy)
			return parseLiteral(p9, p13, p11)
		end)
	end

	if kind == Kind.NULL then
		return nil
	end

	if kind == Kind.VARIABLE then
		if Boolean.toJSBoolean(p11) then
			return p11[p10.name.value]
		end

		return nil
	end

	error(Error.new(("%s cannot represent value: %s"):format(p9, print(p10))))

	return nil
end

local v16 = GraphQLScalarType.new({
	name = "JSON",
	description = "The `JSON` scalar type represents JSON values as specified by [ECMA-404](http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-404.pdf).",
	specifiedByUrl = "http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-404.pdf",
	serialize = identity,
	parseValue = identity,
	parseLiteral = function(p14, p15) -- line: 86
		-- upvalues: parseLiteral (ref)
		return parseLiteral("JSON", p14, p15)
	end
})

t1.GraphQLJSON = v16
t1.default = v16
t1.GraphQLJSONObject = GraphQLScalarType.new({
	name = "JSONObject",
	description = "The `JSONObject` scalar type represents JSON objects as specified by [ECMA-404](http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-404.pdf).",
	specifiedByUrl = "http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-404.pdf",
	serialize = ensureObject,
	parseValue = ensureObject,
	parseLiteral = function(p16, p17) -- line: 99
		-- upvalues: Kind (copy), Error (copy), print (copy), Array (copy), parseLiteral (ref)
		if p16.kind ~= Kind.OBJECT then
			error(Error.new(("JSONObject cannot represent non-object value: %s"):format(print(p16))))
		end

		local t4 = {}
		local s1 = "JSONObject"

		Array.forEach(p16.fields, function(p18) -- line: 49
			-- upvalues: t4 (copy), parseLiteral (ref), s1 (copy), p17 (copy)
			t4[p18.name.value] = parseLiteral(s1, p18.value, p17)
		end)

		return t4
	end
})

return t1
