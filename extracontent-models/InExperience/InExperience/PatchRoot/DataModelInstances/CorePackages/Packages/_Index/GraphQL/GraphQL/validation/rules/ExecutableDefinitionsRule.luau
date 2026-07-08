local ParentParent = script.Parent.Parent.Parent
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local language = ParentParent.language
local Kind = require(language.kinds).Kind
local isExecutableDefinitionNode = require(language.predicates).isExecutableDefinitionNode

return {
	ExecutableDefinitionsRule = function(p1) -- line: 23
		-- upvalues: isExecutableDefinitionNode (copy), Kind (copy), GraphQLError (copy)
		return {
			Document = function(_, p3) -- line: 25
				-- upvalues: isExecutableDefinitionNode (copy), Kind (copy), p1 (copy), GraphQLError (copy)
				for _, v in ipairs(p3.definitions) do
					if not isExecutableDefinitionNode(v) then
						local v11 = if v.kind ~= Kind.SCHEMA_DEFINITION and v.kind ~= Kind.SCHEMA_EXTENSION then "\"" .. v.name.value .. "\"" else "schema"

						p1:reportError(GraphQLError.new(("The %s definition is not executable."):format(v11), v))
					end
				end

				return false
			end
		}
	end
}
