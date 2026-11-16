local parent = script.Parent.Parent.Parent
local language = parent.language
local jsutils = parent.jsutils

local instanceOf = require(jsutils.instanceOf)
local keyMap = require(jsutils.keyMap)
local keyMap2 = keyMap.keyMap
local inspect = require(jsutils.inspect)
local inspect2 = inspect.inspect
local didYouMean = require(jsutils.didYouMean)
local didYouMean2 = didYouMean.didYouMean
local suggestionList = require(jsutils.suggestionList)
local suggestionList2 = suggestionList.suggestionList
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

local printer = require(language.printer)
local Print = printer.print
local definition = require(parent.type.definition)
local isLeafType = definition.isLeafType
local isInputObjectType = definition.isInputObjectType
local isListType = definition.isListType
local isNonNullType = definition.isNonNullType
local isRequiredInputField = definition.isRequiredInputField
local getNullableType = definition.getNullableType
local getNamedType = definition.getNamedType

local isValidValueNode
local ValuesOfCorrectTypeRule = {
	ValuesOfCorrectTypeRule = function(object)
		return {
			ListValue = function(_, p)
				if isListType((getNullableType(object:getParentInputType()))) then
					return
				end

				isValidValueNode(object, p)
				return false
			end,
			ObjectValue = function(_, p)
				local namedType = getNamedType(object:getInputType())

				if not isInputObjectType(namedType) then
					isValidValueNode(object, p)
					return false
				end

				local v = keyMap2(p.fields, function(p2)
					return p2.name.value
				end)

				for _, v2 in ipairs(namedType:getFields():values()) do
					if v[v2.name] or not isRequiredInputField(v2) then
						continue
					end

					local v3 = inspect2(v2.type)
					object:reportError(graphQLError.new(
						("Field \"%s.%s\" of required type \"%s\" was not provided."):format(
							namedType.name,
							v2.name,
							v3
						),
						p
					))
				end
			end,
			ObjectField = function(_, p)
				local namedType = getNamedType(object:getParentInputType())

				if not object:getInputType() and isInputObjectType(namedType) then
					local v = suggestionList2(p.name.value, namedType:getFields():keys())

					object:reportError(graphQLError.new(
						("Field \"%s\" is not defined by type \"%s\"."):format(p.name.value, namedType.name) .. didYouMean2(v),
						p
					))
				end
			end,
			NullValue = function(_, p)
				local inputType = object:getInputType()

				if isNonNullType(inputType) then
					object:reportError(graphQLError.new(
						("Expected value of type \"%s\", found %s."):format(inspect2(inputType), Print(p)),
						p
					))
				end
			end,
			EnumValue = function(_, p)
				return isValidValueNode(object, p)
			end,
			IntValue = function(_, p)
				return isValidValueNode(object, p)
			end,
			FloatValue = function(_, p)
				return isValidValueNode(object, p)
			end,
			StringValue = function(_, p)
				return isValidValueNode(object, p)
			end,
			BooleanValue = function(_, p)
				return isValidValueNode(object, p)
			end
		}
	end
}

isValidValueNode = function(object, p)
	local inputType = object:getInputType()

	if not inputType then
		return
	end

	local namedType = getNamedType(inputType)

	if isLeafType(namedType) then
		xpcall(function()
			if namedType:parseLiteral(p, nil) == nil then
				local v = inspect2(inputType)

				object:reportError(graphQLError.new(("Expected value of type \"%s\", found %s."):format(v, Print(p)), p))
			end
		end, function(p2)
			local v = inspect2(inputType)

			if instanceOf(p2, graphQLError) then
				object:reportError(p2)
			else
				object:reportError(graphQLError.new(
					("Expected value of type \"%s\", found %s; "):format(v, Print(p)) .. p2.message,
					p,
					nil,
					nil,
					nil,
					p2
				))
			end
		end)
		return
	end

	local v = inspect2(inputType)
	object:reportError(graphQLError.new(("Expected value of type \"%s\", found %s."):format(v, Print(p)), p))
end

return ValuesOfCorrectTypeRule
