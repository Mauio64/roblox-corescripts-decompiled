local parent = script.Parent.Parent.Parent
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError
local language = parent.language
local kinds = require(language.kinds)
local kind = kinds.Kind
local predicates = require(language.predicates)
local isTypeDefinitionNode = predicates.isTypeDefinitionNode
local isTypeExtensionNode = predicates.isTypeExtensionNode
local directives = require(parent.type.directives)
local specifiedDirectives = directives.specifiedDirectives

return {
	UniqueDirectivesPerLocationRule = function(object)
		local v = {}

		local schema = object:getSchema()
		local v2

		if schema then
			v2 = schema:getDirectives()
		else
			v2 = specifiedDirectives
		end

		for _, v3 in ipairs(v2) do
			v[v3.name] = not v3.isRepeatable
		end

		local definitions = object:getDocument().definitions

		for _, definition in ipairs(definitions) do
			if definition.kind == kind.DIRECTIVE_DEFINITION then
				v[definition.name.value] = not definition.repeatable
			end
		end

		local v3 = {}
		local v4 = {}

		return {
			enter = function(_, data)
				if data.directives == nil then
					return
				end

				local directives2

				if data.kind == kind.SCHEMA_DEFINITION or data.kind == kind.SCHEMA_EXTENSION then
					directives2 = v3
				elseif isTypeDefinitionNode(data) or isTypeExtensionNode(data) then
					local value = data.name.value
					directives2 = v4[value]

					if directives2 == nil then
						directives2 = {}
						v4[value] = directives2
					end
				else
					directives2 = {}
				end

				for _, directive in ipairs(data.directives) do
					local value = directive.name.value

					if not v[value] then
						continue
					end

					if directives2[value] then
						object:reportError(graphQLError.new(
							("The directive \"@%s\" can only be used once at this location."):format(value),
							{ directives2[value], directive }
						))
					else
						directives2[value] = directive
					end
				end
			end
		}
	end
}
