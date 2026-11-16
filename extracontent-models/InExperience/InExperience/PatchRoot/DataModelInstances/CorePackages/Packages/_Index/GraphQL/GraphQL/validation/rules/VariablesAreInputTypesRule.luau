local parent = script.Parent.Parent.Parent
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError
local printer = require(parent.language.printer)
local Print = printer.print
local definition = require(parent.type.definition)
local isInputType = definition.isInputType
local typeFromAST = require(parent.utilities.typeFromAST)
local typeFromAST2 = typeFromAST.typeFromAST

return {
	VariablesAreInputTypesRule = function(object)
		return {
			VariableDefinition = function(_, p)
				local v = typeFromAST2(object:getSchema(), p.type)

				if v and not isInputType(v) then
					local value = p.variable.name.value
					local Print2 = Print(p.type)

					object:reportError(graphQLError.new(
						("Variable \"$%s\" cannot be non-input type \"%s\"."):format(value, Print2),
						p.type
					))
				end
			end
		}
	end
}
