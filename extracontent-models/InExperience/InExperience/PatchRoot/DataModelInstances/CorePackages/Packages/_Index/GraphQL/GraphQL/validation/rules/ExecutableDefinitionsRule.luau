local parent = script.Parent.Parent.Parent
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError
local language = parent.language
local kinds = require(language.kinds)
local kind = kinds.Kind
local predicates = require(language.predicates)
local isExecutableDefinitionNode = predicates.isExecutableDefinitionNode

return {
	ExecutableDefinitionsRule = function(object)
		return {
			Document = function(_, p): boolean
				for _, definition in ipairs(p.definitions) do
					if isExecutableDefinitionNode(definition) then
						continue
					end

					local v = (definition.kind == kind.SCHEMA_DEFINITION or definition.kind == kind.SCHEMA_EXTENSION)
						and "schema"
						or "\"" .. definition.name.value .. "\""

					object:reportError(graphQLError.new(("The %s definition is not executable."):format(v), definition))
				end

				return false
			end
		}
	end
}
