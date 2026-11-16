local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local jsutils = parent.jsutils

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object

local didYouMean = require(jsutils.didYouMean)
local didYouMean2 = didYouMean.didYouMean
local suggestionList = require(jsutils.suggestionList)
local suggestionList2 = suggestionList.suggestionList
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError
local language = parent.language
local predicates = require(language.predicates)
local isTypeDefinitionNode = predicates.isTypeDefinitionNode
local isTypeSystemDefinitionNode = predicates.isTypeSystemDefinitionNode
local isTypeSystemExtensionNode = predicates.isTypeSystemExtensionNode
local kind = parent.type
local scalars = require(kind.scalars)
local specifiedScalarTypes = scalars.specifiedScalarTypes
local introspection = require(kind.introspection)
local introspectionTypes = introspection.introspectionTypes

local mapped = nil
local isStandardTypeName
local isSDLNode
local KnownTypeNamesRule = {
	KnownTypeNamesRule = function(object)
		local schema = object:getSchema()

		local v = Map.new()

		if schema then
			v = schema:getTypeMap()
		end

		local set = {}

		for _, definition in ipairs(object:getDocument().definitions) do
			if isTypeDefinitionNode(definition) then
				set[definition.name.value] = true
			end
		end

		local joined = Array.concat(v:keys(), Object.keys(set))

		return {
			NamedType = function(_, p, _, p2, _, list)
				local value = p.name.value

				if not (v:get(value) or set[value]) then
					local v2 = list[3] or p2
					local v3

					if v2 == nil then
						v3 = false
					else
						v3 = isSDLNode(v2)
					end

					if v3 and isStandardTypeName(value) then
						return
					end

					local v4 = suggestionList2(value, v3 and Array.concat(mapped, joined) or joined)

					object:reportError(graphQLError.new(("Unknown type \"%s\"."):format(value) .. didYouMean2(v4), p))
				end
			end
		}
	end
}

mapped = Array.map(Array.concat(specifiedScalarTypes, introspectionTypes), function(p)
	return p.name
end)

isStandardTypeName = function(value: string): boolean
	return Array.indexOf(mapped, value) ~= -1
end

isSDLNode = function(p)
	return not Array.isArray(p) and (isTypeSystemDefinitionNode(p) or isTypeSystemExtensionNode(p))
end

return KnownTypeNamesRule
