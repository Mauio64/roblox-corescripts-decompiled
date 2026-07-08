local ParentParent = script.Parent.Parent.Parent.Parent
local invariant = require(ParentParent.jsutils.invariant).invariant
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local definition = require(ParentParent.type.definition)
local getNamedType = definition.getNamedType
local isInputObjectType = definition.isInputObjectType

return {
	NoDeprecatedCustomRule = function(p1) -- line: 28
		-- upvalues: invariant (copy), GraphQLError (copy), getNamedType (copy), isInputObjectType (copy)
		return {
			Field = function(_, p3) -- line: 30
				-- upvalues: p1 (copy), invariant (copy), GraphQLError (copy)
				local v10 = p1:getFieldDef()
				local v11 = v10 and v10.deprecationReason

				if v10 and v11 ~= nil then
					local v12 = p1:getParentType()

					invariant(v12 ~= nil)
					p1:reportError(GraphQLError.new(("The field %s.%s is deprecated. %s"):format(v12.name, v10.name, v11), p3))
				end
			end,
			Argument = function(_, p5) -- line: 48
				-- upvalues: p1 (copy), GraphQLError (copy), invariant (copy)
				local v15 = p1:getArgument()
				local v16 = v15 and v15.deprecationReason

				if v15 and v16 ~= nil then
					local v17 = p1:getDirective()

					if v17 ~= nil then
						p1:reportError(GraphQLError.new(("Directive \"@%s\" argument \"%s\" is deprecated. %s"):format(v17.name, v15.name, v16), p5))

						return
					end

					local v18 = p1:getParentType()
					local v19 = p1:getFieldDef()

					invariant(v18 ~= nil and v19 ~= nil)
					p1:reportError(GraphQLError.new(("Field \"%s.%s\" argument \"%s\" is deprecated. %s"):format(v18.name, v19.name, v15.name, v16), p5))
				end
			end,
			ObjectField = function(_, p7) -- line: 82
				-- upvalues: getNamedType (copy), p1 (copy), isInputObjectType (copy), GraphQLError (copy)
				local v22 = getNamedType(p1:getParentInputType())

				if isInputObjectType(v22) then
					local v23 = v22:getFields():get(p7.name.value)
					local v24 = v23 and v23.deprecationReason

					if v24 ~= nil then
						p1:reportError(GraphQLError.new(("The input field %s.%s is deprecated. %s"):format(v22.name, v23.name, v24), p7))
					end
				end
			end,
			EnumValue = function(_, p9) -- line: 103
				-- upvalues: p1 (copy), getNamedType (copy), invariant (copy), GraphQLError (copy)
				local v27 = p1:getEnumValue()
				local v28 = v27 and v27.deprecationReason

				if v27 and v28 ~= nil then
					local v29 = getNamedType(p1:getInputType())

					invariant(v29 ~= nil)
					p1:reportError(GraphQLError.new(("The enum value \"%s.%s\" is deprecated. %s"):format(v29.name, v27.name, v28), p9))
				end
			end
		}
	end
}
