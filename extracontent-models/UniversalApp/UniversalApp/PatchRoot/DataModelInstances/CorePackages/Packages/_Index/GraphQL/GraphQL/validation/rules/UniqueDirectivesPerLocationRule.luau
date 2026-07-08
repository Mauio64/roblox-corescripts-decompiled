local ParentParent = script.Parent.Parent.Parent
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local language = ParentParent.language
local Kind = require(language.kinds).Kind
local predicates = require(language.predicates)
local isTypeDefinitionNode = predicates.isTypeDefinitionNode
local isTypeExtensionNode = predicates.isTypeExtensionNode
local specifiedDirectives = require(ParentParent.type.directives).specifiedDirectives

return {
	UniqueDirectivesPerLocationRule = function(p1) -- line: 27
		-- upvalues: specifiedDirectives (copy), Kind (copy), isTypeDefinitionNode (copy), isTypeExtensionNode (copy), GraphQLError (copy)
		local t1 = {}
		local v11 = p1:getSchema()
		local v12 = if not v11 then specifiedDirectives else v11:getDirectives()

		for _, v in ipairs(v12) do
			t1[v.name] = not v.isRepeatable
		end

		local definitions = p1:getDocument().definitions

		for _, v in ipairs(definitions) do
			if v.kind == Kind.DIRECTIVE_DEFINITION then
				t1[v.name.value] = not v.repeatable
			end
		end

		local t2 = {}
		local t3 = {}

		return {
			enter = function(_, p3) -- line: 50
				-- upvalues: Kind (copy), t2 (copy), isTypeDefinitionNode (copy), isTypeExtensionNode (copy), t3 (copy), t1 (copy), p1 (copy), GraphQLError (copy)
				if p3.directives == nil then
					return
				end

				local v22

				if p3.kind == Kind.SCHEMA_DEFINITION or p3.kind == Kind.SCHEMA_EXTENSION then
					v22 = t2
				elseif isTypeDefinitionNode(p3) or isTypeExtensionNode(p3) then
					local value = p3.name.value

					v22 = t3[value]

					if v22 == nil then
						v22 = {}
						t3[value] = v22
					end
				else
					v22 = {}
				end

				for _, v in ipairs(p3.directives) do
					local value = v.name.value

					if t1[value] then
						if v22[value] then
							p1:reportError(GraphQLError.new(("The directive \"@%s\" can only be used once at this location."):format(value), {
								v22[value],
								v
							}))
						else
							v22[value] = v
						end
					end
				end
			end
		}
	end
}
