local ParentParent = script.Parent.Parent.Parent
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local language = ParentParent.language
local print = require(language.printer).print
local isCompositeType = require(ParentParent.type.definition).isCompositeType
local typeFromAST = require(ParentParent.utilities.typeFromAST).typeFromAST

return {
	FragmentsOnCompositeTypesRule = function(p1) -- line: 24
		-- upvalues: typeFromAST (copy), isCompositeType (copy), print (copy), GraphQLError (copy)
		return {
			InlineFragment = function(_, p3) -- line: 26
				-- upvalues: typeFromAST (copy), p1 (copy), isCompositeType (copy), print (copy), GraphQLError (copy)
				local typeCondition = p3.typeCondition

				if typeCondition then
					local v11 = typeFromAST(p1:getSchema(), typeCondition)

					if v11 and not isCompositeType(v11) then
						local v12 = print(typeCondition)

						p1:reportError(GraphQLError.new(("Fragment cannot condition on non composite type \"%s\"."):format(v12), typeCondition))
					end
				end
			end,
			FragmentDefinition = function(_, p5) -- line: 43
				-- upvalues: typeFromAST (copy), p1 (copy), isCompositeType (copy), print (copy), GraphQLError (copy)
				local v15 = typeFromAST(p1:getSchema(), p5.typeCondition)

				if v15 and not isCompositeType(v15) then
					local v16 = print(p5.typeCondition)

					p1:reportError(GraphQLError.new(("Fragment \"%s\" cannot condition on non composite type \"%s\"."):format(p5.name.value, v16), p5.typeCondition))
				end
			end
		}
	end
}
