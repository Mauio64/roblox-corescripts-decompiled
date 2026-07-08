local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local jsutils = ParentParent.jsutils
local luaUtils = ParentParent.luaUtils
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local inspect = require(jsutils.inspect).inspect
local invariant = require(jsutils.invariant).invariant
local didYouMean = require(jsutils.didYouMean).didYouMean
local isObjectLike = require(jsutils.isObjectLike).isObjectLike
local suggestionList = require(jsutils.suggestionList).suggestionList
local printPathArray = require(jsutils.printPathArray).printPathArray
local addPath = require(jsutils.Path).addPath
local instanceOf = require(jsutils.instanceOf)
local null = require(luaUtils.null)
local isNillish = require(luaUtils.isNillish)
local isNillish2 = isNillish.isNillish
local isNotNillish = isNillish.isNotNillish
local pathToArray = require(jsutils.Path).pathToArray
local isIteratableObject = require(jsutils.isIteratableObject).isIteratableObject
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local definition = require(ParentParent.type.definition)
local isLeafType = definition.isLeafType
local isInputObjectType = definition.isInputObjectType
local isListType = definition.isListType
local isNonNullType = definition.isNonNullType
local coerceInputValueImpl = nil

local function defaultOnError(p1, p2, p3) -- line: 60
	-- upvalues: inspect (copy), printPathArray (copy)
	local v37 = "Invalid value " .. inspect(p2)

	if #p1 > 0 then
		v37 ..= " at \"value" .. printPathArray(p1) .. "\""
	end

	p3.message = v37 .. ": " .. p3.message
	error(p3)
end

function coerceInputValueImpl(p4, p5, p6: ((...any) -> ...any), p7) -- line: 69
	-- upvalues: isNonNullType (copy), isNotNillish (copy), coerceInputValueImpl (ref), pathToArray (copy), GraphQLError (copy), inspect (copy), isNillish2 (copy), null (copy), isListType (copy), isIteratableObject (copy), Array (copy), addPath (copy), isInputObjectType (copy), isObjectLike (copy), Object (copy), suggestionList (copy), didYouMean (copy), isLeafType (copy), instanceOf (copy), invariant (copy)
	if isNonNullType(p5) then
		if isNotNillish(p4) then
			return coerceInputValueImpl(p4, p5.ofType, p6, p7)
		end

		p6(pathToArray(p7), p4, GraphQLError.new("Expected non-nullable type \"" .. inspect(p5) .. "\" not to be null."))

		return
	end

	if isNillish2(p4) then
		return null
	end

	if isListType(p5) then
		local ofType = p5.ofType

		if isIteratableObject(p4) then
			return Array.from(p4, function(p8, p9) -- line: 97
				-- upvalues: addPath (copy), p7 (copy), coerceInputValueImpl (ref), ofType (copy), p6 (copy)
				local v56 = addPath(p7, p9, nil)

				return coerceInputValueImpl(p8, ofType, p6, v56)
			end)
		end

		return { coerceInputValueImpl(p4, ofType, p6, p7) }
	end

	if isInputObjectType(p5) then
		if not isObjectLike(p4) then
			p6(pathToArray(p7), p4, GraphQLError.new("Expected type \"" .. p5.name .. "\" to be an object."))

			return
		end

		local t1 = {}
		local v44 = p5:getFields()

		for _, v in ipairs(v44:values()) do
			local v47 = p4[v.name]

			if v47 == nil then
				if v.defaultValue ~= nil then
					t1[v.name] = v.defaultValue
				elseif isNonNullType(v.type) then
					local v48 = inspect(v.type)

					p6(pathToArray(p7), p4, GraphQLError.new("Field \"" .. v.name .. "\" of required type \"" .. v48 .. "\" was not provided."))
				end
			else
				t1[v.name] = coerceInputValueImpl(v47, v.type, p6, addPath(p7, v.name, p5.name))
			end
		end

		for _, v in ipairs(Object.keys(p4)) do
			if not v44:get(v) then
				local v51 = suggestionList(v, p5:getFields():keys())

				p6(pathToArray(p7), p4, GraphQLError.new(("Field \"%s\" is not defined by type \"%s\".%s"):format(v, p5.name, didYouMean(v51))))
			end
		end

		return t1
	end

	if isLeafType(p5) then
		local ok, result = pcall(p5.parseValue, p5, p4)

		if not ok then
			if instanceOf(result, GraphQLError) then
				p6(pathToArray(p7), p4, result)

				return
			end

			p6(pathToArray(p7), p4, GraphQLError.new("Expected type \"" .. p5.name .. "\". " .. result.message, nil, nil, nil, nil, result))

			return
		end

		if result == nil then
			p6(pathToArray(p7), p4, GraphQLError.new(("Expected type \"%s\"."):format(p5.name)))
		end

		return result
	end

	invariant(false, "Unexpected input type: " .. inspect(p5))
end

return {
	coerceInputValue = function(p10, p11, p12: ((...any) -> ...any)?) -- line: 55
		-- upvalues: defaultOnError (ref), coerceInputValueImpl (ref)
		local v33 = p12 or defaultOnError

		return coerceInputValueImpl(p10, p11, v33)
	end
}
