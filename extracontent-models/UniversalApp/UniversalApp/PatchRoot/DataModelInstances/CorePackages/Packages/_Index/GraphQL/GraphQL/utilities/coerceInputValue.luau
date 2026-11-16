local parent = script.Parent.Parent
local parent2 = parent.Parent
local jsutils = parent.jsutils
local luaUtils = parent.luaUtils

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array

local Object = LuauPolyfill.Object

local inspect = require(jsutils.inspect)
local inspect2 = inspect.inspect
local invariant = require(jsutils.invariant)
local invariant2 = invariant.invariant
local didYouMean = require(jsutils.didYouMean)
local didYouMean2 = didYouMean.didYouMean
local isObjectLike = require(jsutils.isObjectLike)
local isObjectLike2 = isObjectLike.isObjectLike
local suggestionList = require(jsutils.suggestionList)
local suggestionList2 = suggestionList.suggestionList
local printPathArray = require(jsutils.printPathArray)
local printPathArray2 = printPathArray.printPathArray
local Path = require(jsutils.Path)
local addPath = Path.addPath

local instanceOf = require(jsutils.instanceOf)
local null = require(luaUtils.null)
local isNillish = require(luaUtils.isNillish)
local isNillish2 = isNillish.isNillish
local isNotNillish = isNillish.isNotNillish

local Path2 = require(jsutils.Path)
local pathToArray = Path2.pathToArray
local isIteratableObject = require(jsutils.isIteratableObject)
local isIteratableObject2 = isIteratableObject.isIteratableObject
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

local definition = require(parent.type.definition)

local isLeafType = definition.isLeafType
local isInputObjectType = definition.isInputObjectType
local isListType = definition.isListType
local isNonNullType = definition.isNonNullType

local coerceInputValueImpl
local defaultOnError

local function coerceInputValue(p, p2, callback)
	return coerceInputValueImpl(p, p2, callback or defaultOnError)
end

defaultOnError = function(list, p, message)
	local v = "Invalid value " .. inspect2(p)

	if #list > 0 then
		v ..= " at \"value" .. printPathArray2(list) .. "\""
	end

	message.message = v .. ": " .. message.message
	error(message)
end

coerceInputValueImpl = function(p, object, callback, p2)
	if isNonNullType(object) then
		if isNotNillish(p) then
			return coerceInputValueImpl(p, object.ofType, callback, p2)
		end

		callback(
			pathToArray(p2),
			p,
			graphQLError.new("Expected non-nullable type \"" .. inspect2(object) .. "\" not to be null.")
		)
	else
		if isNillish2(p) then
			return null
		end

		if isListType(object) then
			local ofType = object.ofType

			if isIteratableObject2(p) then
				return Array.from(p, function(p3, p4)
					local v = addPath(p2, p4, nil)
					return coerceInputValueImpl(p3, ofType, callback, v)
				end)
			end

			return { coerceInputValueImpl(p, ofType, callback, p2) }
		elseif isInputObjectType(object) then
			if not isObjectLike2(p) then
				callback(
					pathToArray(p2),
					p,
					graphQLError.new("Expected type \"" .. object.name .. "\" to be an object.")
				)

				return
			end

			local fields = object:getFields()
			local result = {}

			for _, v in ipairs(fields:values()) do
				local v2 = p[v.name]

				if v2 == nil then
					if v.defaultValue == nil then
						if isNonNullType(v.type) then
							local v3 = inspect2(v.type)
							callback(
								pathToArray(p2),
								p,
								graphQLError.new("Field \"" .. v.name .. "\" of required type \"" .. v3 .. "\" was not provided.")
							)
						end
					else
						result[v.name] = v.defaultValue
					end
				else
					result[v.name] = coerceInputValueImpl(v2, v.type, callback, addPath(p2, v.name, object.name))
				end
			end

			for _, v in ipairs(Object.keys(p)) do
				if fields:get(v) then
					continue
				end

				local v2 = suggestionList2(v, object:getFields():keys())
				callback(
					pathToArray(p2),
					p,
					graphQLError.new(("Field \"%s\" is not defined by type \"%s\".%s"):format(
						v,
						object.name,
						didYouMean2(v2)
					))
				)
			end

			return result
		else
			if not isLeafType(object) then
				invariant2(false, "Unexpected input type: " .. inspect2(object))
				return
			end

			local success, result = pcall(object.parseValue, object, p)

			if success then
				if result == nil then
					callback(pathToArray(p2), p, graphQLError.new(("Expected type \"%s\"."):format(object.name)))
				end

				return result
			elseif instanceOf(result, graphQLError) then
				callback(pathToArray(p2), p, result)
			else
				callback(
					pathToArray(p2),
					p,
					graphQLError.new(
						"Expected type \"" .. object.name .. "\". " .. result.message,
						nil,
						nil,
						nil,
						nil,
						result
					)
				)
			end
		end
	end
end

return { coerceInputValue = coerceInputValue }
