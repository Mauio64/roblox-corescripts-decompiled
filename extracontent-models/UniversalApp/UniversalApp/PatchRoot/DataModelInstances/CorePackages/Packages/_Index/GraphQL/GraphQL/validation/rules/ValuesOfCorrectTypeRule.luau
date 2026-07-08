local ParentParent = script.Parent.Parent.Parent
local language = ParentParent.language
local jsutils = ParentParent.jsutils
local instanceOf = require(jsutils.instanceOf)
local keyMap = require(jsutils.keyMap).keyMap
local inspect = require(jsutils.inspect).inspect
local didYouMean = require(jsutils.didYouMean).didYouMean
local suggestionList = require(jsutils.suggestionList).suggestionList
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local print = require(language.printer).print
local definition = require(ParentParent.type.definition)
local isLeafType = definition.isLeafType
local isInputObjectType = definition.isInputObjectType
local isListType = definition.isListType
local isNonNullType = definition.isNonNullType
local isRequiredInputField = definition.isRequiredInputField
local getNullableType = definition.getNullableType
local getNamedType = definition.getNamedType
local t1 = {}
local isValidValueNode = nil

function t1.ValuesOfCorrectTypeRule(p1) -- line: 41
	-- upvalues: getNullableType (copy), isListType (copy), isValidValueNode (ref), getNamedType (copy), isInputObjectType (copy), keyMap (copy), isRequiredInputField (copy), inspect (copy), GraphQLError (copy), suggestionList (copy), didYouMean (copy), isNonNullType (copy), print (copy)
	return {
		ListValue = function(_, p3) -- line: 43
			-- upvalues: getNullableType (copy), p1 (copy), isListType (copy), isValidValueNode (ref)
			local v29 = getNullableType(p1:getParentInputType())

			if not isListType(v29) then
				isValidValueNode(p1, p3)

				return false
			end
		end,
		ObjectValue = function(_, p5) -- line: 53
			-- upvalues: getNamedType (copy), p1 (copy), isInputObjectType (copy), isValidValueNode (ref), keyMap (copy), isRequiredInputField (copy), inspect (copy), GraphQLError (copy)
			local v32 = getNamedType(p1:getInputType())

			if not isInputObjectType(v32) then
				isValidValueNode(p1, p5)

				return false
			end

			local v33 = keyMap(p5.fields, function(p6) -- line: 60
				return p6.name.value
			end)

			for _, v in ipairs(v32:getFields():values()) do
				if not v33[v.name] and isRequiredInputField(v) then
					local v36 = inspect(v.type)

					p1:reportError(GraphQLError.new(("Field \"%s.%s\" of required type \"%s\" was not provided."):format(v32.name, v.name, v36), p5))
				end
			end
		end,
		ObjectField = function(_, p8) -- line: 82
			-- upvalues: getNamedType (copy), p1 (copy), isInputObjectType (copy), suggestionList (copy), GraphQLError (copy), didYouMean (copy)
			local v39 = getNamedType(p1:getParentInputType())

			if not p1:getInputType() and isInputObjectType(v39) then
				local v40 = suggestionList(p8.name.value, v39:getFields():keys())

				p1:reportError(GraphQLError.new(("Field \"%s\" is not defined by type \"%s\"."):format(p8.name.value, v39.name) .. didYouMean(v40), p8))
			end
		end,
		NullValue = function(_, p10) -- line: 102
			-- upvalues: p1 (copy), isNonNullType (copy), GraphQLError (copy), inspect (copy), print (copy)
			local v43 = p1:getInputType()

			if isNonNullType(v43) then
				p1:reportError(GraphQLError.new(("Expected value of type \"%s\", found %s."):format(inspect(v43), print(p10)), p10))
			end
		end,
		EnumValue = function(_, p12) -- line: 116
			-- upvalues: isValidValueNode (ref), p1 (copy)
			return isValidValueNode(p1, p12)
		end,
		IntValue = function(_, p14) -- line: 119
			-- upvalues: isValidValueNode (ref), p1 (copy)
			return isValidValueNode(p1, p14)
		end,
		FloatValue = function(_, p16) -- line: 122
			-- upvalues: isValidValueNode (ref), p1 (copy)
			return isValidValueNode(p1, p16)
		end,
		StringValue = function(_, p18) -- line: 125
			-- upvalues: isValidValueNode (ref), p1 (copy)
			return isValidValueNode(p1, p18)
		end,
		BooleanValue = function(_, p20) -- line: 128
			-- upvalues: isValidValueNode (ref), p1 (copy)
			return isValidValueNode(p1, p20)
		end
	}
end
function isValidValueNode(p21, p22) -- line: 138
	-- upvalues: getNamedType (copy), isLeafType (copy), inspect (copy), GraphQLError (copy), print (copy), instanceOf (copy)
	local v24 = p21:getInputType()

	if not v24 then
		return
	end

	local v25 = getNamedType(v24)

	if not isLeafType(v25) then
		local v26 = inspect(v24)

		p21:reportError(GraphQLError.new(("Expected value of type \"%s\", found %s."):format(v26, print(p22)), p22))

		return
	end

	xpcall(function() -- line: 160
		-- upvalues: v25 (copy), p22 (copy), inspect (copy), v24 (copy), p21 (copy), GraphQLError (copy), print (copy)
		if v25:parseLiteral(p22, nil) == nil then
			local v54 = inspect(v24)

			p21:reportError(GraphQLError.new(("Expected value of type \"%s\", found %s."):format(v54, print(p22)), p22))
		end
	end, function(err) -- line: 173
		-- upvalues: inspect (copy), v24 (copy), instanceOf (copy), GraphQLError (copy), p21 (copy), print (copy), p22 (copy)
		local v56 = inspect(v24)

		if instanceOf(err, GraphQLError) then
			p21:reportError(err)

			return
		end

		p21:reportError(GraphQLError.new(("Expected value of type \"%s\", found %s; "):format(v56, print(p22)) .. err.message, p22, nil, nil, nil, err))
	end)
end

return t1
