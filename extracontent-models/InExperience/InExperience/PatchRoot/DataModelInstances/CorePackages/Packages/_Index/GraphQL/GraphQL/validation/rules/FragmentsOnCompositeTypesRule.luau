local parent = script.Parent.Parent.Parent
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError
local language = parent.language
local printer = require(language.printer)
local Print = printer.print
local definition = require(parent.type.definition)
local isCompositeType = definition.isCompositeType
local typeFromAST = require(parent.utilities.typeFromAST)
local typeFromAST2 = typeFromAST.typeFromAST

return {
	FragmentsOnCompositeTypesRule = function(object)
		return {
			InlineFragment = function(_, p)
				local typeCondition = p.typeCondition

				if typeCondition then
					local v = typeFromAST2(object:getSchema(), typeCondition)

					if v and not isCompositeType(v) then
						local Print2 = Print(typeCondition)
						object:reportError(graphQLError.new(
							("Fragment cannot condition on non composite type \"%s\"."):format(Print2),
							typeCondition
						))
					end
				end
			end,
			FragmentDefinition = function(_, p)
				local v = typeFromAST2(object:getSchema(), p.typeCondition)

				if v and not isCompositeType(v) then
					local Print2 = Print(p.typeCondition)
					object:reportError(graphQLError.new(
						("Fragment \"%s\" cannot condition on non composite type \"%s\"."):format(p.name.value, Print2),
						p.typeCondition
					))
				end
			end
		}
	end
}
