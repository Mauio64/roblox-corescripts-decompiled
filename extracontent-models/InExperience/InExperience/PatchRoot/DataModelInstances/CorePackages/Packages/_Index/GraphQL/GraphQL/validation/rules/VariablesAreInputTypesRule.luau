local ParentParent = script.Parent.Parent.Parent
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local print = require(ParentParent.language.printer).print
local isInputType = require(ParentParent.type.definition).isInputType
local typeFromAST = require(ParentParent.utilities.typeFromAST).typeFromAST

return {
	VariablesAreInputTypesRule = function(p1) -- line: 24
		-- upvalues: typeFromAST (copy), isInputType (copy), print (copy), GraphQLError (copy)
		return {
			VariableDefinition = function(_, p3) -- line: 26
				-- upvalues: typeFromAST (copy), p1 (copy), isInputType (copy), print (copy), GraphQLError (copy)
				local v9 = typeFromAST(p1:getSchema(), p3.type)

				if v9 and not isInputType(v9) then
					local value = p3.variable.name.value
					local v11 = print(p3.type)

					p1:reportError(GraphQLError.new(("Variable \"$%s\" cannot be non-input type \"%s\"."):format(value, v11), p3.type))
				end
			end
		}
	end
}
