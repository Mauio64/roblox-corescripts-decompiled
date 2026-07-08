local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local t1 = {}
local GraphQL = require(ParentParent.GraphQL)
local getNullableType = GraphQL.getNullableType
local isLeafType = GraphQL.isLeafType
local isListType = GraphQL.isListType
local isInputObjectType = GraphQL.isInputObjectType

require(script.Parent.types)

local function transformInputValue(p1, p2, p3, p4) -- line: 34
	-- upvalues: getNullableType (copy), Boolean (copy), isLeafType (copy), isListType (copy), Array (copy), transformInputValue (copy), isInputObjectType (copy)
	local v16 = if p3 == nil then nil else p3
	local v17 = if p4 == nil then nil else p4

	if p2 == nil then
		return p2
	end

	local v18 = getNullableType(p1)

	if Boolean.toJSBoolean(isLeafType(v18)) then
		if v16 ~= nil then
			return (v16(v18, p2))
		end

		return p2
	end

	if Boolean.toJSBoolean(isListType(v18)) then
		return Array.map(p2, function(p5) -- line: 61
			-- upvalues: transformInputValue (copy), v18 (copy), v16 (copy), v17 (copy)
			return transformInputValue(v18.ofType, p5, v16, v17)
		end)
	end

	if Boolean.toJSBoolean(isInputObjectType(v18)) then
		local v19 = v18:getFields()
		local t2 = {}

		for v21 in p2 do
			local v22 = v19[tostring(v21)]

			if v22 ~= nil then
				t2[tostring(v21)] = transformInputValue(v22.type, p2[tostring(v21)], v16, v17)
			end
		end

		if v17 ~= nil then
			return (v17(v18, t2))
		end

		return t2
	end

	return nil
end

t1.transformInputValue = transformInputValue

function t1.serializeInputValue(p6, p7) -- line: 95
	-- upvalues: transformInputValue (copy)
	return transformInputValue(p6, p7, function(p8, p9) -- line: 96
		local ok, result = pcall(p8.serialize, p8, p9)

		if not ok then
			return p9
		end

		return result
	end)
end
function t1.parseInputValue(p10, p11) -- line: 117
	-- upvalues: transformInputValue (copy)
	return transformInputValue(p10, p11, function(p12, p13) -- line: 118
		local ok, result = pcall(p12.parseValue, p12, p13)

		if not ok then
			return p13
		end

		return result
	end)
end
function t1.parseInputValueLiteral(p14, p15) -- line: 139
	-- upvalues: transformInputValue (copy)
	return transformInputValue(p14, p15, function(p16, p17) -- line: 140
		return p16:parseLiteral(p17, {})
	end)
end

return t1
